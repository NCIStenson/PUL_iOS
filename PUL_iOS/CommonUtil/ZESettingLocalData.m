//
//  ZESetLocalData.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZESettingLocalData.h"

static NSString * kUserInformation  = @"keyUserInformation";
static NSString * kSignCookie       = @"keySIGNCOOKIE";
static NSString * kUSERNAME         = @"kUSERNAME";
static NSString * kUSERPASSWORD     = @"kUSERPASSWORD";
static NSString * kUSERCODE         = @"kUSERCODE";
static NSString * kISEXPERT         = @"kISEXPERT";
static NSString * kUSERINFODic      = @"kUSERINFODic";

@implementation ZESettingLocalData

+(id)Get:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(NSString *)GetStringWithKey:(NSString *)key
{
    id value = [self Get:key];
    
    if (value == [NSNull null] || value == nil) {
        return @"";
    }
    
    return value;
}

+(int)GetIntWithKey:(NSString *)key
{
    id value = [self Get:key];
    
    if (value == [NSNull null] || value == nil) {
        return -1;
    }
    
    return [value intValue];
}

+(void)Set:(NSString*)key value:(id)value
{
    if (value == [NSNull null] || value == nil) {
        value = @"";
    }
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - COOKIE

+(void)setCookie:(NSData *)str
{
    [self Set:kSignCookie value:str];
}

+(NSData *)getCookie
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSignCookie];
}

+(void)deleteCookie
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSignCookie];
}

#pragma mark - USERNAME

+(void)setUSERNAME:(NSString *)username
{
    [self Set:kUSERNAME value:username];
}
+(NSString *)getUSERNAME
{
    return [self Get:kUSERNAME];
}
+(void)deleteUSERNAME
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERNAME];
}

#pragma mark - setUSERPASSWORD

/**
 *  @author Stenson, 16-08-12 15:08:26
 *
 *  用户密码
 *
 */
+(void)setUSERPASSWORD:(NSString *)str
{
    [self Set:kUSERPASSWORD value:str];
}
+(NSString *)getUSERPASSWORD
{
    return [self Get:kUSERPASSWORD];
}
+(void)deleteUSERPASSWORD
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERPASSWORD];
}

#pragma mark - getUSERHHEADURL
+(void)changeUSERHHEADURL:(NSString *)headUrl
{
    NSMutableDictionary * userinfoDic = [NSMutableDictionary dictionaryWithDictionary: [self getUSERINFO]];
    [userinfoDic setValue:headUrl forKey:@"FILEURL"];
    [self Set:kUSERINFODic value:userinfoDic];
}
+(NSString *)getUSERHHEADURL
{
    if (![ZEUtil isStrNotEmpty:[[self Get:kUSERINFODic] objectForKey:@"FILEURL"]]) {
        return @"";
    }
    return [[[self Get:kUSERINFODic] objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

+(NSString *)getNAME
{
    if([ZEUtil isNotNull:[[self Get:kUSERINFODic] objectForKey:@"NAME"]]){
        return [[self Get:kUSERINFODic] objectForKey:@"NAME"];
    }
    return @"";
}

#pragma mark - USERCODE

+(void)setUSERCODE:(NSString *)str
{
    [self Set:kUSERCODE value:str];
}
+(NSString *)getUSERCODE
{
    if (![ZEUtil isStrNotEmpty:[[self getUSERINFO] objectForKey:@"USERCODE"]]) {
        return @"";
    }
     return [[self getUSERINFO] objectForKey:@"USERCODE"];
}
+(void)deleteUSERCODE
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERCODE];
}

#pragma mark - USERTYPE

+(NSString *)getUSERTYPE
{
    if (![ZEUtil isStrNotEmpty:[[self getUSERINFO] objectForKey:@"EXPERTTYPE"]]) {
        return @"";
    }
    return [[self getUSERINFO] objectForKey:@"EXPERTTYPE"];
}

#pragma mark - ISEXPERT
+(BOOL)getISEXPERT
{
    return [[[self getUSERINFO] objectForKey:@"ISEXPERT"] boolValue];
}
#pragma mark - USERINFODic
+(void)setUSERINFODic:(NSDictionary *)userinfo
{
    [self Set:kUSERINFODic value:userinfo];
    
}
+(NSDictionary *)getUSERINFO
{
    return [self Get:kUSERINFODic];
}
+(void)deleteUSERINFODic
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERINFODic];
}

+(NSString *)getCurrentUsername
{
    if([ZEUtil isNotNull:[[self Get:kUSERINFODic] objectForKey:@"USERNAME"]]){
        return [[self Get:kUSERINFODic] objectForKey:@"USERNAME"];
    }
    return @"";
}

/******** 修改昵称 *******/
+(void)changeNICKNAME:(NSString *)nickname
{
    NSMutableDictionary * userinfoDic = [NSMutableDictionary dictionaryWithDictionary: [self getUSERINFO]];
    [userinfoDic setValue:nickname forKey:@"NICKNAME"];
    [self Set:kUSERINFODic value:userinfoDic];
}

+(NSString *)getNICKNAME
{
    if (![ZEUtil isStrNotEmpty:[[self getUSERINFO] objectForKey:@"USERNAME"]]) {
        return @"";
    }
    return  [[self getUSERINFO] objectForKey:@"NICKNAME"];
}

/********  用户主键 **********/
+(NSString *)getUSERSEQKEY
{
    return [[self getUSERINFO] objectForKey:@"SEQKEY"];
}

#pragma mark - CLEAR
+(void)clearLocalData
{
    [ZESettingLocalData deleteCookie];
    [ZESettingLocalData deleteUSERPASSWORD];
    [ZESettingLocalData deleteUSERCODE];
    [ZESettingLocalData deleteUSERINFODic];
}


@end

