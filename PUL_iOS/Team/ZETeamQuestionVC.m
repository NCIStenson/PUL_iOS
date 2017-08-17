//
//  ZETeamQuestionVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/13.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamQuestionVC.h"
#import "ZETeamQuestionView.h"

#import "ZETeamQuestionDetailVC.h"
#import "ZEAskTeamQuestionVC.h"
#import "ZETeamChatRoomVC.h"

#import "ZEAnswerTeamQuestionVC.h"

#import "ZESearchTeamQuestionVC.h"

#import "ZETeamCircleChatVC.h"

#import "ZECreateTeamVC.h"

@interface ZETeamQuestionVC ()<ZETeamQuestionViewDelegate,ZETeamQuestionViewDelegate>
{
    ZETeamQuestionView * _teamQuestionView;
    
    NSInteger _currentTeamNewestPage;   //  团队 我来挑战
    NSInteger _currentTeamTargetPage; //  你问我答
    NSInteger _currentTeamMyQuestionPage;  //  我的问题
    NSInteger _currentTeamSolvedPage; //   团队已解决问题
    
    NSInteger _currentAskRankingPage; //   团队已解决问题
    NSInteger _currentAnswerRankingPage; //   团队已解决问题
    
    TEAM_WILL_SHOWVIEW _willShowView;

}
@end

@implementation ZETeamQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = _teamCircleInfo.TEAMCIRCLENAME;
    self.title = @"";
    [self addNavBarBtn];
    [self initView];
    
    _willShowView = -1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ACCEPT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendHomeDataRequest) name:kNOTI_TEAM_CHANGE_QUESTION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTeamCircleInfo:) name:kNOTI_CHANGE_TEAMCIRCLEINFO_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goLeavePracticeWebView) name:kNOTI_LEAVE_PRACTICE_WEBVIEW object:nil];

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self sendHomeDataRequest];
}

#pragma mark - NOTI
-(void)changeTeamCircleInfo:(NSNotification *)noti
{
    if ([noti.object isKindOfClass:[ZETeamCircleModel class]]) {
        _teamCircleInfo = noti.object;
    }
}
-(void)addNavBarBtn
{
    for (int i = 0; i < 3; i ++) {
        UIButton * _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeBtn.frame = CGRectMake(SCREEN_WIDTH - 105 + 33 * i, 27, 30.0, 30.0);
        _typeBtn.contentMode = UIViewContentModeScaleAspectFit;
        _typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftBtn.superview addSubview:_typeBtn];
        _typeBtn.tag = i + 100;
        if (i == 0) {
            [_typeBtn setImage:[UIImage imageNamed:@"yy_nav_people" ] forState:UIControlStateNormal];
        }else if (i == 1){
            [_typeBtn setImage:[UIImage imageNamed:@"yy_nav_search" ] forState:UIControlStateNormal];
        }else if (i == 2){
            [_typeBtn setImage:[UIImage imageNamed:@"yy_nav_why" ] forState:UIControlStateNormal];
        }else if (i == 3){
            [_typeBtn setImage:[UIImage imageNamed:@"icon_team_discuss" color:[UIColor whiteColor]] forState:UIControlStateNormal];
        }
    }
}

