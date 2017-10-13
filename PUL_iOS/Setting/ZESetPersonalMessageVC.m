//
//  ZESetPersonalMessageVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/11.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESetPersonalMessageVC.h"
#import "ZESetPersonalMessageView.h"
#import "ZEUserServer.h"
#import "ZELoginViewController.h"
#import "ZEChangePersonalMsgVC.h"

#import "ZEQuestionTypeCache.h"
#import "ZEChangePwdVC.h"
#import "JPUSHService.h"

@interface ZESetPersonalMessageVC ()<ZESetPersonalMessageViewDelegate>
{
    ZESetPersonalMessageView * personalMsgView;
}
@end

@implementation ZESetPersonalMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [self getCurrentUserLevel];
    [self sendMyBONUSPOINTSRequest];
}


-(void)getCurrentUserLevel
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"stary":@"0",
                                     @"MASTERTABLE":V_KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@'",[ZESettingLocalData getUSERCODE]],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_USER_BASE_INFO];
                                 if(arr.count > 0){
                                     [personalMsgView reloadDataWithDic:arr[0]];
                                 }
                             }
                                fail:^(NSError *error) {
                                   }];
}

-(void)sendMyBONUSPOINTSRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@'",[ZESettingLocalData getUSERCODE]],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * infoArr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
                                 if (infoArr.count > 0) {
                                     NSDictionary * dic = infoArr[0];
                                     [personalMsgView reloadPersonalScore:[NSString stringWithFormat:@"%@",[dic objectForKey:@"SUMPOINTS"]]];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(void)initView
{
    personalMsgView = [[ZESetPersonalMessageView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)
                                                       withEnterType:_enterType];
    personalMsgView.delegate = self;
    [self.view addSubview:personalMsgView];
}

#pragma mark - ZESetPersonalMessageViewDelegate

-(void)changePersonalMsg:(CHANGE_PERSONALMSG_TYPE)type
{
    ZEChangePersonalMsgVC * personalMsgVC = [[ZEChangePersonalMsgVC alloc]init];
    personalMsgVC.changeType = type;
    [self.navigationController pushViewController:personalMsgVC animated:YES];
}

/**
 *  @author Stenson, 16-08-12 13:08:52
 *
 *  退出登录
 */
-(void)logout
{
    [self progressBegin:@"正在退出登录"];
    [ZEUserServer logoutSuccess:^(id data) {
        [self progressEnd:nil];
        [self logoutSuccess];
    } fail:^(NSError *error) {
        [self progressEnd:nil];
        [self logoutSuccess];
    }];
}

-(void)logoutSuccess
{
    //  退出成功注销JPush别名
    if ([ZESettingLocalData getUSERCODE] > 0) {
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            if (iResCode == 0) {//对应的状态码返回为0，代表成功
                [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
            }
        }];
        [JMSGUser logout:^(id resultObject, NSError *error) {
        }];
    }
    [ZESettingLocalData clearLocalData];
    [[ZEQuestionTypeCache instance] clear];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    keyWindow.rootViewController = loginVC;
}

-(void)changePassword
{
    ZEChangePwdVC * pwdVC = [ZEChangePwdVC new];
    [self.navigationController pushViewController:pwdVC animated:YES];
    return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
                                 }else{
                                     NSArray * dataArr = [data objectForKey:@"EXCEPTIONDATA"];
                                     if ([dataArr count] > 0) {
                                         [self alertMessage:[dataArr[0] objectForKey:@"reason"]];
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                             }];
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
