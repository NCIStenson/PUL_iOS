//
//  ZEQZHomeVC.m
//  PUL_iOS
//
//  Created by Stenson on 2018/5/24.
//  Copyright © 2018年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQZHomeVC.h"
#import "ZEQZHomeView.h"
#import "ZEQZDetailVC.h"
@interface ZEQZHomeVC ()<ZEQZHomeViewDelegate>
{
    ZEQZHomeView * QZHomeView;
}
@end

@implementation ZEQZHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"技能学习模块";
    [self initView];
    
    [self getPULHomeIconRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initView{
    QZHomeView = [[ZEQZHomeView alloc] init];
    QZHomeView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    QZHomeView.delegate = self;
    [self.view addSubview:QZHomeView];
}

-(void)getPULHomeIconRequest
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":@"KLB_FUNCTION_LIST",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"20",
                                     @"METHOD":@"search",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.exam.SkillStudyMode",
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[@"KLB_FUNCTION_LIST"]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"SkillStudyList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];
                                 NSDictionary * resultDic = [ZEUtil dictionaryWithJsonString:[dic objectForKey:@"target"]];
                                 NSArray * arr=  [resultDic objectForKey:@"data"];
                                 NSMutableArray * shicaoArr = [NSMutableArray array];
                                 NSMutableArray * lilunArr = [NSMutableArray array];
                                 
                                 if ([ZEUtil isNotNull:arr]) {
                                     for (int i = 0; i < arr.count ; i ++) {
                                         NSDictionary * detailDic = arr[i];
                                         NSString * MODTYPE = [detailDic objectForKey:@"MODTYPE"];
                                         if ([MODTYPE  integerValue] == 1) {
                                             [shicaoArr addObject:detailDic];
                                         }else{
                                             [lilunArr addObject:detailDic];
                                         }
                                     }

                                 }
                                 
                                 NSMutableDictionary * formatDic = [NSMutableDictionary dictionary];
                                 if (shicaoArr.count > 0) {
                                     [formatDic setObject:shicaoArr forKey:@"实操学习"];
                                 }
                                 if (lilunArr.count > 0) {
                                     [formatDic setObject:lilunArr forKey:@"理论学习"];
                                 }

                                 QZHomeView.dataDic = formatDic;
                                 
                             } fail:^(NSError *errorCode) {
                                 NSLog(@" ==== %@",errorCode);
                             }];
    
}

#pragma mark - ZEQZHomeViewDelegate

-(void)goDetail:(NSDictionary *)dic{
    ZEQZDetailVC * detailVC = [ZEQZDetailVC new];
    detailVC.mainDic = dic;
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
