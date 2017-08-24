//
//  ZEPULMenuVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/3.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPULMenuVC.h"
#import "ZEPULMenuView.h"

#import "SDMajletView.h"

@interface ZEPULMenuVC ()
{
    SDMajletView * menuView;
}
@end

@implementation ZEPULMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"应用编辑";
    [self.rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(finishSelectFunction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden =YES;
    
    [self getFunctionListRequest];
}

-(void)getFunctionListRequest
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":KLB_FUNCTION_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"-1",
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":HOME_CLASS_METHOD,
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"funselect"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr =[ZEUtil getServerData:data withTabelName:KLB_FUNCTION_LIST];
                                 [menuView reloadUnuseArr:arr];
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
//    _menuView = [[ZEPULMenuView alloc]initWithFrame:CGRectZero withInUseArr:self.inuseIconArr];
//    _menuView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
//    [self.view addSubview:_menuView];
    
    menuView = [[SDMajletView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    menuView.inUseTitles = [NSMutableArray array];
    menuView.unUseTitles = [NSMutableArray array];
    for (int i = 0 ; i < self.inuseIconArr.count; i ++) {
        NSDictionary * dic =  self.inuseIconArr [i];
        
        NSDictionary * arrDic = @{@"iconName":[[dic objectForKey:@"FUNCTIONURL"] stringByReplacingOccurrencesOfString:@"," withString:@""],
                                  @"title":[dic objectForKey:@"FUNCTIONNAME"],
                                  @"seqkey":[dic objectForKey:@"SEQKEY"],
                                  @"FUNCTIONCODE":[dic objectForKey:@"FUNCTIONCODE"]};
        
        [menuView.inUseTitles addObject:arrDic];
    }
    
    [self.view addSubview:menuView];

}

#pragma mark - 完成选择图标
-(void)finishSelectFunction
{
    if (!menuView.viewEditing) {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        menuView.viewEditing = YES;
        return;
    }else{
        [self.rightBtn setTitle:@"管理" forState:UIControlStateNormal];
        menuView.viewEditing = NO;
    }
    
    [menuView callBacktitlesBlock:^(NSMutableArray *inusesTitles, NSMutableArray *unusesTitles) {
        NSLog(@"inusesTitles ==  %@",inusesTitles);
        NSLog(@"unusesTitles == %@",unusesTitles);
        NSMutableArray * arr = [NSMutableArray arrayWithArray:inusesTitles];
        for (int i = 0; i < arr.count; i ++) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:inusesTitles[i]];
            [dic setValue:[NSString stringWithFormat:@"%d",i + 1] forKey:@"SORT"];\
            [dic removeObjectForKey:@"iconName"];
            [dic removeObjectForKey:@"title"];
            [arr replaceObjectAtIndex:i withObject:dic];
        }
        NSLog(@" ==  %@",inusesTitles);
        
        [self saveFunction:arr];
        
    }];
}

-(void)saveFunction:(NSArray *)arr
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":KLB_FUNCTION_USER_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"-1",
                                     @"METHOD":METHOD_UPDATE,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":HOME_CLASS_METHOD,
                                     };
    NSMutableArray * tableArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i ++) {
        [tableArr addObject:KLB_FUNCTION_USER_LIST];
    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:tableArr
                                                                           withFields:arr
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"functionSave"];
    NSLog(@" ==  %@",packageDic);
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"保存成功"];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
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
