//
//  ZENewQuestionListVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENewQuestionListVC.h"
#import "ZENewQuestionListView.h"

#import "ZEQuestionsDetailVC.h"
#import "ZENewQuestionDetailVC.h"

#import "ZEChatVC.h"
#import "ZENewAnswerQuestionVC.h"
#import "ZEAskQuesViewController.h"

#import "ZENewSearchQuestionVC.h"
#import "ZESchoolWebVC.h"
@interface ZENewQuestionListVC ()<ZENewQuestionListViewDelegate>
{
    ZENewQuestionListView * _questionListView;
    
    NSInteger _currentNewestPage;
    NSInteger _currentRecommandPage;
    NSInteger _currentBounsPage;
    
}
@end

@implementation ZENewQuestionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    self.navBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ACCEPT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_CHANGE_ASK_SUCCESS object:nil];

    
    [self sendNewestQuestionsRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initView
{
    _questionListView = [[ZENewQuestionListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _questionListView.backgroundColor = MAIN_ARM_COLOR;
    _questionListView.delegate = self;
    [self.view addSubview:_questionListView];
}

#pragma mark - Request

-(void)sendHomeDataRequest
{
    _currentNewestPage = 0;
    _currentRecommandPage = 0;
    _currentBounsPage = 0;
    
    [self sendNewestQuestionsRequest];
    [self sendRecommandQuestionsRequest:@""];
    [self sendBounsQuestionsRequest:@""];
}


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
                                         [_questionListView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_NEWEST ];
                                     }else{
                                         [_questionListView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_NEWEST];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentNewestPage += 1;
                                     }else{
                                         [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                     }
                                 }else{
                                     if (_currentNewestPage > 0) {
                                         [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                         return ;
                                     }
                                     [_questionListView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_NEWEST];
                                     [_questionListView headerEndRefreshingWithHomeContent:HOME_CONTENT_NEWEST];
                                     [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_NEWEST];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 [_questionListView endRefreshingWithHomeContent:HOME_CONTENT_NEWEST];
                             }];
    
}

/**
 推荐问题列表
 
 @param searchStr 推荐问题搜索
 */
-(void)sendRecommandQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and ISSOLVE = 0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and ISSOLVE = 0 and QUESTIONEXPLAIN like '%%'"];
    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@" SYSCREATEDATE,ANSWERSUM desc ",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentRecommandPage * MAX_PAGE_COUNT],
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
                                     if (_currentRecommandPage == 0) {
                                         [_questionListView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_RECOMMAND ];
                                     }else{
                                         [_questionListView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_RECOMMAND];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentRecommandPage += 1;
                                     }else{
                                         [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                     }
                                 }else{
                                     if (_currentRecommandPage > 0) {
                                         [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                         return ;
                                     }
                                     [_questionListView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_RECOMMAND];
                                     [_questionListView headerEndRefreshingWithHomeContent:HOME_CONTENT_RECOMMAND];
                                     [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_RECOMMAND];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_questionListView endRefreshingWithHomeContent:HOME_CONTENT_RECOMMAND];
                             }];
    
}
/**
 高悬赏问题列表
 
 @param searchStr 高悬赏问题搜索
 */
-(void)sendBounsQuestionsRequest:(NSString *)searchStr
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and BONUSPOINTS IS NOT NULL and BONUSPOINTS != 0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
    if (![ZEUtil isStrNotEmpty:searchStr]) {
        WHERESQL = [NSString stringWithFormat:@"ISLOSE = 0 and BONUSPOINTS IS NOT NULL and ISSOLVE = 0 and BONUSPOINTS != 0 and QUESTIONEXPLAIN like '%%'"];
    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentBounsPage * MAX_PAGE_COUNT],
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
                                     if (_currentBounsPage == 0) {
                                         [_questionListView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_BOUNS ];
                                     }else{
                                         [_questionListView reloadContentViewWithArr:dataArr withHomeContent:HOME_CONTENT_BOUNS];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentBounsPage += 1;
                                     }else{
                                         [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                     }
                                 }else{
                                     if (_currentBounsPage > 0) {
                                         [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                         return ;
                                     }
                                     [_questionListView reloadFirstView:dataArr withHomeContent:HOME_CONTENT_BOUNS];
                                     [_questionListView headerEndRefreshingWithHomeContent:HOME_CONTENT_BOUNS];
                                     [_questionListView loadNoMoreDataWithHomeContent:HOME_CONTENT_BOUNS];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_questionListView endRefreshingWithHomeContent:HOME_CONTENT_BOUNS];
                             }];
}


