//
//  ZEChatTextCell.m
//  PUL_iOS
//
//  Created by Stenson on 16/12/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChatBaseCell.h"

@implementation ZEChatBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    [self addSubview:self.bubbleView];
    [self addSubview:self.headImageView];
//    [self.contentView addSubview:self.activityView];
//    [self.contentView addSubview:self.retryButton];
}
#pragma mark - Getter and Setter

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _headImageView.origin = CGPointMake(kLeftHeadImageMarginLeft, kHeadImgaeMarginTop);
        _headImageView.size = CGSizeMake(kHeadImageWidth, kHeadImageHight);
        
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = kHeadImageHight / 2;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
        [_headImageView addGestureRecognizer:tapGes];
        
    }
    return _headImageView;
}

- (UIImageView *)bubbleView {
    if (_bubbleView == nil) {
        _bubbleView = [[UIImageView alloc] init];
        _bubbleView.origin = CGPointMake(kBubbleMarginLeft, kBubbleMarginTop);
        _bubbleView.backgroundColor = [UIColor clearColor];
        _bubbleView.image = [[UIImage imageNamed:@"bubble_left" color:[UIColor whiteColor]] stretchableImageWithLeftCapWidth:15 topCapHeight:20];
    }
    return _bubbleView;
}


-(void)headClicked
{
    NSLog(@"==========   headClicked   ============");
}

@end

