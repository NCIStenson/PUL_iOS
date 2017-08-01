//
//  ZEPULHomeVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/7/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPULHomeVC.h"

#import "ZEPULHomeView.h"
#import "ZEPULWebVC.h"
#import "ZEShowQuestionVC.h"
#import "ZEQuestionsDetailVC.h"

#import "ZEChatVC.h"
#import "ZEAnswerQuestionsVC.h"
@interface ZEPULHomeVC () <ZEPULHomeViewDelegate>
{
    ZEPULHomeView * _PULHomeView ;
    NSInteger _currentNewestPage;
}
@end

@implementation ZEPULHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    self.leftBtn.hidden = YES;
    self.title = @"拾学";
    
    [self initView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self sendNewestQuestionsRequest];
    [self getCommandStudy];
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
    dispatch_suspend(_PULHomeView.bannerTimer);
    dispatch_suspend(_PULHomeView.commandStudyTimer);
}

-(void)initView
{
    _PULHomeView = [[ZEPULHomeView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_BAR_HEIGHT)];
    _PULHomeView.delegate = self;
    [self.view addSubview:_PULHomeView];
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

-(void)getCommandStudy
{
    NSDictionary * dic = @{@"impClazz":@"LESSON",
                           @"actionFlag":@"SearchHotLesson"};
    [[ZEServerEngine sharedInstance] sendCommonRequestWithJsonDic:dic
                                                withServerAddress:@"http://117.149.2.229:1624/ecm/service/getDataActionx"
                                                          success:^(id data) {
                                                              [_PULHomeView reloadCommandStudy:[data objectForKey:@"DATAS"]];
                                                          }
                                                             fail:^(NSError *error) {
        
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
            [self goPULWebVC:PULHOME_WEB_MAP];
            break;
            
        case 1:
            [self goPULWebVC:PULHOME_WEB_PRACTICE];
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
    
    if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        [self showTips:@"您不能对自己的提问进行回答"];
        return;
    }
    
    if ([_questionInfoModel.ISSOLVE boolValue]) {
        [self showTips:@"该问题已有答案被采纳"];
        return;
    }
    
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
