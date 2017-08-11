//
//  AppDelegate.h
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

//  测试版     http://117.149.2.229:1630/emark_learn
//  测试版     https://117.149.2.229:1629/emarkspg_nbsjzd

//  正式测试版本    http://114.55.55.205:8888/emarkspg_nbsjzd
//  正式版    http://114.55.55.205:8080/emarkspg_nbsjzd

//  King 机器版     http://192.168.1.175:8080/nbsjzd
//  Juan 机器版     http://192.168.1.189:8080/nbsjzd

#import <UIKit/UIKit.h>
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>

@interface ZEAppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate,JMessageDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

