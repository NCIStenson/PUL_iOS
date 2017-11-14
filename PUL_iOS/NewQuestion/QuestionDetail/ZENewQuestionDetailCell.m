//
//  ZENewQuestionDetailCell.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENewQuestionDetailCell.h"

@implementation ZEDetailCellReplyView

-(id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(self){
//        self.backgroundColor = MAIN_ARM_COLOR;
        [self initView];
    }
    
    return self;
}

-(void)initView
{
    _contentBackgroundView = [[UIView alloc]init];
    _contentBackgroundView.frame = CGRectMake(70, 0, SCREEN_WIDTH - 90, 0);
    _contentBackgroundView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:_contentBackgroundView];
    
    _replyContentLabOne = [[UILabel alloc]init];
    _replyContentLabOne.frame = CGRectMake(8, 5, SCREEN_WIDTH - 90 - 16, 0);
    _replyContentLabOne.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _replyContentLabOne.textColor = RGBA(217, 217, 217, 1);
    _replyContentLabOne.numberOfLines = 0;
//    _replyContentLabOne.backgroundColor = MAIN_ARM_COLOR;
    [_contentBackgroundView addSubview:_replyContentLabOne];
    
    

}

-(void)setDetailLayout:(ZENewDetailLayout *)detailLayout
{
    _detailLayout = detailLayout;
    
    _contentBackgroundView.height = _detailLayout.replayHeight ;
    
    _replyContentLabOne.text = [NSString stringWithFormat:@"%@回复%@ ：%@",detailLayout.answerInfo.NICKNAME,detailLayout.questionInfo.NICKNAME,detailLayout.answerInfo.ANSWEREXPLAIN];
    
    _replyContentLabOne.height = [_replyContentLabOne.text heightForFont:_replyContentLabOne.font width:SCREEN_WIDTH - 90];
    
}

@end

@implementation ZENewQuetionDetailMessageView

-(id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(self){
        [self initView];
    }
    
    return self;
}