-(void)leftBtnClick{
    _willShowView = TEAM_WILL_SHOWVIEW_BACK;
    if(_teamQuestionView.isPractice ){
        [_teamQuestionView showWebViewAlert];
        return;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)goLeavePracticeWebView
{
    if (_willShowView == TEAM_WILL_SHOWVIEW_BACK) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 导航栏两个按钮点击

-(void)typeBtnClick:(UIButton *)btn
{
    if (btn.tag == 100) {
        [self goTeamDetailVC];
    }else if(btn.tag == 101){
        [self goSearchQuestionVC];
    }else if (btn.tag == 102){
        [self goAskTeamQuestionVC];
    }else if (btn.tag == 103){
        [self goTeamChatRoom];
    }
}

-(void)goTeamDetailVC
{
    ZECreateTeamVC * createTeamVC = [[ZECreateTeamVC alloc]init];
    createTeamVC.enterType = ENTER_TEAM_DETAIL;
    createTeamVC.teamCircleInfo = _teamCircleInfo;
    createTeamVC.TEAMCODE = _teamCircleInfo.TEAMCODE;
    createTeamVC.TEAMSEQKEY = _teamCircleInfo.SEQKEY;
    [self.navigationController pushViewController:createTeamVC animated:YES];
    
}
-(void)goSearchQuestionVC
{
    ZESearchTeamQuestionVC * showQuestionsList = [[ZESearchTeamQuestionVC alloc]init];
    showQuestionsList.TEAMCIRCLECODE = _teamCircleInfo.TEAMCODE;
    [self.navigationController pushViewController:showQuestionsList animated:YES];
}

-(void)goTeamChatRoom
{
    JMSGConversation *conversation = [JMSGConversation groupConversationWithGroupId:_teamCircleInfo.JMESSAGEGROUPID];
    if (conversation == nil) {
        [self showTips:@"获取会话" afterDelay:1.5];
        
        [JMSGConversation createGroupConversationWithGroupId:_teamCircleInfo.JMESSAGEGROUPID completionHandler:^(id resultObject, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error) {
                NSLog(@"创建会话失败");
                return ;
            }
            ZETeamChatRoomVC *conversationVC = [ZETeamChatRoomVC new];
            conversationVC.teamcircleModel = _teamCircleInfo;
            conversationVC.conversation = (JMSGConversation *)resultObject;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }];
    } else {
        ZETeamChatRoomVC *conversationVC = [ZETeamChatRoomVC new];
        conversationVC.conversation = conversation;
        conversationVC.teamcircleModel = _teamCircleInfo;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    
}
    
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_teamQuestionView endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGE_TEAMCIRCLEINFO_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ACCEPT_SUCCESS object:nil];
}


-(void)sendHomeDataRequest
{
    _currentTeamNewestPage = 0;
    _currentTeamSolvedPage = 0;
    _currentTeamTargetPage = 0;
    _currentTeamMyQuestionPage = 0;
    
    [[ZEServerEngine sharedInstance] cancelAllTask];
    
    [self sendCommonQuestionsRequest:@""];
    [self sendOnlyMeAskQuestionsRequest:@""];
    [self sendSolvedQuestion];
    [self sendMyQuestionsRequest:@""];
    [self sendAskRankingRequest:[ZEUtil getCurrentDate:@"yyyyMM"]];
    [self sendAnswerRankingRequest:[ZEUtil getCurrentDate:@"yyyyMM"]];
    [self sendPracticeRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self isHaveNewMessage];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_teamQuestionView deleteWebCache];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)initView
{
    _teamQuestionView = [[ZETeamQuestionView alloc] initWithFrame:self.view.frame];
    _teamQuestionView.delegate = self;
    _teamQuestionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_teamQuestionView];
    [self.view sendSubviewToBack:_teamQuestionView];
    
    [_teamQuestionView scrollContentViewToIndex:_currentContent];
}
#pragma mark - 是否有新消息提醒
-(void)isHaveNewMessage
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"INFOCOUNT":@"",
                                @"QUESTIONCOUNT":@"",
                                @"ANSWERCOUNT":@"",
                                @"TEAMINFOCOUNT":@"",
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
                                 if ([arr count] > 0) {
                                     NSString * INFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"INFOCOUNT"]];
                                     NSString * TEAMINFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"TEAMINFOCOUNT"]];
                                     if ([INFOCOUNT integerValue] > 0) {
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                                         item.badgeValue= INFOCOUNT;
                                         if ([INFOCOUNT integerValue] > 99) {
                                             item.badgeValue= @"99+";
                                         }
                                     }else{
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                                         item.badgeValue= nil;
                                     }
                                     if ([TEAMINFOCOUNT integerValue] > 0 ) {
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
                                         item.badgeValue= TEAMINFOCOUNT;
                                         if ([INFOCOUNT integerValue] > 99) {
                                             item.badgeValue= @"99+";
                                         }
                                     }else{
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
                                         item.badgeValue= nil;
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>  %@",errorCode);
                             }];    
}


