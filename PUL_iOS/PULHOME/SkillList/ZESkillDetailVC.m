//
//  ZESkillDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/18.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESkillDetailVC.h"
#import "ZEManagerDetailVC.h"
@interface ZESkillDetailVC ()
{
    ZESkillDetailView * detailView;
}
@end

@implementation ZESkillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _skillModel.ABILITYNAME;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sendRequest];
}

-(void)sendRequest
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_COURSEWARE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"5",
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_ABILITY_CLASS,
                                     @"abilitycode":_skillModel.ABILITYCODE,
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_INFO]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"courseAbility"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_COURSEWARE_INFO];
                                 NSLog(@" ====  %@",arr);
                                 [detailView reloadContentWithData:arr];
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)initView{
    detailView = [[ZESkillDetailView alloc]initWithFrame:self.view.frame withData:_skillModel];
    detailView.delegate = self;
    [self.view addSubview:detailView];
    [self.view sendSubviewToBack:detailView];
}

-(void)goCourseDetail:(NSDictionary *)dic;
{
    ZEManagerDetailVC * detailVC = [[ZEManagerDetailVC alloc]init];
    detailVC.detailManagerModel = [ZEDistrictManagerModel getDetailWithDic:dic];
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
