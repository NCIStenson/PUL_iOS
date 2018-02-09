//
//  ZEPackageServerData.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/9.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

/**
 *  @author Stenson, 16-08-11 14:08:47
 *
 *  封装上传服务器的Json格式字符
 *
 */

#import <Foundation/Foundation.h>

@interface ZEPackageServerData : NSObject

+(NSDictionary *)getLoginServerDataWithUsername:(NSString *)username
                                   withPassword:(NSString *)pwd;
/**
 *  @author Stenson, 16-08-12 14:08:44
 *
 *  获取退出登录封装的JSON格式字段
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)getLogoutServerData;

/**
 *  @author Stenson, 16-08-10 17:08:33
 *
 *  获取上传服务器封装JSON格式字段
 *
 *  @param tableNameArr 相关联表名称
 *  @param fieldsDic    对应表下需要的字段信息
 *  @param PARAMETERS 服务器端要求上传的参数列表
 *
 *  @return 上传服务器封装JSON格式字段
 *
 *
 *  egg.
 */
//  NCI =     {
//    COMMAND =         {
//        actionflag = select;
//        mobileapp = true;
//    };
//    DATAS =         (
//                     {
//                         fields =                 (
//                                                   {
//                                                       name = QSTANDARD;
//                                                       value = "";
//                                                   }
//                                                   );
//                         name = "EPM_TEAM_RATION_COMMON";
//                     }
//                     );
//    PARAMETERS =         {
//        PARA =             (
//                            {
//                                name = METHOD;
//                                value = search;
//                            },
//                            {
//                                name = WHERESQL;
//                                value = "orgcode in (#TEAMORGCODES#) and suitunit='#SUITUNIT#'";
//                            },
//                            );
//    };
//  }

+(NSDictionary *)getCommonServerDataWithTableName:(NSArray *)tableNameArr
                                       withFields:(NSArray *)fieldsArr
                                   withPARAMETERS:(NSDictionary *)PARAMETERS
                                   withActionFlag:(NSString *)actionFlag;

@end
