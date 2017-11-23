//
//  ZETypicalCaseVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/10/31.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETypicalCaseVC.h"
#import "ZETypicalCaseView.h"
#import "ZEAskQuestionTypeView.h"
#import "ZETypicalCaseDetailVC.h"

@interface ZETypicalCaseVC ()<ZETypicalCaseViewDelegate,ZEAskQuestionTypeViewDelegate>
{
    ZETypicalCaseView * caseView;
    ZEAskQuestionTypeView * askTypeView;

    NSInteger _currentPage;
    
    NSString * _currentWHERESQL;
//    NSString * sortOrderSQL;// 最热 最新排序
    NSString * orderStr;// 最热 最新排序

    NSString * questionTypeCode; //  选择的经典案例分类code
    NSString * questionTypeName; //  选择的经典案例分类Name
    
    BOOL _isShowTypicalTypeView;
    
    NSString * totalTypeCode;
}


@end

@implementation ZETypicalCaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentPage = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentWHERESQL = @"";
    if (_enterType == ENTER_CASE_TYPE_NEWEST || _enterType == ENTER_CASE_TYPE_RECOMMAND) {
        
        if (_enterType == ENTER_CASE_TYPE_NEWEST) {
            orderStr = @"1";
        }else{
            orderStr = @"2";
        }
        
        self.title = @"典型案例";
        [self sendRequestWithOrder];
        
        questionTypeName = @"";
        questionTypeCode = @"";
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_question_searchType" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(initAskTypeView) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.title = @"我的收藏";
        [self myCollectRequest];
    }
    [self initView];
    _isShowTypicalTypeView = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreSuccess) name:kNOTI_SCORE_SUCCESS object:nil];
}

-(void)scoreSuccess
{
    _currentPage = 0;
    [self sendRequestWithCurrentPage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self cacheQuestionType];
    
}
-(void)cacheQuestionType
{
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES ];
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_QUESTION_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.procirclestatus.ProcirclePosition",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_TYPE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES ];
                                 [[ZEQuestionTypeCache instance]setQuestionTypeCaches:[ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_TYPE]];
                                 [askTypeView reloadTypeData];
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES ];
                             }];
}

-(void)sendRequestWithOrder
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
                                     @"DETAILTABLE":@"",
                                     @"orderstr":orderStr,
                                     };
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"searchOrder"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [caseView reloadFirstView:dataArr];
                                     }else{
                                         [caseView reloadMoreDataView:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [caseView loadNoMoreData];
                                         return ;
                                     }
                                     [caseView reloadFirstView:dataArr];
                                     [caseView headerEndRefreshing];
                                     [caseView loadNoMoreData];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(void)sendRequestWithCurrentPage
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":_currentWHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
                                     @"DETAILTABLE":@"",};
    
    if (totalTypeCode.length > 0) {
        parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                          @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                          @"MENUAPP":@"EMARK_APP",
                          @"ORDERSQL":@"SYSCREATEDATE desc",
                          @"WHERESQL":_currentWHERESQL,
                          @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                          @"METHOD":METHOD_SEARCH,
                          @"MASTERFIELD":@"SEQKEY",
                          @"DETAILFIELD":@"",
                          @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
                          @"DETAILTABLE":@"",
                          @"PARENTID":@"-1",
                          @"TYPECODE":totalTypeCode};
    }
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    if (totalTypeCode.length > 0) {
        parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                          @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                          @"MENUAPP":@"EMARK_APP",
                          @"ORDERSQL":@"SYSCREATEDATE desc",
                          @"WHERESQL":_currentWHERESQL,
                          @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                          @"METHOD":METHOD_SEARCH,
                          @"MASTERFIELD":@"SEQKEY",
                          @"DETAILFIELD":@"",
                          @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
                          @"DETAILTABLE":@"",
                          @"PARENTID":@"-1",
                          @"TYPECODE":totalTypeCode};
        packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
                                                                withFields:@[fieldsDic]
                                                            withPARAMETERS:parametersDic
                                                            withActionFlag:@"SEARCH_PARENT_TYPE"];
    }

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [caseView reloadFirstView:dataArr];
                                     }else{
                                         [caseView reloadMoreDataView:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [caseView loadNoMoreData];
                                         return ;
                                     }
                                     [caseView reloadFirstView:dataArr];
                                     [caseView headerEndRefreshing];
                                     [caseView loadNoMoreData];
                                 } 
                                 
                             } fail:^(NSError *errorCode) {

                             }];
}
-(void)myCollectRequest
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_COLLECT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE DESC",
                                     @"WHERESQL":[NSString stringWithFormat:@"COLLECTUSERCODE = %@",[ZESettingLocalData getUSERCODE]],
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.CollectCase",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_COLLECT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_COLLECT];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [caseView reloadFirstView:dataArr];
                                     }else{
                                         [caseView reloadMoreDataView:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [caseView loadNoMoreData];
                                         return ;
                                     }
                                     [caseView reloadFirstView:dataArr];
                                     [caseView headerEndRefreshing];
                                     [caseView loadNoMoreData];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                             }];
}