@implementation ZEChatTextView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _contentLab = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 0)];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.textColor = kTextColor;
        _contentLab.origin = CGPointMake(kContentMarginLeft, kContentMarginTop);
        _contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        _contentLab.dataDetectorTypes = UIDataDetectorTypeAll;
        _contentLab.textContainerInset = UIEdgeInsetsMake(0, -4, 0, -4);
        _contentLab.delegate = self;
        _contentLab.editable = NO;
        _contentLab.scrollEnabled = NO;
        [self addSubview:_contentLab];
    }
    return self;
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0);{
    
    if([_cell .delegate respondsToSelector:@selector(showWebVC:)] ){
        [_cell.delegate showWebVC:URL.absoluteString];
    }
    
    return NO;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_DEPRECATED_IOS(7_0, 10_0, "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
{
    if([_cell.delegate respondsToSelector:@selector(showWebVC:)] ){
        [_cell.delegate showWebVC:URL.absoluteString];
    }
    return NO;
}

-(void)setContent:(id)infoM withLayout:(ZEChatLayout *)layout
{
    NSString * textContentStr = @"";
    if ([infoM isKindOfClass:[ZEQuestionInfoModel class]]) {
        textContentStr = ((ZEQuestionInfoModel *)infoM).QUESTIONEXPLAIN;
    }else if ([infoM isKindOfClass:[ZEAnswerInfoModel class]]){
        textContentStr = ((ZEAnswerInfoModel *)infoM).ANSWEREXPLAIN;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kLabel_LineSpace;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:kTiltlFontSize],
                                 NSKernAttributeName:@-.5f,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    _contentLab.attributedText = [[NSAttributedString alloc] initWithString:textContentStr attributes:attributes];
    float textW = [textContentStr widthForFont:[UIFont systemFontOfSize:kTiltlFontSize]];
    float textH = [textContentStr heightForFont:[UIFont systemFontOfSize:kTiltlFontSize] width:kMaxWidth];
    if(textW >= kMaxWidth){
        textH = [ZEUtil boundingRectWithSize:CGSizeMake(kMaxWidth, MAXFLOAT) WithStr:textContentStr andFont:[UIFont systemFontOfSize:kTiltlFontSize] andLinespace:kLabel_LineSpace];
        _contentLab.size = CGSizeMake( kMaxWidth , textH );
    }else{
        _contentLab.size = CGSizeMake( textW + 2,textH );
    }

    if (textH < 21) {
        textH = 21;
    }
    
    if(textW >= kMaxWidth){
        self.bubbleView.size = CGSizeMake( kMaxWidth + 25 ,textH + 20 );
    }else{
        self.bubbleView.size = CGSizeMake( textW + 25 ,textH + 20 );
    }

    [self.headImageView setImageWithURL:ZENITH_IMAGEURL(layout.headImageUrl) placeholder:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    
    if ([infoM isKindOfClass:[ZEQuestionInfoModel class]]) {
        if ([[ZESettingLocalData getUSERCODE] isEqual:((ZEQuestionInfoModel *)infoM).QUESTIONUSERCODE]) {
            self.headImageView.right = SCREEN_WIDTH - kRightHeadImageMarginRight;
            self.bubbleView.image = [[UIImage imageNamed:@"bubble_right" color:MAIN_NAV_COLOR_A(0.7)] stretchableImageWithLeftCapWidth:5 topCapHeight:20];
            self.bubbleView.right = SCREEN_WIDTH - 55;
            _contentLab.textColor = [UIColor whiteColor];
            _contentLab.right = SCREEN_WIDTH - kContentMarginLeft;
        }
    }else if ([infoM isKindOfClass:[ZEAnswerInfoModel class]]){
        if ([[ZESettingLocalData getUSERCODE] isEqual:((ZEAnswerInfoModel *)infoM).ANSWERUSERCODE]) {
            self.headImageView.right = SCREEN_WIDTH - kRightHeadImageMarginRight;
            self.bubbleView.image = [[UIImage imageNamed:@"bubble_right" color:MAIN_NAV_COLOR_A(0.7)] stretchableImageWithLeftCapWidth:5 topCapHeight:20];
            self.bubbleView.right = SCREEN_WIDTH - 55;
            _contentLab.textColor = [UIColor whiteColor];
            _contentLab.right = SCREEN_WIDTH - kContentMarginLeft;
        }
    }
}
-(void)setChatContent:(ZEQuesAnsDetail *)infoM withLayout:(ZEChatLayout *)layout
{
    NSString * textContentStr = infoM.EXPLAIN;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kLabel_LineSpace;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:kTiltlFontSize],
                                 NSKernAttributeName:@-.5f,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    _contentLab.attributedText = [[NSAttributedString alloc] initWithString:textContentStr attributes:attributes];
    float textW = [textContentStr widthForFont:[UIFont systemFontOfSize:kTiltlFontSize]];
    float textH = [textContentStr heightForFont:[UIFont systemFontOfSize:kTiltlFontSize] width:kMaxWidth];
    if(textW >= kMaxWidth){
        textH = [ZEUtil boundingRectWithSize:CGSizeMake(kMaxWidth, MAXFLOAT) WithStr:textContentStr andFont:[UIFont systemFontOfSize:kTiltlFontSize] andLinespace:kLabel_LineSpace];
        _contentLab.size = CGSizeMake( kMaxWidth , textH );
    }else{
        _contentLab.size = CGSizeMake( textW + 2,textH );
    }

    if (textH < 21) {
        textH = 21;
    }
    if(textW >= kMaxWidth){
        self.bubbleView.size = CGSizeMake( kMaxWidth + 25 ,textH + 20 );
    }else{
        self.bubbleView.size = CGSizeMake( textW + 25 ,textH + 20 );
    }
    [self.headImageView setImageWithURL:ZENITH_IMAGEURL(layout.headImageUrl) placeholder:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    if ([[ZESettingLocalData getUSERCODE] isEqualToString:infoM.SYSCREATORID]) {
        self.headImageView.right = SCREEN_WIDTH - kRightHeadImageMarginRight;
        self.bubbleView.image = [[UIImage imageNamed:@"bubble_right" color:MAIN_NAV_COLOR_A(0.7)] stretchableImageWithLeftCapWidth:5 topCapHeight:20];
        self.bubbleView.right = SCREEN_WIDTH - 55;
        _contentLab.textColor = [UIColor whiteColor];
        _contentLab.right = SCREEN_WIDTH - kContentMarginLeft;
    }
}


@end

@implementation ZEChatImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    _contentImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contentImageBtn.origin = CGPointMake(kBubbleMarginLeft + 15.0f, kBubbleMarginTop + 5.0f);
    _contentImageBtn.size = CGSizeMake(SCREEN_WIDTH * .5f, SCREEN_WIDTH * .5f);
    [self addSubview:_contentImageBtn];
    _contentImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_contentImageBtn addTarget:self action:@selector(imageClick) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}
/*** 问题 回答中包含的图片 ****/
-(void)setContent:(ZEChatLayout *)layout;
{
    _chatImageUrl = layout.imageURL;
    
    [self.headImageView setImageWithURL:ZENITH_IMAGEURL(layout.headImageUrl) placeholder:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    self.bubbleView.size = CGSizeMake( SCREEN_WIDTH * .5f + 20 ,SCREEN_WIDTH * .5f + 18.0f );
    [_contentImageBtn setImageWithURL:ZENITH_IMAGEURL(layout.imageURL) forState:UIControlStateNormal placeholder:ZENITH_PLACEHODLER_IMAGE];
    
    if ([[ZESettingLocalData getUSERCODE] isEqual:layout.usercode]) {
        self.headImageView.right = SCREEN_WIDTH - kRightHeadImageMarginRight;
        self.bubbleView.image = [[UIImage imageNamed:@"bubble_right" color:MAIN_NAV_COLOR_A(0.7)] stretchableImageWithLeftCapWidth:5 topCapHeight:20];
        self.bubbleView.right = SCREEN_WIDTH - 55;
        _contentImageBtn.right = SCREEN_WIDTH - kBubbleMarginLeft - 15.0f;
    }
}

/*** 聊天过程中包含的图片 ****/
-(void)setChatContent:(ZEChatLayout *)layout;
{
    _chatImageUrl = layout.imageURL;
    
    [self.headImageView setImageWithURL:ZENITH_IMAGEURL(layout.headImageUrl) placeholder:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    self.bubbleView.size = CGSizeMake( SCREEN_WIDTH * .5f + 20 ,SCREEN_WIDTH * .5f + 18.0f );
    [_contentImageBtn setImageWithURL:ZENITH_IMAGEURL(layout.imageURL) forState:UIControlStateNormal placeholder:ZENITH_PLACEHODLER_IMAGE];
    
    if ([[ZESettingLocalData getUSERCODE] isEqual:layout.usercode]) {
        self.headImageView.right = SCREEN_WIDTH - kRightHeadImageMarginRight;
        self.bubbleView.image = [[UIImage imageNamed:@"bubble_right" color:MAIN_NAV_COLOR_A(0.7)] stretchableImageWithLeftCapWidth:5 topCapHeight:20];
        self.bubbleView.right = SCREEN_WIDTH - 55;
        _contentImageBtn.right = SCREEN_WIDTH - kBubbleMarginLeft - 15.0f;
    }
}

-(void)imageClick
{
    if ([_cell.delegate respondsToSelector:@selector(contentImageClick:)]) {
        [_cell.delegate contentImageClick:_chatImageUrl];
    }
}

@end

@implementation ZEChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = MAIN_LINE_COLOR;
    }
    return self;
}
- (void)setLayout:(ZEChatLayout *)layout withContentType:(NSString *)typeStr
{
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    self.height = layout.height;
    self.contentView.height = layout.height;
    [self setUI:layout];

    if ([typeStr isEqualToString:TYPETEXT]) {
        _contentTextView.hidden = NO;
        if([ZEUtil isNotNull:layout.quesAnsM]){
            [_contentTextView setChatContent:layout.quesAnsM withLayout:layout];;
        }else if([ZEUtil isNotNull:layout.questionInfo]){
            [_contentTextView setContent:layout.questionInfo withLayout:layout];;
        }else if ([ZEUtil isNotNull:layout.answerInfo]){
            [_contentTextView setContent:layout.answerInfo withLayout:layout];
        }
    }else if ([typeStr isEqualToString:TYPEIMAGE]){
        _contentImageView.hidden = NO;
        [_contentImageView setChatContent:layout];;
    }
}

-(void)setUI:(ZEChatLayout *)layout{
    _contentTextView = [[ZEChatTextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, layout.height)];
    _contentTextView.hidden = YES;
    _contentTextView.cell= self;
    [self.contentView addSubview:_contentTextView];
    
    _contentImageView = [[ZEChatImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, layout.height)];
    _contentImageView.origin = CGPointMake(0, 0);
    _contentImageView.size = CGSizeMake(SCREEN_WIDTH, layout.height);
    _contentImageView.hidden = YES;
    _contentImageView.cell = self;
    [self.contentView addSubview:_contentImageView];
}
@end
