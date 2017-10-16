//
//  ZENotiDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/5.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENotiDetailVC.h"
#import "ZENotiDetailView.h"
@interface ZENotiDetailVC ()<ZENotiDetailViewDelegate>
{
    ZENotiDetailView * detailView;
}
@end

@implementation ZENotiDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"团队通知";
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    if(_enterTeamNotiType == ENTER_TEAMNOTI_TYPE_DEFAULT){
        if ([_notiCenModel.ISRECEIPT boolValue]) {
            [self getYesReceiptMemberList];
            [self getNoReceiptMemberList];
        }else{
            [detailView reloadPersonalNoReceiptView:_notiCenModel];
        }
    }else if(_enterTeamNotiType == ENTER_TEAMNOTI_TYPE_RECEIPT_N){
        [detailView reloadPersonalNoReceiptView:_notiCenModel];
        if ([_notiCenModel.DYNAMICTYPE integerValue] == 0 || [_notiCenModel.DYNAMICTYPE integerValue] == 1) {
            [self clearPersonalNotiUnreadCount];
        }
    }else if(_enterTeamNotiType == ENTER_TEAMNOTI_TYPE_RECEIPT_Y){
        [detailView reloadPersonalYesReceiptView:_notiCenModel isReceipt:YES];
        [self getIsReceipt];
        if ([_notiCenModel.DYNAMICTYPE integerValue] == 0 || [_notiCenModel.DYNAMICTYPE integerValue] == 1) {
            [self clearPersonalNotiUnreadCount];
        }
    }
}

-(void)initView {
    detailView = [[ZENotiDetailView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    detailView.delegate = self;
    [self.view addSubview:detailView];
}

-(void)getYesReceiptMemberList
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_MESSAGE_REC_Y,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"SENDID = '%@'",_notiCenModel.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.TeamMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_MESSAGE_REC_Y]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDetail"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_MESSAGE_REC_Y];
                                 if ([ZEUtil isNotNull:arr]) {
                                     detailView.notiYesReceiptArr = [NSMutableArray arrayWithArray:arr];
                                 }
                             } fail:^(NSError *errorCode) {

                             }];
}

-(void)getNoReceiptMemberList
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_MESSAGE_REC_N,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"SENDID = '%@'",_notiCenModel.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.TeamMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_MESSAGE_REC_N]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDetail"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_MESSAGE_REC_N];
                                 if ([ZEUtil isNotNull:arr]) {
                                     detailView.notiNoReceiptArr = [NSMutableArray arrayWithArray:arr];
                                     [detailView reloadViewWithArr:arr withNotiModel:_notiCenModel withIsReceipt:NO];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)getIsReceipt
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_MESSAGE_REC_Y,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"SENDID = '%@' and USERID = '%@'",_notiCenModel.QUESTIONID,[ZESettingLocalData getUSERCODE]],
//                                     @"WHERESQL":[NSString stringWithFormat:@"SENDID = '%@'",_notiCenModel.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.TeamMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_MESSAGE_REC_Y]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDetail"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_MESSAGE_REC_Y];
                                 if ([ZEUtil isNotNull:arr] && arr.count > 0) {
                                     [detailView reloadPersonalYesReceiptView:_notiCenModel isReceipt:YES];
                                 }else{
                                     [detailView reloadPersonalYesReceiptView:_notiCenModel isReceipt:NO];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - ZENotiDetailViewDelegate
-(void)clearPersonalNotiUnreadCount
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
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_notiCenModel.SEQKEY,};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDetail"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO];
                                 if ([ZEUtil isNotNull:arr]) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_READDYNAMIC object:nil];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(void)confirmTeamReceipt
{
    NSLog(@"确认回执111111111111111111111111 >>.  %@",_notiCenModel.ANSWERID);
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_MESSAGE_REC,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.TeamMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_notiCenModel.ANSWERID,
                                @"MESFLAG":@"3"};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_MESSAGE_REC]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageUpdateSave"];
    [self showTips:@"回执中，请稍后..."];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_MESSAGE_REC];
                                 if ([ZEUtil isNotNull:arr]) {
                                     [self showTips:@"回执成功" afterDelay:1.5];
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [detailView reloadPersonalYesReceiptView:_notiCenModel isReceipt:YES];
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