#pragma mark - ZENewQuestionListViewDelegate

-(void)giveQuestionPraise:(ZEQuestionInfoModel *)questionInfo
{
    NSLog(@" ======= 点赞点赞点赞点赞 %@",questionInfo.SEQKEY);
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_GOOD,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerGood",
                                     };
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"QUESTIONID":questionInfo.SEQKEY,
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_GOOD]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"questionGood"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
//                                 button.enabled = YES;
//                                 [self sendSearchAnswerRequest];
                             } fail:^(NSError *errorCode) {
//                                 button.enabled = YES;
                             }];
    
}

-(void)answerQuestion:(ZEQuestionInfoModel *)questionInfo
{
    NSLog(@" ======= 回答 %@ 的问题",questionInfo.NICKNAME);
    if ([questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        [self showTips:@"您不能对自己的提问进行回答"];
        return;
    }
    
    if ([questionInfo.ISSOLVE boolValue]) {
        [self showTips:@"该问题已有答案被采纳"];
        return;
    }
    
    
    if (questionInfo.ISANSWER) {
        ZEChatVC * chatVC = [[ZEChatVC alloc]init];
        chatVC.questionInfo = questionInfo;
        chatVC.enterChatVCType = 1;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else{
        ZENewAnswerQuestionVC * answerQuesVC = [[ZENewAnswerQuestionVC alloc]init];
        answerQuesVC.questionSEQKEY = questionInfo.SEQKEY;
        answerQuesVC.questionInfoM = questionInfo;
        [self.navigationController pushViewController:answerQuesVC animated:YES];
    }
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadNewData:(HOME_CONTENT)contentPage
{
    switch (contentPage) {
        case HOME_CONTENT_RECOMMAND:
            _currentRecommandPage = 0;
            [self sendRecommandQuestionsRequest:@""];
            break;
            
        case HOME_CONTENT_NEWEST:
            _currentNewestPage = 0;
            [self sendNewestQuestionsRequest];
            
            break;
            
        case HOME_CONTENT_BOUNS:
            _currentBounsPage = 0;
            [self sendBounsQuestionsRequest:@""];
            break;
            
        default:
            break;
    }
}

-(void)loadMoreData:(HOME_CONTENT)contentPage
{
    switch (contentPage) {
        case HOME_CONTENT_RECOMMAND:
            [self sendRecommandQuestionsRequest:@""];
            break;
            
        case HOME_CONTENT_NEWEST:
            [self sendNewestQuestionsRequest];
            
            break;
            
        case HOME_CONTENT_BOUNS:
            [self sendBounsQuestionsRequest:@""];
            break;
            
        default:
            break;
    }
}

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
{
    ZENewQuestionDetailVC * detailVC = [[ZENewQuestionDetailVC alloc]init];
    detailVC.questionInfo = infoModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)askQuestion
{
    ZEAskQuesViewController * askQues = [[ZEAskQuesViewController alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_TABBAR;
    [self presentViewController:askQues animated:YES completion:nil];
}

-(void)presentWebVCWithUrl:(NSString *)urlStr
{
    ZESchoolWebVC * webvc = [[ZESchoolWebVC alloc]init];
    webvc.enterType = ENTER_WEBVC_QUESTION;
    webvc.webURL = urlStr;
    [self.navigationController pushViewController:webvc animated:YES];
}

-(void)goSearchView
{
    ZENewSearchQuestionVC * showQuestionsList = [[ZENewSearchQuestionVC alloc]init];
//    showQuestionsList.showQuestionListType = QUESTION_LIST_NEW;
//    showQuestionsList.currentInputStr = str;
    [self.navigationController pushViewController:showQuestionsList animated:YES];
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
