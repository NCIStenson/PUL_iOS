//
//  ZESettingLocalData.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/9.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

/**
 *  @author Stenson, 16-08-11 14:08:39
 *
 *  本地存储类
 *
 */

#import <Foundation/Foundation.h>

@interface ZESettingLocalData : NSObject

/**
 *  @author Stenson, 16-08-11 14:08:52
 *
 *  保存Cookie到本地
 *
 */
+(void)setCookie:(NSData *)str;
+(NSData *)getCookie;
+(void)deleteCookie;
/**
 *  @author Stenson, 16-08-12 15:08:26
 *
 *  用户名
 *
 */
+(void)setUSERNAME:(NSString *)username;
+(NSString *)getUSERNAME;
+(void)deleteUSERNAME;
/**
 *  @author Stenson, 16-08-12 15:08:26
 *
 *  用户密码
 *
 */
+(void)setUSERPASSWORD:(NSString *)str;
+(NSString *)getUSERPASSWORD;
+(void)deleteUSERPASSWORD;

/**
 *  @author Stenson, 16-08-12 15:08:00
 *
 *  保存用户唯一标示
 *
 */
+(void)setUSERCODE:(NSString *)str;
+(NSString *)getUSERCODE;
+(void)deleteUSERCODE;
/**
 *  @author Stenson, 16-08-12 15:08:00
 *
 *  保存是否是专家
 *
 */
+(BOOL)getISEXPERT;

/**
 *  @author Stenson, 16-08-12 15:08:00
 *
 *  用户权限
 *
 */
+(NSString *)getUSERTYPE;

/**
 *  @author Stenson, 16-08-17 13:08:23
 *
 *  存储个人用户数据信息
 */
+(void)setUSERINFODic:(NSDictionary *)userinfo;
+(NSDictionary *)getUSERINFO;
+(void)deleteUSERINFODic;

/******** 修改昵称 *******/
+(void)changeNICKNAME:(NSString *)nickname;
/*********** 获取用户昵称 ********/
+(NSString *)getNICKNAME;

+(NSString *)getNAME;

/*********** 获取用户头像路径 ********/
+(void)changeUSERHHEADURL:(NSString *)headUrl;
+(NSString *)getUSERHHEADURL;

#pragma mark - QUESTIONBANKIndex

+(void)setQUESTIONBANKINDEX:(NSInteger)index;

+(NSInteger)getQUESTIONBANKINDEX;

+(void)deleteQUESTIONBANKINDEX;

/********  用户主键 **********/
+(NSString *)getUSERSEQKEY;

+(NSString *)getCurrentUsername;

+(void)clearLocalData;

@end
