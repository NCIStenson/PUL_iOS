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
#import "ZEChangePwdVC.h"
#import "ZEUserServer.h"

#import "ZEPULHomeVC.h"
#import "ZETeamVC.h"
#import "ZEPersonalNotiVC.h"
#import "ZEUserCenterVC.h"

#import "ZETeamNotiCenVC.h"

#import "LBTabBarController.h"

#import "JPUSHService.h"
#import "ZEChangePweAlertView.h"

@interface ZELoginViewController ()<ZELoginViewDelegate,ZEChangePweAlertViewDelegate>
{
    ZEChangePweAlertView * pwdAlertView;
}
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
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
        [pwdAlertView endEditing:YES];
    }];
    [self.view addGestureRecognizer:tap];
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
    ZELoginView * loginView = [[ZELoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}
-(void)dealloc
{
    
}
#pragma mark - ZELoginViewDelegate

-(void)goLogin:(NSString *)username password:(NSString *)pwd
{
//    [self changePassword];
//    return;
    
    [self progressBegin:nil];
    [ZEUserServer loginWithNum:username
                  withPassword:pwd
                       success:^(id data) {
                           [self progressEnd:nil];
                           
                           if ([[data objectForKey:@"RETMSG"] isEqualToString:@"null"]) {
                               NSLog(@"登陆成功  %@",[data objectForKey:@"RETMSG"]);
                               NSArray * arr = [ZEUtil getServerData:data withTabelName:@"UUM_USER"];
                               if (arr.count > 0) {
                                   NSDictionary * DIC = arr[0];
                                   
                                   NSString * ACCOUNTSTATUS = [NSString stringWithFormat:@"%@",[DIC objectForKey:@"ACCOUNTSTATUS"]];
                                   
                                   if (ACCOUNTSTATUS.length > 0 && [[DIC objectForKey:@"ACCOUNTSTATUS"] integerValue] == 1) {
                                       [self changePassword];
                                       return;
                                   }
                               }
                               
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

#pragma mark - 首次登陆
-(void)changePassword
{
    if (!pwdAlertView) {
        pwdAlertView = [[ZEChangePweAlertView alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, 255)];
        pwdAlertView.center = self.view.center;
        pwdAlertView.delegate = self;
        [self.view addSubview:pwdAlertView];
    }

    return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"首次登陆请先修改密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * field1 = alertController.textFields[0];
        UITextField * field2 = alertController.textFields[1];
        UITextField * field3 = alertController.textFields[2];
        if (field2.text.length < 6 || field3.text.length < 6){
            [self alertMessage:@"新密码不能少于6位"];
        }else if (field1.text.length > 0 && field2.text.length > 0 && field3.text.length > 0 ) {
            [self changePasswordRequestOldPassword:field1.text
                                       newPassword:field2.text
                                   confirmPassword:field3.text];
        }else{
            [self alertMessage:@"密码不能为空"];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        textField.secureTextEntry = YES;
        textField.placeholder = @"旧密码";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        textField.secureTextEntry = YES;
        textField.placeholder = @"新密码";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        textField.secureTextEntry = YES;
        textField.placeholder = @"确认新密码";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)changePwd
{
    UITextField * field1 = pwdAlertView.oldField;
    UITextField * field2 = pwdAlertView.filedNewPwd;
    UITextField * field3 = pwdAlertView.fieldNewConfirm;
    if (field2.text.length < 6 || field3.text.length < 6){
        [self alertMessage:@"新密码不能少于6位"];
    }else if (field1.text.length > 0 && field2.text.length > 0 && field3.text.length > 0 ) {
        [self changePasswordRequestOldPassword:field1.text
                                   newPassword:field2.text
                               confirmPassword:field3.text];
    }else{
        [self alertMessage:@"密码不能为空"];
    }
}

-(void)cancelChangePwd
{
    [pwdAlertView removeAllSubviews];
    [pwdAlertView removeFromSuperview];
    pwdAlertView = nil;
}


-(void)alertMessage:(NSString * )str
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)changePasswordRequestOldPassword:(NSString *)OLDPASSWORD
                            newPassword:(NSString *)NEWPASSWORD
                        confirmPassword:(NSString *)NEWPASSWORD1

{
    NSDictionary * parametersDic = @{@"limit":@"2000",
                                     @"MASTERTABLE":@"EPM_USER_PWD",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"saveSelfPwd",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.epm.biz.hr.EpmHr",
                                     };
    
    NSDictionary * fieldsDic =@{@"OLDPASSWORD":OLDPASSWORD,
                                @"NEWPASSWORD":NEWPASSWORD,
                                @"NEWPASSWORD1":NEWPASSWORD1};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[@"EPM_USER_PWD"]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 if ([[data objectForKey:@"RETMSG"] isEqualToString:@"操作成功！"]) {
                                     [self alertMessage:@"操作成功"];
                                     [self cancelChangePwd];
                                 }else{
                                     NSArray * dataArr = [data objectForKey:@"EXCEPTIONDATA"];
                                     if ([dataArr count] > 0) {
                                         [self alertMessage:[dataArr[0] objectForKey:@"reason"]];
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
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
                                @"USERID":@"",
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
                                     
                                     [self loginJPushServer:[userinfoDic objectForKey:@"USERCODE"]];
                                     
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

#pragma mark - 登陆极光聊天用户

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
    
    
    ZEPersonalNotiVC *fourthVC = [ZEPersonalNotiVC new];
    fourthVC.navigationItem.title = @"消息";
    //设置标签名称
    fourthVC.tabBarItem.title = @"消息";
    //可以根据需求设置标签的的图标
    fourthVC.tabBarItem.image = [UIImage imageNamed:@"tabbar_noti"];
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
