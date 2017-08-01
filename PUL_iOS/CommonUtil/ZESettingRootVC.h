//
//  DPSettingRootVC.h
//
//  Created by Stensonon 15/9/8.
//  Copyright (c) 2015年 Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScale (SCREEN_HEIGHT - (IPHONE4S_LESS ? 40.0 : 50.0f)) / (666.0f - (IPHONE4S_LESS ? 40.0 : 50.0f))

@interface ZESettingRootVC : UIViewController
{
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    UILabel *_titleLabel;
    NSString *_titleStr;
    NSString *_rightBtnTitleStr;
}

@property (nonatomic,strong) UIView *navBar;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) UIButton * rightBtn;
/**
 *  添加一条提示 1s后消失
 */
- (void)showTips:(NSString *)labelText;
- (void)showTips:(NSString *)labelText afterDelay:(NSTimeInterval)time;
/**
 *  开始加载HUD
 */
- (void)progressBegin:(NSString *)labelText;
/**
 *  结束加载HUD 1s后消失
 */
- (void)progressEnd:(NSString *)labelText;

- (void)leftBtnClick;
- (void)rightBtnClick;
- (void)setTitle:(NSString *)title;
- (void)setRightBtnTitle:(NSString *)rightBtnTitle;
- (void)disableLeftBtn;
- (void)disableRightBtn;

- (void)hiddenLine;

- (void)goBack;
@end
