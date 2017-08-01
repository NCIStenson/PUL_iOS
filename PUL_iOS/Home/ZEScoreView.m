//
//  ZEScoreView.m
//  PUL_iOS
//
//  Created by Stenson on 16/11/9.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEScoreView.h"

@interface ZEScoreView ()
{
    CGRect _viewFrame;
    
    NSString * scoreStr;
}

@end


@implementation ZEScoreView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 144.0f)];
    if (self) {
        _viewFrame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 144.0f);
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        [self initView];
    }
    return self;
}

-(void)initView
{
    
    
    for (int i = 0; i < 5; i ++) {
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        optionBtn.frame = CGRectMake(( _viewFrame.size.width - 200 ) / 2 + 40 * i, 30.0f, 30.0f, 30.0f);
        [optionBtn setImage:[UIImage imageNamed:@"course_score_number"] forState:UIControlStateNormal];
        [optionBtn setImage:[UIImage imageNamed:@"course_score_number"] forState:UIControlStateHighlighted];
        optionBtn.tag = i + 1000;
        [optionBtn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:optionBtn];
    }
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 60.0f, self.frame.size.width, 44.0f)];
    titleLab.text = @"请点选星星评分";
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];


    for (int i = 0; i < 2; i ++) {
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        optionBtn.frame = CGRectMake(0 + _viewFrame.size.width / 2 * i , 100.0f, _viewFrame.size.width / 2, 44.0f);
        [optionBtn setTitle:@"暂不评分" forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        optionBtn.tag = i + 100;
        [optionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [optionBtn addTarget:self action:@selector(confirmScoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:optionBtn];
        if (i == 1) {
            [optionBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
            [optionBtn setTitle:@"提交评分" forState:UIControlStateNormal];
        }
    }
    
    CALayer * vLineLayer = [CALayer layer];
    vLineLayer.frame = CGRectMake(0.0, 100.0f, self.frame.size.width, 0.5f);
    vLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    [self.layer addSublayer:vLineLayer];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(_viewFrame.size.width / 2 - 0.25f, 100.0f, 0.5f, 44.0f);
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    [self.layer addSublayer:lineLayer];
}

-(void)starBtnClick:(UIButton *)btn
{
    for (int i = 1000;  i <= 1005; i ++ ) {
        UIButton * btn = (UIButton * )[self viewWithTag:i];
        [btn setImage:[UIImage imageNamed:@"course_score_number"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"course_score_number"] forState:UIControlStateHighlighted];
    }

    for (int i = 1000; i <= btn.tag; i ++) {
        UIButton * btn = (UIButton * )[self viewWithTag:i];
        [btn setImage:[UIImage imageNamed:@"course_score_number_selectd"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"course_score_number_selectd"] forState:UIControlStateHighlighted];
    }
    scoreStr = [NSString stringWithFormat:@"%ld",(long)btn.tag - 999];
}

-(void)confirmScoreBtnClick:(UIButton *)btn
{
    if (btn.tag == 101) {
        if([ZEUtil isNotNull:scoreStr]){
            if ([self.delegate respondsToSelector:@selector(didSelectScore:)]) {
                [self.delegate didSelectScore:scoreStr];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(dismissTheScoreView)]) {
                [self.delegate dismissTheScoreView];
            }
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(dismissTheScoreView)]) {
            [self.delegate dismissTheScoreView];
        } 
    }
}

@end
