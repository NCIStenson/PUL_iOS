//
//  ZESkillListVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/12.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESkillListVC.h"
#import "ZESkillDetailVC.h"

@interface ZESkillListVC ()<ZESkillListViewDelegate>
{
    NSMutableArray * _currentPageArr;
}
@end

@implementation ZESkillListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"技能清单";
    [self initView];
    [self getYESSkillListRequest];
    [self getNOSkillListRequest];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initView{
    listView = [[ZESkillListView alloc]initWithFrame:self.view.frame];
    listView.delegate = self;
    [self.view addSubview:listView];
    [self.view bringSubviewToFront:self.navBar];
}

-(void)getYESSkillListRequest
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_COURSEWARE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"-1",
                                     @"METHOD":@"abilityListy",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_ABILITY_CLASS,
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_INFO]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"abilityListy"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSString * targetURL = [[ZEUtil getCOMMANDDATA:data] objectForKey:@"target"];
                                 NSDictionary * dic = [ZEUtil dictionaryWithJsonString:targetURL];
                                 
                                 NSArray * yesArr = [dic objectForKey:@"data"];
                                 
                                 [listView reloadDataWithData:yesArr withIndex:1];


                             } fail:^(NSError *errorCode) {
                                 
                             }];

}

-(void)getNOSkillListRequest
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_COURSEWARE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"5",
                                     @"METHOD":@"abilityListn",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_ABILITY_CLASS,
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_INFO]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"abilityListn"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {

                                 NSString * targetURL = [[ZEUtil getCOMMANDDATA:data] objectForKey:@"target"];
                                 NSDictionary * dic = [ZEUtil dictionaryWithJsonString:targetURL];
                                 
                                 NSArray * noArr = [dic objectForKey:@"data"];

                                 NSLog(@" ====  %@",noArr);
                                 [listView reloadDataWithData:noArr withIndex:0];
                                 
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}

#pragma mark - ZESkillListViewDelegate

-(void)goSkillDetailWithObject:(id)obj
{
    ZESkillDetailVC * detailVC = [[ZESkillDetailVC alloc]init];
    detailVC.skillModel = [ZESkillListModel getDetailWithDic:obj];
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
