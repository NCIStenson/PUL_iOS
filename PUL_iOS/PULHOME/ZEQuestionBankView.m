//
//  ZEQuestionBankView.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kMyAchievementViewHeight 140.0f

#define kMyBankBtnViewHeight (SCREEN_HEIGHT - kMyBankViewHeight - kMyAchievementViewHeight - NAV_HEIGHT)
#define kMyBankViewHeight 80.0f

#define kLineWidth 2
#define endPointMargin 4

#define kServerBtnWidth (SCREEN_WIDTH - 40 ) / 4

#import "ZEQuestionBankView.h"
#import "XLCircle.h"
#import "ZEButton.h"

@interface ZEQuestionBankView()
{
    UIView * _redDot;
}

@end

@implementation ZEQuestionBankView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initTabBar];
    }
    return self;
}

-(void)initView{
    [self  initMyAchievementView];
    [self initBankBtn];
    
}

-(void)initMyAchievementView
{
    UIView * achiView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 140)];
    [self addSubview:achiView];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [achiView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UILabel * textLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 100, 20)];
    textLab.textColor = MAIN_SUBTITLE_COLOR;
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.text = @"我的成就";
    [achiView addSubview:textLab];
    
    float progress = 0.43;
    
    XLCircle * _circle = [[XLCircle alloc] initWithFrame:CGRectMake(50, 35, 100, 100) lineWidth:4];
    _circle.progress = progress;
    [achiView addSubview:_circle];
    
    for (int i = 0; i < 2; i ++) {
        UIImageView * imageView = [UIImageView new];
        imageView.frame = CGRectMake(SCREEN_WIDTH - 170, _circle.top + 15 + 45 * i, 25, 25);
        [achiView addSubview:imageView];
        imageView.backgroundColor = MAIN_ARM_COLOR;
        
        UILabel * textLab = [UILabel new];
        textLab.frame = CGRectMake(imageView.right + 10.0f, imageView.top, 120, 25);
        [achiView addSubview:textLab];
        textLab.font = [UIFont systemFontOfSize:12];
        
        switch (i) {
                case 0:
                    textLab.text = @"总时长     100h";
                break;
                
                case 1:
                    textLab.text = @"刷题数     200";
                break;
                
            default:
                break;
        }
        
    }
}

-(void)initBankBtn{
    UIView * bankBtnView = [UIView new];
    bankBtnView.frame = CGRectMake(0, NAV_HEIGHT + kMyAchievementViewHeight, SCREEN_WIDTH, kMyBankBtnViewHeight );
    [self addSubview:bankBtnView];
    bankBtnView.backgroundColor = MAIN_ARM_COLOR;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [bankBtnView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

}

-(void)initTabBar
{
    UIView * tabBarView = [UIView new];
    [self addSubview:tabBarView];
    tabBarView.backgroundColor = MAIN_ARM_COLOR;
    tabBarView.frame = CGRectMake(0, kMyBankBtnViewHeight + kMyAchievementViewHeight + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kMyBankBtnViewHeight - kMyAchievementViewHeight - NAV_HEIGHT);
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [tabBarView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    for (int i = 0 ; i < 4; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(20 + kServerBtnWidth * i, 0, kServerBtnWidth, kServerBtnWidth);
        [tabBarView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor clearColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 200;
        [optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        switch (i) {
                case 0:
                [optionBtn setImage:[UIImage imageNamed:@"home_btn_bank"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"能力题库" forState:UIControlStateNormal];
                break;
                case 1:
                [optionBtn setImage:[UIImage imageNamed:@"home_btn_ask" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"知道问答" forState:UIControlStateNormal];
                break;
                case 2:
                [optionBtn setImage:[UIImage imageNamed:@"home_btn_school_white" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"能力学堂" forState:UIControlStateNormal];
                break;
                case 3:
                [optionBtn setImage:[UIImage imageNamed:@"home_btn_dev" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"员工发展" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        if (i == 0) {
            [optionBtn setSelected:YES];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
