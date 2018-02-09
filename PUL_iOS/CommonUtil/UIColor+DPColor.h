//
//  UIColor+DPColor.h
//  dripo
//
//  Created by xiubo2008@gmail.com on 14-4-5.
//  Copyright (c) 2014年 xuejili. All rights reserved.
//

#import <UIKit/UIKit.h>

// Fonts for texts

//#define DPFontTextBold       @"HelveticaNeue"
//#define DPFontTextRegular    @"HelveticaNeue-Light"
//#define DPFontTextLight      @"HelveticaNeue-UltraLight"

#define DPFontTextBold       @"FZLanTingHeiS-L-GB"
#define DPFontTextRegular    @"FZLanTingHeiS-EL-GB"
#define DPFontTextLight      @"FZLanTingHeiS-UL-GB"

// Fonts for numbers

//FZLanTingHeiS-EL-GB  //中
//FZLanTingHeiS-L-GB  //粗
//FZLanTingHeiS-UL-GB //细

#define FZLTXIHJW @"FZLTXIHJW--GB1-0" // 粗
#define FZLTCXHJW @"FZLTCXHJW--GB1-0"// 细
#define FZLTXHJW @"FZLTXHJW--GB1-0" // 中

#define DPFontNumberBold     @"AvenirNextCondensed-Regular"
#define DPFontNumberRegular  @"AvenirNextCondensed-Light"
#define DPFontNumberThin     @"AvenirNextCondensed-UltraLight"

#define DPHashiLaboRegular    @"HashiLabo-Regular"


//#define SettingGroupFont @"HelveticaNeue-UltraLight"
//#define SettingLeftFont  @"HelveticaNeue-UltraLight"
//#define SettingRightFont @"HelveticaNeue"

#define SettingGroupFont @"FZLanTingHeiS-L-GB"
#define SettingLeftFont  @"FZLanTingHeiS-EL-GB"
#define SettingRightFont @"FZLanTingHeiS-UL-GB"


#define SettingGroupFontSize      14
#define SettingLeftFontSize       18
#define SettingLeftSmallFontSize  14
#define SettingRightFontSize      16
#define SettingRightSmallFontSize 14

@interface UIColor (DPColor)
+ (UIColor *)dpLineColor;
+ (UIColor *)dpBackgroundColor;
+ (UIColor *)dpColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)settingLineColor;
+ (UIColor *)settingBackgroundColor;
+ (UIColor *)settingGroupTitleColor;
+ (UIColor *)settingLeftFontColor;
+ (UIColor *)settingRightFontColor;
+ (UIColor *)SettingRightSmallFontColor;
+ (UIColor *)settingSwitchColor;

+ (UIColor*)colorWithHexString:(NSString*)hex andAlpha:(float)alpha;
+ (UIColor *)dpColor153;
+ (UIColor *)dpColor61;
+ (UIColor *)dpColor102;
+ (UIColor *)dpColor249;
+ (UIColor *)dpColor238;
//pageControl
+ (UIColor *)controlOnColor;
+ (UIColor *)controlOffColor;

+ (UIColor *)infoColor;
+ (UIColor *)lightPurple;


// Colors

+ (UIColor *)DPColorPrimary; //大紫
+ (UIColor *)DPColorReverse; //白色

+ (UIColor *)DPColorBackground1; //
+ (UIColor *)DPColorBackground2;
+ (UIColor *)DPColorBackground3;

+ (UIColor *)DPColorCardFooter1;
+ (UIColor *)DPColorCardFooter2;

+ (UIColor *)DPColorText;  //
+ (UIColor *)DPColorTextScore1;
+ (UIColor *)DPColorTextScore2;

+ (UIColor *)DPColorHighlight;

+ (UIColor *)DPColorLine1;
+ (UIColor *)DPColorLine2;

//添加渐变的颜色组合
+ (CAGradientLayer *)shadowAsInverse:(UIView *)view;

+ (UIColor *)getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image;

@end
