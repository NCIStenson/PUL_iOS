//
//  ZEAnswerQuestionsView.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kMaxTextLength 2000

#define kInputViewMarginLeft    10.0f
#define kInputViewMarginTop     NAV_HEIGHT
#define kInputViewWidth         SCREEN_WIDTH - 20.0f
#define kInputViewHeight        200.0f

#define textViewStr @"这个问题将由您来解答。"

#import "ZENewAnswerQuestionView.h"
#import "JCAlertView.h"
#import "PYPhotoBrowseView.h"
@interface ZENewAnswerQuestionView()<UITextViewDelegate,PYPhotoBrowseViewDataSource,PYPhotoBrowseViewDelegate>
{
    UITextView * _inputView;
    NSMutableArray * _choosedImageArr;
    JCAlertView * _alertView;
    UIView * _backImageView;//   上传图片背景view
    UIButton * questionTypeBtn;
    
    UIView * dashView; // 虚线视图
    ZEQuestionInfoModel * _questionInfoM;
    
    UIView * modelBackgroundView;
    
}

@property (nonatomic,strong) NSMutableArray * choosedImageArr;

@end


@implementation ZENewAnswerQuestionView

-(id)initWithFrame:(CGRect)frame withQuestionInfoModel:(ZEQuestionInfoModel *)questionInfoM
{
    self = [super initWithFrame:frame];
    if (self) {
        _questionInfoM = questionInfoM;
        self.choosedImageArr = [NSMutableArray array];
        [self initView];
        [self initChooseImageView];
        
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
            modelBackgroundView.frame = CGRectMake(0, SCREEN_HEIGHT - end.size.height - 40.0f, SCREEN_WIDTH, 40.0f);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.29 animations:^{
        if (_choosedImageArr.count >0) {
            modelBackgroundView.top =  SCREEN_HEIGHT - 216 - 40.0f;
        }else{
            modelBackgroundView.top =  SCREEN_HEIGHT - 40.0f;
        }
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)initView
{
    self.questionExplainView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT- 217 - 40)];
    _questionExplainView.delegate = self;
    _questionExplainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_questionExplainView];
    
    float questionExplainHeight = [ZEUtil heightForString:_questionInfoM.QUESTIONEXPLAIN font:[UIFont boldSystemFontOfSize:16] andWidth:SCREEN_WIDTH - 20];
    
    UIView * backgroundView = [UIView new];
    backgroundView.backgroundColor = MAIN_BACKGROUND_COLOR;
    [_questionExplainView addSubview:backgroundView];
    backgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, questionExplainHeight + 20);
    
    UILabel * explainLab = [UILabel new];
    explainLab.left = 10;
    explainLab.top = 10;
    explainLab.size = CGSizeMake(SCREEN_WIDTH - 20, questionExplainHeight);
    [backgroundView addSubview:explainLab];
    explainLab.text = _questionInfoM.QUESTIONEXPLAIN;
    explainLab.font = [UIFont boldSystemFontOfSize:16];
    explainLab.textColor = kTextColor;
    explainLab.numberOfLines = 0;
    
    self.inputView = [[UITextView alloc]initWithFrame:CGRectZero];
    _inputView.text = textViewStr;
    _inputView.font = [UIFont systemFontOfSize:14];
    _inputView.textColor = [UIColor lightGrayColor];
    _inputView.delegate = self;
    _inputView.left = kInputViewMarginLeft;
    _inputView.top =  backgroundView.bottom;
    _inputView.size = CGSizeMake(kInputViewWidth, kInputViewHeight);
    [_questionExplainView addSubview:_inputView];
    
    self.lengthLab = [UILabel new];
    _lengthLab.frame = CGRectMake(_inputView.left, _inputView.bottom, _inputView.width, 20);
    _lengthLab.font = [UIFont systemFontOfSize:14];
    _lengthLab.textColor = kTextColor;
    _lengthLab.text = [NSString stringWithFormat:@"0/%ld",(long)kMaxTextLength];
    _lengthLab.textAlignment = NSTextAlignmentRight;
//    [_questionExplainView addSubview:_lengthLab];
    
    _questionExplainView.contentSize = CGSizeMake(SCREEN_WIDTH, _lengthLab.bottom);
}

-(void)initChooseImageView
{
    modelBackgroundView = [UIView new];
    modelBackgroundView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    modelBackgroundView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:modelBackgroundView];
    
    for (int i = 0; i < 1; i ++) {
        UIButton * upImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upImageBtn.frame = CGRectMake( 20  +  50 * i, 5, 30, 30);
        upImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [modelBackgroundView addSubview:upImageBtn];
        [upImageBtn addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
        [upImageBtn setImage:[UIImage imageNamed:@"icon_ask_image"] forState:UIControlStateNormal];
    }
}

-(void)initImageView
{
    _backImageView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
    [self addSubview:_backImageView];
    
    [UIView animateWithDuration:0.29 animations:^{
        modelBackgroundView.top = SCREEN_HEIGHT - 216 - 40;
    }];
    
    for (int i = 0; i < self.choosedImageArr.count + 1; i ++) {
        UIButton * upImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upImageBtn.frame = CGRectMake( 10 * (i + 1) + (SCREEN_WIDTH - 40)/3* i , 18 , ( SCREEN_WIDTH - 40)/3, (SCREEN_WIDTH - 40)/3);
        upImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backImageView addSubview:upImageBtn];
        
        if (i == self.choosedImageArr.count && self.choosedImageArr.count < 4) {
            
            upImageBtn.layer.borderColor = [MAIN_LINE_COLOR CGColor];
            upImageBtn.layer.borderWidth = 1;
            
            [upImageBtn addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 删除选择过的图片
-(void)deleteSelectedPhoto:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(deleteSelectedImageWIthIndex:)]) {
        [self.delegate deleteSelectedImageWIthIndex:btn.tag];
    }
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

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_questionExplainView.contentSize.height >SCREEN_HEIGHT - ( NAV_HEIGHT + 282 + 40)) {
        _questionExplainView.height = SCREEN_HEIGHT - NAV_HEIGHT- 322;
        [_questionExplainView scrollToBottom];
    }
    
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self downTheKeyBoard];
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
    _questionExplainView.height = SCREEN_HEIGHT - NAV_HEIGHT- 217;
    [_inputView resignFirstResponder];
}

#pragma mark - ZEAskQuesViewDelegate

-(void)showCondition
{
    if ([self.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
        [self.delegate takePhotosOrChoosePictures];
    }
}

-(void)goLookView:(UIButton *)btn
{
    PYPhotoBrowseView *browser = [[PYPhotoBrowseView alloc] init];
    browser.images = self.choosedImageArr; // 图片总数
    browser.currentIndex = btn.tag - 100;
    browser.delegate = self;
    browser.dataSource = self;
    [browser show];
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

