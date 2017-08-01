//
//  ZEWorkStandardListVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/4/24.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEWorkStandardListVC.h"
#import "ZEWorkStandardListView.h"
#import "ZEAskQuestionTypeView.h"
#import "ZESchoolWebVC.h"
#import "ZESearchWorkStandardVC.h"
@interface ZEWorkStandardListVC ()<ZEWorkStandardListViewDelegate,ZEAskQuestionTypeViewDelegate>
{
    ZEWorkStandardListView * workStandardListView;
    ZEAskQuestionTypeView * askTypeView;
    
    NSInteger _currentPage;
    
    NSString * _currentWHERESQL;
    NSString * sortOrderSQL;// 最热 最新排序
    
    NSString * questionTypeCode; //  选择的经典案例分类code
    NSString * questionTypeName; //  选择的经典案例分类Name
    
    BOOL _isShowTypicalTypeView;
}


@end

@implementation ZEWorkStandardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sortOrderSQL = @"SYSCREATEDATE desc";
    _currentPage = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentWHERESQL = @"";

    [self.rightBtn setImage:[UIImage imageNamed:@"icon_search" color:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    self.title = @"行业规范";
    
    [self initView];
    _isShowTypicalTypeView = NO;
    [self sendRequestWithCurrentPage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self cacheQuestionType];
}

-(void)rightBtnClick{
    ZESearchWorkStandardVC * searchVC = [[ZESearchWorkStandardVC alloc]init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
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
                                     @"METHOD":METHOD_SEARCH,
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
                                 [MBProgressHUD hideHUDForView:self.view animated:YES ];
                                 [[ZEQuestionTypeCache instance]setQuestionTypeCaches:[ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_TYPE]];
                                 [askTypeView reloadTypeData];
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES ];
                             }];
}

-(void)sendRequestWithCurrentPage
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_STANDARD_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":sortOrderSQL,
                                     @"WHERESQL":_currentWHERESQL,
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.standard.StandardInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_STANDARD_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"PROCIRCLE_STANDARD_INFO"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_STANDARD_INFO];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [workStandardListView reloadFirstView:dataArr];
                                     }else{
                                         [workStandardListView reloadMoreDataView:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [workStandardListView loadNoMoreData];
                                         return ;
                                     }
                                     [workStandardListView reloadFirstView:dataArr];
                                     [workStandardListView headerEndRefreshing];
                                     [workStandardListView loadNoMoreData];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)initView{
    workStandardListView = [[ZEWorkStandardListView alloc]initWithFrame:self.view.frame];
    workStandardListView.delegate = self;
    [self.view addSubview:workStandardListView];
    [self.view sendSubviewToBack:workStandardListView];
}

#pragma mark - 根据分类 选择经典案例类型
-(void)initAskTypeView
{
    if(_isShowTypicalTypeView){
        self.title = @"行业规范";
        [askTypeView removeFromSuperview];
        askTypeView = nil;
        [self sendRequestWithCurrentPage];
    }else{
        self.title = @"技能分类";
        
        askTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
    self.title = @"行业规范";

    _currentPage = 0;
    
    [askTypeView removeFromSuperview];
    askTypeView = nil;
    if ([fatherCode integerValue] > 0) {
        _currentWHERESQL = [NSString stringWithFormat:@"QUESTIONTYPECODE like '%%%@%%'",questionTypeCode];
    }else{
        _currentWHERESQL = [NSString stringWithFormat:@"PROCIRCLECODE like '%%%@%%' ",questionTypeCode];
    }    
    [self sendRequestWithCurrentPage];
    
    [workStandardListView reloadNavView:questionTypeName];
}

#pragma mark - ZETypicalworkStandardListViewDelegate

-(void)loadNewData
{
    _currentPage = 0;
    [self sendRequestWithCurrentPage];
}
-(void)loadMoreData
{
    [self sendRequestWithCurrentPage];
}

-(void)goWorkStandardDetail:(id)obj
{
    NSString * fileURL = [ obj objectForKey:@"FILEURL" ];
    NSString * seqkey = [ obj objectForKey:@"SEQKEY" ];
    
    ZESchoolWebVC * webVC = [[ZESchoolWebVC alloc]init];
    webVC.enterType = ENTER_WEBVC_WORK_STANDARD;
    webVC.webURL = ZENITH_IMAGE_FILESTR([fileURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]);
    webVC.workStandardSeqkey = seqkey;
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)showType
{
    [self initAskTypeView];
}
-(void)sortConditon:(NSString *)condition
{
    sortOrderSQL = condition;
    _currentPage = 0;
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
