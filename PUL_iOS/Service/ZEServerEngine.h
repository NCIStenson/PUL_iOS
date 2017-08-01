//
//  NCIServerEngine.h
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

/**
 *  @author Stenson, 16-08-11 14:08:34
 *
 *  封装AFNetWorking请求
 *
 */


#import "AFNetworking.h"

typedef void (^ServerResponseBlock) (NSDictionary *result);
typedef void (^ServerResponseSuccessBlock) (id data);
typedef void (^ServerResponseFailBlock) (NSError *error);
typedef void (^ServerErrorRecordBlock) (void);  // 记录服务器错误block

@interface ZEServerEngine : NSObject

+ (ZEServerEngine *)sharedInstance;

-(void)requestWithParams:(NSMutableDictionary *)params
                    path:(NSString * )path
              httpMethod:(NSString *)httpMethod
                 success:(ServerResponseSuccessBlock)successBlock
                    fail:(ServerResponseFailBlock)failBlock;


-(void)requestWithJsonDic:(NSDictionary *)jsonDic
        withServerAddress:(NSString *)serverAddress
                   success:(ServerResponseSuccessBlock)successBlock
                      fail:(ServerResponseFailBlock)failBlock;

-(void)requestWithJsonDic:(NSDictionary *)jsonDic
             withImageArr:(NSArray *)arr
        withServerAddress:(NSString *)serverAddress
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock;

-(void)downloadFiletWithJsonDic:(NSDictionary *)jsonDic
              withServerAddress:(NSString *)serverAddress
                       fileName:(NSString *)fileName
                   withProgress:(void (^)(CGFloat progress))progressBlock
                        success:(ServerResponseSuccessBlock)successBlock
                           fail:(ServerResponseFailBlock)failBlock;

-(void)cancelAllTask;

#pragma mark - 普通请求接口

-(void)sendCommonRequestWithJsonDic:(NSDictionary *)jsonDic
                  withServerAddress:(NSString *)serverAddress
                            success:(ServerResponseSuccessBlock)successBlock
                               fail:(ServerResponseFailBlock)failBlock;

@end
