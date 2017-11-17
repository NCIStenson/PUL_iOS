//
//  ZENewQuestionListCell.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENewQuestionListCell.h"

@implementation ZEListCellQuestionModeContent

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor =  [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView
{
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [self addSubview:lineView];
    lineView.backgroundColor =MAIN_LINE_COLOR;
    
    UIView * lineView1 = [UIView new];
    lineView1.frame = CGRectMake(SCREEN_WIDTH / 2 - 2, 5, 2, 25);
    [self addSubview:lineView1];
    lineView1.backgroundColor =MAIN_LINE_COLOR;

    
    for (int i = 0; i < 2; i ++) {
        UIButton * answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        answerBtn.frame = CGRectMake(SCREEN_WIDTH / 2 * i, 0, SCREEN_WIDTH / 2, 35);
        [answerBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
        [answerBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
        answerBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [self addSubview:answerBtn];
        answerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

        if (i == 0) {
            [answerBtn setTitle:@" 回答" forState:UIControlStateNormal];
            [answerBtn setImage:[UIImage imageNamed:@"center_name_logo.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
            [answerBtn addTarget:self action:@selector(answerQuestion) forControlEvents:UIControlEventTouchUpInside];
            _answerButton = answerBtn;
        }else{
            [answerBtn setTitle:@" 赞" forState:UIControlStateNormal];
            [answerBtn setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png"] forState:UIControlStateNormal];
            [answerBtn addTarget:self action:@selector(giveQuestionPraise:) forControlEvents:UIControlEventTouchUpInside];
            _praiseButton = answerBtn;
        }
    }
}

-(void)setLayout:(ZENewQuetionLayout *)layout
{
    _layout = layout;
    [self setData];
}

-(void)setData{
    NSLog(@" ------  %@",_layout.questionInfo.GOODNUMS);
    NSLog(@"ISGOOD ------  %d",_layout.questionInfo.ISGOOD);
    
    if ([_layout.questionInfo.ANSWERSUM integerValue] == 0) {
        [_answerButton setTitle:@" 回答" forState:UIControlStateNormal];
    }else{
        [_answerButton setTitle:[NSString stringWithFormat:@" %@",_layout.questionInfo.ANSWERSUM] forState:UIControlStateNormal];
    }

    
    if ([_layout.questionInfo.GOODNUMS integerValue] == 0) {
        [_praiseButton setTitle:@" 赞" forState:UIControlStateNormal];
    }else{
        [_praiseButton setTitle:[NSString stringWithFormat:@" %@",_layout.questionInfo.GOODNUMS] forState:UIControlStateNormal];
    }
    
    if (_layout.questionInfo.ISGOOD) {
        _praiseButton.enabled = NO;
        [_praiseButton setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    }
    
}

-(void)answerQuestion
{
    if ([_listCell.delegate respondsToSelector:@selector(answerQuestion:)]) {
        [_listCell.delegate answerQuestion:_layout.questionInfo];
    }
}

-(void)giveQuestionPraise:(UIButton *)btn{
    
    btn.enabled = NO;
    NSInteger googNums = [_layout.questionInfo.GOODNUMS integerValue];
    googNums +=1;
   
    [_praiseButton setTitle:[NSString stringWithFormat:@" %ld",(long)googNums] forState:UIControlStateNormal];
    [_praiseButton setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];

    if ([_listCell.delegate respondsToSelector:@selector(giveQuestionPraise:)]) {
        [_listCell.delegate giveQuestionPraise:_layout.questionInfo];
    }
}

@end


@implementation ZEListCellQuestionTypeContent

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    UIImageView * typeImg = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, 0, 15, 15)];
    typeImg.image = [UIImage imageNamed:@"answer_tag"];
    [self addSubview:typeImg];
    
    _typeContentLab = [[UILabel alloc]initWithFrame:CGRectMake(typeImg.right + 10,0,SCREEN_WIDTH - 70,kTypeContentHeight)];
    _typeContentLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    _typeContentLab.textColor = MAIN_SUBTITLE_COLOR;
    _typeContentLab.numberOfLines = 0;
    [self addSubview:_typeContentLab];

}

@end

@implementation ZEListCellImageContent

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
//        self.backgroundColor =  MAIN_ARM_COLOR;
//        [self initView];
    }
    return self;
}

-(void)setLayout:(ZENewQuetionLayout *)layout
{
    _layout = layout;
    [self creatrCellImage];
}

-(void)creatrCellImage
{
    NSMutableArray * urlsArr = [NSMutableArray array];

    if(_layout.questionInfo.FILEURLARR.count > 0){
        for (NSString * str in _layout.questionInfo.FILEURLARR) {
            [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
        }
    }
    
    _linePhotosView = [PYPhotosView photosViewWithThumbnailUrls:urlsArr originalUrls:urlsArr];
    // 设置Frame
    _linePhotosView.left = 20;
    _linePhotosView.top = 0;
    _linePhotosView.width = SCREEN_WIDTH - 40;
    // 3. 添加到指定视图中
    [self addSubview:_linePhotosView];
    
    if (_layout.questionInfo.FILEURLARR.count == 3 ) {
        _linePhotosView.height = kMultiImageHeight;
    }else{
        _linePhotosView.photoWidth = kSingleImageHeight;
        _linePhotosView.photoHeight = kSingleImageHeight;
        _linePhotosView.height = kSingleImageHeight;
    }
    
}

@end

@implementation ZEListCellTextContent

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor =  [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView
{
    _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 0)];
    _contentLab.numberOfLines = 4;
    _contentLab.textColor = kTextColor;
    _contentLab.font = [UIFont boldSystemFontOfSize:kTiltlFontSize];
    [self addSubview:_contentLab];
    
    _seeAllExplainLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 75, SCREEN_WIDTH - 40, 20)];
    _seeAllExplainLab.text = @"查看全文";
    _seeAllExplainLab.textColor = RGBA(36, 91, 131, 1);
//    _seeAllExplainLab.backgroundColor =MAIN_ARM_COLOR;
    _seeAllExplainLab.font = [UIFont boldSystemFontOfSize:kTiltlFontSize];
    [self addSubview:_seeAllExplainLab];
    _seeAllExplainLab.hidden = YES;
    
}

