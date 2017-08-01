//
//  ZESearchQuestionVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/16.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESearchTeamQuestionVC.h"
#import "ZETeamQuestionDetailVC.h"
#import "ZEShowQuestionView.h"
@interface ZESearchTeamQuestionVC ()<ZEShowQuestionViewDelegate>
{
    ZEShowQuestionView * _questionsView;
    NSInteger _currentPage;
    
    NSString * _currentInputStr;
}
@end

@implementation ZESearchTeamQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索问题";
    _currentInputStr = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _questionsView = [[ZEShowQuestionView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) withEnterType:QUESTION_LIST_TEAM_QUESTION];
    _questionsView.delegate = self;
    [self.view addSubview:_questionsView];
//    _questionsView.searchStr = _currentInputStr;
    [self.view sendSubviewToBack:_questionsView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    [self createWhereSQL];
}

-(void)createWhereSQL
{
    NSString * whereSQL = [NSString stringWithFormat:@" QUESTIONEXPLAIN like '%%%@%%' and teamcirclecode ='%@' and ( targetusercode is null or targetusercode like '%%%@%%' ) ",_currentInputStr,_TEAMCIRCLECODE,[ZESettingLocalData getUSERCODE]];
    [self sendRequestWithCondition:whereSQL ];
}

-(void)sendRequestWithCondition:(NSString *)conditionStr
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":conditionStr,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic = @{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [_questionsView reloadFirstView:dataArr];
                                     }else{
                                         [_questionsView reloadContentViewWithArr:dataArr];
                                     }
                                     if (dataArr.count%MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [_questionsView loadNoMoreData];
                                         return ;
                                     }else{
                                         if (_teamSearchType != ENTER_TEAM_SEARCH_MYQUESTION) {
                                             [self showTips:@"暂时没有相关问题，去提一个吧~" afterDelay:1.5];
                                         }else{
                                             [self showTips:@"您还没有提问过任何问题，去提一个吧~" afterDelay:1.5];
                                         }
                                     }
                                     [_questionsView reloadFirstView:dataArr];
                                     [_questionsView headerEndRefreshing];
                                     [_questionsView loadNoMoreData];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}
#pragma mark - ZEShowQuestionViewDelegate

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel
{
    ZETeamQuestionDetailVC * detailVC = [[ZETeamQuestionDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    detailVC.questionTypeModel = typeModel;
    [self.navigationController pushViewController:detailVC animated:YES];
//    detailVC.enterQuestionDetailType = _showQuestionListType;
}

-(void)goSearch:(NSString *)str
{
    _currentPage = 0;
    [_questionsView reloadFirstView:nil];
    _questionsView.searchStr = str;
    
    _currentInputStr = str;
    [self createWhereSQL];
}

-(void)loadNewData
{
    _currentPage = 0;
    [self createWhereSQL];
}

-(void)loadMoreData
{
    [self createWhereSQL];
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
