//
//  ZEFindTeamVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEFindTeamVC.h"

#import "ZECreateTeamVC.h"
@interface ZEFindTeamVC ()
{
    ZEFindTeamView * findTeamView;
    NSString * searchStr;
}
@end

@implementation ZEFindTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发现团队";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.rightBtn setTitle:@"创建" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(goCreateTeamVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self initView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]){
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
-(void)goBackTeamVC{
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView{
    findTeamView = [[ZEFindTeamView alloc]initWithFrame:CGRectZero];
    findTeamView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    findTeamView.delegate = self;
    [self.view addSubview:findTeamView];
    [self.view sendSubviewToBack:findTeamView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (searchStr.length > 0) {
        [self goSerachTeamWithStr:searchStr];
    }else{
        [self findTeamRequest];
    }
    self.tabBarController.tabBar.hidden = YES;
    if (_enterType == ENTER_FINDTEAM_HOMEDYNAMIC) {
        [self.leftBtn addTarget:self action:@selector(goBackTeamVC) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)findTeamRequest
{
    NSString * whereSQL =@"TEAMMEMBERS desc ";
    if (_enterType == ENTER_FINDTEAM_HOMEDYNAMIC) {
        whereSQL =@"SYSCREATEDATE desc ";
    }
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":whereSQL,
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_INFO];
                                 if ([dataArr count] > 0) {
                                     [findTeamView reloadFindTeamView:dataArr];
                                 }else{
                                     [findTeamView reloadFindTeamView:dataArr];
                                     [self showTips:@"暂时没有发现任何团队~"];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - ZEFindTeamViewDelegate

-(void)goCreateTeamVC
{
    ZECreateTeamVC * createTeamVC = [[ZECreateTeamVC alloc]init];
    [self.navigationController pushViewController:createTeamVC animated:YES];
    createTeamVC.enterType = ENTER_TEAM_CREATE;
}

-(void)goTeamVCDetail:(ZETeamCircleModel *)teamCircleInfo;
{
    ZECreateTeamVC * createTeamVC = [[ZECreateTeamVC alloc]init];
    createTeamVC.enterType = ENTER_TEAM_DETAIL;
    createTeamVC.teamCircleInfo = teamCircleInfo;
    [self.navigationController pushViewController:createTeamVC animated:YES];
}

-(void)goApplyJoinTeam:(ZETeamCircleModel *)teamCircleInfo
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"DETAILTABLE":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"TEAMCIRCLECODE":teamCircleInfo.SEQKEY,
                                @"USERTYPE":@"2"};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

        [ZEUserServer getDataWithJsonDic:packageDic
                           showAlertView:YES
                                 success:^(id data) {
                                     [self showTips:@"申请成功"];
                                     [self findTeamRequest];
//                                     [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                                 } fail:^(NSError *error) {
                                     
                                 }];
        
    
}

-(void)goSerachTeamWithStr:(NSString *)inputStr
{
    searchStr = inputStr;
    NSString * orderSQL =@"TEAMMEMBERS desc ";
    if (_enterType == ENTER_FINDTEAM_HOMEDYNAMIC) {
        orderSQL =@"SYSCREATEDATE desc ";
    }
    
    NSString * whereSQL = [NSString stringWithFormat:@"TEAMCIRCLENAME like '%%%@%%'",inputStr];
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":orderSQL,
                                     @"WHERESQL":whereSQL,
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_INFO];
                                 if ([dataArr count] > 0) {
                                     [findTeamView reloadFindTeamView:dataArr];
                                 }else{
                                     [findTeamView reloadFindTeamView:dataArr];
                                     [self showTips:@"暂未找到包含该信息的团队"];
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
