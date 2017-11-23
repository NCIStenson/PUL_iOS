//
//  ZEWorkStandardHomeVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/17.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETypicalCaseHomeVC.h"
#import "ZETypicalCaseHomeView.h"
#import "ZETypicalCaseVC.h"
#import "ZETypicalCaseDetailVC.h"
@interface ZETypicalCaseHomeVC ()<ZETypicalCaseHomeViewDelegate>
{
    ZETypicalCaseHomeView * homeView;
}
@end

@implementation ZETypicalCaseHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"典型案例";
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self  sendBannerRequest];
    [self  sendRecommandRequest];
    [self sendHotRequest];
}

-(void)initView{
    
    homeView = [[ZETypicalCaseHomeView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    homeView.delegate = self;
    [self.view addSubview:homeView];
}

-(void)sendBannerRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
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
                                                                       withActionFlag:@"searchtop"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO];
                                 [homeView reloadBannerView:dataArr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(void)sendRecommandRequest
{
    NSDictionary * parametersDic = @{@"limit":@"3",
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
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
                                                                       withActionFlag:@"searchnew"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO];
                                 [homeView reloadRecommandView:dataArr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)sendHotRequest
{
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
                                                                       withActionFlag:@"searchhot"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO];
                                 [homeView reloadNewestView:dataArr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


#pragma mark - delegate

-(void)goMoreView:(ENTER_CASE_TYPE)enterType
{
    NSLog(@"geggegegegege more  more  more");
    ZETypicalCaseVC * caseVC = [[ZETypicalCaseVC alloc]init];
    caseVC.enterType = enterType;
    [self.navigationController pushViewController:caseVC animated:YES];

}

-(void)goTypicalCaseDetailVC:(id)obj
{
    ZETypicalCaseDetailVC * detailVC = [[ZETypicalCaseDetailVC alloc]init];
    detailVC.classicalCaseDetailDic = obj;
    [self.navigationController pushViewController:detailVC animated:YES];
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
