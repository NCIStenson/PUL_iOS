//
//  ZEUserServer.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEPackageServerData.h"
#import "ZEUserServer.h"
#import "ZELoginViewController.h"
@implementation ZEUserServer


+(void)loginWithNum:(NSString *)username
       withPassword:(NSString *)password
            success:(ServerResponseSuccessBlock)successBlock
               fail:(ServerResponseFailBlock)failBlock
{
    NSDictionary * dataDic = [ZEPackageServerData getLoginServerDataWithUsername:username
                                                                    withPassword:password];
    
    NSString * loginServer = [NSString stringWithFormat: @"%@/do/app/login",Zenith_Server];
    
    [[ZEServerEngine sharedInstance]requestWithJsonDic:dataDic
                                     withServerAddress:loginServer
                                               success:^(id data) {
                                                   successBlock(data);
                                               } fail:^(NSError *errorCode) {
                                                   NSLog(@"请求失败 >>  %@",errorCode);
                                                   failBlock(errorCode);
                                               }];
}

+(void)logoutSuccess:(ServerResponseSuccessBlock)successBlock
                fail:(ServerResponseFailBlock)failBlock
{
    NSDictionary * dataDic = [ZEPackageServerData getLogoutServerData];
    NSString * logoutServer = [NSString stringWithFormat: @"%@/do/app/logout",Zenith_Server];
    [[ZEServerEngine sharedInstance]requestWithJsonDic:dataDic
                                     withServerAddress:logoutServer
                                               success:^(id data) {
                                                   successBlock(data);
                                               } fail:^(NSError *errorCode) {
                                                   NSLog(@"请求失败 >>  %@",errorCode);
                                                   failBlock(errorCode);
                                               }];
}

+(void)getDataWithJsonDic:(NSDictionary *)dic
            showAlertView:(BOOL)isShow
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock
{
    
    NSString * commonServer = [NSString stringWithFormat: @"%@/do/app/uiaction",Zenith_Server];
    
    [[ZEServerEngine sharedInstance]requestWithJsonDic:dic
                                     withServerAddress:commonServer
                                               success:^(id data) {
                                                                                                      
                                                   if ([ZEUtil isSuccess:[data objectForKey:@"RETMSG"]]) {
                                                       successBlock(data);
                                                   }else{
                                                       NSLog(@" failBlock ==  %@ ",[data objectForKey:@"RETMSG"]);
                                                       NSLog(@" failData ==  %@ ",data);
                                                       static NSInteger i = 0;
                                                       i ++;
                                                       
                                                       if (i > 10) {
                                                           [ZEUserServer operationFailed];
                                                       }
                                                       NSError *errorCode = nil;
                                                       failBlock(errorCode);
                                                   }
                                               } fail:^(NSError *errorCode) {
                                                   failBlock(errorCode);
                                               }];
}

+(void)uploadImageWithJsonDic:(NSDictionary *)dic
                 withImageArr:(NSArray *)arr
                showAlertView:(BOOL)isShow
                      success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock
{
    NSString * commonServer = [NSString stringWithFormat: @"%@/do/app/uiaction",Zenith_Server];
    
    [[ZEServerEngine sharedInstance]requestWithJsonDic:dic
                                          withImageArr:arr
                                     withServerAddress:commonServer
                                               success:^(id data) {
                                                   if ([ZEUtil isSuccess:[data objectForKey:@"RETMSG"]]) {
                                                       successBlock(data);
                                                   }else{
                                                       [ZEUserServer operationFailed];
                                                       NSError *errorCode = nil;
                                                       failBlock(errorCode);
                                                   }
                                               } fail:^(NSError *errorCode) {
                                                   [ZEUserServer operationFailed];
                                                   failBlock(errorCode);
                                               }];
}
+(void)operationFailed
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:@"操作失败!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action];
    
    [[ZEUtil getCurrentVC] presentViewController:alertC animated:YES completion:nil];

}

#pragma mark - 进行操作前 预先进行查询操作

+(void)searchDataISExistWithTableName:(NSString *)tableName
                      withMASTERFIELD:(NSString *)MASTERFIELD
                        withFieldsDic:(NSDictionary *)fieldsDic
                             complete:(void(^)(BOOL isExist,NSString * SEQKEY))complete
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":tableName,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":MASTERFIELD,
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[tableName]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    __block BOOL isExist;
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSString * SEQKEY = nil;
                                 NSDictionary * userinfoDic = [[data objectForKey:@"DATAS"] objectForKey:tableName];
                                 if ([[userinfoDic objectForKey:@"totalCount"] integerValue] == 0) {
                                     isExist = NO;
                                 }else{
                                     isExist = YES;
                                     SEQKEY = [[ZEUtil getServerData:data withTabelName:tableName][0] objectForKey:@"SEQKEY"];
                                 }

                                 complete(isExist,SEQKEY);
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>  %@",errorCode);
                             }];
    
}


@end
