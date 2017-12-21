//
//  ZECourseSearchVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/21.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZECourseSearchVC.h"
#import "ZECourseSearchView.h"
#import "ZEWithoutDataTipsView.h"
#import "ZEManagerDetailVC.h"
@interface ZECourseSearchVC ()<ZECourseSearchViewDelegate>
{
    NSInteger _currentPage;
    
    NSString * _currentInputStr;
    ZECourseSearchView * _searchView;
    
    ZEWithoutDataTipsView * tipsView;

}
@end

@implementation ZECourseSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.'
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBar.hidden =YES;
    [self initView];
    _currentInputStr = @"";
    [self getCourseListRequest:@""];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)initView
{
    _searchView = [[ZECourseSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    _searchView.delegate = self;
    [self.view addSubview:_searchView];

    [self.view sendSubviewToBack:_searchView];
}


-(void)goSearch:(NSString *)str
{
    _currentPage = 0;
    [_searchView reloadFirstView:nil];
    
    _currentInputStr = str;
    [self getCourseListRequest:_currentInputStr];
}

-(void)loadNewData
{
    _currentPage = 0;
    [self getCourseListRequest:_currentInputStr];
}

-(void)loadMoreData
{
    [self getCourseListRequest:_currentInputStr];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getCourseListRequest:(NSString *)searchStr
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%d",MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_COURSEWARE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":@"",
                                     @"start":[NSString stringWithFormat:@"%ld",(long)_currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"DETAILTABLE":@"",
                                     @"courseware":searchStr,
                                     };
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"courseSearch"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_COURSEWARE_INFO];
                                 if (dataArr.count > 0) {
                                     [tipsView removeFromSuperview];
                                     tipsView = nil;
                                     if (_currentPage == 0) {
                                         [_searchView reloadFirstView:dataArr];
                                     }else{
                                         [_searchView reloadContentViewWithArr:dataArr];
                                     }
                                     if (dataArr.count%MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [_searchView loadNoMoreData];
                                         return ;
                                     }else{
                                         if (!tipsView) {
                                             tipsView = [[ZEWithoutDataTipsView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
                                             tipsView.type = SHOW_TIPS_TYPE_MYQUESTION;
                                             tipsView.imageType = SHOW_TIPS_IMAGETYPE_CRY;
                                             [self.view addSubview:tipsView];
                                         }
                                     }
                                     [_searchView reloadFirstView:dataArr];
                                     [_searchView headerEndRefreshing];
                                     [_searchView loadNoMoreData];
                                 }
                             }
                                fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)goCourseDetail:(NSDictionary *)dic
{
    ZEManagerDetailVC * detailVC = [[ZEManagerDetailVC alloc]init];
    detailVC.detailManagerModel = [ZEDistrictManagerModel getDetailWithDic:dic];
    [self.navigationController pushViewController:detailVC animated:YES];
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