@end


@implementation ZEListCellPersonalMessage

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor =  [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView
{
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
    [_headerImageView setImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [self addSubview:_headerImageView];
    _headerImageView.clipsToBounds = YES;
    _headerImageView.layer.cornerRadius = _headerImageView.height / 2;
    
    _nameLab = [UILabel new];
    _nameLab.frame = CGRectMake(_headerImageView.right + 10, _headerImageView.top, SCREEN_WIDTH - 200, 20);
    _nameLab.textColor = kTextColor;
    _nameLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [self addSubview:_nameLab];
    
    _timeLab = [UILabel new];
    _timeLab.frame = CGRectMake(_headerImageView.right + 10, _nameLab.bottom, SCREEN_WIDTH - 200, 20);
    [self addSubview:_timeLab];
    _timeLab.textColor = kSubTitleColor;
    _timeLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    
    _bounsImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 10, 20, 20)];
    [_bounsImage setImage:[UIImage imageNamed:@"high_score_icon.png"]];
    [self addSubview:_bounsImage];
    _bounsImage.hidden = YES;
    
    _bounsLab = [UILabel new];
    _bounsLab.frame = CGRectMake(_bounsImage.right + 7, _bounsImage.top, 40, 20);
    [self addSubview:_bounsLab];
    _bounsLab.textColor = kSubTitleColor;
    _bounsLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _bounsLab.textColor = RGBA(227, 138, 46, 1);
    _bounsLab.hidden =YES;
}

