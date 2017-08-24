
//
//  ZEHomeVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//
#define kTipsImageTag 1234

#import "ZEHomeVC.h"
#import "ZEHomeView.h"
#import "ZESinginVC.h"
#import "ZEShowQuestionVC.h"
#import "ZEQuestionsDetailVC.h"
#import "ZETypicalCaseVC.h"
#import "ZETypicalCaseDetailVC.h"
#import "ZEPersonalNotiVC.h"
#import "ZEAskQuesViewController.h"

#import "ZEAnswerQuestionsVC.h"

#import "SvUDIDTools.h"

#import "ZEServerEngine.h"
#import "ZEChatVC.h"

@interface ZEHomeVC ()<ZEHomeViewDelegate>
{
    ZEHomeView * _homeView;
    
    NSInteger _currentNewestPage;
    NSInteger _currentRecommandPage;
    NSInteger _currentBounsPage;
    
    NSString * notiUnreadCount;
}

@end

@implementation ZEHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [self cacheQuestionType];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyLogin:) name:kVerifyLogin object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ACCEPT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_CHANGE_ASK_SUCCESS object:nil];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self sendHomeDataRequest];
    [self storeSystemInfo];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_homeView endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kVerifyLogin object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ACCEPT_SUCCESS object:nil];
}

- (void)verifyLogin:(NSNotification *)noti
{
    // Refresh...
//    [self checkUpdate];
//    [self sendIsSigninToday];
//    [self sendSigninViewMessage];
    _currentNewestPage = 0;
    _currentRecommandPage = 0;
    _currentBounsPage = 0;
    
    [[ZEServerEngine sharedInstance] cancelAllTask];
    [self isHaveNewMessage];
    [self cacheQuestionType];
    [self sendNewestQuestionsRequest:@""];
    [self sendRecommandQuestionsRequest:@""];
    [self sendBounsQuestionsRequest:@""];
}

-(void)sendHomeDataRequest
{
    _currentNewestPage = 0;
    _currentRecommandPage = 0;
    _currentBounsPage = 0;
    
    [[ZEServerEngine sharedInstance] cancelAllTask];
    
    [self cacheQuestionType];
    [self sendNewestQuestionsRequest:@""];
    [self sendRecommandQuestionsRequest:@""];
    [self sendBounsQuestionsRequest:@""];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
//    [self checkUpdate];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_QUESTION object:nil];
    [self isHaveNewMessage];
}

-(void)initView
{
    _homeView = [[ZEHomeView alloc] initWithFrame:self.view.frame];
    _homeView.delegate = self;
    [self.view addSubview:_homeView];
}
#pragma mark - 是否有新消息提醒
-(void)isHaveNewMessage
{

}

#pragma mark - 检测更新

-(void)checkUpdate
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":SNOW_APP_VERSION,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"MOBILETYPE='3'",
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
                                     NSString* localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                                     if ([localVersion floatValue] < [[dic objectForKey:@"VERSIONNAME"] floatValue]) {
                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"经检测当前版本不是最新版本，点击确定跳转更新。" preferredStyle:UIAlertControllerStyleAlert];
                                         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dic objectForKey:@"FILEURL"]]];
                                         }];
                                         [alertController addAction:okAction];
                                         [self presentViewController:alertController animated:YES completion:nil];
                                         
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
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
                                 NSLog(@">>>>>>  %@",data);
                                 if([[ZEUtil getServerData:data withTabelName:SNOW_MOBILE_DEVICE] count] == 0){
                                     
                                 }else{
                                     
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - Request

-(void)cacheQuestionType
{
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_QUESTION_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_TYPE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [[ZEQuestionTypeCache instance]setQuestionTypeCaches:[ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_TYPE]];
                                 [_homeView reloadContentViewWithArr:@[] withHomeContent:HOME_CONTENT_RECOMMAND];
                                 [_homeView reloadContentViewWithArr:@[] withHomeContent:HOME_CONTENT_NEWEST];
                                 [_homeView reloadContentViewWithArr:@[] withHomeContent:HOME_CONTENT_BOUNS];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

/************* 今日是否签到 *************/
-(void)sendIsSigninToday
{
    NSString * whereSQL = [NSString stringWithFormat:@"SIGNINDATE = to_date('%@','yyyy-mm-dd') AND USERCODE = '%@'",[ZEUtil getCurrentDate:@"yyyy-MM-dd"],[ZESettingLocalData getUSERCODE]];
    NSDictionary * parametersDic = @{@"limit":@"32",
                                     @"MASTERTABLE":KLB_SIGNIN_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":whereSQL,
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"USERCODE",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_SIGNIN_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_SIGNIN_INFO];
                                 if ([dataArr count] > 0) {
                                     [_homeView hiddenSinginView];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)sendSigninViewMessage{
    
    NSString * whereSQL = [NSString stringWithFormat:@"PERIOD='%@'",[ZEUtil getCurrentDate:@"yyyy-MM"]];
    
    NSDictionary * parametersDic = @{@"limit":@"32",
                                     @"MASTERTABLE":V_KLB_HELPPERSONS_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":whereSQL,
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"HELPPERSONS":@"",
                                @"SIGNINSUM":@""};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_HELPPERSONS_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_HELPPERSONS_INFO];
                                 if ([arr count] >0) {
                                     NSDictionary * dic = arr[0];
                                     [_homeView reloadSigninedViewDay:[NSString stringWithFormat:@"%@",[dic objectForKey:@"SIGNINSUM"]] numbers:[dic objectForKey:@"HELPPERSONS"]];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];

}
/************* 查询最新问题 *************/
-(void)sendNewestQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and ISSOLVE = 0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and ISSOLVE = 0 and QUESTIONEXPLAIN like '%%'"];
    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentNewestPage * MAX_PAGE_COUNT],
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentNewestPage == 0) {
                                         [_homeView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_NEWEST ];
                                     }else{
                                         [_homeView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_NEWEST];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentNewestPage += 1;
                                     }else{
                                         [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                     }
                                 }else{
                                     if (_currentNewestPage > 0) {
                                         [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                         return ;
                                     }
                                     [_homeView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_NEWEST];
                                     [_homeView headerEndRefreshingWithHomeContent:HOME_CONTENT_NEWEST];
                                     [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                 }

                             } fail:^(NSError *errorCode) {
                                 [_homeView endRefreshingWithHomeContent:HOME_CONTENT_NEWEST];
                             }];
    
}


