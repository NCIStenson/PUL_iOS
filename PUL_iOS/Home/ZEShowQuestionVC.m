//
//  ZEQuestionVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/7/28.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEShowQuestionVC.h"
#import "ZEShowQuestionView.h"

#import "ZEQuestionsDetailVC.h"

#import "ZEAskQuestionTypeView.h"

@interface ZEShowQuestionVC ()<ZEShowQuestionViewDelegate,ZEAskQuestionTypeViewDelegate>
{
    ZEShowQuestionView * _questionsView;
    NSInteger _currentPage;
    
    NSString * _currentInputStr;
    
    ZEAskQuestionTypeView * askTypeView;
    
}
@end

@implementation ZEShowQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_showQuestionListType == QUESTION_LIST_NEW) {
        self.title = @"最新问题";
    }else if(_showQuestionListType == QUESTION_LIST_TYPE){
        self.title = _QUESTIONTYPENAME;
        [self initAskTypeView];
    }else if(_showQuestionListType == QUESTION_LIST_MY_QUESTION){
        self.title = @"我的问题";
    }else if(_showQuestionListType == QUESTION_LIST_MY_ANSWER){
        self.title = @"我的回答";
    }else if (_showQuestionListType == QUESTION_LIST_EXPERT){
        self.title = @"专家解答";
    }else if (_showQuestionListType == QUESTION_LIST_CASE){
        self.title = @"典型案例";
    }
    if(_showQuestionListType != QUESTION_LIST_TYPE){
        [self createWhereSQL:_currentInputStr];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:kNOTI_CHANGE_ASK_SUCCESS object:nil];;
    
    [self initView];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGE_ASK_SUCCESS object:nil];
}

#pragma mark - 问题分类

-(void)cacheQuestionType
{
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        [askTypeView reloadTypeData];
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_QUESTION_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_TYPE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [[ZEQuestionTypeCache instance]setQuestionTypeCaches:[ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_TYPE]];
                                 [askTypeView reloadTypeData];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(void)initAskTypeView
{
    self.title = @"问题分类";
    self.rightBtn.enabled = NO;
    
    askTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    askTypeView.delegate = self;
    [self.view addSubview:askTypeView];
    [self.view sendSubviewToBack:askTypeView];
    
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        [askTypeView reloadTypeData];
    }else{
        [self cacheQuestionType];
    }
}

#pragma mark - ZEAskQuestionTypeViewDelegate

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode fatherCode:(NSString *)fatherCode
{
    self.title = typeName;
    self.typeSEQKEY = typeCode;
    self.typeParentID = fatherCode;
    
    [askTypeView removeFromSuperview];
    [self createWhereSQL:_currentInputStr];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)createWhereSQL:(NSString *)searchStr
{
    NSString * searchCondition = @"";
    if (_showQuestionListType == QUESTION_LIST_NEW) {
        searchCondition = [NSString stringWithFormat:@"ISLOSE = 0 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
        if (![ZEUtil isStrNotEmpty:searchStr]) {
            searchCondition = [NSString stringWithFormat:@"ISLOSE = 0"];
        }
    }else if (_showQuestionListType == QUESTION_LIST_TYPE){
        searchCondition = [NSString stringWithFormat:@"ISLOSE = 0 and QUESTIONTYPECODE like '%%%@%%' and QUESTIONEXPLAIN like '%%%@%%'",_typeSEQKEY,searchStr];
        if (![ZEUtil isStrNotEmpty:searchStr]) {
            searchCondition = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONTYPECODE like '%%%@%%'",_typeSEQKEY];
        }
        if([ZEUtil isStrNotEmpty:self.typeParentID] && [self.typeParentID integerValue] == -1){
            [self getAllTypeQuestion];
            return;
        }
    }else if (_showQuestionListType == QUESTION_LIST_MY_QUESTION){
        searchCondition = [NSString stringWithFormat:@"ISLOSE = 0 and QUESTIONUSERCODE = '%@' and QUESTIONEXPLAIN like '%%%@%%'",[ZESettingLocalData getUSERCODE],searchStr];
        if (![ZEUtil isStrNotEmpty:searchStr]) {
            searchCondition = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONUSERCODE = '%@'",[ZESettingLocalData getUSERCODE]];
        }
    }else if (_showQuestionListType == QUESTION_LIST_MY_ANSWER){
        searchCondition = [NSString stringWithFormat:@"ISLOSE = 0 and USERCODE = '%@'  and QUESTIONEXPLAIN like '%%%@%%'",[ZESettingLocalData getUSERCODE],searchStr];
        if (![ZEUtil isStrNotEmpty:searchStr]) {
            searchCondition = [NSString stringWithFormat:@"ISLOSE=0 and USERCODE = '%@'",[ZESettingLocalData getUSERCODE]];
        }
        [self sendMyAnswerRequestWithCondition:searchCondition];
        return;
    }else if (_showQuestionListType == QUESTION_LIST_EXPERT){
        searchCondition = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONEXPLAIN like '%%%@%%' and EXPERTUSERCODE like '%%%@%%'",searchStr,_expertModel.USERCODE];
        if (![ZEUtil isStrNotEmpty:searchStr]) {
            searchCondition = [NSString stringWithFormat:@"ISLOSE=0 and EXPERTUSERCODE like '%%%@%%'",_expertModel.USERCODE];
        }
    }else if (_showQuestionListType == QUESTION_LIST_CASE){
        searchCondition = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONLEVEL = 2 and QUESTIONEXPLAIN like '%%%@%%'",searchStr];
        if (![ZEUtil isStrNotEmpty:searchStr]) {
            searchCondition = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONLEVEL = 2 and QUESTIONEXPLAIN like '%%'"];
        }
    }
    
    [self sendRequestWithCondition:searchCondition];
}

-(void)getAllTypeQuestion
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionSearch",
                                     @"DETAILTABLE":@"",
                                     @"PARENTID":self.typeParentID,
                                     @"TYPECODE":self.typeSEQKEY};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"SEARCH_PARENT_TYPE"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
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
                                         if (_showQuestionListType != QUESTION_LIST_MY_QUESTION) {
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

-(void)sendRequestWithCondition:(NSString *)conditionStr
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":conditionStr,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
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
                                         if (_showQuestionListType != QUESTION_LIST_MY_QUESTION) {
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
-(void)sendMyAnswerRequestWithCondition:(NSString *)conditionStr
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":conditionStr,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.MyAnswer",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO_LIST]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO_LIST];
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
                                         [self showTips:@"快去帮助小伙伴们解决他们的疑问吧！" afterDelay:1.5];
                                     }
                                     [_questionsView reloadFirstView:dataArr];
                                     [_questionsView headerEndRefreshing];
                                     [_questionsView loadNoMoreData];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}



