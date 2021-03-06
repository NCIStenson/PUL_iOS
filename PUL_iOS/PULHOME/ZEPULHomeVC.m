    //
//  ZEPULHomeVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/7/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPULHomeVC.h"
#import "ZEHomeVC.h"
#import "ZEPULHomeView.h"
#import "ZEPULWebVC.h"
#import "ZEShowQuestionVC.h"
#import "ZEQuestionsDetailVC.h"

#import "ZEQuestionBankWebVC.h"
#import "ZEChatVC.h"
#import "ZEAnswerQuestionsVC.h"

#import "ZEPULMenuVC.h"

#import "ZEQuestionBankVC.h"
#import "ZEQuestionBankWebVC.h"

#import "ZENewQuestionListVC.h"

#import "ZEGroupVC.h"
#import "ZESinginVC.h"
#import "ZEFindTeamVC.h"
#import "SvUDIDTools.h"

#import "ZETypicalCaseHomeVC.h"
#import "ZEWorkStandardListVC.h"
#import "ZEExpertListVC.h"
#import "ZEWorkStandardListVC.h"
#import "ZETypicalCaseHomeVC.h"
#import "ZEDistrictManagerHomeVC.h"
#import "ZESkillListVC.h"
#import "ZEManagerPracticeBankVC.h"
#import "ZESkillListVC.h"
#import "ZEQZHomeVC.h"
@interface ZEPULHomeVC () <ZEPULHomeViewDelegate>
{
    ZEPULHomeView * _PULHomeView ;

    NSArray * _homeIcoArr;
    
}
@end

@implementation ZEPULHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyLogin:) name:kVerifyLogin object:nil];
    
    [self storeSystemInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.tintColor = MAIN_NAV_COLOR;
    
    [self geMyMessageList];
    [self getPULHomeIconRequest];
    [ZEUtil cacheQuestionType];
    
    [self isHaveNewMessage];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)initView
{
    _PULHomeView = [[ZEPULHomeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT)];
    _PULHomeView.delegate = self;
    [self.view addSubview:_PULHomeView];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kVerifyLogin object:nil];
}

#pragma mark - 检测更新

-(void)checkUpdate
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_APP_VERSION,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"MOBILETYPE='5'",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSDictionary * fieldsDic =@{@"MOBILETYPE":@"",
                                @"VERSIONCODE":@"",
                                @"VERSIONNAME":@"",
                                @"FILEURL":@"",
                                @"FILEURL2":@"",
                                @"TYPE":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[SNOW_APP_VERSION]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if ([[ZEUtil getServerData:data withTabelName:SNOW_APP_VERSION] count] > 0) {
                                     NSDictionary * dic = [ZEUtil getServerData:data withTabelName:SNOW_APP_VERSION][0];
                                     NSString * version = dic[@"VERSIONNAME"];
                                     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                                     // app版本
                                     NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                                     
                                     NSArray * serverVersionArr = [version componentsSeparatedByString:@"."];
                                     NSArray * appVersionArr = [app_Version componentsSeparatedByString:@"."];
                                     
                                     NSInteger bigServerVersion = 0;
                                     NSInteger smallServerVersion = 0;
                                     NSInteger bigAppVersison = 0;
                                     NSInteger smallAppVersison = 0;
                                     
                                     if (serverVersionArr.count > 0) {
                                         bigServerVersion = [serverVersionArr[0] integerValue];
                                     }
                                     
                                     if (appVersionArr.count > 0) {
                                         bigAppVersison = [appVersionArr[0] integerValue];
                                     }
                                     
                                     if(serverVersionArr.count > 1){
                                         smallServerVersion = [serverVersionArr[1] integerValue];
                                     }
                                     
                                     if (appVersionArr.count > 1) {
                                         smallAppVersison = [appVersionArr[1] integerValue];
                                     }
                                     
                                     if (bigServerVersion > bigAppVersison) {
                                         [self showUpdateAlertView:[NSURL URLWithString:[dic objectForKey:@"FILEURL"]] ];
                                     }else if (bigServerVersion == bigAppVersison){
                                         if (smallServerVersion > smallAppVersison) {
                                             [self showUpdateAlertView:[NSURL URLWithString:[dic objectForKey:@"FILEURL"]] ];
                                         }
                                     }
                                                                      }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}

