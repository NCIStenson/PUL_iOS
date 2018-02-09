//
//  ZEChangePweAlertView.h
//  PUL_iOS
//
//  Created by Stenson on 17/9/22.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEChangePweAlertView;

@protocol ZEChangePweAlertViewDelegate <NSObject>

-(void)changePwd;

-(void)cancelChangePwd;

@end

@interface ZEChangePweAlertView : UIView

@property (nonatomic,weak) id <ZEChangePweAlertViewDelegate> delegate;

@property (nonatomic,strong) UITextField * oldField;
@property (nonatomic,strong) UITextField * filedNewPwd;
@property (nonatomic,strong) UITextField * fieldNewConfirm;


-(id)initWithFrame:(CGRect)frame;

@end