#pragma mark - Request
/**
 我来挑战列表
 
 @param searchStr 推荐问题搜索
 */
-(void)sendCommonQuestionsRequest:(NSString *)searchStr
{
    //    NSString * WHERESQL = [NSString stringWithFormat:@" ISSOLVE = 0 and TEAMCIRCLECODE = @ and QUESTIONEXPLAIN like '%%%@%%'",,searchStr];
    //    if (![ZEUtil isStrNotEmpty:searchStr]) {
    NSString *  WHERESQL = [NSString stringWithFormat:@" ISSOLVE = 0 and TEAMCIRCLECODE = '%@' and TARGETUSERCODE is NULL",_teamCircleInfo.TEAMCODE];
    //    }
    //    ANSWERSUM DESC,
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@" SYSCREATEDATE desc ",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentTeamNewestPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_QUESTION_INFO ];
                                 if (dataArr.count > 0) {
                                     if (_currentTeamNewestPage == 0) {
                                         [_teamQuestionView reloadFirstView:dataArr withHomeContent:TEAM_CONTENT_NEWEST ];
                                     }else{
                                         [_teamQuestionView reloadContentViewWithArr:dataArr withHomeContent:TEAM_CONTENT_NEWEST];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentTeamNewestPage += 1;
                                     }else{
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_NEWEST];
                                     }
                                 }else{
                                     if (_currentTeamNewestPage > 0) {
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_NEWEST];
                                         return ;
                                     }
                                     [_teamQuestionView reloadFirstView:dataArr withHomeContent:TEAM_CONTENT_NEWEST];
                                     [_teamQuestionView headerEndRefreshingWithHomeContent:TEAM_CONTENT_NEWEST];
                                     [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_NEWEST];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_teamQuestionView endRefreshingWithHomeContent:TEAM_CONTENT_NEWEST];
                             }];
    
}

/************* 你问我答问题列表 *************/
-(void)sendOnlyMeAskQuestionsRequest:(NSString *)searchStr
{
    NSString *  WHERESQL = [NSString stringWithFormat:@" ISSOLVE = 0 and TEAMCIRCLECODE = '%@' and TARGETUSERCODE like '%%%@%%'",_teamCircleInfo.TEAMCODE,[ZESettingLocalData getUSERCODE]];
    //    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@" SYSCREATEDATE,ANSWERSUM desc ",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentTeamTargetPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_QUESTION_INFO ];
                                 if (dataArr.count > 0) {
                                     if (_currentTeamTargetPage == 0) {
                                         [_teamQuestionView reloadFirstView:dataArr withHomeContent:TEAM_CONTENT_TARGETASK ];
                                     }else{
                                         [_teamQuestionView reloadContentViewWithArr:dataArr withHomeContent:TEAM_CONTENT_TARGETASK];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentTeamTargetPage += 1;
                                     }else{
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_TARGETASK];
                                     }
                                 }else{
                                     if (_currentTeamTargetPage > 0) {
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_TARGETASK];
                                         return ;
                                     }
                                     [_teamQuestionView reloadFirstView:dataArr withHomeContent:TEAM_CONTENT_TARGETASK];
                                     [_teamQuestionView headerEndRefreshingWithHomeContent:TEAM_CONTENT_TARGETASK];
                                     [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_TARGETASK];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_teamQuestionView endRefreshingWithHomeContent:TEAM_CONTENT_TARGETASK];
                             }];

}


/**
 已解决问题列表
 */
