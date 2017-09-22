//
//  ZEPackageServerData.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/9.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPackageServerData.h"

@implementation ZEPackageServerData


+(NSDictionary *)getLogoutServerData
{
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionary];
    
    ZEPackageServerData * pack = [[ZEPackageServerData alloc]init];
    
    [mutableDic setObject:@[]forKey:@"DATAS"];
    [mutableDic setObject:[pack PARAMETERS] forKey:@"PARAMETERS"];
    [mutableDic setObject:[pack COMMAND] forKey:@"COMMAND"];
    
    return @{@"NCI":mutableDic};
}

+(NSDictionary *)getLoginServerDataWithUsername:(NSString *)username
                                   withPassword:(NSString *)pwd
{
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionary];
    
    ZEPackageServerData * pack = [[ZEPackageServerData alloc]init];
    
    [mutableDic setObject:[pack DATASWithUsername:username withPassword:pwd] forKey:@"DATAS"];
    [mutableDic setObject:[pack PARAMETERS] forKey:@"PARAMETERS"];
    [mutableDic setObject:[pack COMMAND] forKey:@"COMMAND"];
    
    return @{@"NCI":mutableDic};
}

-(NSArray *)DATASWithUsername:(NSString *)username
                 withPassword:(NSString *)pwd
{
    NSArray * arr = @[@{@"name":@"UUM_USER",
                        @"fields":@[@{@"name":@"LOGINPWD",
                                           @"value":pwd},
                                       @{@"name":@"USERACCOUNT",
                                         @"value":username},
                                    @{@"name":@"ACCOUNTSTATUS",
                                      @"value":@""}]}];
    return arr;
}

-(NSDictionary *)PARAMETERS
{
    NSDictionary * dic =@{@"PARA":@[@{@"name":@"NOSUITUNIT",@"value":@"true"},
                                    @{@"name":@"appId",@"value":APPID},
                                    @{@"name":@"appKey",@"value":JMESSAGE_APPKEY},
                                    @{@"name":@"masterSecret",@"value":JMESSAGE_MasterSecret}]};
    return dic;
}

-(NSDictionary *)COMMAND
{
    NSDictionary * dic =@{@"mobileapp":@"true"};
    return dic;
}

#pragma mark - COMMONSERVERDATA


+(NSDictionary *)getCommonServerDataWithTableName:(NSArray *)tableNameArr
                                       withFields:(NSArray *)fieldsArr
                                   withPARAMETERS:(NSDictionary *)PARAMETERS
                                   withActionFlag:(NSString *)actionFlag;
{
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionary];
    
    ZEPackageServerData * pack = [[ZEPackageServerData alloc]init];
    
    [mutableDic setObject:[pack addCommonDATASWithTableName:tableNameArr withFields:fieldsArr] forKey:@"DATAS"];
    [mutableDic setObject:[pack commonPARAMETERS:PARAMETERS] forKey:@"PARAMETERS"];
    [mutableDic setObject:[pack commonCOMMANDWithActionFlag:actionFlag] forKey:@"COMMAND"];
    
    return @{@"NCI":mutableDic};
}

/**
 *  @author Stenson, 16-08-10 16:08:57
 *
 *  封装上传服务器端DATAS 字符
 *
 *  @param tableNameArr 相关联表名称
 *  @param fieldsDic    对应表下需要的字段信息
 *
 *  @return 封装完成的DATAS数据
 *
 *
 *  egg.    NSArray * arr = @[@{@"name":@"EPM_TEAM_RATION_COMMON",
                                @"fields":@[@{@"name" : @"CATEGORYCODE",
                                              @"value":@""}]}];
 
 *
 *
 *
 */
-(NSArray *)addCommonDATASWithTableName:(NSArray *)tableNameArr
                             withFields:(NSArray *)fieldsArr
{
    
    ZEPackageServerData * pack = [[ZEPackageServerData alloc]init];

    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0 ; i < tableNameArr.count ; i ++) {
        NSString * tableNameStr = tableNameArr[i];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:tableNameStr forKey:@"name"];
        [dic setObject:[pack addCommonFields:fieldsArr[i]] forKey:@"fields"];
        [arr addObject:dic];
    }
    
    return arr;
}

-(NSMutableArray *)addCommonFields:(NSDictionary *)fields
{
    NSMutableArray * fieldsArr = [NSMutableArray array];
    for (NSString * keys in fields.allKeys) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:keys forKey:@"name"];
        [dic setObject:[fields objectForKey:keys] forKey:@"value"];
        [fieldsArr addObject:dic];
    }
    
    return fieldsArr;
}

/**
 *  @author Stenson, 16-08-10 17:08:18
 *
 *  上传服务器端参数格式化
 *
 *  @param parametersDic 传入普通字典类型 egg.
 *                                     @{@"key":@"value"}
 *
 *  @return 格式化后的参数         egg.
 *
 *    NSDictionary * dic = @{@"PARA":@[@{@"name":@"limit",@"value":@"20"},
 *                                     @{@"name":@"MASTERTABLE",@"value":@"EPM_TEAM_RATION_COMMON"},
 *                                     @{@"name":@"MENUAPP",@"value":@"EMARK_APP"},
 *                                     @{@"name":@"ORDERSQL",@"value":@"DISPLAYORDER"},
 *                                     @{@"name":@"WHERESQL",@"value":@"orgcode in (#TEAMORGCODES#) and suitunit='#SUITUNIT#'"}];
 */

-(NSDictionary *)commonPARAMETERS:(NSDictionary *)parametersDic
{
    NSMutableArray * parametersArr = [NSMutableArray array];
    for (NSString * keys in parametersDic.allKeys) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:keys forKey:@"name"];
        [dic setObject:[parametersDic objectForKey:keys] forKey:@"value"];
        [parametersArr addObject:dic];
    }
    NSDictionary * dic = @{@"PARA":parametersArr};

    return dic;
}

-(NSDictionary *)commonCOMMANDWithActionFlag:(NSString *)actionFlag
{
    if (![ZEUtil isStrNotEmpty:actionFlag]) {
        actionFlag = @"select";
    }
    NSDictionary * dic =@{@"mobileapp":@"true",
                          @"actionflag":actionFlag};
    return dic;
}

@end
