//
//  ZESetPersonalMessageView.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/11.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZESetPersonalMessageView;

@protocol ZESetPersonalMessageViewDelegate <NSObject>

-(void)changePersonalMsg:(CHANGE_PERSONALMSG_TYPE)type;

/**
 *  @author Stenson, 16-08-15 09:08:28
 *
 *  退出登录
 */
-(void)logout;

-(void)changePassword;
@end

@interface ZESetPersonalMessageView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) id <ZESetPersonalMessageViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame withEnterType:(ENTER_SETTING_TYPE)type;

-(void)reloadDataWithDic:(NSDictionary *)dic;

-(void)reloadPersonalScore:(NSString *)points;

@end
