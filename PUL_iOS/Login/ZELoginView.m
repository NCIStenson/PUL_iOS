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
#define kUsernameLabMarginTop   5.0f
#define kUsernameLabWidth       70.0f
#define kUsernameLabHeight      30.0f


#define kUsernameFieldMarginLeft  (kUsernameLabMarginLeft + kUsernameLabWidth)
#define kUsernameFieldMarginTop   0.0f
#define kUsernameFieldWidth       (SCREEN_WIDTH - 60.0f - kUsernameFieldMarginLeft)
#define kUsernameFieldHeight      34.0f

#define kPasswordImageMarginLeft  kUsernameImageMarginLeft
#define kPasswordImageMarginTop   (60.0f + kUsernameImageMarginTop)
#define kPasswordImageWidth       kUsernameImageWidth
#define kPasswordImageHeight      kUsernameImageHeight

#define kPasswordLabMarginLeft   (kPasswordImageMarginLeft + kPasswordImageWidth + 7.0f)
#define kPasswordLabMarginTop   65.0f
#define kPasswordLabWidth       70.0f
#define kPasswordLabHeight      30.0f

#define kPasswordFieldMarginLeft  (kPasswordLabMarginLeft + kPasswordLabWidth)
#define kPasswordFieldMarginTop   (kPasswordLabMarginTop + 0.0f)
#define kPasswordFieldWidth       (SCREEN_WIDTH - 60.0f - kPasswordLabMarginLeft - kPasswordLabWidth)
#define kPasswordFieldHeight      34.0f

// 登陆按钮位置
#define kLoginBtnWidth (_viewFrame.size.width - 70.0f)
#define kLoginBtnHeight 40.0f
#define kLoginBtnToLeft (SCREEN_WIDTH - kLoginBtnWidth) / 2
#define kLoginBtnToTop 428.0f

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
//        [self initLoginBtn];
    }
    return self;
}

#pragma mark - custom view init
- (void)initInputView
{
    UIImage * bannerImage = [UIImage imageNamed:@"login_background.png"];
    
    UIImageView * backgroundImage = [[UIImageView alloc]init];
    [backgroundImage setImage:bannerImage];
    [self addSubview:backgroundImage];
    backgroundImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * bannerImage.size.height /  bannerImage.size.width );
    
    UIView * inputMessageBackView = [[UIView alloc]init];
    [self addSubview:inputMessageBackView];
    inputMessageBackView.frame = CGRectMake(kLoginBtnToLeft, backgroundImage.height + 30, kLoginBtnWidth, 100);
#pragma mark - 用户名
    UIImageView * usernameImage = [[UIImageView alloc]init];
    usernameImage.contentMode = UIViewContentModeScaleAspectFit;
    [inputMessageBackView addSubview:usernameImage];
    usernameImage.left = kUsernameImageMarginLeft;
    usernameImage.top = kUsernameImageMarginTop;
    usernameImage.size = CGSizeMake(kUsernameImageWidth, kUsernameImageHeight);
    usernameImage.image = [UIImage imageNamed:@"login_username.png" color:kSubTitleColor];

    UILabel * usernameLab = [[UILabel alloc]initWithFrame:CGRectMake(kUsernameLabMarginLeft,kUsernameLabMarginTop,70,kUsernameLabHeight)];
    usernameLab.text = @"用户名：";
    usernameLab.font = [UIFont systemFontOfSize:15];
    usernameLab.userInteractionEnabled = NO;
    [inputMessageBackView addSubview:usernameLab];
    usernameLab.textColor = kSubTitleColor;
    
    _usernameField = [[UITextField alloc]initWithFrame:CGRectMake(kUsernameFieldMarginLeft,kUsernameFieldMarginTop,kUsernameFieldWidth, kUsernameFieldHeight)];
    _usernameField.textColor = kTextColor;
    _usernameField.delegate = self;
    [inputMessageBackView addSubview:_usernameField];
    _usernameField.textColor = kTextColor;

    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(kUsernameImageMarginLeft, kUsernameLabMarginTop + kUsernameLabHeight , inputMessageBackView.width, 0.5);
    lineLayer.backgroundColor = MAIN_LOGIN_COLOR.CGColor;
    [inputMessageBackView.layer addSublayer:lineLayer];

#pragma mark - 密码

    UIImageView * passwordImage = [[UIImageView alloc]init];
    [inputMessageBackView addSubview:passwordImage];
    passwordImage.contentMode = UIViewContentModeScaleAspectFit;
    passwordImage.left = kPasswordImageMarginLeft;
    passwordImage.top = kPasswordImageMarginTop;
    passwordImage.size = CGSizeMake(kPasswordImageWidth, kPasswordImageHeight);
    passwordImage.image = [UIImage imageNamed:@"login_password.png" color:kSubTitleColor];
    
    UILabel * passwordLab = [[UILabel alloc]initWithFrame:CGRectMake(kPasswordLabMarginLeft ,kPasswordLabMarginTop,70,kPasswordLabHeight)];
    passwordLab.text = @"密   码：";
    passwordLab.font = [UIFont systemFontOfSize:15];
    passwordLab.userInteractionEnabled = NO;
    passwordLab.textColor = kSubTitleColor;
    [inputMessageBackView addSubview:passwordLab];

    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(kPasswordFieldMarginLeft,kPasswordFieldMarginTop,(inputMessageBackView.width - kPasswordFieldMarginLeft) , kPasswordFieldHeight)];
    _passwordField.textColor = kTextColor;
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    [inputMessageBackView addSubview:_passwordField];

    CALayer * passwordLineLayer = [CALayer layer];
    passwordLineLayer.frame = CGRectMake(kPasswordImageMarginLeft, kPasswordFieldMarginTop + kPasswordFieldHeight, inputMessageBackView.width, 0.5);
    passwordLineLayer.backgroundColor = MAIN_LOGIN_COLOR.CGColor;
    [inputMessageBackView.layer addSublayer:passwordLineLayer];

#pragma mark - 登录按钮
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(kLoginBtnToLeft, inputMessageBackView.bottom + 40, kLoginBtnWidth, kLoginBtnHeight);
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [loginBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [loginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 3;
    if (IPHONE4S_LESS) {
        loginBtn.frame = CGRectMake(kLoginBtnToLeft, 420, kLoginBtnWidth, kLoginBtnHeight);
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#41b76a"].CGColor,  (__bridge id)RGBA(33, 132, 136, 0.8).CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    gradientLayer.frame = CGRectMake(0, 0, kLoginBtnWidth, kLoginBtnHeight);
    gradientLayer.frame = loginBtn.frame;
    gradientLayer.cornerRadius = 3;
    [self.layer addSublayer:gradientLayer];
    
    [self addSubview:loginBtn];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

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
    if([textField isEqual:_usernameField] && _passwordField.text.length == 0){
        [_passwordField becomeFirstResponder];
        return YES;
    }
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
