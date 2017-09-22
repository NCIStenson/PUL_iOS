//
//  ZEProCirDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEProCirDetailVC.h"
#import "ZEProCirDeatilView.h"

#import "ZEProCirDynamicVC.h"

#import "ZETypicalCaseVC.h"
#import "ZETypicalCaseDetailVC.h"

#import "ZEExpertListVC.h"
#import "ZEExpertDetailVC.h"

#import "ZEWorkStandardListVC.h"
#import "ZESchoolWebVC.h"

@interface ZEProCirDetailVC ()<ZEProCirDeatilViewDelegate>
{
    ZEProCirDeatilView * detailView;
}
@end

@implementation ZEProCirDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _PROCIRCLENAME;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_enter_group_type == ENTER_GROUP_TYPE_DEFAULT) {
        [self.rightBtn setTitle:@"加入他们" forState:UIControlStateNormal];
    }
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [self isShowJoin];
    [self sendCaseQuestionsRequest];
    [self sendExpertListRequest];
    [self proCirecleMember];
    [self sendWorkStandardRequest];
}
#pragma mark - 典型案例
/************* 查询典型案例 *************/
-(void)sendCaseQuestionsRequest
{    
    NSDictionary * parametersDic = @{@"limit":@"3",
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"CLICKCOUNT desc",
                                     @"WHERESQL":[NSString stringWithFormat:@"PROCIRCLECODE = %@",_PROCIRCLECODE],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
                                     @"DETAILTABLE":@"",};

    NSDictionary * fieldsDic =@{};

    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO] ;
                                 if ([ZEUtil isNotNull:arr] && [arr count] > 0) {
                                     [detailView reloadCaseView:arr];
                                 }else{
                                     [self sendWithoutProcircleCodeCaseQuestionsRequest];
                                 }
                             } fail:^(NSError *errorCode) {

                             }];

}
-(void)sendWithoutProcircleCodeCaseQuestionsRequest
{
    NSLog(@">>>>>>>>=======  %@ ",_PROCIRCLECODE);
    
    NSDictionary * parametersDic = @{@"limit":@"3",
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"CLICKCOUNT desc",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO] ;
                                 if ([ZEUtil isNotNull:arr] && [arr count] > 0) {
                                     [detailView reloadCaseView:arr];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}


#pragma mark - 专家列表

-(void)sendExpertListRequest
{
    NSDictionary * parametersDic = @{@"limit":@"3",
                                     @"MASTERTABLE":KLB_EXPERT_DETAIL,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"PROCIRCLECODE = '%@'",_PROCIRCLECODE],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_EXPERT_DETAIL]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_EXPERT_DETAIL] ;
                                 if ([ZEUtil isNotNull:arr] && [arr count] > 0) {
                                     [detailView reloadExpertView:arr];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}

-(void)proCirecleMember
{
    NSDictionary * parametersDic = @{@"limit":@"10",
                                     @"MASTERTABLE":KLB_PROCIRCLE_USER_POS,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SUMPOINTS DESC",
                                     @"WHERESQL":[NSString stringWithFormat:@" PROCIRCLECODE = '%@' ",_PROCIRCLECODE],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.procirclestatus.ProcircleUserPos",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"PROCIRCLECODE":_PROCIRCLECODE,
                                @"QUESTIONSUM":@"",
                                @"ANSWERSUM":@"",
                                @"ANSWERTAKESUM":@"",
                                @"SUMPOINTS":@"",
                                @"NICKNAME":@"",
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_USER_POS]
                                                                           withFields:@[fieldsDic]
                                                                        withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 NSArray * memberArr = [ZEUtil getServerData:data withTabelName:KLB_PROCIRCLE_USER_POS];
                                 if ([memberArr isKindOfClass:[NSArray class]]) {
                                     [detailView reloadSection:1 scoreDic:nil memberData:memberArr];
                                 }
                             } fail:^(NSError *errorCode) {
                             }];
}

#pragma mark - 行业规范

