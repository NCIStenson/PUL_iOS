//
//  ZEAskQuesView.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kInputViewMarginLeft    10.0f
#define kInputViewMarginTop     NAV_HEIGHT
#define kInputViewWidth         SCREEN_WIDTH - 20.0f
#define kInputViewHeight        120.0f

#define kMaxTextLength 2000

#define textViewStr @"试着将问题尽可能清晰的描述出来，这样回答者们才能更完整、更高质量的为您解答。"

#import "ZEAskQuesView.h"
#import "ZEAskQuestionTypeView.h"

@interface ZEAskQuesView()<UITextViewDelegate,ZEAskQuestionTypeViewDelegate,PYPhotoBrowseViewDataSource,PYPhotoBrowseViewDelegate>
{
    UITextView * _inputView;
    NSMutableArray * _choosedImageArr;
    
    
    UIButton * questionTypeBtn; // 选择问题Button
    
    UIView * _backImageView;//   上传图片背景view
    
//    UIView    * _dashView;  //  添加图片的View
    UIView * _rewardGoldView;  //  添加图片的View
    UIView * _anonymousAskView;  //  添加图片的View
    
    UIView * _functionButtonView;  // 盛放四个按钮
    
    NSMutableArray * goldScoreArr;
    
    BOOL _isAnonymousAsk; //  是否匿名提问
    
    UIButton * _rewardBtn; // 悬赏值按钮
}

@property (nonatomic,strong) NSMutableArray * choosedImageArr;

@end

