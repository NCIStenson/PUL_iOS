//
//  ZESearchWorkStandardVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/4/25.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESearchWorkStandardVC.h"
#import "ZESearchWorkStandardView.h"
#import "ZESchoolWebVC.h"

@interface ZESearchWorkStandardVC ()<ZESearchWorkStandardViewDelegate>
{
    NSInteger _currentPage;
    NSString * _currentInputStr;
    ZESearchWorkStandardView * _workStandardView;
}
@end

@implementation ZESearchWorkStandardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"行业规范";
    _currentInputStr = @"";
    [self initView];
    [self createWhereSQL:@""];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGE_ASK_SUCCESS object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)createWhereSQL:(NSString *)searchStr
{
    NSString * searchCondition = @"";
    searchCondition = [NSString stringWithFormat:@"STANDARDEXPLAIN like '%%%@%%' ",searchStr];
    [self sendRequestWithCondition:searchCondition];
}


-(void)sendRequestWithCondition:(NSString *)conditionStr
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_STANDARD_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE DESC",
                                     @"WHERESQL":conditionStr,
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
                                         [_workStandardView reloadFirstView:dataArr];
                                     }else{
                                         [_workStandardView reloadContentViewWithArr:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [_workStandardView loadNoMoreData];
                                         return ;
                                     }
                                     [_workStandardView reloadFirstView:dataArr];
                                     [_workStandardView headerEndRefreshing];
                                     [_workStandardView loadNoMoreData];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                                 [_workStandardView headerEndRefreshing];
                             }];
}

#pragma mark -

-(void)initView
{
    _workStandardView = [[ZESearchWorkStandardView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) ];
    _workStandardView.delegate = self;
    [self.view addSubview:_workStandardView];
    [self.view sendSubviewToBack:_workStandardView];
}

#pragma mark - ZEShowQuestionViewDelegate

-(void)goWorkStandardDetail:(NSDictionary *)dic
{
    NSString * fileURL = [ dic objectForKey:@"FILEURL" ];
    NSString * seqkey = [ dic objectForKey:@"SEQKEY" ];
    
    ZESchoolWebVC * webVC = [[ZESchoolWebVC alloc]init];
    webVC.enterType = ENTER_WEBVC_WORK_STANDARD;
    webVC.webURL = ZENITH_IMAGE_FILESTR([fileURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]);
    webVC.workStandardSeqkey = seqkey;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)goSearch:(NSString *)str
{
    _currentPage = 0;
    [_workStandardView reloadFirstView:nil];
    _workStandardView.searchStr = str;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
}
@end
