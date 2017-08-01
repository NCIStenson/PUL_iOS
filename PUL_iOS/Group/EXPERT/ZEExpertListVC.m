//
//  ZEExpertListVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/28.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEExpertListVC.h"
#import "ZEExpertListView.h"
#import "ZEExpertDetailVC.h"
@interface ZEExpertListVC ()<ZEExpertListViewDelegate>
{
    ZEExpertListView * _expertListView;
}
@end

@implementation ZEExpertListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"专家信息";
    [self initView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self sendRequestWithCurrentPage];
}

-(void)initView{
    _expertListView = [[ZEExpertListView alloc]initWithFrame:CGRectZero];
    _expertListView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _expertListView.delegate = self;
    [self.view addSubview:_expertListView];
    [self.view sendSubviewToBack:_expertListView];
}
-(void)sendRequestWithCurrentPage
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
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
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:KLB_EXPERT_DETAIL];
                                 if (dataArr.count > 0) {
                                     [_expertListView reloadExpertListViw:dataArr];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)goExpertVCDetail:(ZEExpertModel *)expertModel
{
    ZEExpertDetailVC * expertDetailVC = [[ZEExpertDetailVC alloc]init];
    expertDetailVC.expertModel = expertModel;
    [self.navigationController pushViewController:expertDetailVC animated:YES];
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