@implementation ZEAskQuesView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.choosedImageArr = [NSMutableArray array];
        self.quesTypeSEQKEY = @"";
        
        [self initView];
        [self initImageView];
        [self initAnonymousView];
        [self initRewardGoldView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withQuestionInfoM:(ZEQuestionInfoModel *)quesInfoM
{
    self = [super initWithFrame:frame];
    if (self) {
        self.QUESINFOM = quesInfoM;
        self.choosedImageArr = [NSMutableArray array];
        self.quesTypeSEQKEY = @"";
        
        self.isAnonymousAsk = self.QUESINFOM.ISANONYMITY;
        self.goldScore = self.QUESINFOM.BONUSPOINTS;
        self.quesTypeSEQKEY = self.QUESINFOM.QUESTIONTYPECODE;
        
        [self initView];
        [self initImageView];
        [self initAnonymousView];
        [self initRewardGoldView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

#pragma mark - 键盘监听事件
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    CGRect end = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if(end.size.height > 0 ){
        [UIView animateWithDuration:0.29 animations:^{
            _functionButtonView.frame = CGRectMake(0, SCREEN_HEIGHT - end.size.height - 40.0f, SCREEN_WIDTH, 40.0f);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.29 animations:^{
        if(_backImageView.top == SCREEN_HEIGHT - 216 || _anonymousAskView.top == SCREEN_HEIGHT - 216 || _rewardGoldView.top == SCREEN_HEIGHT - 216){
            _functionButtonView.frame = CGRectMake(0, SCREEN_HEIGHT - 256.0f, SCREEN_WIDTH, 40.0f);
        }else{
            _functionButtonView.frame = CGRectMake(0, SCREEN_HEIGHT - 40.0f, SCREEN_WIDTH, 40.0f);
        }
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)initView
{
    self.inputView = [[UITextView alloc]initWithFrame:CGRectZero];
    _inputView.text = textViewStr;
    _inputView.font = [UIFont systemFontOfSize:14];
    _inputView.textColor = [UIColor lightGrayColor];
    _inputView.delegate = self;
    [self addSubview:_inputView];
    _inputView.frame = CGRectMake(kInputViewMarginLeft, kInputViewMarginTop, kInputViewWidth, kInputViewHeight);
    
    self.lengthLab = [UILabel new];
    _lengthLab.frame = CGRectMake(_inputView.left, _inputView.bottom, _inputView.width, 20);
    _lengthLab.font = [UIFont systemFontOfSize:14];
    _lengthLab.textColor = kTextColor;
    if([ZEUtil isNotNull:_QUESINFOM]){
        _lengthLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)_QUESINFOM.QUESTIONEXPLAIN.length,(long)kMaxTextLength];
    }else{
        _lengthLab.text = [NSString stringWithFormat:@"0/%ld",(long)kMaxTextLength];
    }
    _lengthLab.textAlignment = NSTextAlignmentRight;
//    [self addSubview:_lengthLab];
    
    UIView * dashView= [[UIView alloc]initWithFrame:CGRectMake( 0, kInputViewHeight + NAV_HEIGHT + _lengthLab.height, SCREEN_WIDTH, 1)];
    [self addSubview:dashView];
    
    [self drawDashLine:dashView lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
        
    questionTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionTypeBtn.frame = CGRectMake(10 , dashView.bottom , SCREEN_WIDTH - 20, 40.0f);
    [questionTypeBtn  setTitle:@"关键词：请选择问题分类" forState:UIControlStateNormal];
    [self addSubview:questionTypeBtn];
    [questionTypeBtn addTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
    questionTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [questionTypeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    questionTypeBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    questionTypeBtn.titleLabel.numberOfLines = 0;
    
    UIView * dashView2= [[UIView alloc]initWithFrame:CGRectMake( 0, questionTypeBtn.bottom, SCREEN_WIDTH, 1)];
    [self addSubview:dashView2];
    
    [self drawDashLine:dashView2 lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];

    _functionButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40)];
    _functionButtonView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:_functionButtonView];
    
    UIButton * downKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downKeyboardBtn.frame = CGRectMake(10, 0, 30, 30);
    [downKeyboardBtn setImage:[UIImage imageNamed:@"TLdown"] forState:UIControlStateNormal];
//    [_functionButtonView addSubview:downKeyboardBtn];
    [downKeyboardBtn addTarget:self action:@selector(downTheKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    downKeyboardBtn.clipsToBounds = YES;
    downKeyboardBtn.layer.cornerRadius = 15.0f;
    downKeyboardBtn.layer.borderWidth = 1.5;
    downKeyboardBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
    
    for (int i = 0 ; i < 3; i ++) {
        UIButton * cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(20 + 50 * i, 5, 30, 30);
        if (i == 1) {
            [cameraBtn setImage:[UIImage imageNamed:@"icon_ask_anonymous" ] forState:UIControlStateNormal];
            [cameraBtn addTarget:self action:@selector(anonymousAsk) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 2){
            [cameraBtn setImage:[UIImage imageNamed:@"icon_ask_gold" ] forState:UIControlStateNormal];
            [cameraBtn addTarget:self action:@selector(rewardGold) forControlEvents:UIControlEventTouchUpInside];
            _rewardBtn = cameraBtn;
        }else if (i == 0){
            [cameraBtn setImage:[UIImage imageNamed:@"icon_ask_image" ] forState:UIControlStateNormal];
            [cameraBtn addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
        }
        [_functionButtonView addSubview:cameraBtn];
//        cameraBtn.clipsToBounds = YES;
//        cameraBtn.layer.cornerRadius = 15.0f;
//        cameraBtn.layer.borderWidth = 1.5;
//        cameraBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
    }
    
    if ([ZEUtil isNotNull:self.QUESINFOM]) {
        self.inputView.text = self.QUESINFOM.QUESTIONEXPLAIN;
        self.inputView.textColor = kTextColor;
        
        NSArray * typeCodeArr = [_QUESINFOM.QUESTIONTYPECODE componentsSeparatedByString:@","];
        NSString * typeNameContent = @"";
        
        for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
            ZEQuestionTypeModel * questionTypeM = nil;
            ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
            for (int i = 0; i < typeCodeArr.count; i ++) {
                if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                    questionTypeM = typeM;
                    if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                        typeNameContent = questionTypeM.NAME;
                    }else{
                        typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                    }
                    break;
                }
            }
        }
        [questionTypeBtn  setTitle:[NSString stringWithFormat:@"关键词：%@",typeNameContent] forState:UIControlStateNormal];
    }
}

#pragma mark - 选择过的照片

-(void)initImageView
{
    if(_backImageView){
        return;
    }
    
    _backImageView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    [self addSubview:_backImageView];
    _backImageView.hidden = YES;
    _backImageView.backgroundColor =  MAIN_LINE_COLOR;
    
//    _dashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    [_backImageView addSubview:_dashView];
//    [self drawDashLine:_dashView lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    
    for (int i = 0; i < self.choosedImageArr.count + 1; i ++) {
        UIButton * upImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upImageBtn.frame = CGRectMake( 10 * (i + 1) + (SCREEN_WIDTH - 40)/3* i , 18 , ( SCREEN_WIDTH - 40)/3, (SCREEN_WIDTH - 40)/3);
        upImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backImageView addSubview:upImageBtn];
        
        if (i == self.choosedImageArr.count && self.choosedImageArr.count < 4) {
            
            upImageBtn.layer.borderColor = [MAIN_DEEPLINE_COLOR CGColor];
            upImageBtn.layer.borderWidth = 1;
            
            [upImageBtn addTarget:self action:@selector(addImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [upImageBtn setImage:[UIImage imageNamed:@"icon_add_image" color:MAIN_BLUE_COLOR] forState:UIControlStateNormal];
        }else{
            
            UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_backImageView addSubview:deleteBtn];
            deleteBtn.frame = CGRectMake(0, 0, 30, 30);
            [deleteBtn setImage:[UIImage imageNamed:@"delete_photo.png" ] forState:UIControlStateNormal];
            deleteBtn.center = CGPointMake(upImageBtn.frame.origin.x +  upImageBtn.width - deleteBtn.width / 2, upImageBtn.top + deleteBtn.height / 2);
            [deleteBtn addTarget:self action:@selector(deleteSelectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.tag = i;
            
            upImageBtn.tag = 100 + i;
            [upImageBtn addTarget:self action:@selector(goLookView:) forControlEvents:UIControlEventTouchUpInside];
            upImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [upImageBtn setImage:self.choosedImageArr[i] forState:UIControlStateNormal];
        }
    }
}

- (CGSize)getScaleImageSize:(UIImage*)_selectedImage backgroundFrame:(CGRect)frame
{
    float heightScale = frame.size.height/_selectedImage.size.height/1.0;
    float widthScale = frame.size.width/_selectedImage.size.width/1.0;
    float scale = MIN(heightScale, widthScale);
    float h = _selectedImage.size.height*scale;
    float w = _selectedImage.size.width*scale;
    return CGSizeMake(w, h);
}


-(void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

-(void)initAnonymousView
{
    _anonymousAskView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216.0f)];
    _anonymousAskView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:_anonymousAskView];
    
    UILabel * messageLab = [[UILabel alloc]init];
    [_anonymousAskView addSubview:messageLab];
    messageLab.text = @"匿名提问";
    messageLab.left = 20.0f;
    messageLab.top = 20.0f;
    messageLab.height = 20.0f;
    [messageLab sizeToFit];

    UISwitch * switchView = [[UISwitch alloc] init];
    [switchView addTarget:self action:@selector(isAnonymous:) forControlEvents:UIControlEventValueChanged];
    [_anonymousAskView addSubview:switchView];
    switchView.right = SCREEN_WIDTH - 20;
    switchView.top = 10.0f;
    if ([ZEUtil isNotNull:self.QUESINFOM]) {
        switchView.on = self.QUESINFOM.ISANONYMITY;
    }
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.0f, SCREEN_WIDTH, .5f)];
    lineView.backgroundColor = [UIColor grayColor];
    [_anonymousAskView addSubview:lineView];
    
    UILabel * subTitleLab = [[UILabel alloc]init];
    subTitleLab.left = 20.0f;
    subTitleLab.top = 55;
    subTitleLab.height = 20.0f;
    [_anonymousAskView addSubview:subTitleLab];
    subTitleLab.font = [UIFont systemFontOfSize:12];
    subTitleLab.textColor = [UIColor grayColor];
    subTitleLab.text = @"匿名提问扣10个积分";
    [subTitleLab sizeToFit];

    UILabel * currentGodeLab = [[UILabel alloc]init];
    currentGodeLab.font = [UIFont systemFontOfSize:12];
    currentGodeLab.textColor = [UIColor grayColor];
    currentGodeLab.text = @"当前积分：0";
    if([self.SUMPOINTS integerValue] > 0){
        currentGodeLab.text = [NSString stringWithFormat:@"当前积分：%@",self.SUMPOINTS];
    }
    currentGodeLab.textAlignment = NSTextAlignmentRight;
    [_anonymousAskView addSubview:currentGodeLab];
    currentGodeLab.frame = CGRectMake(0 , 55, 100, 20);
    [currentGodeLab sizeToFit];
    currentGodeLab.right = SCREEN_WIDTH - 20;
}

-(void)initRewardGoldView
{
    _rewardGoldView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216.0f)];
    _rewardGoldView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:_rewardGoldView];
    
    UILabel * messageLab = [[UILabel alloc]init];
    [_rewardGoldView addSubview:messageLab];
    messageLab.font = [UIFont systemFontOfSize:14];
    messageLab.text = @"选择悬赏积分：";
    messageLab.left = 20.0f;
    messageLab.top = 20.0f;
    messageLab.height = 20.0f;
    [messageLab sizeToFit];
    
    goldScoreArr = [[NSMutableArray alloc]init];
    
    NSArray * scoreArr = @[@"0",@"5",@"10",@"20",@"30",@"50",@"70",@"100",];

    for (int i = 0; i < 8; i ++) {
        
        float goldScoreBtnW = (SCREEN_WIDTH - 90) / 4;
        
        UIButton * goldScoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goldScoreBtn.frame = CGRectMake(30 + (goldScoreBtnW + 10) * i , 50.0f , goldScoreBtnW, 45);
        [goldScoreBtn setTitle:scoreArr[i] forState:UIControlStateNormal];
        [goldScoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rewardGoldView addSubview:goldScoreBtn];
        [goldScoreBtn addTarget:self action:@selector(downTheKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        goldScoreBtn.backgroundColor = [UIColor whiteColor];
        goldScoreBtn.clipsToBounds = YES;
        goldScoreBtn.layer.cornerRadius = 5.0f;
        goldScoreBtn.layer.borderWidth = 1;
        goldScoreBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
        goldScoreBtn.tag = i;
        [goldScoreBtn addTarget:self action:@selector(selectScore:) forControlEvents:UIControlEventTouchUpInside];
        if (i > 3) {
            goldScoreBtn.frame = CGRectMake(30 + (goldScoreBtnW + 10) * (i - 4) , 105.0f , goldScoreBtnW, 45);
        }
        if ([ZEUtil isNotNull:self.QUESINFOM]) {
            if ([scoreArr[i] integerValue] == [self.QUESINFOM.BONUSPOINTS integerValue]) {
                goldScoreBtn.backgroundColor = MAIN_GREEN_COLOR;
                [goldScoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }else{
            if(i == 0){
                goldScoreBtn.backgroundColor = MAIN_GREEN_COLOR;
                [goldScoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        if ([self.SUMPOINTS integerValue] < [scoreArr[i] integerValue]) {
            goldScoreBtn.enabled = NO;
            goldScoreBtn.backgroundColor = MAIN_LINE_COLOR;
            goldScoreBtn.layer.borderColor = [[UIColor grayColor] CGColor];;
        }
        
        [goldScoreArr addObject:goldScoreBtn];
    }
    
    UILabel * tipLab = [[UILabel alloc]init];
    [_rewardGoldView addSubview:tipLab];
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.text = @"您可用的积分：0";
    if ([self.SUMPOINTS integerValue] > 0) {
        tipLab.text = [NSString stringWithFormat:@"您可用的积分：%@",self.SUMPOINTS];

    }
    tipLab.frame = CGRectMake(0, 216 - 50, SCREEN_WIDTH, 20);
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.tag = 100;

    UILabel * subTipLab = [[UILabel alloc]init];
    [_rewardGoldView addSubview:subTipLab];
    subTipLab.font = [UIFont systemFontOfSize:12];
    subTipLab.textColor = [UIColor grayColor];
    subTipLab.text = @"提高悬赏，更容易吸引高手为你解答";
    subTipLab.frame = CGRectMake(0, 216 - 30, SCREEN_WIDTH, 20);
    subTipLab.textAlignment = NSTextAlignmentCenter;

}

#pragma mark - 匿名提问

-(void)anonymousAsk{
    if ([self.SUMPOINTS integerValue] < 10) {
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.labelText = @"当前积分过少，快去获取积分吧。";
        [hud3 hide:YES afterDelay:1.5];
        return;
    }
    
    [self endEditing:YES];

    _anonymousAskView.hidden = NO;
    [self bringSubviewToFront:_anonymousAskView];
    
    if (_anonymousAskView.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.29 animations:^{
            _functionButtonView.top =  SCREEN_HEIGHT - 256;
            _anonymousAskView.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
        } completion:^(BOOL finished) {
            _rewardGoldView.hidden = YES;
            _backImageView.hidden = YES;
            _rewardGoldView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
            _backImageView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        }];
    }else{
        [UIView animateWithDuration:0.29 animations:^{
            _functionButtonView.top =  SCREEN_HEIGHT - 40;
            _anonymousAskView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        }];
    }
}

-(void)isAnonymous:(UISwitch *)swit{
    _isAnonymousAsk = swit.on;
}

#pragma mark - 积分悬赏

-(void)rewardGold
{
    [self endEditing:YES];

    _rewardGoldView.hidden = NO;
    [self bringSubviewToFront:_rewardGoldView];

    if (_rewardGoldView.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.29 animations:^{
            _functionButtonView.top =  SCREEN_HEIGHT - 256;
            _rewardGoldView.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
        } completion:^(BOOL finished) {
            _anonymousAskView.hidden = YES;
            _backImageView.hidden = YES;
            _anonymousAskView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
            _backImageView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        }];
    }else{
        [UIView animateWithDuration:0.29 animations:^{
            _functionButtonView.top =  SCREEN_HEIGHT - 40;
            _rewardGoldView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        }];
    }
}
-(void)selectScore:(UIButton *)btn
{
    NSArray * scoreArr = @[@"0",@"5",@"10",@"20",@"30",@"50",@"70",@"100",];
    int i = 0;
    for (UIButton * button in goldScoreArr) {
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        if ([self.SUMPOINTS integerValue] < [scoreArr[i] integerValue]) {
            button.enabled = NO;
            button.backgroundColor = MAIN_LINE_COLOR;
            button.layer.borderColor = [[UIColor grayColor] CGColor];;
        }
        i ++;
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = MAIN_GREEN_COLOR;
    self.goldScore = scoreArr[btn.tag];
    
//    if([self.goldScore integerValue] == 0){
//        [_rewardBtn setTitle:@"赏" forState:UIControlStateNormal];
//    }else{
//        [ZEUtil shakeToShow:_rewardBtn];
//        [_rewardBtn setTitle:self.goldScore forState:UIControlStateNormal];
//    }
}

#pragma mark - Public Method

-(void)reloadChoosedImageView:(id)choosedImage
{
    if ([choosedImage isKindOfClass:[UIImage class]]) {
        [_choosedImageArr addObject:choosedImage];
    }else if([choosedImage isKindOfClass:[NSArray class]]){
        self.choosedImageArr = [NSMutableArray arrayWithArray:choosedImage];
    }
    for (UIView * view in _backImageView.subviews) {
        [view removeFromSuperview];
    }
    [_backImageView removeFromSuperview];
    _backImageView = nil;
    
    [self initImageView];
    _backImageView.hidden = NO;
    _backImageView.top = SCREEN_HEIGHT - 216;
    _functionButtonView.top =  SCREEN_HEIGHT - 256;
    [self bringSubviewToFront:_functionButtonView];
}

#pragma mark - 展示提问问题分类列表

-(void)showQuestionTypeView
{
    [self endEditing:YES];
    if([self.delegate respondsToSelector:@selector(changeAskQuestionTitle:)]){
        [self.delegate changeAskQuestionTitle:@"分类"];
    }
    _askTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withMarginTop:NAV_HEIGHT + 200];
    _askTypeView.delegate = self;
    [self addSubview:_askTypeView];
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        [_askTypeView reloadTypeData];
    }
}

#pragma mark - 选择问题分类

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode fatherCode:(NSString *)fatherCode
{
    for (UIView * view in _askTypeView.subviews) {
        [view removeFromSuperview];
    }
    [_askTypeView removeFromSuperview];
    _askTypeView = nil;
    if([self.delegate respondsToSelector:@selector(changeAskQuestionTitle:)]){
        [self.delegate changeAskQuestionTitle:@"描述你的问题"];
    }
    if (typeName.length == 0  && typeCode.length == 0 &&  fatherCode.length == 0) {
        return;
    }
    [questionTypeBtn  setTitle:[NSString stringWithFormat:@"关键词：%@",typeName] forState:UIControlStateNormal];
    self.quesTypeSEQKEY = typeCode;
}



-(void)reloadRewardGold:(NSString *)sumpoints
{
    self.SUMPOINTS = sumpoints;
    
    [_rewardGoldView removeAllSubviews];
    [_anonymousAskView removeAllSubviews];
    
    [self initAnonymousView];
    [self initRewardGoldView];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewStr]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = textViewStr;
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    _lengthLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)kMaxTextLength];
    if (textView.text.length > kMaxTextLength) {
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.detailsLabelText = [NSString stringWithFormat:@"最多显示%d个字",kMaxTextLength];
        hud3.detailsLabelFont = [UIFont systemFontOfSize:14];
        [hud3 hide:YES afterDelay:1.0f];
        
        textView.text = [textView.text substringToIndex:kMaxTextLength];
        _lengthLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)kMaxTextLength];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self downTheKeyBoard];
}

