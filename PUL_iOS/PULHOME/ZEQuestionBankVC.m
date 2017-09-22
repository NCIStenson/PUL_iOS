//
//  ZEQuestionBankVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionBankVC.h"
#import "ZEQuestionBankView.h"
#import "ZEQuestionBankWebVC.h"

@interface ZEQuestionBankVC ()<ZEQuestionBankViewDelegate>
{
    ZEQuestionBankView * bankView;
}
@end

@implementation ZEQuestionBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"能力题库";
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden =YES;
    [self getMyReflectionAndBankList];
}
-(void)initView{
    bankView = [[ZEQuestionBankView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bankView.delegate = self;
    [self.view addSubview:bankView];
    [self.view sendSubviewToBack:bankView];
}

#pragma mark - Request

-(void)getMyReflectionAndBankList{
    [self progressBegin:@""];
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
    
    NSDictionary * dic = @{};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:@[dic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"questionBank"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:@""];
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];
                                 
                                 NSString * targetStr = [dic objectForKey:@"target"];
                                 NSDictionary * resultDic =  [self dictionaryWithJsonString:targetStr];
                                 
                                 bankView.bankModel = [ZEPULHomeQuestionBankModel getDetailWithDic:resultDic];
                                 
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:@"加载失败，请重新进入页面"];
                             }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

#pragma mark - 跳转网页

-(void)goQuestionBankWebView:(ENTER_QUESTIONBANK_TYPE)type
{
    ZEQuestionBankWebVC * webVC = [[ZEQuestionBankWebVC alloc]init];
    webVC.enterType = type;
    webVC.bankID = bankView.bankID;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)goSearchBankList{
    [self getMyReflectionAndBankList];
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