/**
 推荐问题列表

 @param searchStr 推荐问题搜索
 */
-(void)sendRecommandQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and ISSOLVE = 0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and ISSOLVE = 0 and QUESTIONEXPLAIN like '%%'"];
    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@" SYSCREATEDATE,ANSWERSUM desc ",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentRecommandPage * MAX_PAGE_COUNT],
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentRecommandPage == 0) {
                                         [_homeView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_RECOMMAND ];
                                     }else{
                                         [_homeView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_RECOMMAND];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentRecommandPage += 1;
                                     }else{
                                         [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                     }
                                 }else{
                                     if (_currentRecommandPage > 0) {
                                         [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                         return ;
                                     }
                                     [_homeView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_RECOMMAND];
                                     [_homeView headerEndRefreshingWithHomeContent:HOME_CONTENT_RECOMMAND];
                                     [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_homeView endRefreshingWithHomeContent:HOME_CONTENT_RECOMMAND];
                             }];
    
}
/**
 高悬赏问题列表
 
 @param searchStr 高悬赏问题搜索
 */
-(void)sendBounsQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and BONUSPOINTS IS NOT NULL and BONUSPOINTS != 0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and BONUSPOINTS IS NOT NULL and ISSOLVE = 0 and BONUSPOINTS != 0 and QUESTIONEXPLAIN like '%%'"];
    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentBounsPage * MAX_PAGE_COUNT],
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentBounsPage == 0) {
                                         [_homeView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_BOUNS ];
                                     }else{
                                         [_homeView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_BOUNS];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentBounsPage += 1;
                                     }else{
                                         [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                     }
                                 }else{
                                     if (_currentBounsPage > 0) {
                                         [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                         return ;
                                     }
                                     [_homeView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_BOUNS];
                                     [_homeView headerEndRefreshingWithHomeContent:HOME_CONTENT_BOUNS];
                                     [_homeView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_homeView endRefreshingWithHomeContent:HOME_CONTENT_BOUNS];
                             }];
}

/************* 查询典型案例 *************/
//-(void)sendCaseQuestionsRequest
//{
//    NSDictionary * parametersDic = @{@"limit":@"3",
//                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
//                                     @"MENUAPP":@"EMARK_APP",
//                                     @"ORDERSQL":@"CLICKCOUNT desc",
//                                     @"WHERESQL":@"",
//                                     @"start":@"0",
//                                     @"METHOD":METHOD_SEARCH,
//                                     @"MASTERFIELD":@"SEQKEY",
//                                     @"DETAILFIELD":@"",
//                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
//                                     @"DETAILTABLE":@"",};
//    
//    NSDictionary * fieldsDic =@{};
//    
//    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
//                                                                           withFields:@[fieldsDic]
//                                                                       withPARAMETERS:parametersDic
//                                                                       withActionFlag:nil];
//    [ZEUserServer getDataWithJsonDic:packageDic
//                       showAlertView:NO
//                             success:^(id data) {
//                                 if ([[ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO] count] > 0) {
//                                     [_homeView reloadSectionView:[ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO]];
//                                 }
//
//                             } fail:^(NSError *errorCode) {
//                                 
//                             }];
//    
//}