-(void)downTheKeyBoard
{
    [_inputView resignFirstResponder];
}

-(void)addImageBtnClick{
    if ([self.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
        [self.delegate takePhotosOrChoosePictures];
    }
}

-(void)showCondition
{
    [self endEditing:YES];
    _backImageView.hidden = NO;
    [self bringSubviewToFront:_backImageView];
    
    if (_backImageView.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.29 animations:^{
            _functionButtonView.top =  SCREEN_HEIGHT - 256;
            _backImageView.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
        } completion:^(BOOL finished) {
            _anonymousAskView.hidden = YES;
            _rewardGoldView.hidden = YES;
            _anonymousAskView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
            _rewardGoldView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        }];
        
        if ([self.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
            [self.delegate takePhotosOrChoosePictures];
        }
    }else{
        [UIView animateWithDuration:0.29 animations:^{
            _backImageView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
            _functionButtonView.top =  SCREEN_HEIGHT - 40;
        }];
    }
}

#pragma mark - 删除选择过的图片
-(void)deleteSelectedPhoto:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(deleteSelectedImageWIthIndex:)]) {
        [self.delegate deleteSelectedImageWIthIndex:btn.tag];
    }
}

-(void)goLookView:(UIButton*)btn
{
    PYPhotoBrowseView * browseView = [[PYPhotoBrowseView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    browseView.images = self.choosedImageArr; // 图片总数
    browseView.currentIndex = btn.tag - 100;
    browseView.delegate = self;
    browseView.dataSource = self;
    [browseView show];
}

- (CGRect)frameFormWindow{
    return CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

-(void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didSingleClickedImage:(UIImage *)image index:(NSInteger)index
{
    [photoBrowseView hidden];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