-(void)initView{
    caseView = [[ZETypicalCaseView alloc]initWithFrame:self.view.frame withEnterType:_enterType];
    caseView.delegate = self;
    [self.view addSubview:caseView];
    [self.view sendSubviewToBack:caseView];
}

#pragma mark - 根据分类 选择经典案例类型
-(void)initAskTypeView
{
    if(_isShowTypicalTypeView){
        self.title = @"典型案例";
        [askTypeView removeFromSuperview];
        askTypeView = nil;
        [self sendRequestWithCurrentPage];
    }else{
        self.title = @"技能分类";
        [caseView.questionSearchTF resignFirstResponder];
        askTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withMarginTop:NAV_HEIGHT + 45];
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
    
    questionTypeCode = typeCode;
    questionTypeName = typeName;
    self.title = typeName;

    _currentPage = 0;

    [askTypeView removeFromSuperview];
    askTypeView = nil;
    if (typeName.length == 0 && typeCode.length == 0 && fatherCode.length == 0) {
        self.title = @"典型案例";
        [caseView.questionSearchTF becomeFirstResponder];
        return;
    }

    if ([fatherCode integerValue] == -1) {
        totalTypeCode = typeCode;
        [self sendRequestWithCurrentPage];
        return;
    }
    
    totalTypeCode = @"";
    if (_currentWHERESQL.length > 0 && ![_currentWHERESQL containsString:@"QUESTIONTYPECODE"]) {
        _currentWHERESQL = [NSString stringWithFormat:@"QUESTIONTYPECODE = '%@' and (%@)",questionTypeCode,_currentWHERESQL];
    }else{
        _currentWHERESQL = [NSString stringWithFormat:@"QUESTIONTYPECODE = '%@'",questionTypeCode];
    }
    
    [self sendRequestWithCurrentPage];
}

#pragma mark - ZETypicalCaseViewDelegate

-(void)loadNewData
{
    if (_enterType == ENTER_CASE_TYPE_SETTING) {
        _currentPage = 0;
        [self myCollectRequest];
    }else{
        _currentPage = 0;
        [self sendRequestWithCurrentPage];
    }
}
-(void)loadMoreData
{
    if (_enterType == ENTER_CASE_TYPE_SETTING){
        [self myCollectRequest];
    }else{
        [self sendRequestWithCurrentPage];
    }
}

-(void)goTypicalCaseDetailVC:(id)obj
{
    ZETypicalCaseDetailVC * detailVC = [[ZETypicalCaseDetailVC alloc]init];
    detailVC.classicalCaseDetailDic = obj;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)screenFileType:(NSString *)fileType
{    
    if ([fileType isEqualToString:@"视频"]) {
        _currentWHERESQL = [NSString stringWithFormat:@"COURSEFILETYPE like '%%.mp4%%'"];
    }else if ([fileType isEqualToString:@"图片"]){
        _currentWHERESQL = [NSString stringWithFormat:@"COURSEFILETYPE like '%%.jpg%%' or COURSEFILETYPE like '%%.png%%' "];
    }else if([fileType isEqualToString:@"文档"]){
        _currentWHERESQL = [NSString stringWithFormat:@"COURSEFILETYPE like '%%.doc%%' or COURSEFILETYPE like '%%.xls%%' or COURSEFILETYPE like '%%.ppt%%' or COURSEFILETYPE like '%%.pdf%%'"];
    }else if([fileType isEqualToString:@"其他"] || [fileType isEqualToString:@"全部"]){
        _currentWHERESQL = @"";
    }
    
    if (_currentWHERESQL.length > 0 & questionTypeCode.length > 0) {
        _currentWHERESQL = [NSString stringWithFormat:@"QUESTIONTYPECODE = '%@' and (%@)",questionTypeCode,_currentWHERESQL];
    }else if (questionTypeCode.length > 0){
        _currentWHERESQL = [NSString stringWithFormat:@"QUESTIONTYPECODE = '%@'",questionTypeCode];
    }
    
    _currentPage = 0;
    [self sendRequestWithCurrentPage];
}

-(void)sortConditon:(NSString *)condition
{
    orderStr= condition;
    _currentPage = 0;
    [self sendRequestWithOrder];
}

-(void)showType
{
    [self initAskTypeView];
}

-(void)goSearchWithSearchStr:(NSString *)str
{
    _currentPage = 0;
    _currentWHERESQL = [NSString stringWithFormat:@"CASENAME like '%%%@%%'",str];
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
