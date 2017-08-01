//
//  ZELoginView.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//


#define kUsernameImageMarginLeft  0.0f
#define kUsernameImageMarginTop   9.0f
#define kUsernameImageWidth       18.0f
#define kUsernameImageHeight      22.0f

#define kUsernameLabMarginLeft  (kUsernameImageMarginLeft + kUsernameImageWidth + 7.0f)
#define kUsernameLabMarginTop   0.0f
#define kUsernameLabWidth       70.0f
#define kUsernameLabHeight      40.0f


#define kUsernameFieldMarginLeft  (kUsernameLabMarginLeft + kUsernameLabWidth)
#define kUsernameFieldMarginTop   3.0f
#define kUsernameFieldWidth       (SCREEN_WIDTH - 60.0f - kUsernameFieldMarginLeft)
#define kUsernameFieldHeight      34.0f

#define kPasswordImageMarginLeft  kUsernameImageMarginLeft
#define kPasswordImageMarginTop   (50.0f + kUsernameImageMarginTop)
#define kPasswordImageWidth       kUsernameImageWidth
#define kPasswordImageHeight      kUsernameImageHeight

#define kPasswordLabMarginLeft   (kPasswordImageMarginLeft + kPasswordImageWidth + 7.0f)
#define kPasswordLabMarginTop   50.0f
#define kPasswordLabWidth       70.0f
#define kPasswordLabHeight      40.0f


#define kPasswordFieldMarginLeft  (kPasswordLabMarginLeft + kPasswordLabWidth)
#define kPasswordFieldMarginTop   (kPasswordLabMarginTop + 3.0f)
#define kPasswordFieldWidth       (SCREEN_WIDTH - 60.0f - kPasswordFieldMarginLeft)
#define kPasswordFieldHeight      34.0f

// 登陆按钮位置
#define kLoginBtnWidth (_viewFrame.size.width - 75.0f)
#define kLoginBtnHeight 40.0f
#define kLoginBtnToLeft (SCREEN_WIDTH - kLoginBtnWidth) / 2
#define kLoginBtnToTop 428.0f * kCURRENTASPECT

#define kNavTitleLabelWidth SCREEN_WIDTH
#define kNavTitleLabelHeight 150.0f
#define kNavTitleLabelMarginLeft 0.0f
#define kNavTitleLabelMarginTop 20.0f

#define MAIN_LOGIN_COLOR    [ZEUtil colorWithHexString:@"aaaaaa"]
#define MAIN_LOGINBTN_COLOR    [ZEUtil colorWithHexString:@"#02bb32"]

#import "ZELoginView.h"
@interface ZELoginView ()<UITextFieldDelegate>
{
    CGRect _viewFrame;
    UIButton * loginBtn;
    
    UITextField * _usernameField;
    UITextField * _passwordField;
}
@end

@implementation ZELoginView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        self.backgroundColor = MAIN_LINE_COLOR;
        [self initInputView];
        [self initLoginBtn];
    }
    return self;
}

#pragma mark - custom view init
- (void)initInputView
{
    UIImageView * backgroundImage = [[UIImageView alloc]init];
    [backgroundImage setImage:[UIImage imageNamed:@"login_background.png"]];
    [self addSubview:backgroundImage];
    backgroundImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if (IPHONE4S_LESS) {
        backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    }
//    UIImageView * logoImageView = [[UIImageView alloc]init];
//    [logoImageView setImage:[UIImage imageNamed:@"logo.png"]];
//    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:logoImageView];
//    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.rightMargin.offset(kNavTitleLabelMarginLeft);
//        make.top.offset(kNavTitleLabelMarginTop);
//        make.size.mas_equalTo(CGSizeMake(kNavTitleLabelWidth, kNavTitleLabelHeight));
//    }];
    
    UIView * inputMessageBackView = [[UIView alloc]init];
    [self addSubview:inputMessageBackView];
    [inputMessageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IPHONE4S_LESS) {
            make.top.mas_equalTo(210);
        }else{
            make.top.mas_equalTo((235.0f + NAV_HEIGHT )  * kCURRENTASPECT);
        }
        make.left.mas_equalTo(kLoginBtnToLeft);
        make.size.mas_equalTo(CGSizeMake(kLoginBtnWidth,90));
    }];
    