-(void)sendSolvedQuestion
{
    NSString *  WHERESQL = [NSString stringWithFormat:@" ISSOLVE = 1 and TEAMCIRCLECODE = '%@'",_teamCircleInfo.TEAMCODE];
    //    }
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@" SYSCREATEDATE,ANSWERSUM desc ",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentTeamSolvedPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_QUESTION_INFO ];
                                 if (dataArr.count > 0) {
                                     if (_currentTeamSolvedPage == 0) {
                                         [_teamQuestionView reloadFirstView:dataArr withHomeContent:TEAM_CONTENT_SOLVED];
                                     }else{
                                         [_teamQuestionView reloadContentViewWithArr:dataArr withHomeContent:TEAM_CONTENT_SOLVED];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentTeamSolvedPage += 1;
                                     }else{
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_SOLVED];
                                     }
                                 }else{
                                     if (_currentTeamSolvedPage > 0) {
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_SOLVED];
                                         return ;
                                     }
                                     [_teamQuestionView reloadFirstView:dataArr withHomeContent:TEAM_CONTENT_SOLVED];
                                     [_teamQuestionView headerEndRefreshingWithHomeContent:TEAM_CONTENT_SOLVED];
                                     [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_SOLVED];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_teamQuestionView endRefreshingWithHomeContent:TEAM_CONTENT_SOLVED];
                             }];
}


/**
 我的问题列表
 
 @param searchStr 高悬赏问题搜索
 */
-(void)sendMyQuestionsRequest:(NSString *)searchStr
{
    NSString *  WHERESQL = [NSString stringWithFormat:@" TEAMCIRCLECODE = '%@' and QUESTIONUSERCODE = '%@'",_teamCircleInfo.TEAMCODE,[ZESettingLocalData getUSERCODE]];

    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentTeamMyQuestionPage * MAX_PAGE_COUNT],
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentTeamMyQuestionPage == 0) {
                                         [_teamQuestionView reloadFirstView:dataArr withHomeContent:TEAM_CONTENT_MYQUESTION ];
                                     }else{
                                         [_teamQuestionView reloadContentViewWithArr:dataArr withHomeContent:TEAM_CONTENT_MYQUESTION];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentTeamMyQuestionPage += 1;
                                     }else{
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_MYQUESTION];
                                     }
                                 }else{
                                     if (_currentTeamMyQuestionPage > 0) {
                                         [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_MYQUESTION];
                                         return ;
                                     }
                                     [_teamQuestionView reloadFirstView:dataArr withHomeContent:TEAM_CONTENT_MYQUESTION];
                                     [_teamQuestionView headerEndRefreshingWithHomeContent:TEAM_CONTENT_MYQUESTION];
                                     [_teamQuestionView loadNoMoreDataWithHomeContent:TEAM_CONTENT_MYQUESTION];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_teamQuestionView endRefreshingWithHomeContent:TEAM_CONTENT_MYQUESTION];
                             }];
}


#pragma mark - 比一比接口请求

-(void)sendAskRankingRequest:(NSString *)yearMonth
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_MEMBERRANK,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleRank",
                                     @"YEARMONTH":yearMonth,
                                     @"TEAMCIRCLECODE":_teamCircleInfo.TEAMCODE,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"TEAMCIRCLECODE":_teamCircleInfo.TEAMCODE,
                                @"USERNAME":@"",
                                @"FILEURL":@"",
                                @"QUESTIONSUM":@"",
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_MEMBERRANK]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"TEAMCIRCLE_QUESTIONRANK"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_MEMBERRANK];
                                 [_teamQuestionView reloadTeamViewRankingList:dataArr withRankingContent:TEAM_RANKING_ASK];
                             } fail:^(NSError *errorCode) {

                             }];
}

