//
//  ZEDistrictManagerHomeVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEDistrictManagerHomeVC.h"
#import "ZEMyCollectCourseVC.h"
#import "ZEManagerPracticeBankVC.h"
#import "ZENewQuestionListVC.h"
#import "ZEQuestionBankWebVC.h"
#import "ZECourseSearchVC.h"
@interface ZEDistrictManagerHomeVC ()
{
    NSMutableArray * _currentPageArr;
    
    NSInteger _currentRecommondPage;
    
}
@end

@implementation ZEDistrictManagerHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentPageArr = [NSMutableArray array];
    self.title = @"学习课件";
    [self initView];
    [self sendRequestWithOrderIndex:ORDER_BY_DATE];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)initView{
    managerHomeView = [[ZEDistrictManagerHomeView alloc]initWithFrame:self.view.frame];
    managerHomeView.delegate = self;
    [self.view addSubview:managerHomeView];
    [self.view sendSubviewToBack:managerHomeView];
}

#pragma mark - sendRequest
-(void)sendRequestWithOrderIndex:(ORDER_BY_TYPE)index{
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_ABILITY_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"20",
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"orderstr":[NSString stringWithFormat:@"%ld",(long)index],
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_ABILITY_TYPE]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"courseList"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr =[ZEUtil getServerData:data withTabelName:V_KLB_ABILITY_TYPE];
                                 if (arr.count > 0) {
                                     for (int i = 0; i < arr.count;i ++) {
                                         [_currentPageArr addObject:@"1"];
                                     }
                                     [managerHomeView reloadDataWithArr:arr];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)getRecommondListRequest:(NSUInteger)index{
    NSInteger MAX_PAGE_COUN = MAX_PAGE_COUNT;
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_COURSEWARE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":[NSString stringWithFormat:@"%ld",(long) (_currentRecommondPage * MAX_PAGE_COUN)],
                                     @"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUN],
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"orderstr":[NSString stringWithFormat:@"%ld",(long)index],
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_INFO]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"courseRecommend"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr =[ZEUtil getServerData:data withTabelName:V_KLB_COURSEWARE_INFO];
                                 if (arr.count > 0) {
                                     _currentRecommondPage += 1;
                                     [managerHomeView reloadRecommandDataWithArr:arr];
                                 }else{
                                     [managerHomeView endFooterRefreshingWithNoMoreData];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)loadMoreDataSendRequestWithCurrentPage:(NSInteger)pageNum
                             withSectionIndex:(NSInteger)index
                              withCurrentCode:(NSString *)codeStr
{
    [self progressBegin:@"数据加载中..."];
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_COURSEWARE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":[NSString stringWithFormat:@"%ld",pageNum * MAX_PAGE_COUNT],
                                     @"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"abilitytype":codeStr,
                                     };
    
//    NSDictionary * fieldsDic = @{  @"ABILITYTYPE":codeStr, };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_INFO]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"courseAbilitytype"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self progressEnd:@""];
                                 NSArray * arr =[ZEUtil getServerData:data withTabelName:V_KLB_COURSEWARE_INFO];
                                 NSInteger newPageNum = pageNum + 1;
                                 [_currentPageArr replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",newPageNum]];
                                 if (arr.count > 0) {
                                     [managerHomeView reloadSectionWithIndex:index withArr:arr];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [self progressEnd:@""];
                             }];
}

-(void)sendRequestWithOrder:(ORDER_BY_TYPE)index
{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < _currentPageArr.count;i ++) {
        [arr addObject:@"1"];
    }
    _currentPageArr = [NSMutableArray arrayWithArray:arr];
    _currentRecommondPage = 0;

    [self sendRequestWithOrderIndex:index];
    [self getRecommondListRequest:index];
}

-(void)goRecommondViewRequest
{
    [self getRecommondListRequest:ORDER_BY_DATE];
}

-(void)goManagerDetail:(id)obj
{
    ZEManagerDetailVC * detailVC = [[ZEManagerDetailVC alloc]init];
    detailVC.detailManagerModel = [ZEDistrictManagerModel getDetailWithDic:obj];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goMyCollectCourse
{
    ZEMyCollectCourseVC * collectCourseVC = [[ZEMyCollectCourseVC alloc]init];
    [self.navigationController pushViewController:collectCourseVC animated:YES];
}

-(void)goManagerPractice
{
    ZEManagerPracticeBankVC * bankVC = [[ZEManagerPracticeBankVC alloc]init];
    
    [self.navigationController pushViewController:bankVC animated:YES];
}

-(void)loadMoreDataWithSection:(NSInteger)index withTypeDic:(NSDictionary *)dic
{    
    NSInteger _currentPage = [_currentPageArr[index] integerValue];
    NSString * codeStr = [dic objectForKey:@"ABILITYTYPE"];
    
    [self loadMoreDataSendRequestWithCurrentPage:_currentPage
                                withSectionIndex:index
                                 withCurrentCode:codeStr];
}

-(void)reloadRequest{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < _currentPageArr.count;i ++) {
        [arr addObject:@"1"];
    }
    _currentPageArr = [NSMutableArray arrayWithArray:arr];
    
    [self sendRequestWithOrderIndex:ORDER_BY_DATE];

    _currentRecommondPage = 0;
    [self getRecommondListRequest:ORDER_BY_DATE];

}

-(void)loadMoreRecommondRequest:(NSInteger)index
{
    [self getRecommondListRequest:index];
}

-(void)goNewQuestionListVC
{
    ZENewQuestionListVC * questionListVC = [[ZENewQuestionListVC alloc]init];
    questionListVC.enterType = ENTER_NEWQUESLIST_TYPE_COURSEHOME;
    [self.navigationController pushViewController:questionListVC animated:YES];
}

-(void)goCourseSearchView
{
    ZECourseSearchVC * searchVC = [[ZECourseSearchVC alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)goChapterPractice:(NSDictionary *)dic
{
    [self getUrl:[ZEDistrictManagerModel getDetailWithDic:dic]];
}

-(void)getUrl:(ZEDistrictManagerModel*)managerModel
{
    NSString * actionFlag = @"";
    actionFlag = @"typechapterPractice";

    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_FUNCTION_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":actionFlag,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":QUESTION_BANK,
                                     @"DETAILTABLE":@"",
                                     @"abilitytype":managerModel.ABILITYTYPE};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"questionBank"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];
                                 NSString * targetURL = [dic objectForKey:@"target"];
                                 if (targetURL.length > 0 &&  [ZEUtil isNotNull:targetURL]  ) {
                                     if ([targetURL containsString:@"http"]) {
                                         ZEQuestionBankWebVC * bankVC =[ZEQuestionBankWebVC new];
                                         bankVC.needLoadRequestUrl = targetURL;
                                         [self.navigationController pushViewController:bankVC animated:YES];
                                     }else{
                                         [self showTips:targetURL];
                                     }
                              }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
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
