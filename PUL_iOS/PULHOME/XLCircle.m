//
//  Circle.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircle.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

static CGFloat endPointMargin = -5.0f;

@interface XLCircle ()
{
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;
    UIImageView* _endPoint;//在终点位置添加一个点
    UILabel * numberLab;
}
@end

@implementation XLCircle


-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        [self initUI];
        [self buildLayout];
    }
    return self;
}
-(void)initUI
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBA(156, 209, 169, 1).CGColor,  (__bridge id)RGBA(135, 181, 183, 1).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:gradientLayer];
    gradientLayer.cornerRadius = self.frame.size.height / 2;
    
    numberLab = [UILabel new];
    numberLab.frame = CGRectMake(0, (IPHONE5 ? 15 :20), self.frame.size.width,  (IPHONE5 ? 25 :40));
    if(IPHONE4S_LESS){
        numberLab.top = 15;
        numberLab.height = 25;
    }
    [self addSubview:numberLab];
    numberLab.text = [NSString  stringWithFormat:@"%.2f%%",_progress * 100];
    numberLab.font = [UIFont systemFontOfSize:20];
    numberLab.textColor = [UIColor whiteColor];
    numberLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel * textLab = [UILabel new];
    textLab.frame = CGRectMake(0, numberLab.bottom, self.frame.size.width, 20);
    [self addSubview:textLab];
    textLab.text = @"正答率";
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.textAlignment = NSTextAlignmentCenter;
    numberLab.textColor = MAIN_SUBTITLE_COLOR;
}

-(void)buildLayout
{
    float centerX = self.bounds.size.width/2.0;
    float centerY = self.bounds.size.height/2.0;
    //半径
    float radius = (self.bounds.size.width-_lineWidth)/2.0;
    
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.5f*M_PI) endAngle:2.5f*M_PI clockwise:YES];
    
    //添加背景圆环

//    CAShapeLayer *backLayer = [CAShapeLayer layer];
//    backLayer.frame = self.bounds;
//    backLayer.fillColor =  [[UIColor clearColor] CGColor];
//    backLayer.strokeColor  = [UIColor clearColor].CGColor;
//    backLayer.lineWidth = _lineWidth;
//    backLayer.path = [path CGPath];
//    backLayer.strokeEnd = 1;
//    [self.layer addSublayer:backLayer];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [RGB(72, 103, 139) CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    //设置渐变颜色
//    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
//    gradientLayer.frame = self.bounds;
//    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RGB(255, 151, 0) CGColor],(id)[RGB(255, 203, 0) CGColor], nil]];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_progressLayer];
    
    
    //用于显示结束位置的小点
    _endPoint = [[UIImageView alloc] init];
    _endPoint.frame = CGRectMake(0, 0, 14,14);
    _endPoint.hidden = true;
    _endPoint.backgroundColor = RGBA(72, 103, 139,1);
//    _endPoint.backgroundColor = [UIColor redColor];
    _endPoint.image = [UIImage imageNamed:@"endPoint"];
    _endPoint.layer.masksToBounds = true;
    _endPoint.layer.cornerRadius = _endPoint.bounds.size.width/2;
    [self addSubview:_endPoint];
    _endPoint.layer.borderWidth = 4;
    _endPoint.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.5] CGColor];
//    _endPoint.layer.borderColor = [[UIColor redColor] CGColor];
    
}

-(void)setProgress:(float)progress
{
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [self updateEndPoint];
    [_progressLayer removeAllAnimations];
    numberLab.text = [NSString  stringWithFormat:@"%.0f%%",_progress * 100];
    numberLab.textColor = [UIColor whiteColor];
    numberLab.font = [UIFont systemFontOfSize:20];
}

//更新小点的位置
-(void)updateEndPoint
{
    //转成弧度
    CGFloat angle = M_PI*2*_progress + M_PI;
    float radius = (self.bounds.size.width-_lineWidth)/2.0;
    int index = (angle)/M_PI_2;//用户区分在第几象限内
    float needAngle = angle - index*M_PI_2;//用于计算正弦/余弦的角度
    float x = 0,y = 0;//用于保存_dotView的frame
    switch (index % 4) {
        case 0:
            NSLog(@"第一象限");
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 1:
            NSLog(@"第二象限");
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            NSLog(@"第三象限");
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        case 3:
            NSLog(@"第四象限");
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
            
        default:
            break;
    }
    
    //更新圆环的frame
    CGRect rect = _endPoint.frame;
    rect.origin.x = x + endPointMargin;
    rect.origin.y = y + endPointMargin;
    _endPoint.frame = rect;
    
    //移动到最前
    [self bringSubviewToFront:_endPoint];
    _endPoint.hidden = false;
    if (_progress == 0 || _progress == 1) {
        _endPoint.hidden = true;
    }
}

@end
