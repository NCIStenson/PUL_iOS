//
//  ZETypicalCaseDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/11/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETypicalCaseDetailVC.h"
#import "ZETypicalCaseDetailView.h"

#import "JRPlayerViewController.h"

#import "ZEScoreView.h"
#import "JCAlertView.h"

#import "ZETypicalCaseWebVC.h"

@interface ZETypicalCaseDetailVC ()<ZEScoreViewDelegate,ZETypicalCaseViewDelegate>
{
    JCAlertView * _alertView;
    ZETypicalCaseDetailView * detailView;
    
    NSInteger _currentPage;
}
@end

@implementation ZETypicalCaseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavView];
    [self initView];
    _currentPage = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self sendRequest];
    [self isScored];
    [self isCollected];
}

-(void)reloadViewData
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"SEQKEY = '%@'",[self.classicalCaseDetailDic objectForKey:@"SEQKEY"]],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClassicCase",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if([[ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO] count] > 0){
                                     self.classicalCaseDetailDic = [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_INFO][0];
                                     [detailView reloadSectionView:self.classicalCaseDetailDic];
                                 }
                             } fail:^(NSError *error) {
                                 
                             }];
}

-(void)sendRequest
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_CLASSICCASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.ClickCount",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":[self.classicalCaseDetailDic objectForKey:@"SEQKEY"]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_CLASSICCASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)isScored
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_CLASSICCASE_SCORE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@' and CASECODE = '%@'",[ZESettingLocalData getUSERCODE],[self.classicalCaseDetailDic objectForKey:@"SEQKEY"]],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_CLASSICCASE_SCORE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if ([[ZEUtil getServerData:data withTabelName:KLB_CLASSICCASE_SCORE ] count] > 0) {
                                     [[self.leftBtn.superview viewWithTag:100] removeFromSuperview];
                                 }
                                 
                             } fail:^(NSError *errorCode) {
                             }];

}
-(void)isCollected
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_CLASSICCASE_COLLECT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@' and CASECODE = '%@'",[ZESettingLocalData getUSERCODE],[self.classicalCaseDetailDic objectForKey:@"SEQKEY"]],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_CLASSICCASE_COLLECT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 if ([[ZEUtil getServerData:data withTabelName:KLB_CLASSICCASE_COLLECT ] count] > 0) {
                                     UIButton * collectBtn = [self.leftBtn.superview viewWithTag:101];
                                     [collectBtn setImage:[UIImage imageNamed:@"detail_nav_star_pressed"] forState:UIControlStateNormal];
                                     [collectBtn removeTarget:self action:@selector(didCollect) forControlEvents:UIControlEventTouchUpInside];
                                     [collectBtn addTarget:self action:@selector(cancelCollect) forControlEvents:UIControlEventTouchUpInside];
                                 }
                             } fail:^(NSError *errorCode) {
                             }];
    
}


-(void)initNavView
{
    for (int i = 0; i < 1; i++ ) {
        UIButton *  typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [typeBtn setImage:[UIImage imageNamed:@"detail_nav_flower" color:[UIColor whiteColor]] forState:UIControlStateNormal];
        if(i == 1){
            [typeBtn setImage:[UIImage imageNamed:@"detail_nav_star" color:[UIColor whiteColor]] forState:UIControlStateNormal];
            [typeBtn addTarget:self action:@selector(didCollect) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [typeBtn addTarget:self action:@selector(showScoreView) forControlEvents:UIControlEventTouchUpInside];
        }
        [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeBtn setFrame:CGRectMake(SCREEN_WIDTH - 40 + 35 * i, 25, 30, 30)];
        typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        typeBtn.tag = i + 100;
        [self.leftBtn.superview addSubview:typeBtn];
    }
}

#pragma mark - 星星评分

-(void)showScoreView
{
    ZEScoreView * showTypeView = [[ZEScoreView alloc]initWithFrame:CGRectZero];
    showTypeView.delegate = self;
    _alertView = [[JCAlertView alloc]initWithCustomView:showTypeView dismissWhenTouchedBackground:YES];
    [_alertView show];
}

-(void)dismissTheScoreView
{
    [_alertView dismissWithCompletion:nil];
}

-(void)didSelectScore:(NSString *)score
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_CLASSICCASE_SCORE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.CaseScore",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"CASECODE":[self.classicalCaseDetailDic objectForKey:@"SEQKEY"],
                                @"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"CASESCORE":score};

    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_CLASSICCASE_SCORE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"评分成功"];
                                 [self dismissTheScoreView];

                                 [[self.leftBtn.superview viewWithTag:100] removeFromSuperview];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_SCORE_SUCCESS object:nil];
                                 [self reloadViewData];
                                 
                             } fail:^(NSError *errorCode) {
                                 [_alertView dismissWithCompletion:nil];
                             }];
}

