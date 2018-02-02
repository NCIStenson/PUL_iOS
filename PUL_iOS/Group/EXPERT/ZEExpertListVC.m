//
//  ZEExpertListVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/28.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEExpertListVC.h"
#import "ZEExpertListView.h"
#import "ZEExpertDetailVC.h"
#import "ZEShowQuestionVC.h"
#import "ZEAskQuestionTypeView.h"
#import "ZEExpertChatListVC.h"
#import "ZEExpertChatVC.h"
@interface ZEExpertListVC ()<ZEExpertListViewDelegate>
{
    ZEExpertListView * _expertListView;
    
    ZEAskQuestionTypeView * askTypeView;
    BOOL _isShowTypicalTypeView;
    
    NSUInteger _currentPage;
    
    NSString * orderStr;
    
    NSString * _currentWhereSql;
    NSString * _currentProCircleCode;
}
@end

@implementation ZEExpertListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"专家解答";
    _currentWhereSql = @"";
    _currentProCircleCode = @"";
    _currentPage = 0;
    orderStr = @"1";
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_question_searchType" color:[UIColor whiteColor]] forState:UIControlStateNormal];

    [self initView];
    [self sendRequestWithCurrentPage];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initView{
    _expertListView = [[ZEExpertListView alloc]initWithFrame:CGRectZero];
    _expertListView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _expertListView.delegate = self;
    [self.view addSubview:_expertListView];
    [self.view sendSubviewToBack:_expertListView];
}

-(void)sendRequestWithCurrentPage
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long) MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_EXPERT_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.procirclestatus.ExpertManage",
                                     @"DETAILTABLE":@"",
                                     @"orderstr":orderStr,
                                     @"procirclecode":_currentProCircleCode,
                                     };
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_EXPERT_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"searchOrder"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_EXPERT_INFO];
                                 if (dataArr.count > 0) {
//                                     if (_currenPage == 0) {
                                         [_expertListView reloadExpertListViw:dataArr];
//                                     }else{
//                                         [_expertListView reloadMoreDataView:dataArr];
//                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [_expertListView loadNoMoreData];
                                         return ;
                                     }
                                     [_expertListView reloadExpertListViw:dataArr];
                                     [_expertListView headerEndRefreshing];
                                     [_expertListView loadNoMoreData];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)goExpertVCDetail:(ZEExpertModel *)expertModel
{
    ZEExpertDetailVC * expertDetailVC = [[ZEExpertDetailVC alloc]init];
    expertDetailVC.expertModel = expertModel;
    [self.navigationController pushViewController:expertDetailVC animated:YES];
}

-(void)goSearchWithSearchStr:(NSString *)str
{
    NSLog(@"  -------   进行搜索");
    _currentProCircleCode = @"";
    _currentWhereSql = [NSString stringWithFormat:@"USERNAME like '%%%@%%'",str];
    [self sendRequestWithCurrentPage];

}

#pragma mark - 根据分类 选择经典案例类型
-(void)rightBtnClick{
    [self initAskTypeView];
}

-(void)initAskTypeView
{
    if(_isShowTypicalTypeView){
        self.title = @"专家解答";
        [askTypeView removeFromSuperview];
        askTypeView = nil;
        [self sendRequestWithCurrentPage];
    }else{
//        self.view.userInteractionEnabled
        self.title = @"技能分类";
        [_expertListView.questionSearchTF resignFirstResponder];
        askTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withMarginTop:(NAV_HEIGHT + 45)];
        askTypeView.delegate = self;
        [self.view addSubview:askTypeView];
        
        [self.view bringSubviewToFront:self.navBar];
        
        NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
        if (typeArr.count > 0) {
            [askTypeView reloadTypeData];
        }
    }
    _isShowTypicalTypeView = !_isShowTypicalTypeView;
}
#pragma mark - 选择分类

#pragma mark - ZEAskQuestionTypeViewDelegate

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode fatherCode:(NSString *)fatherCode
{
    _isShowTypicalTypeView = NO;
    
    self.title = @"专家解答";
    [askTypeView removeFromSuperview];
    askTypeView = nil;
    if (typeName.length == 0 && typeCode.length == 0 && fatherCode.length == 0) {
        [_expertListView.questionSearchTF becomeFirstResponder];
        return;
    }
    
//    if ([fatherCode integerValue] > 0) {
//        _currentWhereSql = [NSString stringWithFormat:@"PROCIRCLECODE like '%%%@%%'",fatherCode];
//    }else{
//        _currentWhereSql = [NSString stringWithFormat:@"PROCIRCLECODE like '%%%@%%' ",typeCode];
//    }
    [_expertListView initDataArr];
    _currentProCircleCode = typeCode;
    [self sendRequestWithCurrentPage];
    
}

-(void)goExpertHistoryAnswer:(ZEExpertModel *)expertModel
{
    ZEShowQuestionVC * showQuesVC = [[ZEShowQuestionVC alloc]init];
    showQuesVC.showQuestionListType = QUESTION_LIST_EXPERT;
    showQuesVC.expertModel = expertModel;
    [self.navigationController pushViewController:showQuesVC animated:YES];
}
-(void)goExpertOnlineAnswer:(ZEExpertModel *)expertModel
{
    if ([expertModel.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        NSLog(@"是专家！！！");
        ZEExpertChatListVC * chatListVC = [[ZEExpertChatListVC alloc]init];
        [self.navigationController pushViewController:chatListVC animated:YES];
    }else{
        JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:expertModel.USERCODE];
        if (conversation == nil) {
            [self showTips:@"获取会话" afterDelay:1.5];
            [JMSGConversation createSingleConversationWithUsername:expertModel.USERCODE completionHandler:^(id resultObject, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (error) {
                    NSLog(@"创建会话失败");
                    return ;
                }
                self.navigationController.navigationBar.hidden = NO;

                ZEExpertChatVC *conversationVC = [ZEExpertChatVC new];
                conversationVC.expertModel = expertModel;
                conversationVC.conversation = (JMSGConversation *)resultObject;
                [self.navigationController pushViewController:conversationVC animated:YES];
                
            }];
        } else {
            self.navigationController.navigationBar.hidden = NO;
            ZEExpertChatVC *conversationVC = [ZEExpertChatVC new];
            conversationVC.conversation = conversation;
            conversationVC.expertModel = expertModel;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
    }
}

-(void)sortConditon:(NSString *)condition
{
    orderStr = condition;
    [self sendRequestWithCurrentPage];
}

-(void)loadNewData
{
    _currentPage = 0;
    [self sendRequestWithCurrentPage];
}

-(void)loadMoreData{
    [self sendRequestWithCurrentPage];
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