-(void)initView
{
    _timeLab = [UILabel new];
    _timeLab.frame = CGRectMake(70, 0, 150, 40);
    _timeLab.textColor = kSubTitleColor;
    _timeLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [self addSubview:_timeLab];
    
    _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _acceptBtn.frame = CGRectMake(SCREEN_WIDTH - 130, 10, 40, 20);
    _acceptBtn.backgroundColor = MAIN_NAV_COLOR;
    _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [self addSubview:_acceptBtn];
    [_acceptBtn setTitle:@"采纳" forState:UIControlStateNormal];
    [_acceptBtn addTarget:self action:@selector(acceptAnswer:) forControlEvents:UIControlEventTouchUpInside];
    _acceptBtn.clipsToBounds = YES;
    _acceptBtn.layer.cornerRadius = _acceptBtn.height / 2;
    
    _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _praiseBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 60, 40);
    [_praiseBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [self addSubview:_praiseBtn];
    _praiseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png"] forState:UIControlStateNormal];
    [_praiseBtn addTarget:self action:@selector(giveAnswerPraise:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setDetailLayout:(ZENewDetailLayout *)detailLayout
{
    _detailLayout = detailLayout;
    
    _timeLab.text = [detailLayout.answerInfo.SYSCREATEDATE stringByReplacingOccurrencesOfString:@".0" withString:@""];
    if ([detailLayout.answerInfo.GOODNUMS integerValue] == 0) {
        [_praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
    }else{
        [_praiseBtn setTitle:[NSString stringWithFormat:@" %@",detailLayout.answerInfo.GOODNUMS] forState:UIControlStateNormal];
    }
    
    if (detailLayout.answerInfo.ISGOOD) {
        _praiseBtn.enabled = NO;
        [_praiseBtn setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    }
}

-(void)giveAnswerPraise:(UIButton *)btn{
    btn.enabled = NO;
    if ([_detailCell.delegate respondsToSelector:@selector(giveAnswerPraise:)]) {
        [_detailCell.delegate giveAnswerPraise:_detailLayout.answerInfo];
    }
}

-(void)acceptAnswer:(UIButton *)btn{
//    btn.enabled = NO;
    if ([_detailCell.delegate respondsToSelector:@selector(acceptAnswer:)]) {
        [_detailCell.delegate acceptAnswer:_detailLayout.answerInfo];
    }
}

@end

@implementation ZENewDetailCellImageContent

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        //        self.backgroundColor =  MAIN_ARM_COLOR;
        //        [self initView];
    }
    return self;
}

-(void)setLayout:(ZENewDetailLayout *)layout
{
    _layout = layout;
    [self creatrCellImage];
}

-(void)creatrCellImage
{
    NSMutableArray * urlsArr = [NSMutableArray array];
    
    if(_layout.answerInfo.FILEURLARR.count > 0){
        for (NSString * str in _layout.answerInfo.FILEURLARR) {
            [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
        }
    }
    
    _linePhotosView = [PYPhotosView photosViewWithThumbnailUrls:urlsArr originalUrls:urlsArr];
    // 设置Frame
    
    // 3. 添加到指定视图中
    [self addSubview:_linePhotosView];
    
    if (_layout.answerInfo.FILEURLARR.count == 3 ) {
        _linePhotosView.left = 70;
        _linePhotosView.top = 0;
        _linePhotosView.width = SCREEN_WIDTH - 90;
        _linePhotosView.height = kMultiImageHeight;
        _linePhotosView.contentSize = CGSizeMake(_linePhotosView.width, _linePhotosView.height);
        _linePhotosView.photoWidth = kMultiImageHeight;
        _linePhotosView.photoHeight = kMultiImageHeight;
    }else{
        
        _linePhotosView.left = 70;
        _linePhotosView.top = 0;
        _linePhotosView.width = SCREEN_WIDTH - 90;
        
        _linePhotosView.photoWidth = kSingleImageHeight;
        _linePhotosView.photoHeight = kSingleImageHeight;
        _linePhotosView.height = kSingleImageHeight;
    }
}

@end


@implementation ZENewQuetionDetailSingleAnswerView

-(id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(self){
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
    
    _contentLab = [UILabel new];
    _contentLab.frame = CGRectMake(_headerImageView.right + 10, _nameLab.bottom, SCREEN_WIDTH - 200, 20);
    _contentLab.width = SCREEN_WIDTH - _contentLab.left - 20;
    [self addSubview:_contentLab];
    _contentLab.textColor = kTextColor;
    _contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _contentLab.numberOfLines = 0;
}

-(void)setDetailLayout:(ZENewDetailLayout *)detailLayout
{
    _detailLayout = detailLayout;
    
    _contentLab.height = detailLayout.textHeight;
    _contentLab.text = detailLayout.answerInfo.ANSWEREXPLAIN;
    
    _nameLab.text = detailLayout.answerInfo.NICKNAME;
    [_headerImageView sd_setImageWithURL:ZENITH_IMAGEURL(detailLayout.answerInfo.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
}


@end


@implementation ZENewQuestionDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDetailLayout:(ZENewDetailLayout *)detailLayout{
    _detailLayout = detailLayout;
    for (UIView * view in self.contentView.subviews) {
        for (UIView * subView in view.subviews) {
            [subView removeAllSubviews];
            [subView removeFromSuperview];
        }
        [view removeFromSuperview];
    }
        
    self.height = _detailLayout.height;
    self.contentView.height = _detailLayout.height;
    
    [self setUI:_detailLayout];
//    [self initCellData:layout];
}

-(void)setUI:(ZENewDetailLayout *)layout{
    _answerView = [ZENewQuetionDetailSingleAnswerView new];
    
    _answerView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 40);
    [self.contentView addSubview:_answerView];
//    _answerView.backgroundColor = MAIN_ARM_COLOR;
    _answerView.detailLayout = layout;
    if (layout.textHeight < 20) {
        _answerView.height = 40;
    }else{
        _answerView.height = 20 + layout.textHeight;
    }
    
    _imageContentView = [[ZENewDetailCellImageContent alloc]init];
    if (layout.answerInfo.FILEURLARR.count > 0) {
        _imageContentView.listCell = self;
        [self.contentView addSubview:_imageContentView];
        _imageContentView.origin = CGPointMake(0, _answerView.bottom + kImageContentMarginTextContent);
        _imageContentView.layout = layout;
        
        if (layout.answerInfo.FILEURLARR.count == 3) {
            _imageContentView.size = CGSizeMake(SCREEN_WIDTH, kMultiImageHeight);
        }else{
            _imageContentView.size = CGSizeMake(SCREEN_WIDTH, kSingleImageHeight);
        }
    }else{
        _imageContentView.top =  _answerView.bottom;
        _imageContentView.size = CGSizeMake(0, 0);
    }
    
    _replyView = [ZEDetailCellReplyView new];
    if (layout.answerInfo.FILEURLARR.count > 0) {
        _replyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, layout.replayHeight);
        [self.contentView addSubview:_replyView];
        _replyView.detailLayout = layout;
        _replyView.top = _imageContentView.bottom + kImageContentMarginTextContent;
        _replyView.detailCell = self;
    }else{
        _replyView.top =  _imageContentView.bottom;
        _replyView.size = CGSizeMake(0, 0);
    }
    
    _messageView = [ZENewQuetionDetailMessageView new];
    _messageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMessageViewHeight);
    [self.contentView addSubview:_messageView];
    _messageView.detailLayout = layout;
    _messageView.top = _replyView.bottom + kMessageViewMarginContentHeigth;
    _messageView.detailCell = self;
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