#pragma mark - 用户名
    UIImageView * usernameImage = [[UIImageView alloc]init];
    usernameImage.contentMode = UIViewContentModeScaleAspectFit;
    [inputMessageBackView addSubview:usernameImage];
    usernameImage.left = kUsernameImageMarginLeft;
    usernameImage.top = kUsernameImageMarginTop;
    usernameImage.size = CGSizeMake(kUsernameImageWidth, kUsernameImageHeight);
    usernameImage.image = [UIImage imageNamed:@"login_username.png" color:MAIN_LOGIN_COLOR];

    UILabel * usernameLab = [[UILabel alloc]initWithFrame:CGRectMake(kUsernameLabMarginLeft,kUsernameLabMarginTop,70,kUsernameLabHeight)];
    usernameLab.text = @"用户名：";
    usernameLab.userInteractionEnabled = NO;
    usernameLab.textColor = MAIN_LOGIN_COLOR;
    [inputMessageBackView addSubview:usernameLab];
    
    _usernameField = [[UITextField alloc]initWithFrame:CGRectMake(kUsernameFieldMarginLeft,kUsernameFieldMarginTop,kUsernameFieldWidth, kUsernameFieldHeight)];
    _usernameField.textColor = [UIColor whiteColor];
    _usernameField.delegate = self;
    [inputMessageBackView addSubview:_usernameField];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(kUsernameImageMarginLeft, kUsernameLabMarginTop + kUsernameLabHeight, kLoginBtnWidth, 0.5);
    lineLayer.backgroundColor = MAIN_LOGIN_COLOR.CGColor;
    [inputMessageBackView.layer addSublayer:lineLayer];

#pragma mark - 密码

    UIImageView * passwordImage = [[UIImageView alloc]init];
    [inputMessageBackView addSubview:passwordImage];
    passwordImage.contentMode = UIViewContentModeScaleAspectFit;
    passwordImage.left = kPasswordImageMarginLeft;
    passwordImage.top = kPasswordImageMarginTop;
    passwordImage.size = CGSizeMake(kPasswordImageWidth, kPasswordImageHeight);
    passwordImage.image = [UIImage imageNamed:@"login_password.png" color:MAIN_LOGIN_COLOR];
    
    UILabel * passwordLab = [[UILabel alloc]initWithFrame:CGRectMake(kPasswordLabMarginLeft ,kPasswordLabMarginTop,70,kPasswordLabHeight)];
    passwordLab.text = @"密   码：";
    passwordLab.userInteractionEnabled = NO;
    passwordLab.textColor = MAIN_LOGIN_COLOR;
    [inputMessageBackView addSubview:passwordLab];

    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(kPasswordFieldMarginLeft,kPasswordFieldMarginTop,kPasswordFieldWidth, kPasswordFieldHeight)];
    _passwordField.textColor = [UIColor whiteColor];
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    [inputMessageBackView addSubview:_passwordField];
    
    CALayer * passwordLineLayer = [CALayer layer];
    passwordLineLayer.frame = CGRectMake(kPasswordImageMarginLeft, kPasswordLabMarginTop + kPasswordLabHeight - 0.5, kLoginBtnWidth, 0.5);
    passwordLineLayer.backgroundColor = MAIN_LOGIN_COLOR.CGColor;
    [inputMessageBackView.layer addSublayer:passwordLineLayer];

}

- (void)initLoginBtn
{
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(kLoginBtnToLeft, kLoginBtnToTop, kLoginBtnWidth, kLoginBtnHeight);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [loginBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [loginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    loginBtn.backgroundColor = MAIN_LOGINBTN_COLOR;
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 3;
    if (IPHONE4S_LESS) {
        loginBtn.frame = CGRectMake(kLoginBtnToLeft, 330, kLoginBtnWidth, kLoginBtnHeight);
    }
}

-(void)goLogin
{
    if (![_usernameField isExclusiveTouch]) {
        [_usernameField resignFirstResponder];
    }
    
    if (![_passwordField isExclusiveTouch]) {
        [_passwordField resignFirstResponder];
    }
    [UIView animateWithDuration:0.29 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
    if ([self.delegate respondsToSelector:@selector(goLogin:password:)]) {
        [self.delegate goLogin:_usernameField.text password:_passwordField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
        [UIView animateWithDuration:0.29 animations:^{
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:nil];
    
    if (![_usernameField isExclusiveTouch]) {
        [_usernameField resignFirstResponder];
    }
    
    if (![_passwordField isExclusiveTouch]) {
        [_passwordField resignFirstResponder];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IPHONE5) {
        [UIView animateWithDuration:0.29 animations:^{
            self.frame = CGRectMake(0, -100, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:nil];
    }else if (IPHONE4S_LESS) {
        [UIView animateWithDuration:0.29 animations:^{
            self.frame = CGRectMake(0, -150, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:nil];
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
