//
//  ZEManagerPracticeBankVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEManagerPracticeBankVC.h"
#import "ZEManagerPracticeBankView.h"
#import "ZEQuestionBankWebVC.h"
#import "ZEPULHomeModel.h"
@interface ZEManagerPracticeBankVC ()<ZEManagerPracticeBankViewDelegate>
{
    ZEManagerPracticeBankView * bankView;
}
@end

@implementation ZEManagerPracticeBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"题库练习";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self getBankRequest];
}


-(void)getBankRequest
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
                                     @"CLASSNAME":QUESTION_BANK,
                                     };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"questionBankScene"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:@""];
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];

                                 NSString * targetStr = [dic objectForKey:@"target"];
                                 NSDictionary * resultDic =  [ZEUtil dictionaryWithJsonString:targetStr];
                                 NSLog(@" ====  %@",resultDic);
                                 [bankView reloadContentView:[resultDic objectForKey:@"data"]];
//nslo
//                                 bankView.bankModel = [ZEPULHomeQuestionBankModel getDetailWithDic:resultDic];
                                 
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:@"加载失败，请重新进入页面"];
                             }];

}

-(void)initView{
    bankView = [[ZEManagerPracticeBankView alloc]initWithFrame:self.view.frame];
    bankView.delegate = self;
    [self.view addSubview:bankView];
    [self.view sendSubviewToBack:bankView];
}

-(void)goManagerBank:(NSDictionary *)dic withIndex:(NSInteger)index
{
    ZEPULHomeQuestionBankModel * bankModel = [ZEPULHomeQuestionBankModel getDetailWithDic:dic];
    
    ZEQuestionBankWebVC * bankVC = [[ZEQuestionBankWebVC alloc]init];
    bankVC.bankID = bankModel.module_id;

    switch (index) {
        case 0:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_DAILY;
            break;
            
        case 1:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_EXAM;
            break;

        case 2:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_TEST;
            break;

        case 3:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_RANDOM;
            break;

        case 4:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_DIFFCULT;
            break;

        case 5:
            bankVC.bankID = bankModel.module_id;
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_STANDARD;
            break;
            
        case 105:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_MYERROR;
            break;
        case 106:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_MYCOLL;
            break;
        case 107:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_MYRECORD;
            break;
        case 108:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_NOTE;
            break;

        default:
            break;
    }
    [self.navigationController pushViewController:bankVC animated:YES];
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
