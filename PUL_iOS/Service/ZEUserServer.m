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

#import "JPUSHService.h"

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
                                                       if (![ZEUtil isNotNull:data]) {
                                                           [self reLogin];
                                                       }
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

+(void)reLogin{
    if([ZESettingLocalData getUSERNAME].length > 0 && [[ZESettingLocalData getUSERPASSWORD] length] > 0){
        [self goLogin:[ZESettingLocalData getUSERNAME] password:[ZESettingLocalData getUSERPASSWORD]];
    }
}
+(void)goLogin:(NSString *)username password:(NSString *)pwd
{
    [ZEUserServer loginWithNum:username
                  withPassword:pwd
                       success:^(id data) {
                           if ([[data objectForKey:@"RETMSG"] isEqualToString:@"null"]) {
                               [ZESettingLocalData setUSERNAME:username];
                               [ZESettingLocalData setUSERPASSWORD:pwd];
                               [[NSNotificationCenter defaultCenter]postNotificationName:kVerifyLogin object:nil];
                           }else{
                               [ZESettingLocalData deleteCookie];
                               [ZESettingLocalData deleteUSERNAME];
                               [ZESettingLocalData deleteUSERPASSWORD];
                               [self goLoginVC:[data objectForKey:@"RETMSG"]];
                           }
                       } fail:^(NSError *errorCode) {
                       }];
}
+(void)goLoginVC:(NSString *)str
{
    //  退出成功注销JPush别名
    if ([ZESettingLocalData getUSERCODE] > 0) {
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            if (iResCode == 0) {//对应的状态码返回为0，代表成功
                [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
            }
        }];
    }
    [ZESettingLocalData clearLocalData];
    [JMSGUser logout:^(id resultObject, NSError *error) {
        
    }];
    
    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    UIWindow * window = [UIApplication sharedApplication].keyWindow ;
     window.rootViewController = loginVC;
    if (str.length > 0) {
        [ZEUtil showAlertView:str viewController:loginVC];
    }
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