-(void)sendWorkStandardRequest
{
    NSDictionary * parametersDic = @{@"limit":@"5",
                                     @"MASTERTABLE":V_KLB_STANDARD_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"CLICKCOUNT desc",
                                     @"WHERESQL":[NSString stringWithFormat:@" PROCIRCLECODE like '%@' ",_PROCIRCLECODE],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.standard.StandardInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_STANDARD_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"PROCIRCLE_STANDARD_INFO"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 NSArray * memberArr = [ZEUtil getServerData:data withTabelName:V_KLB_STANDARD_INFO];
                                 if ([memberArr isKindOfClass:[NSArray class]]) {
                                     [detailView reloadWorkStandardView:memberArr];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma  mark - 是否加入当前圈子

-(void)isShowJoin
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_PROCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":[NSString stringWithFormat:@"PROCIRCLECODE='%@' and USERCODE='%@'",_PROCIRCLECODE,[ZESettingLocalData getUSERCODE]],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_PROCIRCLE_REL_USER];
                                 if(arr.count == 0){
                                     self.rightBtn.hidden = NO;
                                 }else{
                                     [self.rightBtn setTitle:@"退出圈子" forState:UIControlStateNormal];
                                     [self.rightBtn removeTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
                                     [self.rightBtn addTarget:self action:@selector(exitCircle) forControlEvents:UIControlEventTouchUpInside];
                                 }
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)rightBtnClick
{
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_PROCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"PROCIRCLECODE":_PROCIRCLECODE,
                                @"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"STATUS":@"1",
                                @"NICKNAME":[ZESettingLocalData getNICKNAME],
                                @"USERNAME":[ZESettingLocalData getNAME],
                                @"USERTYPE":[ZESettingLocalData getUSERTYPE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"加入成功"];

                                 [self.rightBtn setTitle:@"退出圈子" forState:UIControlStateNormal];
                                 [self.rightBtn removeTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
                                 [self.rightBtn addTarget:self action:@selector(exitCircle) forControlEvents:UIControlEventTouchUpInside];

                                 [self proCirecleMember];
                                 
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)exitCircle
{
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_PROCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_DELETE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"PROCIRCLECODE":_PROCIRCLECODE};

    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"退出成功"];
                                 [self.rightBtn setTitle:@"加入圈子" forState:UIControlStateNormal];
                                 [self.rightBtn removeTarget:self action:@selector(exitCircle) forControlEvents:UIControlEventTouchUpInside];
                                 [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
                                 [self proCirecleMember];
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)initView{
    detailView = [[ZEProCirDeatilView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:detailView];
    detailView.delegate =self;
    [self.view sendSubviewToBack:detailView];
    [detailView reloadSection:0 scoreDic:self.PROCIRCLEDataDic memberData:nil];
}

-(void)goDynamic
{
    ZEProCirDynamicVC * dynamicVC =[[ZEProCirDynamicVC alloc]init];
    dynamicVC.PROCIRCLECODE = self.PROCIRCLECODE;
    [self.navigationController pushViewController:dynamicVC animated:YES];
}

-(void)goMoreCaseVC
{
    ZETypicalCaseVC * caseVC = [[ZETypicalCaseVC alloc]init];
    caseVC.enterType = ENTER_CASE_TYPE_DEFAULT;
    [self.navigationController pushViewController:caseVC animated:YES];
}

-(void)goMoreExpertVC
{
    ZEExpertListVC * experListVC = [[ZEExpertListVC alloc]init];
    experListVC.PROCIRCLECODE = _PROCIRCLECODE;
    [self.navigationController pushViewController:experListVC animated:YES];
}

-(void)goTypicalDetail:(NSDictionary *)detailDic
{
    ZETypicalCaseDetailVC * caseDetailVC = [[ZETypicalCaseDetailVC alloc]init];
    caseDetailVC.classicalCaseDetailDic = detailDic;
    [self.navigationController pushViewController:caseDetailVC animated:YES];
}

-(void)goExpertDetail:(ZEExpertModel *)expertM
{
    ZEExpertDetailVC * expertDetailVC = [[ZEExpertDetailVC alloc]init];
    expertDetailVC.expertModel = expertM;
    [self.navigationController pushViewController:expertDetailVC animated:YES];
}

-(void)goMoreWorkStandard
{
    ZEWorkStandardListVC * workStandardListVC = [[ZEWorkStandardListVC alloc]init];
    
    [self.navigationController pushViewController:workStandardListVC animated:YES];
    NSLog(@"goMoreWorkStandardgoMoreWorkStandardgoMoreWorkStandard");
}

-(void)goWorkStandardDetail:(NSDictionary *)standardDic;
{
    NSString * fileURL = [ standardDic objectForKey:@"FILEURL" ];
    NSString * seqkey = [ standardDic objectForKey:@"SEQKEY" ];
    
    ZESchoolWebVC * webVC = [[ZESchoolWebVC alloc]init];
    webVC.enterType = ENTER_WEBVC_WORK_STANDARD;
    webVC.webURL = ZENITH_IMAGE_FILESTR([fileURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]);
    webVC.workStandardSeqkey = seqkey;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)moreRankingMessage
{
    [self showTips:@"功能建设中,敬请期待" afterDelay:1.5];
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
