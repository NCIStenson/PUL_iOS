//
//  ZEChangePweAlertView.m
//  PUL_iOS
//
//  Created by Stenson on 17/9/22.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kTextFieldHeight 45

#import "ZEChangePweAlertView.h"

@interface ZEChangePweAlertView(){

}

@end

@implementation ZEChangePweAlertView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    UILabel * titlelab = [UILabel new];
    titlelab.backgroundColor = MAIN_NAV_COLOR;
    [self addSubview:titlelab];
    titlelab.frame = CGRectMake(0, 0,self.width , 50);
    titlelab.text = @"首次登陆请修改密码";
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.textColor = [UIColor whiteColor];
    
    UIView * inputView = [UIView new];
    inputView.frame = CGRectMake(20, titlelab.bottom + 10, self.width - 40, kTextFieldHeight * 3);
    [self addSubview:inputView];
//    inputView.backgroundColor = [UIColor redColor];
    for (int i = 0; i < 3; i ++) {
        
        UIView * inputBackView = [UIView new];
        [inputView addSubview:inputBackView];
//        inputBackView.backgroundColor = MAIN_ARM_COLOR;
        inputBackView.frame = CGRectMake(0, 0 + kTextFieldHeight * i, inputView.width, kTextFieldHeight);
        
        UIImageView * iconBackgroundImage = [UIImageView new];
        [inputBackView addSubview:iconBackgroundImage];
        iconBackgroundImage.backgroundColor = MAIN_LINE_COLOR;
        iconBackgroundImage.frame = CGRectMake(0, 5, 35, 35);
        
        UIImageView * usernameImage = [[UIImageView alloc]init];
        usernameImage.contentMode = UIViewContentModeScaleAspectFit;
        usernameImage.size = CGSizeMake(16, 16);
        usernameImage.image = [UIImage imageNamed:@"login_password.png" color:kSubTitleColor];
        [inputBackView addSubview:usernameImage];
        
        usernameImage.center = iconBackgroundImage.center;
        
        [ZEUtil addLineLayerMarginLeft:iconBackgroundImage.right marginTop:39 width:inputBackView.width - 35 height:1 superView:inputBackView];
        
        UITextField * _usernameField = [[UITextField alloc]initWithFrame:CGRectMake(45,5 ,inputBackView.width - 35, 35)];
        _usernameField.secureTextEntry = YES;
        _usernameField.font = [UIFont systemFontOfSize:14];
        _usernameField.placeholder = @"请输入当前密码";
        _usernameField.textColor = kTextColor;
        [_usernameField setValue:kSubTitleColor forKeyPath:@"_placeholderLabel.textColor"];
        [inputBackView addSubview:_usernameField];
        
        switch (i) {
            case 0:
                _usernameField.placeholder = @"请输入当前密码";
                _oldField = _usernameField;
                break;
                
            case 1:
                _usernameField.placeholder = @"请输入新密码";
                _filedNewPwd = _usernameField;
                break;
                
            case 2:
                _usernameField.placeholder = @"请确认新密码";
                _fieldNewConfirm = _usernameField;
                break;
                
            default:
                break;
        }
    }
    
    for (int i = 0; i < 2; i ++) {
        UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(0 , inputView.bottom + 10, self.width / 3  , 40);
        [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [loginBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [loginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        loginBtn.clipsToBounds = YES;
        loginBtn.layer.cornerRadius = 3;
        [loginBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
//        loginBtn.titleLabel.textColor = MAIN_NAV_COLOR;
        [self addSubview:loginBtn];
        loginBtn.layer.borderWidth = 1;
        loginBtn.layer.borderColor = [MAIN_NAV_COLOR CGColor];
        
        if (i ==1) {
            [loginBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
            [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
            loginBtn.centerX = self.width / 18 * 13 ;
        }else if (i == 0){
            [loginBtn addTarget:self action:@selector(cancelChangePwd) forControlEvents:UIControlEventTouchUpInside];
            [loginBtn setTitle:@"取消" forState:UIControlStateNormal];
            loginBtn.centerX = self.width / 6  + self.width / 9;
        }

    }
}

-(void)changePwd
{
    if ([self.delegate respondsToSelector:@selector(changePwd)]) {
        [self.delegate changePwd];
    }
}

-(void)cancelChangePwd
{
    if ([self.delegate respondsToSelector:@selector(cancelChangePwd)]) {
        [self.delegate cancelChangePwd];
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