#pragma mark -

-(void)initView
{
    _questionsView = [[ZEShowQuestionView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) withEnterType:_showQuestionListType];
    _questionsView.delegate = self;
    [self.view addSubview:_questionsView];
    _questionsView.searchStr = _currentInputStr;
    [self.view sendSubviewToBack:_questionsView];
}

#pragma mark - ZEShowQuestionViewDelegate

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel
{
    ZEQuestionsDetailVC * detailVC = [[ZEQuestionsDetailVC alloc]init];
    detailVC.questionInfoModel = infoModel;
    detailVC.questionTypeModel = typeModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.enterQuestionDetailType = _showQuestionListType;
}

-(void)goSearch:(NSString *)str
{
    _currentPage = 0;
    [_questionsView reloadFirstView:nil];
    _questionsView.searchStr = str;
    
    _currentInputStr = str;
    [self createWhereSQL:_currentInputStr];
}

-(void)loadNewData
{
    _currentPage = 0;
    [self createWhereSQL:_currentInputStr];
}

-(void)loadMoreData
{
    [self createWhereSQL:_currentInputStr];
}

-(void)deleteMyQuestion:(NSString *)questionSEQKEY
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":questionSEQKEY,
                                @"ISLOSE":@"1"};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                           showAlertView:YES
                                 success:^(id data) {
                                     NSArray * arr = [ZEUtil getEXCEPTIONDATA:data];
                                     if(arr.count > 0){
                                         NSDictionary * failReason = arr[0];
                                         [self showTips:[NSString stringWithFormat:@"%@\n",[failReason objectForKey:@"reason"]] afterDelay:1.5];
                                     }else{
                                         [self showTips:@"问题删除成功" afterDelay:1];
                                         [self loadNewData];
                                     }
                                 } fail:^(NSError *error) {
                                     [self showTips:@"问题删除失败，请稍后重试。"];
                                 }];
}

-(void)deleteMyAnswer:(NSString *)questionSEQKEY
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_DELETE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.MyAnswer",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"QUESTIONID":questionSEQKEY,
                                @"ANSWERUSERCODE":[ZESettingLocalData getUSERCODE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"DELETE_MY_ANSWER"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getEXCEPTIONDATA:data];
                                 if(arr.count > 0){
                                     NSDictionary * failReason = arr[0];
                                     [self showTips:[NSString stringWithFormat:@"%@\n",[failReason objectForKey:@"reason"]] afterDelay:1.5];
                                 }else{
                                     [self showTips:@"回答删除成功" afterDelay:1];
                                     [self loadNewData];
                                 }
                             } fail:^(NSError *error) {
                                 [self showTips:@"回答删除失败，请稍后重试。"];
                             }];
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
