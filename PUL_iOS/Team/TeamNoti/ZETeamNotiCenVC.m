//
//  ZETeamNotiCenVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamNotiCenVC.h"
#import "ZETeamNotiCenView.h"

#import "ZESendNotiVC.h"
#import "ZENotiDetailVC.h"
@interface ZETeamNotiCenVC ()<ZETeamNotiCenViewDelegate>
{
    ZETeamNotiCenView * teamNotiView;
    NSInteger _currentPageCount;
}
@end

@implementation ZETeamNotiCenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"团队通知";
    [self initView];
    self.navigationController.navigationBarHidden = YES;
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_team_sendNoti" color:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self getNotiList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:kNOTI_TEAM_SENDMESSAGE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceUnreadCount) name:kNOTI_READDYNAMIC object:nil];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_TEAM_SENDMESSAGE_NOTI object:nil];;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_READDYNAMIC object:nil];;
}

-(void)reduceUnreadCount
{
    
}

-(void)getNotiList
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":KLB_MESSAGE_SEND,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":[NSString stringWithFormat:@"TEAMID = '%@'",_teamID],
                                     @"start":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT * _currentPageCount],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.TeamMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_MESSAGE_SEND]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_MESSAGE_SEND] ;
                                if (dataArr.count > 0) {
                                     if (_currentPageCount == 0) {
                                         [teamNotiView reloadFirstView:dataArr];
                                     }else{
                                         [teamNotiView reloadContentViewWithArr:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPageCount += 1;
                                     }
                                 }else{
                                     if (_currentPageCount > 0) {
                                         [teamNotiView loadNoMoreData];
                                         return ;
                                     }
                                     [teamNotiView reloadFirstView:dataArr];
                                     [teamNotiView headerEndRefreshing];
                                     [teamNotiView loadNoMoreData];
                                 }

                             } fail:^(NSError *errorCode) {
                                 [teamNotiView headerEndRefreshing];
                             }];
}

-(void)initView{
    teamNotiView = [[ZETeamNotiCenView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    teamNotiView.delegate = self;
    [self.view addSubview:teamNotiView];
}

-(void)rightBtnClick
{
    ZESendNotiVC * sendNoti =  [[ZESendNotiVC alloc]init];
    sendNoti.teamID = _teamID;
    [self.navigationController pushViewController:sendNoti animated:YES];
}

#pragma mark - ZETeamNotiCenViewDelegate

-(void)didSelectNoti:(ZETeamNotiCenModel *)notiModel
{
    ZENotiDetailVC * notiDetailVC = [[ZENotiDetailVC alloc]init];
    notiDetailVC.notiCenModel = notiModel;
    notiDetailVC.teamID = _teamID;
    [self.navigationController pushViewController:notiDetailVC animated:YES];
}

-(void)loadNewData
{
    _currentPageCount = 0;
    [self getNotiList];
}

-(void)loadMoreData
{
    [self getNotiList];
}

-(void)didSelectDeleteBtn:(ZETeamNotiCenModel *)notiModel
{
    [self deletePersonalDataWithSeqkey:notiModel.SEQKEY];
}

-(void)deletePersonalDataWithSeqkey:(NSString *)seqkey
{
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":KLB_MESSAGE_SEND,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_DELETE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.TeamMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":seqkey};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_MESSAGE_SEND]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"messageDelete"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:KLB_MESSAGE_SEND] ;
                                 if (dataArr.count > 0) {
                                     [self showTips:@"删除成功"];
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
