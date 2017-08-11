//
//  ZEPULHomeVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/7/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPULHomeVC.h"
#import "ZEHomeVC.h"
#import "ZEPULHomeView.h"
#import "ZEPULWebVC.h"
#import "ZEShowQuestionVC.h"
#import "ZEQuestionsDetailVC.h"

#import "ZEChatVC.h"
#import "ZEAnswerQuestionsVC.h"

#import "ZEPULMenuVC.h"

#import "ZEQuestionBankVC.h"
@interface ZEPULHomeVC () <ZEPULHomeViewDelegate>
{
    ZEPULHomeView * _PULHomeView ;
    NSInteger _currentNewestPage;
    NSArray * _homeIcoArr;
    
}
@end

@implementation ZEPULHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.tintColor = MAIN_NAV_COLOR;
    
    [self sendNewestQuestionsRequest];
    
    [self getPULHomeIconRequest];
    if(_PULHomeView.bannerTimer){
        dispatch_resume(_PULHomeView.bannerTimer);
    }
    if(_PULHomeView.commandStudyTimer){
        dispatch_resume(_PULHomeView.commandStudyTimer);
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    dispatch_suspend(_PULHomeView.bannerTimer);
//    dispatch_suspend(_PULHomeView.commandStudyTimer);
}

-(void)initView
{
    _PULHomeView = [[ZEPULHomeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT)];
    _PULHomeView.delegate = self;
    [self.view addSubview:_PULHomeView];
}

#pragma mark - 获取首页图标请求

-(void)getPULHomeIconRequest
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_FUNCTION_USER_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"20",
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":HOME_CLASS_METHOD,
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_FUNCTION_USER_LIST]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"functionList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr =[ZEUtil getServerData:data withTabelName:V_KLB_FUNCTION_USER_LIST];
//                                 if(arr.count > 0){
                                 _homeIcoArr = arr;
                                     [_PULHomeView reloadHeaderView:arr];
//                                 }else{
//                                     
//                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
    
}


/************* 查询最新问题 *************/
-(void)sendNewestQuestionsRequest
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and ISSOLVE = 0"];
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentNewestPage * MAX_PAGE_COUNT],
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentNewestPage == 0) {
                                         [_PULHomeView reloadFirstView:dataArr];
                                     }else{
                                         [_PULHomeView reloadContentViewWithArr:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentNewestPage += 1;
                                     }else{
                                         [_PULHomeView loadNoMoreData];
                                     }
                                 }else{
                                     if (_currentNewestPage > 0) {
                                         [_PULHomeView loadNoMoreData];
                                         return ;
                                     }
                                     [_PULHomeView reloadFirstView:dataArr ];
                                     [_PULHomeView headerEndRefreshing];
                                     [_PULHomeView loadNoMoreData];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 [_PULHomeView endRefreshing];
                             }];
    
}

#pragma mark - 
-(void)loadNewData
{
    _currentNewestPage = 0;
    [self sendNewestQuestionsRequest];
}

-(void)loadMoreData
{
    [self sendNewestQuestionsRequest];
}

-(void)serverBtnClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
            [self goQuesionBank];
            return;
            break;
            
        case 1:
            [self goAskHome];
            return;
            break;

        case 2:
            [self goPULWebVC:PULHOME_WEB_Course];
            break;

        case 3:
            [self goMyQuestionVC];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 能力题库

-(void)goQuesionBank
{
    ZEQuestionBankVC * bankVC = [[ZEQuestionBankVC alloc]init];
    [self.navigationController pushViewController:bankVC animated:YES];
}

#pragma mark - 知道问答

-(void)goAskHome
{
    ZEHomeVC * homeVC = [[ZEHomeVC alloc]init];
    
    [self.navigationController pushViewController:homeVC animated:YES];
}

-(void)goPULWebVC:(PULHOME_WEB)tag
{
    ZEPULWebVC * webVC = [[ZEPULWebVC alloc]init];
    webVC.enterPULWebVCType = tag;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)goMyQuestionVC
{
    ZEShowQuestionVC * showQuesVC = [[ZEShowQuestionVC alloc]init];
    showQuesVC.showQuestionListType = QUESTION_LIST_MY_QUESTION;
    [self.navigationController pushViewController:showQuesVC animated:YES];
}

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel
{
    if (_questionInfoModel.ISANSWER) {
        ZEChatVC * chatVC = [[ZEChatVC alloc]init];
        chatVC.questionInfo = _questionInfoModel;
        chatVC.enterChatVCType = 1;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else{
        ZEAnswerQuestionsVC * answerQuesVC = [[ZEAnswerQuestionsVC alloc]init];
        answerQuesVC.questionSEQKEY = _questionInfoModel.SEQKEY;
        answerQuesVC.questionInfoM = _questionInfoModel;
        [self.navigationController pushViewController:answerQuesVC animated:YES];
    }
}

#pragma mark - 自选功能区

-(void)goGWCP
{
    NSLog(@" ===  岗位测评");
}

-(void)goZYQ
{
    NSLog(@" ===  专业圈");
}
-(void)goZYXGCP
{
    NSLog(@" ===  专职业性格测");
}

-(void)goGWTX
{
    NSLog(@" ===  岗位体系");
}
-(void)goZJZX
{
    NSLog(@" === 专家在线");
}

-(void)goXWGF{
    NSLog(@" ===  行为规范");
}

-(void)goZXCS
{
    NSLog(@" ===  在线测试");
}

-(void)goMoreFunction
{
    ZEPULMenuVC * menuVC = [[ZEPULMenuVC alloc]init];
    menuVC.inuseIconArr = _homeIcoArr;
    [self.navigationController pushViewController:menuVC animated:YES];
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