-(void)showUpdateAlertView:(NSURL *)downloadUrl{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"经检测当前版本不是最新版本，点击确定跳转更新。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:downloadUrl];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)storeSystemInfo
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_MOBILE_DEVICE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"2000",
                                     @"METHOD":@"search",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSDictionary * fieldsDic =@{@"IMEI":[SvUDIDTools UDID],
                                @"SEQKEY":@"",
                                @"LOGINTIMES":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[SNOW_MOBILE_DEVICE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if([[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE] count] == 0){
                                     [self insertSystemInfo];
                                 }else{
                                     [self updateSystemInfo:[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE][0]];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}
-(void)insertSystemInfo
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_MOBILE_DEVICE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"20",
                                     @"METHOD":@"addSave",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSMutableDictionary * fieldsDic = [NSMutableDictionary dictionaryWithDictionary:[ZEUtil getSystemInfo]];
    [fieldsDic setObject:@"1" forKey:@"LOGINTIMES"];
    [fieldsDic setObject:@"true" forKey:@"ISENABLE"];
    [fieldsDic setObject:[ZEUtil getCurrentDate:@"YYYY-MM-dd"] forKey:@"FIRSTUSE"];
    [fieldsDic setObject:[ZEUtil getCurrentDate:@"YYYY-MM-dd"] forKey:@"LATESTUSE"];
    [fieldsDic setObject:[ZEUtil getCurrentDate:@"YYYY-MM-dd"] forKey:@"SYSCREATEDATE"];
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[SNOW_MOBILE_DEVICE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if([[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE] count] == 0){
                                     
                                 }else{
                                     
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)updateSystemInfo:(NSDictionary *)dic
{
    long loginTimes = [[dic objectForKey:@"LOGINTIMES"] integerValue];
    loginTimes += 1;
    
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_MOBILE_DEVICE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"20",
                                     @"METHOD":@"updateSave",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSMutableDictionary * fieldsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"IMEI":[SvUDIDTools UDID],
                                                                                      @"SEQKEY":[dic objectForKey:@"SEQKEY"],
                                                                                      @"LOGINTIMES":[NSString stringWithFormat:@"%ld",loginTimes],
                                                                                      @"LATESTUSE":[ZEUtil getCurrentDate:@"YYYY-MM-dd"],
                                                                                      @"SYSUPDATEDATE":[ZEUtil getCurrentDate:@"YYYY-MM-dd"]}];
    
    [fieldsDic setObject:[ZESettingLocalData getUSERNAME] forKey:@"USERACCOUNT"];
    [fieldsDic setObject:[ZESettingLocalData getNAME] forKey:@"PSNNAME"];
    [fieldsDic setObject:[ZESettingLocalData getUSERCODE] forKey:@"PSNNUM"];
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[SNOW_MOBILE_DEVICE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if([[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE] count] == 0){
                                     
                                 }else{
                                     
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - Request
#pragma mark - 获取首页图标请求

- (void)verifyLogin:(NSNotification *)noti
{
    [[ZEServerEngine sharedInstance] cancelAllTask];

    [self checkUpdate];
    [self storeSystemInfo];
    [self geMyMessageList];
    [self getPULHomeIconRequest];
    [ZEUtil cacheQuestionType];
}

-(void)getPULHomeIconRequest
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_FUNCTION_USER_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"20",
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":HOME_CLASS_METHOD,
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_FUNCTION_USER_LIST]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"functionList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr =[ZEUtil getServerData:data withTabelName:V_KLB_FUNCTION_USER_LIST];
                                 _homeIcoArr = arr;
                                 [_PULHomeView reloadHeaderView:arr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}
#pragma mark - 是否有新消息提醒
-(void)isHaveNewMessage
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfoManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"INFOCOUNT":@"",
                                @"QUESTIONCOUNT":@"",
                                @"ANSWERCOUNT":@"",
                                @"TEAMINFOCOUNT":@"",
                                @"PERINFOCOUNT":@"",
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"userbaseinfo"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
                                 if ([arr count] > 0) {
//                                     NSString * INFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"INFOCOUNT"]];
//                                     NSString * TEAMINFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"TEAMINFOCOUNT"]];
                                     
                                     NSInteger chatUnresadCount = [[JMSGConversation getAllUnreadCount] integerValue];
                                     NSString * PERINFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"PERINFOCOUNT"]];
                                     if ([PERINFOCOUNT integerValue]  + chatUnresadCount> 0 ) {
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
                                         item.badgeValue= [NSString stringWithFormat:@"%ld",(long)([PERINFOCOUNT integerValue] + chatUnresadCount)] ;
                                         if ([PERINFOCOUNT integerValue] + chatUnresadCount > 99) {
                                             item.badgeValue= @"99+";
                                         }
                                     }else{
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
                                         item.badgeValue= nil;
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>  %@",errorCode);
                             }];
}

/************* 查询最新问题 *************/
-(void)geMyMessageList
{
    NSDictionary * parametersDic = @{@"limit":@"10",
                                     @"MASTERTABLE":KLB_DYNAMIC_HOME_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":HOME_MY_MESSAGE,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_HOME_INFO]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageList"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_HOME_INFO];
                                [_PULHomeView reloadFirstView:dataArr];
                                [_PULHomeView headerEndRefreshing];
//                                     [_PULHomeView loadNoMoreData];
                             } fail:^(NSError *errorCode) {
                                 [_PULHomeView endRefreshing];
                             }];
    
}

