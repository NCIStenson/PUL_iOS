//
//  ZEUserServer.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

/**
 *  @author Stenson, 16-08-11 14:08:11
 *
 *  三基知道项目 与服务器交互
 *
 */

#import <Foundation/Foundation.h>
#import "ZEServerEngine.h"

@interface ZEUserServer : NSObject

/**
 *  @author Stenson, 16-08-11 14:08:58
 *
 *  登陆接口
 *
 *  @param username     用户名
 *  @param password     用户密码
 *  @param successBlock 登陆成功返回
 *  @param failBlock    请求失败返回
 */
+(void)loginWithNum:(NSString *)username
       withPassword:(NSString *)password
            success:(ServerResponseSuccessBlock)successBlock
               fail:(ServerResponseFailBlock)failBlock;
/**
 *  @author Stenson, 16-08-12 14:08:49
 *
 *  退出登录 注销接口
 *
 *  @param successBlock 退出登录成功返回
 *  @param failBlock    退出登录失败返回
 */
+(void)logoutSuccess:(ServerResponseSuccessBlock)successBlock
                fail:(ServerResponseFailBlock)failBlock;


/**
 *  @author Stenson, 16-08-11 14:08:36
 *
 *  将封装好的Json格式字符上传至服务器
 *
 *  @param dic          封装好的Json字符
 *  @param successBlock 登陆成功返回
 *  @param failBlock    请求失败返回
 */
+(void)getDataWithJsonDic:(NSDictionary *)dic
            showAlertView:(BOOL)isShow
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock;
/**
 *  @author Stenson, 16-08-17 09:08:56
 *
 *  执行网络请求前进行查询操作
 *
 *  @param tableName   查询表名
 *  @param MASTERFIELD 主键名
 *  @param fieldsDic   字段
 *  @param complete    存在 1  不存在 0
 */
+(void)searchDataISExistWithTableName:(NSString *)tableName
                      withMASTERFIELD:(NSString *)MASTERFIELD
                        withFieldsDic:(NSDictionary *)fieldsDic
                             complete:(void(^)(BOOL isExist,NSString * SEQKEY))complete;


+(void)uploadImageWithJsonDic:(NSDictionary *)dic
                 withImageArr:(NSArray *)arr
                showAlertView:(BOOL)isShow
                      success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock;

@end
