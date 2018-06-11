//
//  ZEQZDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 2018/5/25.
//  Copyright © 2018年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQZDetailVC.h"
#import "ZEQZDetailView.h"
#import "ZEPULHomeModel.h"
#import "ZEQZWebVC.h"
#import "ZEDistrictManagerHomeVC.h"

@interface ZEQZDetailVC ()<ZEQZDetailViewDelegate>
{
    ZEQZDetailView* detailView;
}
@end

@implementation ZEQZDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [_mainDic objectForKey:@"ABILITYTYPE"];
    
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getBankScoreRequest];
}

-(void)initView{
    detailView = [[ZEQZDetailView alloc]init];
    detailView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    detailView.delegate = self;
    [self.view addSubview:detailView];
}

-(void)getBankScoreRequest
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
                                     @"CLASSNAME":@"com.nci.klb.app.exam.QuestionBankQuery",
                                     @"ABILITYTYPECODE":[_mainDic objectForKey:@"ABILITYTYPECODE"],
                                     @"MODTYPE":[_mainDic objectForKey:@"MODTYPE"],
                                     };
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"questionList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:@""];
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];
                                 
                                 NSString * targetStr = [dic objectForKey:@"target"];
                                 NSDictionary * resultDic =  [ZEUtil dictionaryWithJsonString:targetStr];
                                 
                                 NSArray * cellDataArr;
                                 NSDictionary * scoreListDic;
                                 if([ZEUtil isNotNull:[resultDic objectForKey:@"itemsList"]]){
                                      cellDataArr = [resultDic objectForKey:@"itemsList"];
                                 }
                                 if ([ZEUtil isNotNull:[resultDic objectForKey:@"scoreList"]]) {
                                     NSString * scoreListStr = [resultDic objectForKey:@"scoreList"];
                                     scoreListDic =  [ZEUtil dictionaryWithJsonString:scoreListStr];
                                 }
                                 
                                 [detailView reloadContentView:[scoreListDic objectForKey:@"data"] withCellDataArr:cellDataArr];
                                 
                             } fail:^(NSError *errorCode) {
                                 NSLog(@" ====  %@",errorCode);
                                 [self progressEnd:@"加载失败，请重新进入页面"];
                             }];
}




#pragma mark - ZEQZDetailViewDelegate

-(void)goManagerBank:(NSDictionary *)dic withIndex:(NSInteger)index
{
    ZEPULHomeQuestionBankModel * bankModel = [ZEPULHomeQuestionBankModel getDetailWithDic:dic];

    ZEQZWebVC * bankVC = [[ZEQZWebVC alloc]init];
    bankVC.bankID = bankModel.module_id;
    bankVC.abilitytypecode =[_mainDic objectForKey:@"ABILITYTYPECODE"];

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
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_STANDARD;
            break;
            
        case 6:
            bankVC.MODTYPE =[_mainDic objectForKey:@"MODTYPE"];
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_TKLL;
            break;
            
        case 105:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_MYERROR;
            break;
        case 106:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_MYCOLL;
            break;
        case 107:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_RECORD;
            break;
        case 108:
            bankVC.enterType = ENTER_QUESTIONBANK_TYPE_NOTE;
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:bankVC animated:YES];

}


-(void)goTKLL:(NSString *)functionCode
{
    
}

-(void)goStudyCourse:(NSString *)functionCode
{
    ZEDistrictManagerHomeVC * disManager = [[ZEDistrictManagerHomeVC alloc]init];
    disManager.abilityCode =[_mainDic objectForKey:@"ABILITYTYPECODE"];
    [self.navigationController pushViewController:disManager animated:YES];
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
