//
//  ZEAnswerQuestionsView.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kMaxTextLength 500

#define kInputViewMarginLeft    10.0f
#define kInputViewMarginTop     NAV_HEIGHT
#define kInputViewWidth         SCREEN_WIDTH - 20.0f
#define kInputViewHeight        200.0f

#define textViewStr @"这个问题将由您来解答。"

#import "ZEAnswerQuestionsView.h"
#import "JCAlertView.h"
#import "PYPhotoBrowseView.h"
@interface ZEAnswerQuestionsView()<UITextViewDelegate,PYPhotoBrowseViewDataSource,PYPhotoBrowseViewDelegate>
{
    UITextView * _inputView;
    NSMutableArray * _choosedImageArr;
    JCAlertView * _alertView;
    UIView * _backImageView;//   上传图片背景view
    UIButton * questionTypeBtn;
    
    UIView * dashView; // 虚线视图
    ZEQuestionInfoModel * _questionInfoM;
    
}

@property (nonatomic,strong) NSMutableArray * choosedImageArr;

@end


@implementation ZEAnswerQuestionsView

-(id)initWithFrame:(CGRect)frame withQuestionInfoModel:(ZEQuestionInfoModel *)questionInfoM
{
    self = [super initWithFrame:frame];
    if (self) {
        _questionInfoM = questionInfoM;
        self.choosedImageArr = [NSMutableArray array];
        [self initView];
        [self initImageView];
    }
    return self;
}
-(void)initView
{
    self.questionExplainView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT- 217)];
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
    [_questionExplainView addSubview:_lengthLab];

    _questionExplainView.contentSize = CGSizeMake(SCREEN_WIDTH, _lengthLab.bottom);
}

-(void)initImageView
{
    if(!dashView){
        dashView= [[UIView alloc]initWithFrame:CGRectMake( 0, SCREEN_HEIGHT - 217, SCREEN_WIDTH, 1)];
        [self addSubview:dashView];
        [self drawDashLine:dashView lineLength:5 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    }
    
    _backImageView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
    [self addSubview:_backImageView];
    
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
    if (_questionExplainView.contentSize.height > NAV_HEIGHT + 282) {
        _questionExplainView.height = SCREEN_HEIGHT - NAV_HEIGHT- 300;
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
        hud3.detailsLabelText = @"最多显示500个字";
        hud3.detailsLabelFont = [UIFont systemFontOfSize:14];
        [hud3 hide:YES afterDelay:1.0f];

        textView.text = [textView.text substringToIndex:500];
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
