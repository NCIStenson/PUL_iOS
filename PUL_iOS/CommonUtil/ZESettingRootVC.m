//
//  DPSettingRootVC.m
//
//  Created by Stenson on 15/9/8.
//  Copyright (c) 2015年 Zenith Electronic Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

// 导航栏
#define kNavBarWidth SCREEN_WIDTH
#define kNavBarHeight NAV_HEIGHT
#define kNavBarMarginLeft 0.0f
#define kNavBarMarginTop 0.0f
// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f + 16.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 0.0f
#define kLeftButtonMarginTop (IPHONEX ? 42 : 20.0f + 2.0f)
// 导航栏右侧按钮
#define kRightButtonWidth 60.0f
#define kRightButtonHeight 40.0f
#define kRightButtonMarginLeft kNavBarWidth - kRightButtonWidth
#define kRightButtonMarginTop kLeftButtonMarginTop + 2.0f
// 导航栏标题
#define kNavTitleLabelWidth (SCREEN_WIDTH - 110.0f)
#define kNavTitleLabelHeight 44.0f
#define kNavTitleLabelMarginLeft (kNavBarWidth - kNavTitleLabelWidth) / 2.0f
#define kNavTitleLabelMarginTop kLeftButtonMarginTop - 2.0f

@interface ZESettingRootVC ()
{
    CALayer *line;
}
@end

@implementation ZESettingRootVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
//    [self beginLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)progressBegin:(NSString *)labelText {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (labelText) {
        hud.labelText = labelText;
    }
//    hud.labelText = @"正在加载数据";
}

-(void)progressHidden
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)showTips:(NSString *)labelText {

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud3.mode = MBProgressHUDModeText;
    hud3.detailsLabelText = labelText;
    hud3.detailsLabelFont = [UIFont systemFontOfSize:14];
    [hud3 hide:YES afterDelay:1.0f];
}

- (void)showTips:(NSString *)labelText afterDelay:(NSTimeInterval)time {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud3.mode = MBProgressHUDModeText;
    hud3.labelText = labelText;
    [hud3 hide:YES afterDelay:time];
}


- (void)progressEnd:(NSString *)labelText {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (labelText) {
        hud2.labelText = labelText;
    }
//    hud2.labelText = @"加载完成";
    [hud2 hide:YES afterDelay:1.0f];
}

#pragma mark - View init
- (void)initNavBar
{
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(kNavBarMarginLeft, kNavBarMarginTop, kNavBarWidth, kNavBarHeight)];
//    _navBar.backgroundColor = MAIN_NAV_COLOR;
    _navBar.clipsToBounds = YES;
    
    [ZEUtil addGradientLayer:_navBar];

    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, kLeftButtonWidth, kLeftButtonHeight);
    _leftBtn.backgroundColor = [UIColor clearColor];
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    _leftBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_leftBtn setImage:[UIImage imageNamed:@"icon_back" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"icon_back" tintColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_navBar addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(kRightButtonMarginLeft, kRightButtonMarginTop, kRightButtonWidth, kRightButtonHeight);
    _rightBtn.backgroundColor = [UIColor clearColor];
    [_rightBtn setTitle:_rightBtnTitleStr forState:UIControlStateNormal];
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:19.0f]];
    [_rightBtn.titleLabel setTextColor:[UIColor blackColor]];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_rightBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:_rightBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNavTitleLabelMarginLeft, kNavTitleLabelMarginTop, kNavTitleLabelWidth, kNavTitleLabelHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:22.0f];
    _titleLabel.text = [ZEUtil isStrNotEmpty:_titleStr] ? _titleStr : @"";
    _titleLabel.numberOfLines = 0;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [_navBar addSubview:_titleLabel];
    
//    line = [CALayer layer];
//    line.frame = CGRectMake(0, kNavBarHeight - 0.5f, kNavBarWidth, 0.5f);
//    line.backgroundColor = [[UIColor lightGrayColor] CGColor];
//    [_navBar.layer addSublayer:line];
    
    
    [self.view addSubview:_navBar];
}

#pragma mark - Btn event
- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick
{
//    NSLog(@"parent right btn click!!");
}

#pragma mark - Data event
- (void)setTitle:(NSString *)title
{
    _titleStr = title;
    _titleLabel.text = title;
}
- (void)setRightBtnTitle:(NSString *)rightBtnTitle
{
    _rightBtnTitleStr = rightBtnTitle;
    [_rightBtn setTitle:_rightBtnTitleStr forState:UIControlStateNormal];
    
}

- (void)disableLeftBtn
{
    _leftBtn.enabled = NO;
    _leftBtn.hidden = YES;
}
- (void)disableRightBtn
{
    _rightBtn.enabled = NO;
    _rightBtn.hidden = YES;
}

- (void)hiddenLine{
    line.hidden = YES;
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
