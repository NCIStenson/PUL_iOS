//
//  ZEAskTeamQuestionView.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kInputViewMarginLeft    10.0f
#define kInputViewMarginTop     NAV_HEIGHT
#define kInputViewWidth         SCREEN_WIDTH - 20.0f
#define kInputViewHeight        120.0f

#define kMaxTextLength 200

#define textViewStr @"试着将问题尽可能清晰的描述出来，这样回答者们才能更完整、更高质量的为您解答。"

#import "ZEAskTeamQuestionView.h"

#import "ZEAskQuestionTypeView.h"

@interface ZEAskTeamQuestionView()<UITextViewDelegate,ZEAskQuestionTypeViewDelegate>
{
    UITextView * _inputView;
    NSMutableArray * _choosedImageArr;
    
    
    UIButton * questionTypeBtn; // 选择问题分类Button
    UIButton * _designatedNumberBtn; // 选择问题回答人员Button
    ZEAskQuestionTypeView * _askTypeView; // 选择问题分类视图
    
    UIView * _backImageView;//   上传图片背景view
    
    UIView * _dashView;  //  添加图片的View
    UIView * _rewardGoldView;  //  添加图片的View
    UIView * _anonymousAskView;  //  添加图片的View
    
    UIView * _functionButtonView;  // 盛放四个按钮
    
    NSMutableArray * goldScoreArr;
    
    BOOL _isAnonymousAsk; //  是否匿名提问
    
    UIButton * _rewardBtn; // 悬赏值按钮
}

@property (nonatomic,strong) NSMutableArray * choosedImageArr;

@end

