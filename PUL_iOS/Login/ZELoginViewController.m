//
//  ZELoginViewController.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZELoginViewController.h"
#import <JMUICommon/MBProgressHUD.h>
#import "ZELoginView.h"

#import "ZEUserServer.h"

#import "ZEPULHomeVC.h"
#import "ZETeamVC.h"
#import "ZEHomeVC.h"
#import "ZEUserCenterVC.h"

#import "ZETeamNotiCenVC.h"

#import "LBTabBarController.h"

#import "JPUSHService.h"

@interface ZELoginViewController ()<ZELoginViewDelegate>

@end

@implementation ZELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.title  = @"用户登录";
    //    self.navBar.backgroundColor = MAIN_GREEN_COLOR;
    //    [self disableLeftBtn];
    self.navBar.hidden = YES;
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

-(void)initView
{
    ZELoginView * loginView = [[ZELoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}
-(void)dealloc
{
    
}
#pragma mark - ZELoginViewDelegate

-(void)goLogin:(NSString *)username password:(NSString *)pwd
{
    [self progressBegin:nil];
    [ZEUserServer loginWithNum:username
                  withPassword:pwd
                       success:^(id data) {
                           [self progressEnd:nil];
                           if ([[data objectForKey:@"RETMSG"] isEqualToString:@"null"]) {
                               NSLog(@"登陆成功  %@",[data objectForKey:@"RETMSG"]);
                               [ZESettingLocalData setUSERNAME:username];
                               [ZESettingLocalData setUSERPASSWORD:pwd];
                               [self commonRequest:username];
                           }else{
                               [ZESettingLocalData deleteCookie];
                               [ZESettingLocalData deleteUSERNAME];
                               [ZESettingLocalData deleteUSERPASSWORD];
                               NSLog(@"登陆失败   %@",[data objectForKey:@"RETMSG"]);
                               [ZEUtil showAlertView:[data objectForKey:@"RETMSG"] viewController:self];
                           }
                           
                       } fail:^(NSError *errorCode) {
                           [self progressEnd:nil];
                       }];
    
}

#pragma mark - 获取个人信息

-(void)commonRequest:(NSString *)username
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":V_KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":@"",
                                @"USERNAME":@"",
                                @"NICKNAME":@"",
                                @"SEQKEY":@"",
                                @"EXPERTDATE":@"",
                                @"EXPERTTYPE":@"",
                                @"STATUS":@"",
                                @"EXPERTFRADE":@"",
                                @"ISEXPERT":@"",
                                @"USERACCOUNT":username,
                                @"FILEURL":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_USER_BASE_INFO];
                                 if ([arr count] > 0) {
                                     NSMutableDictionary * userinfoDic = [NSMutableDictionary dictionaryWithDictionary:arr[0]];
                                     [userinfoDic setObject:[userinfoDic objectForKey:@"USERNAME"] forKey:@"NAME"];
                                     [ZESettingLocalData setUSERINFODic:userinfoDic];
                                     
                                     [self loginJPushServer:username];
                                     
                                     //  重新注册通知
                                     if ([ZESettingLocalData getUSERCODE] > 0) {
                                         [JPUSHService setAlias:[ZESettingLocalData getUSERCODE] callbackSelector:nil object:nil];
                                     }
                                     
                                     if([ZEUtil isStrNotEmpty:[userinfoDic objectForKey:@"FILEURL"]]){
                                         NSArray * headUrlArr = [[userinfoDic objectForKey:@"FILEURL"] componentsSeparatedByString:@","];
                                         [ZESettingLocalData changeUSERHHEADURL:headUrlArr[1]];
                                     }
                                 }
                                 [self goHome];
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>  %@",errorCode);
                             }];
    
}

#pragma mark - 登陆极光用户
-(void)loginJPushServer:(NSString *)username
{
    [JMSGUser loginWithUsername:username
                       password:@"1234"
              completionHandler:^(id resultObject, NSError *error) {
                  if (error == nil) {
                      NSLog(@">>>>>>  登陆成功  ！！！ %@ ",resultObject);
                  } else {
                      NSLog(@">>>>>>  登陆失败  ！！！ %@ ",error);
                  }
              }];
    
    //  重新注册通知
    if ([ZESettingLocalData getUSERCODE] > 0) {
        [JPUSHService setAlias:[ZESettingLocalData getUSERCODE] callbackSelector:nil object:nil];
    }
    
}


#pragma mark - 查询该用户是否为专家

