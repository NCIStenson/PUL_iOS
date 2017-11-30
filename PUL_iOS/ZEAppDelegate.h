//
//  AppDelegate.h
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//
1、知道问答页面修改调试完成 100%
2、专业圈拆分完成 100%
1、图片放大问题原因查找修改 100%
2、拾学正式版本项目测试修改 100%
3、电知道项目测试修改 100%
4、电知道、拾学项目发布 100%

//  测试版     http://117.149.2.229:1630/emark_learn

//  正式测试版本    http://114.55.55.205:8888/emarkspg_nbsjzd

//  Juan 机器版     http://192.168.1.190:8080/emark_learn

#import <UIKit/UIKit.h>
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>

@interface ZEAppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate,JMessageDelegate>

@property (nonatomic, assign) BOOL allowRotation; // 标记是否可以旋转
@property (strong, nonatomic) UIWindow *window;

@end