-(void)sendAnswerRankingRequest:(NSString *)yearMonth
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_MEMBERRANK,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleRank",
                                     @"YEARMONTH":yearMonth,
                                     @"TEAMCIRCLECODE":_teamCircleInfo.TEAMCODE,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"TEAMCIRCLECODE":_teamCircleInfo.TEAMCODE,
                                @"USERNAME":@"",
                                @"FILEURL":@"",
                                @"ANSWERSUM":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_MEMBERRANK]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"TEAMCIRCLE_ANSWERRANK"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_MEMBERRANK];
                                 [_teamQuestionView reloadTeamViewRankingList:dataArr withRankingContent:TEAM_RANKING_ANSWER];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - 练一练接口

-(void)sendPracticeRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"",
                                     @"METHOD":@"DailyPractice",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.exam.examCaseTeam",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_teamCircleInfo.TEAMCODE};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];
                                 NSString * targetURL = [dic objectForKey:@"target"];
                                 if (targetURL.length > 0) {
                                     NSLog(@"targetURL >>>  %@",targetURL);
                                     _teamQuestionView.practiceURL = targetURL;
                                     [_teamQuestionView refreshPracticeWebView];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - ZEHomeViewDelegate

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel;
{
    ZETeamQuestionDetailVC * detailVC = [[ZETeamQuestionDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    detailVC.questionTypeModel = typeModel;
    detailVC.teamCircleInfo = _teamCircleInfo;
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
        ZETeamCircleChatVC * chatVC = [[ZETeamCircleChatVC alloc]init];
        chatVC.questionInfo = _questionInfoModel;
        chatVC.enterChatVCType = 1;
        [self.navigationController pushViewController:chatVC animated:YES];
        
    }else{
        ZEAnswerTeamQuestionVC * answerQuesVC = [[ZEAnswerTeamQuestionVC alloc]init];
        answerQuesVC.questionSEQKEY = _questionInfoModel.SEQKEY;
        answerQuesVC.questionInfoModel = _questionInfoModel;
        [self.navigationController pushViewController:answerQuesVC animated:YES];
    }
}

-(void)goAskTeamQuestionVC
{
    ZEAskTeamQuestionVC * askQues = [[ZEAskTeamQuestionVC alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_TABBAR;
    askQues.teamInfoModel = _teamCircleInfo;
    [self presentViewController:askQues animated:YES completion:nil];
}

- (void)showTips:(NSString *)labelText {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud3.mode = MBProgressHUDModeText;
    hud3.labelText = labelText;
    [hud3 hide:YES afterDelay:1.0f];
}

-(void)loadNewData:(TEAM_CONTENT)contentPage
{
    switch (contentPage) {
        case TEAM_CONTENT_NEWEST:
            _currentTeamNewestPage = 0;
            [self sendCommonQuestionsRequest:@""];
            break;
            
        case TEAM_CONTENT_TARGETASK:
            _currentTeamTargetPage = 0;
            [self sendOnlyMeAskQuestionsRequest:@""];
            break;
            
        case TEAM_CONTENT_SOLVED:
            _currentTeamSolvedPage = 0;
            [self sendSolvedQuestion];
            break;

        case TEAM_CONTENT_MYQUESTION:
            _currentTeamMyQuestionPage = 0;
            [self sendMyQuestionsRequest:@""];
            break;
            
        default:
            break;
    }
}

-(void)loadMoreData:(TEAM_CONTENT)contentPage
{
    switch (contentPage) {
        case TEAM_CONTENT_NEWEST:
            [self sendCommonQuestionsRequest:@""];
            break;
            
        case TEAM_CONTENT_TARGETASK:
            [self sendOnlyMeAskQuestionsRequest:@""];
            break;
            
        case TEAM_CONTENT_SOLVED:
            [self sendSolvedQuestion];
            break;
            
        case TEAM_CONTENT_MYQUESTION:
            [self sendMyQuestionsRequest:@""];
            break;
            
        default:
            break;
    }
}

-(void)selectMonthStr:(NSString *)yearMonth
{
    NSLog(@" yearMonth  ===============  %@ ",yearMonth);
    [self sendAnswerRankingRequest:yearMonth];
    [self sendAskRankingRequest:yearMonth];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
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
