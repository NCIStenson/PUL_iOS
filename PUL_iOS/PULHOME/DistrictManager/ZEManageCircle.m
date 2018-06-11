//
//  ZEManageCircle.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//


#import "ZEManageCircle.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define CIRCLE_BLUE_COLOR RGBA(75, 175, 217, 1)

static CGFloat endPointMargin = -5.0f;

@interface ZEManageCircle ()
{
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;

    UILabel * numberLab;
}
@end

@implementation ZEManageCircle


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
    numberLab = [UILabel new];
    numberLab.frame = CGRectMake(0, (IPHONE5 ? 15 :20), self.frame.size.width,  (IPHONE5 ? 25 :40));
    if(IPHONE4S_LESS){
        numberLab.top = 15;
        numberLab.height = 25;
    }
    [self addSubview:numberLab];
    numberLab.text = [NSString  stringWithFormat:@"%.2f%%",_progress * 100];
    numberLab.font = [UIFont systemFontOfSize:24];
    numberLab.textColor =MAIN_NAV_COLOR;
    numberLab.textAlignment = NSTextAlignmentCenter;
    numberLab.center = CGPointMake(self.width / 2, self.height / 2);
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
    
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
    backLayer.strokeColor = MAIN_DEEPLINE_COLOR.CGColor;
    backLayer.lineWidth = _lineWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];

    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [MAIN_NAV_COLOR CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    [self.layer addSublayer:_progressLayer];
    
    
}

-(void)setProgress:(float)progress
{
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [_progressLayer removeAllAnimations];
    numberLab.text = [NSString  stringWithFormat:@"%.0f%%",_progress * 100];
    numberLab.font = [UIFont systemFontOfSize:20];
    if(progress < .8){
        numberLab.textColor = CIRCLE_BLUE_COLOR;
        _progressLayer.strokeColor  = [CIRCLE_BLUE_COLOR CGColor];
    }else{
        numberLab.textColor = MAIN_NAV_COLOR;
        _progressLayer.strokeColor  = [MAIN_NAV_COLOR CGColor];
    }
}

-(void)setScore:(float)score
{
    _score = score;
    
    _progressLayer.strokeEnd = _score/100;
    [_progressLayer removeAllAnimations];
    numberLab.text = [NSString  stringWithFormat:@"%.0f分",_score];
    numberLab.font = [UIFont systemFontOfSize:20];
    
    if(_score < 80){
        numberLab.textColor = CIRCLE_BLUE_COLOR;
        _progressLayer.strokeColor  = [CIRCLE_BLUE_COLOR CGColor];
    }else{
        numberLab.textColor = MAIN_NAV_COLOR;
        _progressLayer.strokeColor  = [MAIN_NAV_COLOR CGColor];
    }
    
}

@end
