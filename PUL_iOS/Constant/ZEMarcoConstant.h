//
//  ZEMarcoConstant.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#ifndef ZEMarcoConstant_h
#define ZEMarcoConstant_h

#define RICHTEXT_IMAGE (@"[UIImageView]")

#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif


#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define IS_IOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define IS_IOS10 [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0
#define IS_IOS11 [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0

#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define kCURRENTASPECT SCREEN_WIDTH / 375.0f


#define FRAME_WIDTH     [[UIScreen mainScreen] applicationFrame].size.width
#define FRAME_HEIGHT    [[UIScreen mainScreen] applicationFrame].size.height
#define IPHONE5_MORE     ([[UIScreen mainScreen] bounds].size.height > 480)
#define IPHONE4S_LESS    ([[UIScreen mainScreen] bounds].size.height <= 480)
#define IPHONE5     ([[UIScreen mainScreen] bounds].size.height == 568)
#define IPHONE6_MORE     ([[UIScreen mainScreen] bounds].size.height > 568)
#define IPHONE6     ([[UIScreen mainScreen] bounds].size.height == 667)
#define IPHONE6P     ([[UIScreen mainScreen] bounds].size.height == 736)
#define IPHONEX     ([[UIScreen mainScreen] bounds].size.height == 812)

#define IPHONETabbarHeight (IPHONEX ? 83.0f : 49.0f)

#define TYPEIMAGE @"ZEIMAGE"
#define TYPETEXT @"ZETEXT"

#define HTTPMETHOD_GET @"GET"
#define HTTPMETHOD_POST @"POST"

#define METHOD_SEARCH @"search"
#define METHOD_UPDATE @"updateSave"
#define METHOD_INSERT @"addSave"
#define METHOD_DELETE @"delete"

#define APPID @"SX"
#define JMESSAGE_APPKEY @"c7b4b8aa2a0902bfd22b7915"
#define JMESSAGE_MasterSecret  @"0c04e7556f382bd665171b94"

#define kTiltlFontSize 14.0f
#define kSubTiltlFontSize 12.0f

//追问界面字体大小
#define kFontSize 16.0f
//追问界面行间距
#define kLabel_LineSpace 3.0f

#define NAV_HEIGHT (IPHONEX ? 88.0f : 64.0f)
#define STATUS_HEIGHT (IPHONEX ? 44.0f : 20.0f)
#define TAB_BAR_HEIGHT (IPHONEX ? 83.0f : 49.0f)
#define MAX_PAGE_COUNT 20

#define Zenith_Server [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ZenithServerAddress"]

#define ZENITH_IMAGEURL(fileURL) [NSURL URLWithString:[ZEUtil changeURLStrFormat:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,fileURL]]]
#define ZENITH_ICON_IMAGEURL(fileURL) [NSURL URLWithString:[ZEUtil changeURLStrFormat:[NSString stringWithFormat:@"%@/%@",Zenith_Server,fileURL]]]
#define ZENITH_IMAGE_FILESTR(fileStr) [NSString stringWithFormat:@"%@/file/%@",Zenith_Server,fileStr]
#define ZENITH_PLACEHODLER_IMAGE [UIImage imageNamed:@"placeholder.png"]
#define ZENITH_PLACEHODLER_USERHEAD_IMAGE [UIImage imageNamed:@"avatar_default.jpg"]
#define ZENITH_PLACEHODLER_TEAM_IMAGE [UIImage imageNamed:@"icon_team_headimage"]

#define kCellImgaeHeight (SCREEN_WIDTH - 60)/3

#define kNOTI_CHANGEPERSONALMSG_SUCCESS @"NOTI_CHANGEPERSONALMSG_SUCCESS"

#define kNOTI_SCORE_SUCCESS @"NOTI_SCORE_SUCCESS"  // 经典案例打分成功通知
#define kNOTI_ACCEPT_SUCCESS @"NOTI_ACCEPT_SUCCESS" // 采纳答案成功通知
#define kNOTI_ASK_SUCCESS @"NOTI_ASK_SUCCESS" // 提问成功通知
#define kNOTI_CHANGE_ASK_SUCCESS @"NOTI_CHANGE_ASK_SUCCESS" // 修改我的问题成功通知
#define kNOTI_ANSWER_SUCCESS @"NOTI_ANSWER_SUCCESS" // 回答成功通知
#define kNOTI_ASK_QUESTION @"NOTI_ASK_QUESTION" // 普通问题提问通知
//#define kNOTI_ASK_TEAM_QUESTION @"NOTI_ASK_TEAM_QUESTION" // 班组圈问题提问通知
#define kNOTI_FINISH_INVITE_TEAMCIRCLENUMBERS @"NOTI_FINISH_INVITE_TEAMCIRCLENUMBERS" // 班组圈添加人员
#define kNOTI_FINISH_DELETE_TEAMCIRCLENUMBERS @"NOTI_FINISH_DELETE_TEAMCIRCLENUMBERS" // 班组圈删除人员

#define kNOTI_CHANGE_TEAMCIRCLEINFO_SUCCESS @"NOTI_CHANGE_TEAMCIRCLEINFO_SUCCESS" // 班组圈删除人员

#define kNOTI_FINISH_CHOOSE_TEAMCIRCLENUMBERS @"NOTI_FINISH_CHOOSE_TEAMCIRCLENUMBERS" // 指定人员回答选定成员

#define kNOTI_BACK_QUEANSVIEW @"NOTI_BACK_QUEANSVIEW" // 追问追答页面返回界面时，发送请求OPERATETYPE为空

#define kJMESSAGE_TAP_IMAGE @"kJMESSAGE_TAP_IMAGE" // 聊天界面FrameWork发送出的固定通知 点击聊天内容图片
#define kJMESSAGE_TAP_HEADVIEW @"kJMESSAGE_TAP_HEADVIEW" // 聊天界面FrameWork发送出的固定通知 点击聊天头像

#define kNOTI_LEAVE_PRACTICE_WEBVIEW @"kNOTI_LEAVE_PRACTICE_WEBVIEW" // 聊天界面FrameWork发送出的固定通知 点击聊天头像

#define kNOTI_TEAM_SENDMESSAGE_NOTI @"kNOTI_TEAM_SENDMESSAGE_NOTI" // 团队发送通知成功
#define kNOTI_READDYNAMIC @"kNOTI_READDYNAMIC" // 已读消息
#define kNOTI_DELETE_ALL_DYNAMIC @"kNOTI_DELETE_ALL_DYNAMIC" // 删除全部已读消息
#define kNOTI_DELETE_SINGLE_DYNAMIC @"kNOTI_DELETE_SINGLE_DYNAMIC" // 删除单条已读消息

#define kNOTI_TEAM_CHANGE_QUESTION_SUCCESS @"NOTI_TEAM_CHANGE_QUESTION_SUCCESS" // 修改我的问题成功通知

#define kNOTI_PERSONAL_WITHOUTDYNAMIC @"NOTI_PERSONAL_WITHOUTDYNAMIC" // 一条个人动态都没有时 发送通知

#define kRelogin @"kRelogin"
#define kVerifyLogin @"kVerifyLogin"
#endif /* ZEMarcoConstant_h */