@implementation ZEAskTeamQuestionView

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
//        [self initAnonymousView];
//        [self initRewardGoldView];
        
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
            _functionButtonView.frame = CGRectMake(0, SCREEN_HEIGHT - end.size.height - 35.0f, SCREEN_WIDTH, 30.0f);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.29 animations:^{
        _functionButtonView.frame = CGRectMake(0, SCREEN_HEIGHT - 250.0f, SCREEN_WIDTH, 30.0f);
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
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kInputViewMarginLeft);
        make.top.mas_equalTo(kInputViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kInputViewWidth, kInputViewHeight));
    }];
    
    UIView * dashView= [[UIView alloc]initWithFrame:CGRectMake( 0, kInputViewHeight + NAV_HEIGHT, SCREEN_WIDTH, 1)];
    [self addSubview:dashView];
    
    [self drawDashLine:dashView lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    
    questionTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionTypeBtn.frame = CGRectMake(10 , kInputViewHeight + NAV_HEIGHT , SCREEN_WIDTH - 20, 40.0f);
    [questionTypeBtn  setTitle:@"关键词：请选择问题分类" forState:UIControlStateNormal];
    [self addSubview:questionTypeBtn];
    [questionTypeBtn addTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
    questionTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [questionTypeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    questionTypeBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    questionTypeBtn.titleLabel.numberOfLines = 0;
    
    UIView * dashView2= [[UIView alloc]initWithFrame:CGRectMake( 0, kInputViewHeight + NAV_HEIGHT + 40, SCREEN_WIDTH, 1)];
    [self addSubview:dashView2];
    [self drawDashLine:dashView2 lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    
    _designatedNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _designatedNumberBtn.frame = CGRectMake(10 , kInputViewHeight + NAV_HEIGHT + 40 , SCREEN_WIDTH - 20, 40.0f);
    [_designatedNumberBtn  setTitle:@"指定提问：只能选取团队中的人，可多选" forState:UIControlStateNormal];
    [self addSubview:_designatedNumberBtn];
    [_designatedNumberBtn addTarget:self action:@selector(goChoooseNumberVC) forControlEvents:UIControlEventTouchUpInside];
    _designatedNumberBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_designatedNumberBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _designatedNumberBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _designatedNumberBtn.titleLabel.numberOfLines = 0;
    
    UIView * dashView3= [[UIView alloc]initWithFrame:CGRectMake( 0, kInputViewHeight + NAV_HEIGHT + 80, SCREEN_WIDTH, 1)];
    [self addSubview:dashView3];
    [self drawDashLine:dashView3 lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];

    _functionButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 30)];
    [self addSubview:_functionButtonView];
    
    UIButton * downKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downKeyboardBtn.frame = CGRectMake(10, 0, 30, 30);
    [downKeyboardBtn setImage:[UIImage imageNamed:@"TLdown"] forState:UIControlStateNormal];
    [_functionButtonView addSubview:downKeyboardBtn];
    [downKeyboardBtn addTarget:self action:@selector(downTheKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    downKeyboardBtn.clipsToBounds = YES;
    downKeyboardBtn.layer.cornerRadius = 15.0f;
    downKeyboardBtn.layer.borderWidth = 1.5;
    downKeyboardBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
    
    for (int i = 0 ; i < 1; i ++) {
        UIButton * cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(SCREEN_WIDTH - 120.0f + 40 * i, 0, 30, 30);
        if (i == 02) {
            [cameraBtn setImage:[UIImage imageNamed:@"discuss_pv" color:MAIN_GREEN_COLOR] forState:UIControlStateNormal];
            [cameraBtn addTarget:self action:@selector(anonymousAsk) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1){
            [cameraBtn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
            [cameraBtn setTitle:@"赏" forState:UIControlStateNormal];
            cameraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [cameraBtn addTarget:self action:@selector(rewardGold) forControlEvents:UIControlEventTouchUpInside];
            _rewardBtn = cameraBtn;
        }else if (i == 0){
            cameraBtn.frame = CGRectMake(SCREEN_WIDTH - 40, 0, 30, 30);
            [cameraBtn setImage:[UIImage imageNamed:@"camera_gray" color:MAIN_GREEN_COLOR] forState:UIControlStateNormal];
            [cameraBtn addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
        }
        [_functionButtonView addSubview:cameraBtn];
        cameraBtn.clipsToBounds = YES;
        cameraBtn.layer.cornerRadius = 15.0f;
        cameraBtn.layer.borderWidth = 1.5;
        cameraBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
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
    _backImageView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
    [self addSubview:_backImageView];
    
    _dashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [_backImageView addSubview:_dashView];
    
    [self drawDashLine:_dashView lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    
    for (int i = 0; i < self.choosedImageArr.count + 1; i ++) {
        UIButton * upImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upImageBtn.frame = CGRectMake( 10 * (i + 1) + (SCREEN_WIDTH - 40)/3* i , 18 , ( SCREEN_WIDTH - 40)/3, 180);
        upImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backImageView addSubview:upImageBtn];
        
        if (i == self.choosedImageArr.count && self.choosedImageArr.count < 4) {
            [upImageBtn addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
            [upImageBtn setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        }else{
            CGSize imageSize = [self getScaleImageSize:self.choosedImageArr[i] backgroundFrame:upImageBtn.frame];
            
            UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_backImageView addSubview:deleteBtn];
            deleteBtn.frame = CGRectMake(0, 0, 30, 30);
            [deleteBtn setImage:[UIImage imageNamed:@"delete_photo.png" ] forState:UIControlStateNormal];
            deleteBtn.center = CGPointMake(upImageBtn.frame.origin.x + (upImageBtn.frame.size.width - imageSize.width) / 2 + imageSize.width - 5, upImageBtn.frame.origin.y + (upImageBtn.frame.size.height - imageSize.height ) / 2 + 5);
            [deleteBtn addTarget:self action:@selector(deleteSelectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.tag = i;
            
            upImageBtn.tag = 100 + i;
            [upImageBtn addTarget:self action:@selector(goLookView:) forControlEvents:UIControlEventTouchUpInside];
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
        //        BOOL isOn = self.QUESINFOM.ISANONYMITY;
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
    [self endEditing:YES];
    
    _anonymousAskView.hidden = NO;
    [self bringSubviewToFront:_anonymousAskView];
    
    if (_anonymousAskView.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.5 animations:^{
            _anonymousAskView.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
        } completion:^(BOOL finished) {
            _rewardGoldView.hidden = YES;
            _rewardGoldView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
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
        [UIView animateWithDuration:0.5 animations:^{
            _rewardGoldView.frame = CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216);
        } completion:^(BOOL finished) {
            _anonymousAskView.hidden = YES;
            _anonymousAskView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
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
    
    if([self.goldScore integerValue] == 0){
        [_rewardBtn setTitle:@"赏" forState:UIControlStateNormal];
    }else{
        [ZEUtil shakeToShow:_rewardBtn];
        [_rewardBtn setTitle:self.goldScore forState:UIControlStateNormal];
    }
}

#pragma mark - Public Method

-(void)reloadChoosedImageView:(UIImage *)choosedImage
{
    if ([choosedImage isKindOfClass:[UIImage class]]) {
        [_choosedImageArr addObject:choosedImage];
    }else if([choosedImage isKindOfClass:[NSArray class]]){
        self.choosedImageArr = [NSMutableArray arrayWithArray:(NSArray *)choosedImage];
    }
    for (UIView * view in _backImageView.subviews) {
        [view removeFromSuperview];
    }
    
    [self initImageView];
}

-(void)reloadChooseMembersBtn:(NSString *)nameStr
{
    
}

#pragma mark - 展示提问问题分类列表

-(void)showQuestionTypeView
{
    [self endEditing:YES];
    _askTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _askTypeView.delegate = self;
    [self addSubview:_askTypeView];
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        [_askTypeView reloadTypeData];
    }
}

-(void)goChoooseNumberVC
{
    if ([self.delegate respondsToSelector:@selector(goChoooseMemberVC)]) {
        [self.delegate goChoooseMemberVC];
    }
}

#pragma mark - 选择问题分类

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode fatherCode:(NSString *)fatherCode
{
    [questionTypeBtn  setTitle:[NSString stringWithFormat:@"关键词：%@",typeName] forState:UIControlStateNormal];
    self.quesTypeSEQKEY = typeCode;
    for (UIView * view in _askTypeView.subviews) {
        [view removeFromSuperview];
    }
    [_askTypeView removeFromSuperview];
    _askTypeView = nil;
}



-(void)reloadRewardGold:(NSString *)sumpoints
{
    self.SUMPOINTS = sumpoints;
    
    [_rewardGoldView removeAllSubviews];
    
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
    if (textView.text.length > kMaxTextLength) {
        textView.text = [textView.text substringToIndex:kMaxTextLength];
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

-(void)showCondition
{
    [UIView animateWithDuration:0.29 animations:^{
        _rewardGoldView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216.0f);
        _anonymousAskView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216.0f);
    } completion:^(BOOL finished) {
        _rewardGoldView.hidden = YES;
        _anonymousAskView.hidden = YES;
    }];
    
    if ([self.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
        [self.delegate takePhotosOrChoosePictures];
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
    PYPhotoBrowseView *browser = [[PYPhotoBrowseView alloc] init];
    browser.images = self.choosedImageArr; // 图片总数
    browser.currentIndex = btn.tag - 100;
    [browser show];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