/************* 查询最新问题 *************/
-(void)ignoreHomeDynamicWithSeqkey:(NSString *)seqkey
{
    NSDictionary * parametersDic = @{@"limit":@"10",
                                     @"MASTERTABLE":KLB_DYNAMIC_HOME_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":HOME_MY_MESSAGE,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * dic = @{@"SEQKEY":seqkey,
                           @"MES_STATE":@"0"};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_HOME_INFO]
                                                                           withFields:@[dic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"updateUserSave"];
    
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self geMyMessageList];
                             } fail:^(NSError *errorCode) {
                                 [_PULHomeView endRefreshing];
                             }];
}


#pragma mark - 
-(void)loadNewData
{
    [self geMyMessageList];
    [self getPULHomeIconRequest];
}

-(void)loadMoreData
{
    [self geMyMessageList];
}

-(void)serverBtnClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
            [self goQuesionBank];
            return;
            break;
            
        case 1:
            [self goAskHome];
            return;
            break;

        case 2:
            [self goSchool];
            break;

        case 3:
            [self goStaffDevelopment];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 能力题库

-(void)goQuesionBank
{
    ZEQuestionBankVC * bankVC = [[ZEQuestionBankVC alloc]init];
    [self.navigationController pushViewController:bankVC animated:YES];
}

#pragma mark - 知道问答

-(void)goAskHome
{
//    ZEHomeVC * homeVC = [[ZEHomeVC alloc]init];
    ZENewQuestionListVC * homeVC = [ZENewQuestionListVC new];
    [self.navigationController pushViewController:homeVC animated:YES];
}