-(void)didCollect
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_CLASSICCASE_COLLECT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"CASECODE":[self.classicalCaseDetailDic objectForKey:@"SEQKEY"],
                                @"USERCODE":[ZESettingLocalData getUSERCODE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_CLASSICCASE_COLLECT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"收藏成功"];
                                 
                                 UIButton * collectBtn = [self.leftBtn.superview viewWithTag:101];
                                 [collectBtn setImage:[UIImage imageNamed:@"detail_nav_star_pressed"] forState:UIControlStateNormal];
                                 [collectBtn removeTarget:self action:@selector(didCollect) forControlEvents:UIControlEventTouchUpInside];
                                 [collectBtn addTarget:self action:@selector(cancelCollect) forControlEvents:UIControlEventTouchUpInside];

                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)cancelCollect
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_CLASSICCASE_COLLECT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_DELETE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"CASECODE":[self.classicalCaseDetailDic objectForKey:@"SEQKEY"],
                                @"USERCODE":[ZESettingLocalData getUSERCODE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_CLASSICCASE_COLLECT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"取消收藏"];
                                 
                                 UIButton * collectBtn = [self.leftBtn.superview viewWithTag:101];
                                 [collectBtn setImage:[UIImage imageNamed:@"detail_nav_star"] forState:UIControlStateNormal];
                                 [collectBtn removeTarget:self action:@selector(cancelCollect) forControlEvents:UIControlEventTouchUpInside];
                                 [collectBtn addTarget:self action:@selector(didCollect) forControlEvents:UIControlEventTouchUpInside];

                             } fail:^(NSError *errorCode) {
                             }];
}


-(void)initView
{
    detailView = [[ZETypicalCaseDetailView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withData:self.classicalCaseDetailDic];
    detailView.delegate = self;
    [self.view addSubview:detailView];
    [self.view sendSubviewToBack:detailView];
}

#pragma mark - ZETypicalCaseDetailViewDelegate

-(void)showCourseView
{
    
}

-(void)showCommentView
{
    [self sendRequestWithCurrentPage];
}

-(void)loadMoreData
{
    [self sendRequestWithCurrentPage];
}

-(void)sendRequestWithCurrentPage
{
    NSDictionary * parametersDic = @{@"limit":[NSString stringWithFormat:@"%ld",(long)MAX_PAGE_COUNT],
                                     @"MASTERTABLE":V_KLB_CLASSICCASE_COMMENT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE DESC",
                                     @"WHERESQL":[NSString stringWithFormat:@"CASECODE = '%@'",[self.classicalCaseDetailDic objectForKey:@"SEQKEY"]],
                                     @"start":[NSString stringWithFormat:@"%ld",(long) _currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.classiccase.CaseComment",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_CLASSICCASE_COMMENT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_CLASSICCASE_COMMENT];
                                 if (dataArr.count > 0) {
                                     if (_currentPage == 0) {
                                         [detailView reloadFirstView:dataArr];
                                     }else{
                                         [detailView reloadMoreDataView:dataArr];
                                     }
                                     if (dataArr.count % MAX_PAGE_COUNT == 0) {
                                         _currentPage += 1;
                                     }
                                 }else{
                                     if (_currentPage > 0) {
                                         [detailView loadNoMoreData];
                                         return ;
                                     }
                                     [detailView reloadFirstView:dataArr];
                                     [detailView headerEndRefreshing];
                                     [detailView loadNoMoreData];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [_alertView dismissWithCompletion:nil];
                             }];
}

-(void)publishComment:(NSString *)commentStr
{
    if ([commentStr length] < 1) {
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_CLASSICCASE_COMMENT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
NSDictionary * fieldsDic =@{@"CASECODE":[self.classicalCaseDetailDic objectForKey:@"SEQKEY"],
                            @"USERCODE":[ZESettingLocalData getUSERCODE],
                            @"COMMENTEXPLAIN":commentStr};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_CLASSICCASE_COMMENT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"发表成功"];
                                 [detailView publishCommentSuccess];

                                 _currentPage = 0;
                                 [self sendRequestWithCurrentPage];
                             } fail:^(NSError *errorCode) {
                                 [_alertView dismissWithCompletion:nil];
                             }];
}

-(void)playCourswareImagePath:(NSString *)filepath
{
    NSMutableArray * photosArr = [NSMutableArray arrayWithObject:[ZEUtil changeURLStrFormat:filepath]];

    PYPhotoBrowseView *browser = [[PYPhotoBrowseView alloc] init];
    browser.imagesURL = photosArr; // 图片总数
    browser.currentIndex = 0;
    [browser show];
}

-(void)playCourswareVideo:(NSString *)filepath
{
    NSURL * urlStr = [NSURL URLWithString:filepath];
    JRPlayerViewController * playView = [[JRPlayerViewController alloc]initWithHTTPLiveStreamingMediaURL:urlStr];
    [self presentViewController:playView animated:YES completion:^{
        [playView play:nil];
    }];
    
}

-(void)playLocalVideoWithPath:(NSString *)videoPath
{
    NSString * escapedUrlString = [videoPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * urlStr  = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",escapedUrlString]];
    JRPlayerViewController * playView = [[JRPlayerViewController alloc]initWithLocalMediaURL:urlStr];
    [self presentViewController:playView animated:YES completion:^{
        [playView play:nil];
    }];
}
-(void)loadFile:(NSString *)filePath
{
    ZETypicalCaseWebVC * webVC = [[ZETypicalCaseWebVC alloc]init];
    webVC.filePath = filePath;
    [self.navigationController pushViewController:webVC animated:YES];
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