#pragma mark - ZEHomeViewDelegate

-(void)goNotiVC
{
    ZEPersonalNotiVC * personalNotiVC = [[ZEPersonalNotiVC alloc]init];
    personalNotiVC.notiCount = [notiUnreadCount integerValue];
    [self.navigationController pushViewController:personalNotiVC animated:YES];
}

-(void)goTypicalDetail:(NSDictionary *)detailDic
{
    ZETypicalCaseDetailVC * caseDetailVC = [[ZETypicalCaseDetailVC alloc]init];
    caseDetailVC.classicalCaseDetailDic = detailDic;
    [self.navigationController pushViewController:caseDetailVC animated:YES];
}

-(void)goSinginView
{
    ZESinginVC * singVC = [[ZESinginVC alloc]init];
    [self.navigationController pushViewController:singVC animated:YES];
}

-(void)goMoreQuestionsView
{
    [self.tabBarController setSelectedIndex:1];
}
-(void)goMoreCaseAnswerView
{
    ZETypicalCaseVC * caseVC = [[ZETypicalCaseVC alloc]init];
    caseVC.enterType = ENTER_CASE_TYPE_DEFAULT;
    [self.navigationController pushViewController:caseVC animated:YES];
}
-(void)goMoreExpertAnswerView
{    
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    showQuestionsList.showQuestionListType = QUESTION_LIST_EXPERT;
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
//    detailVC.questionTypeModel = typeModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goSearch:(NSString *)str
{
    ZEShowQuestionVC * showQuestionsList = [[ZEShowQuestionVC alloc]init];
    showQuestionsList.showQuestionListType = QUESTION_LIST_NEW;
    showQuestionsList.currentInputStr = str;
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goTypeQuestionVC
{
    ZEShowQuestionVC * askQues = [[ZEShowQuestionVC alloc]init];
    askQues.showQuestionListType =  QUESTION_LIST_TYPE;
    [self.navigationController pushViewController:askQues animated:YES];
}

-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel
{
    
    if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        [self showTips:@"您不能对自己的提问进行回答"];
        return;
    }
    
//    for (NSDictionary * dic in _datasArr) {
//        ZEAnswerInfoModel * answerInfo = [ZEAnswerInfoModel getDetailWithDic:dic];
//        if ([answerInfo.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
//            [self acceptTheAnswerWithQuestionInfo:_questionInfoModel
//                                   withAnswerInfo:answerInfo];
//            return;
//        }
//    }
    
    if ([_questionInfoModel.ISSOLVE boolValue]) {
        [self showTips:@"该问题已有答案被采纳"];
        return;
    }

    
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

- (void)showTips:(NSString *)labelText {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud3.mode = MBProgressHUDModeText;
    hud3.labelText = labelText;
    [hud3 hide:YES afterDelay:1.0f];
}


-(void)loadNewData:(HOME_CONTENT)contentPage
{
    switch (contentPage) {
        case HOME_CONTENT_RECOMMAND:
            _currentRecommandPage = 0;
            [self sendRecommandQuestionsRequest:@""];
            break;
            
        case HOME_CONTENT_NEWEST:
            _currentNewestPage = 0;
            [self sendNewestQuestionsRequest:@""];

            break;
            
        case HOME_CONTENT_BOUNS:
            _currentBounsPage = 0;
            [self sendBounsQuestionsRequest:@""];
            break;
            
        default:
            break;
    }
}

-(void)loadMoreData:(HOME_CONTENT)contentPage
{
    switch (contentPage) {
        case HOME_CONTENT_RECOMMAND:
            [self sendRecommandQuestionsRequest:@""];
            break;
            
        case HOME_CONTENT_NEWEST:
            [self sendNewestQuestionsRequest:@""];
            
            break;
            
        case HOME_CONTENT_BOUNS:
            [self sendBounsQuestionsRequest:@""];
            break;
            
        default:
            break;
    }
}

//-(void)didSelectDifferentType:(HOME_CONTENT)contentType
//{
//    [self loadNewData:];
//}

-(void)askQuestion
{
    ZEAskQuesViewController * askQues = [[ZEAskQuesViewController alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_TABBAR;
    [self presentViewController:askQues animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    [[SDImageCache sharedImageCache] clearDisk];

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