//-(void)isExpert
//{
//    NSDictionary * parametersDic = @{@"limit":@"20",
//                                     @"MASTERTABLE":KLB_EXPERT_INFO,
//                                     @"MENUAPP":@"EMARK_APP",
//                                     @"ORDERSQL":@"",
//                                     @"WHERESQL":@"",
//                                     @"start":@"0",
//                                     @"METHOD":@"search",
//                                     @"MASTERFIELD":@"SEQKEY",
//                                     @"DETAILFIELD":@"",
//                                     @"CLASSNAME":BASIC_CLASS_NAME,
//                                     @"DETAILTABLE":@"",};
//
//    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERNAME],
//                                @"USERNAME":@"",
//                                @"EXPERTDATE":@"",
//                                @"EXPERTTYPE":@"",
//                                @"STATUS":@"",
//                                @"EXPERTFRADE":@"",
//                                @"SEQKEY":@""};
//
//    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_EXPERT_INFO]
//                                                                           withFields:@[fieldsDic]
//                                                                       withPARAMETERS:parametersDic
//                                                                       withActionFlag:nil];
//
//    [ZEUserServer getDataWithJsonDic:packageDic
//                       showAlertView:NO
//                             success:^(id data) {
//                                 NSDictionary * dataDic = [ZEUtil getServerDic:data withTabelName:KLB_EXPERT_INFO];
//                                 if ([[dataDic objectForKey:@"totalCount"] integerValue] == 0) {
//                                     [ZESettingLocalData setISEXPERT:NO];
//                                 }else{
//                                     [ZESettingLocalData setISEXPERT:YES];
//                                 }
//
//                             } fail:^(NSError *errorCode) {
//                                 NSLog(@">>  %@",errorCode);
//                             }];
//}


-(void)showAlertView:(NSString *)alertMes
{
    
    if (IS_IOS8) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:alertMes message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                           style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:alertMes
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)goHome
{
    
    UITabBarController *tab = [[UITabBarController alloc]init];
    
    //2.创建相应的子控制器（viewcontroller）
    ZEPULHomeVC *homeVC = [ZEPULHomeVC new];
    homeVC.navigationItem.title = @"拾学";
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"icon_home"];
    UINavigationController *firstNC = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    ZETeamVC *secondVC = [ZETeamVC new];
    secondVC.navigationItem.title = @"团队";
    //设置标签名称
    secondVC.tabBarItem.title = @"团队";
    //可以根据需求设置标签的的图标
    secondVC.tabBarItem.image = [UIImage imageNamed:@"icon_team"];
    UINavigationController *secondNC = [[UINavigationController alloc]initWithRootViewController:secondVC];
    
    //        ZEPULWebVC *thirdVC = [ZEPULWebVC new];
    //        thirdVC.enterPULWebVCType = PULHOME_WEB_SCHOOL;
    //        thirdVC.navigationItem.title = @"学堂";
    //        //设置标签名称
    //        thirdVC.tabBarItem.title = @"学堂";
    //        //可以根据需求设置标签的的图标
    //        thirdVC.tabBarItem.image = [UIImage imageNamed:@"icon_school"];
    //        UINavigationController *thidrNC = [[UINavigationController alloc]initWithRootViewController:thirdVC];
    
    
    ZEHomeVC *fourthVC = [ZEHomeVC new];
    fourthVC.navigationItem.title = @"知道";
    //设置标签名称
    fourthVC.tabBarItem.title = @"知道";
    //可以根据需求设置标签的的图标
    fourthVC.tabBarItem.image = [UIImage imageNamed:@"icon_circle"];
    UINavigationController *fourthNC = [[UINavigationController alloc]initWithRootViewController:fourthVC];
    
    
    ZEUserCenterVC * fifthVC = [ZEUserCenterVC new];
    fifthVC.navigationItem.title = @"我的";
    //设置标签名称
    fifthVC.tabBarItem.title = @"我的";
    //可以根据需求设置标签的的图标
    fifthVC.tabBarItem.image = [UIImage imageNamed:@"icon_user"];
    UINavigationController *fifthNC = [[UINavigationController alloc]initWithRootViewController:fifthVC];
    
    
    //3.添加到控制器
    //特别注意：管理一组的控制器(最多显示五个,多余五个的话,包括第五个全部在更多模块里面,并且可以通过拖拽方式进行顺序编辑);
    NSArray *array = @[firstNC,secondNC,fourthNC,fifthNC];
    tab.viewControllers = array;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    window.rootViewController = tab;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
