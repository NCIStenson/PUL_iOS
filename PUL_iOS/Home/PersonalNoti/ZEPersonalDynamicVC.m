//
//  ZEPersonalDynamicVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPersonalDynamicVC.h"
#import "ZEQuestionBankWebVC.h"
#import "ZENotiDetailVC.h"
#import "ZEQuestionsDetailVC.h"

@interface ZEPersonalDynamicVC ()<ZEPersonalNotiViewDelegate>
{
    ZEPersonalNotiView * _personalNotiView;
    long _currentPageCount;
    
    ZETeamNotiCenModel * previousSelectNotiModel;
}
@end

@implementation ZEPersonalDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyLogin:) name:kVerifyLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceUnreadCount) name:kNOTI_READDYNAMIC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:kNOTI_DELETE_ALL_DYNAMIC object:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVerifyLogin object:nil];;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_READDYNAMIC object:nil];;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_DELETE_ALL_DYNAMIC object:nil];;
}

-(void)reduceUnreadCount
{
    [self getPersonalNotiList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self loadNewData];
}

-(void)verifyLogin:(NSNotification *)noti
{
    [self getPersonalNotiList];
}

-(void)getPersonalNotiList
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":@"",
                                     @"start":[NSString stringWithFormat:@"%ld",_currentPageCount * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_DYNAMIC_INFO] ;
                                 if(dataArr.count == 0  && _currentPageCount == 0){
                                     //  没有数据时 取消表的编辑状态
                                     [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_PERSONAL_WITHOUTDYNAMIC object:nil];
                                 }
                                 if (dataArr.count > 0) {
                                     if (_currentPageCount == 0) {
                                         [_personalNotiView reloadFirstView:dataArr];
                                     }else{
                                         [_personalNotiView reloadContentViewWithArr:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPageCount += 1;
                                     }
                                 }else{
                                     if (_currentPageCount > 0) {
                                         [_personalNotiView loadNoMoreData];
                                         return ;
                                     }
                                     [_personalNotiView reloadFirstView:dataArr];
                                     [_personalNotiView headerEndRefreshing];
                                     [_personalNotiView loadNoMoreData];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_personalNotiView headerEndRefreshing];
                             }];
}

#pragma mark - 删除个人动态

-(void)didSelectDeleteNumberOfDynamic:(NSString *)deleteSeqkeys
{
    [self deletePersonalDataWithSeqkey:deleteSeqkeys];
}

-(void)deletePersonalDataWithSeqkey:(NSString *)seqkey
{
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":seqkey};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDelete"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO] ;
                                 if (dataArr.count > 0) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_READDYNAMIC object:nil];

                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                     hud3.mode = MBProgressHUDModeText;
                                     hud3.labelText = @"删除成功";
                                     [hud3 hide:YES afterDelay:1.0f];
                                 }
                                 [self isHaveNewMessage];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - 删除全部动态

-(void)didSelectDeleteAllDynamic
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"清空消息列表" message:@"当前消息记录将被清空，是否确认?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmDeleteAllDynamic];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)confirmDeleteAllDynamic
{
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDeleteAll"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO] ;
                                 if (dataArr.count > 0) {
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                     hud3.mode = MBProgressHUDModeText;
                                     hud3.labelText = @"删除成功";
                                     [hud3 hide:YES afterDelay:1.0f];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_PERSONAL_WITHOUTDYNAMIC object:nil];
                                 }
                                 [self isHaveNewMessage];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - 全部标为已读

-(void)clearUnreadDynamic
{
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"updateReadFlag"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO] ;
                                 if (dataArr.count > 0) {
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                     hud3.mode = MBProgressHUDModeText;
                                     hud3.labelText = @"全部标为已读成功";
                                     [hud3 hide:YES afterDelay:1.0f];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_DELETE_ALL_DYNAMIC object:nil];
                                 }
                                 [self isHaveNewMessage];
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

-(void)clearPersonalNotiUnreadCount:(ZETeamNotiCenModel *)notiCenModel
{
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":notiCenModel.SEQKEY,
                                @"ISREAD":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDetail"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO];
                                 if ([ZEUtil isNotNull:arr] && arr.count > 0) {
                                     BOOL isRead = [[arr[0] objectForKey:@"ISREAD"] boolValue];
                                     if (!isRead) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_READDYNAMIC object:nil];
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(void)initView{
    _personalNotiView = [[ZEPersonalNotiView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 60.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 60)];
    _personalNotiView.delegate = self;
    [self.view addSubview:_personalNotiView];
}

#pragma mark - ZEPersonalNotiViewDelegate

-(void)didSelectTeamMessage:(ZETeamNotiCenModel *)notiModel
{
    if([notiModel.MESTYPE integerValue] == 5){
        [self clearPersonalNotiUnreadCount:notiModel];
        return;
    }
    
    if([notiModel.MESTYPE integerValue] == 4){
        [self clearPersonalNotiUnreadCount:notiModel];
        return;
    }
    
    ZENotiDetailVC * notiDetailVC = [[ZENotiDetailVC alloc]init];
    notiDetailVC.notiCenModel = notiModel;
    [self.navigationController pushViewController:notiDetailVC animated:YES];
    if ([notiModel.DYNAMICTYPE integerValue] == 1) {
        notiDetailVC.enterTeamNotiType = ENTER_TEAMNOTI_TYPE_RECEIPT_Y;
    }else{
        notiDetailVC.enterTeamNotiType = ENTER_TEAMNOTI_TYPE_RECEIPT_N;
    }
}

-(void)didSelectQuestionMessage:(ZETeamNotiCenModel *)notiModel
{
    previousSelectNotiModel = notiModel;
    ZEQuestionsDetailVC * questionDetailVC = [[ZEQuestionsDetailVC alloc]init];
    questionDetailVC.enterDetailIsFromNoti = QUESTIONDETAIL_TYPE_NOTI;
    questionDetailVC.notiCenM = notiModel;
    [self.navigationController pushViewController:questionDetailVC animated:YES];
}

-(void)didSelectWebViewWithIndex:(NSString *)urlpath;
{
    if (urlpath.length == 0) {
        return;
    }
    ZEQuestionBankWebVC * webVC = [[ZEQuestionBankWebVC alloc]init];
    webVC.URLPATH = urlpath;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)didSelectDeleteBtn:(ZETeamNotiCenModel *)notiModel
{
    [self deletePersonalDataWithSeqkey:notiModel.SEQKEY];
}
-(void)loadNewData
{
    _currentPageCount = 0;
    [self getPersonalNotiList];
}

-(void)loadMoreData
{
    [self getPersonalNotiList];
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