-(void)setData:(ZEQuestionInfoModel *)questionInfo
{
    _timeLab.text = [ZEUtil compareCurrentTime:questionInfo.SYSCREATEDATE];

    if(!questionInfo.ISANONYMITY){
        _nameLab.text = questionInfo.NICKNAME;
        [_headerImageView sd_setImageWithURL:ZENITH_IMAGEURL(questionInfo.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    }else{
        _nameLab.text = @"匿名提问";
    }
    
    if ([questionInfo.BONUSPOINTS integerValue] > 0) {
        _bounsImage.hidden = NO;
        _bounsLab.hidden =NO;
        _bounsLab.text = [NSString stringWithFormat:@"%@",questionInfo.BONUSPOINTS];
    }
    
}

@end


@implementation ZENewQuestionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setLayout:(ZENewQuetionLayout *)layout
{
    for (UIView * view in self.contentView.subviews) {
        for (UIView * subView in view.subviews) {
            [subView removeAllSubviews];
            [subView removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = MAIN_LINE_COLOR;
    
    self.height = layout.height;
    self.contentView.height = layout.height;
    
    [self setUI:layout];
    [self initCellData:layout];
}

-(void)setUI:(ZENewQuetionLayout *)layout{
    
    _personalMessageView = [[ZEListCellPersonalMessage alloc]init];
    _personalMessageView.listCell = self;
    [self.contentView addSubview:_personalMessageView];
    _personalMessageView.left = 0;
    _personalMessageView.top = 15.0f;
    _personalMessageView.size = CGSizeMake(SCREEN_WIDTH, kPersonalMessageHeight);

    _textContenView = [[ZEListCellTextContent alloc]init];
    _textContenView.listCell = self;
    [self.contentView addSubview:_textContenView];
    _textContenView.top = _personalMessageView.bottom + kTextContentMarginPersonalMessage;
    _textContenView.size = CGSizeMake(SCREEN_WIDTH, layout.textHeight);
    _textContenView.left = 0;
    if (layout.isShowMode && layout.textHeight > kMaxExplainHeight) {
        _textContenView.height = layout.textHeight + 20;
    }
    
    if (layout.questionInfo.FILEURLARR.count > 0) {
        _imageContentView = [[ZEListCellImageContent alloc]init];
        _imageContentView.listCell = self;
        [self.contentView addSubview:_imageContentView];
        _imageContentView.origin = CGPointMake(0, _textContenView.bottom + kImageContentMarginTextContent);
        
        if (layout.questionInfo.FILEURLARR.count == 3) {
            _imageContentView.size = CGSizeMake(SCREEN_WIDTH, kMultiImageHeight);
        }else{
            _imageContentView.size = CGSizeMake(SCREEN_WIDTH, kSingleImageHeight);
        }
    }else{
        _imageContentView.origin = CGPointMake(0, _textContenView.bottom );
        _imageContentView.size = CGSizeMake(0, 0);
    }
    
    if (layout.typeStr.length > 0) {
        _typeContentView = [ZEListCellQuestionTypeContent new];
        [self.contentView addSubview:_typeContentView];
        if (layout.questionInfo.FILEURLARR.count > 0) {
            _typeContentView.origin = CGPointMake(0, _imageContentView.bottom + kImageContentMarginTextContent);
        }else{
            _typeContentView.origin = CGPointMake(0, _textContenView.bottom + kImageContentMarginTextContent);
        }
        _typeContentView.size = CGSizeMake(SCREEN_WIDTH, kTypeContentHeight);
    }else{
        _typeContentView.hidden = YES;
    }
    
    _modelContentView = [ZEListCellQuestionModeContent new];
    _modelContentView.listCell = self;
    [self.contentView addSubview:_modelContentView];
    _modelContentView.top = self.height - kModelContentHeight;
    _modelContentView.height = kModelContentHeight;
    _modelContentView.width = SCREEN_WIDTH;
    _modelContentView.left = 0;
    _modelContentView.layout = layout;
    
    if (!layout.isShowMode) {
        _modelContentView.hidden = YES;
    }
}

-(void)initCellData:(ZENewQuetionLayout *)layout
{
    [_personalMessageView setData:layout.questionInfo];
    
    _textContenView.contentLab.text = layout.questionInfo.QUESTIONEXPLAIN;
    _textContenView.contentLab.height = layout.textHeight;
    
    if(!layout.isShowMode){
        _textContenView.contentLab.numberOfLines = 0;
    }else{
        if (layout.textHeight > kMaxExplainHeight) {
            _textContenView.seeAllExplainLab.hidden =NO;
        }
    }
    
    
    if (layout.questionInfo.FILEURLARR.count > 0) {
        _imageContentView.layout = layout;
    }
    
    if (layout.typeStr.length >0) {
        NSLog(@" ===  %@",layout.typeStr);
        _typeContentView.typeContentLab.text = layout.typeStr;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