-(void)goSchool
{
    ZEQuestionBankWebVC * webVC = [[ZEQuestionBankWebVC alloc]init];
    webVC.enterType = ENTER_QUESTIONBANK_TYPE_ABISCHOOL;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)goStaffDevelopment
{
    ZEQuestionBankWebVC * webVC = [[ZEQuestionBankWebVC alloc]init];
    webVC.enterType = ENTER_QUESTIONBANK_TYPE_STAFFDEV;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)didSelectWebViewWithIndex:(NSString *)urlpath
{
    ZEQuestionBankWebVC * webVC = [[ZEQuestionBankWebVC alloc]init];
    webVC.URLPATH = urlpath;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel
{
    if (_questionInfoModel.ISANSWER) {
        ZEChatVC * chatVC = [[ZEChatVC alloc]init];
        chatVC.questionInfo = _questionInfoModel;
        chatVC.enterChatVCType = 1;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else{
        ZEAnswerQuestionsVC * answerQuesVC = [[ZEAnswerQuestionsVC alloc]init];
        answerQuesVC.questionSEQKEY = _questionInfoModel.SEQKEY;
        answerQuesVC.questionInfoM = _questionInfoModel;
        [self.navigationController pushViewController:answerQuesVC animated:YES];
    }
}

#pragma mark - 自选功能区
-(void)goWebVC:(NSString *)functionCode
{
    ZEQuestionBankWebVC * bankVC = [[ZEQuestionBankWebVC alloc]init];
    bankVC.functionCode = functionCode;
    [self.navigationController pushViewController:bankVC animated:YES];
}

-(void)goGWCP
{
}

-(void)goZYQ
{
    ZEGroupVC *FishVC = [[ZEGroupVC alloc] init];
    [self.navigationController pushViewController:FishVC animated:YES];
}
-(void)goZYXGCP
{
    ZEQuestionBankWebVC * bankVC = [[ZEQuestionBankWebVC alloc]init];
    bankVC.enterType = ENTER_QUESTIONBANK_TYPE_PROEXAM;
    [self.navigationController pushViewController:bankVC animated:YES];
}

-(void)goGWTX
{
}

-(void)goXXKJ
{
    ZEDistrictManagerHomeVC* bankVC = [[ZEDistrictManagerHomeVC alloc]init];
    [self.navigationController pushViewController:bankVC animated:YES];
}

-(void)goZJZX
{
    ZEGroupVC *FishVC = [[ZEGroupVC alloc] init];
    [self.navigationController pushViewController:FishVC animated:YES];
}

-(void)goHYGF{
    ZEWorkStandardListVC * workStandardListVC = [[ZEWorkStandardListVC alloc]init];
    [self.navigationController pushViewController:workStandardListVC animated:YES];

}

-(void)goJNXX{
    ZEQZHomeVC * workStandardListVC = [[ZEQZHomeVC alloc]init];
    [self.navigationController pushViewController:workStandardListVC animated:YES];
}

-(void)goDXAL{
    ZETypicalCaseHomeVC * caseHome = [[ZETypicalCaseHomeVC alloc]init];
    [self.navigationController pushViewController:caseHome animated:YES];
}
-(void)goZJJD{
    ZEExpertListVC * expertListVC = [[ZEExpertListVC alloc]init];
    [self.navigationController pushViewController:expertListVC animated:YES];
}

-(void)goLXTK
{
    ZEManagerPracticeBankVC* bankVC = [[ZEManagerPracticeBankVC alloc]init];
    [self.navigationController pushViewController:bankVC animated:YES];
}

-(void)goJNBG
{
//    ZEDistrictManagerHomeVC* bankVC = [[ZEDistrictManagerHomeVC alloc]init];
//    [self.navigationController pushViewController:bankVC animated:YES];
    ZEQuestionBankWebVC * bankVC = [[ZEQuestionBankWebVC alloc]init];
    bankVC.enterType = ENTER_QUESTIONBANK_TYPE_ONLINEEXAM;
    [self.navigationController pushViewController:bankVC animated:YES];

}

-(void)goZXCS
{
    ZEQuestionBankWebVC * bankVC = [[ZEQuestionBankWebVC alloc]init];
    bankVC.enterType = ENTER_QUESTIONBANK_TYPE_ONLINEEXAM;
    [self.navigationController pushViewController:bankVC animated:YES];
}

-(void)goJNQD
{
    ZESkillListVC *FishVC = [[ZESkillListVC alloc] init];
    [self.navigationController pushViewController:FishVC animated:YES];
}

-(void)goMoreFunction
{
    ZEPULMenuVC * menuVC = [[ZEPULMenuVC alloc]init];
    menuVC.inuseIconArr = _homeIcoArr;
    [self.navigationController pushViewController:menuVC animated:YES];
}

-(void)goSinginView
{
    ZESinginVC * singVC = [[ZESinginVC alloc]init];
    [self.navigationController pushViewController:singVC animated:YES];
}

-(void)goFindTeamView
{
    ZEFindTeamVC * fineTeamVC = [[ZEFindTeamVC alloc]init];
    fineTeamVC.enterType = ENTER_FINDTEAM_HOMEDYNAMIC;
    [self.navigationController pushViewController:fineTeamVC animated:YES];
}

-(void)goQuestionView:(NSString *)QUESTIONID
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    detailVC.enterDetailIsFromNoti = QUESTIONDETAIL_TYPE_HOMEDYNAMIC;
    detailVC.QUESTIONID = QUESTIONID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goQuestionSearchView:(NSString *)searchStr
{
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    showQuestionsList.showQuestionListType = QUESTION_LIST_NEW;
    showQuestionsList.currentInputStr = searchStr;
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}

-(void)goDistrictManagerHome
{
    ZEDistrictManagerHomeVC* bankVC = [[ZEDistrictManagerHomeVC alloc]init];
    [self.navigationController pushViewController:bankVC animated:YES];
}

-(void)ignoreHomeDynamic:(ZEPULHomeModel *)model
{
    [self ignoreHomeDynamicWithSeqkey:model.SEQKEY];
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
