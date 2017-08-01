  //
//  ZEChangePersonalMsgView.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/15.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChangePersonalMsgView.h"

@implementation ZEChangePersonalMsgView

-(id)initWithFrame:(CGRect)frame withChangeType:(CHANGE_PERSONALMSG_TYPE)changType;
{
    self = [super initWithFrame:frame];
    if (self) {
        if (changType == CHANGE_PERSONALMSG_NICKNAME) {
            [self initTextField];
        }else{
            [self initTextView];
        }
    }
    return self;
}

-(void)initTextField
{
    self.nicknameField = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 40)];
    _nicknameField.clipsToBounds = YES;
    _nicknameField.placeholder = [ZESettingLocalData getNICKNAME];
    _nicknameField.layer.cornerRadius = 5.0f;
    _nicknameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _nicknameField.leftViewMode = UITextFieldViewModeAlways;
    _nicknameField.backgroundColor = [UIColor whiteColor];
    [self addSubview:_nicknameField];
    [_nicknameField becomeFirstResponder];
}
-(void)initTextView
{
    UILabel * adviceLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40.0f, 20.0f)];
    adviceLab.text = @"请在此留下你对本APP的任何意见及看法：";
    adviceLab.textColor = [UIColor lightGrayColor];
    adviceLab.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:adviceLab];
    
    self.adviceTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 35, SCREEN_WIDTH - 40.0f, 150.0f)];
    _adviceTextView.clipsToBounds = YES;
    _adviceTextView.layer.cornerRadius = 5;
    [self addSubview:_adviceTextView];
    [_adviceTextView becomeFirstResponder];
}



@end
