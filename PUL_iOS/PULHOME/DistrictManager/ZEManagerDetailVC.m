//
//  ZEManagerDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEManagerDetailVC.h"
#import "ZEManagerWebVC.h"
#import "JRPlayerViewController.h"
#import "ZEMyCollectCourseVC.h"
#import "ZEManagerPracticeBankVC.h"
#import "ZETypicalCaseWebVC.h"
#import "ZEQuestionBankWebVC.h"
#import "ZENewQuestionListVC.h"
@interface ZEManagerDetailVC ()
{
    ZEManagerDetailView *detailView;
    NSInteger _currentPage;
}
@end

@implementation ZEManagerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = _detailManagerModel.COURSENAME;
    if([_detailManagerModel.ISCOLLECT boolValue]){
        [self.rightBtn setImage:[UIImage imageNamed:@"detail_nav_star_pressed" color:RGBA(226, 136, 53, 1)] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(cancelCollect) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.rightBtn setImage:[UIImage imageNamed:@"detail_nav_star" color:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(didCollect) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self addCLickCount];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getAboutCourseList];
}

-(void)addCLickCount
{
    if (_detailManagerModel.SEQKEY.length == 0) {
        return;
    }
    
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_ABILITY_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"-1",
                                     @"METHOD":METHOD_UPDATE,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"courseid":_detailManagerModel.SEQKEY,
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_ABILITY_TYPE]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"clickcount"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}

-(void)getAboutCourseList
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_COURSEWARE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"-1",
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"abilitycode":_detailManagerModel.ABILITYCODE,
                                     @"courseid":_detailManagerModel.SEQKEY,
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_INFO]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"courseAbility"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr =[ZEUtil getServerData:data withTabelName:V_KLB_COURSEWARE_INFO];
                                 if(arr.count >0){
                                     [detailView reloadAboutCourseData:arr];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];

}

-(void)initUI{
    detailView = [[ZEManagerDetailView alloc]initWithFrame:self.view.frame withData:_detailManagerModel];
    detailView.delegate = self;
    [self.view addSubview:detailView];
    [self.view sendSubviewToBack:detailView];
}

-(void)didCollect
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_COURSEWARE_COLLECT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"COURSEID":_detailManagerModel.SEQKEY,
                                @"USERCODE":[ZESettingLocalData getUSERCODE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_COURSEWARE_COLLECT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"收藏成功"];
                                 
                                 UIButton * collectBtn = self.rightBtn;
                                 [self.rightBtn setImage:[UIImage imageNamed:@"detail_nav_star_pressed" color:RGBA(226, 136, 53, 1)] forState:UIControlStateNormal];
                                 [collectBtn removeTarget:self action:@selector(didCollect) forControlEvents:UIControlEventTouchUpInside];
                                 [collectBtn addTarget:self action:@selector(cancelCollect) forControlEvents:UIControlEventTouchUpInside];
                                 
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)cancelCollect
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_COURSEWARE_COLLECT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_DELETE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"COURSEID":_detailManagerModel.SEQKEY,
                                @"USERCODE":[ZESettingLocalData getUSERCODE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_COURSEWARE_COLLECT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"取消收藏"];
                                 
                                 [self.rightBtn setImage:[UIImage imageNamed:@"detail_nav_star"] forState:UIControlStateNormal];
                                 [self.rightBtn removeTarget:self action:@selector(cancelCollect) forControlEvents:UIControlEventTouchUpInside];
                                 [self.rightBtn addTarget:self action:@selector(didCollect) forControlEvents:UIControlEventTouchUpInside];
                                 
                             } fail:^(NSError *errorCode) {
                             }];
}


#pragma mark - ZEManagerDetailViewDelegate

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
                                     @"MASTERTABLE":V_KLB_COURSEWARE_CONTENT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE DESC",
                                     @"WHERESQL":[NSString stringWithFormat:@"COURSEID = '%@'",_detailManagerModel.SEQKEY],
                                     @"start":[NSString stringWithFormat:@"%ld",(long) _currentPage * MAX_PAGE_COUNT],
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_CONTENT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"coursecontent"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr =  [ZEUtil getServerData:data withTabelName:V_KLB_COURSEWARE_CONTENT];
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

                             }];
}

-(void)publishComment:(NSString *)commentStr
{
    if ([commentStr length] < 1) {
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_COURSEWARE_CONTENT,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"COURSEID":_detailManagerModel.SEQKEY,
                                @"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"CONTENTEXPLAIN":commentStr};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_COURSEWARE_CONTENT]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"contentcount"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getEXCEPTIONDATA:data];
                                 if(arr.count > 0){
                                     NSDictionary * failReason = arr[0];
                                     [self showTips:[NSString stringWithFormat:@"%@\n",[failReason objectForKey:@"reason"]] afterDelay:1.5];
                                 }else{
                                     [self showTips:@"发表成功"];
                                     [detailView publishCommentSuccess];
                                     _currentPage = 0;
                                     [self sendRequestWithCurrentPage];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(void)goCourseDetail
{
    if ([_detailManagerModel.FILETYPE isEqualToString:@".mp4"]) {
        [self playCourswareVideo:[ZENITH_IMAGEURL(_detailManagerModel.FORMATFILEURL) absoluteString]];
    }else if([_detailManagerModel.FILETYPE isEqualToString:@".jpg"] | [_detailManagerModel.FILETYPE isEqualToString:@".png"]){
        [self playCourswareImagePath:[ZENITH_IMAGEURL(_detailManagerModel.FORMATFILEURL) absoluteString] ];
    }else if (_detailManagerModel.H5URL.length > 0){
        if ([_detailManagerModel.H5URL containsString:@"http://"] ) {
            if ( [_detailManagerModel.H5URL hasSuffix:@".mp4"]) {
                [self playCourswareVideo:_detailManagerModel.H5URL];
            }else{
                [self loadFile:_detailManagerModel.H5URL];
            }
        }else{
            if ( [_detailManagerModel.H5URL hasSuffix:@".mp4"]) {
                [self playCourswareVideo:[NSString stringWithFormat:@"http://%@",_detailManagerModel.H5URL]];
            }else{
                [self loadFile:[NSString stringWithFormat:@"http://%@",_detailManagerModel.H5URL]];
            }
        }
    }else{
        NSLog(@" ===   %@",[ZENITH_IMAGEURL(_detailManagerModel.FORMATFILEURL) absoluteString]);
        [self loadFile:[ZENITH_IMAGEURL(_detailManagerModel.FORMATFILEURL) absoluteString]];
    }
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

-(void)goNextCourseDetail:(id)detail
{
    ZEManagerDetailVC * detailVC = [[ZEManagerDetailVC alloc]init];
    detailVC.detailManagerModel = [ZEDistrictManagerModel getDetailWithDic:detail];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)goMyCollectCourse
{
    ZEMyCollectCourseVC * collectCourseVC = [[ZEMyCollectCourseVC alloc]init];
    [self.navigationController pushViewController:collectCourseVC animated:YES];
}

-(void)goManagerPractice:(ZEDistrictManagerModel *)managerModel
{
    [self getUrl:managerModel];
}
-(void)goNewQuestionListVC:(ZEDistrictManagerModel *)model
{
    ZENewQuestionListVC * questionListVC = [[ZENewQuestionListVC alloc]init];
    questionListVC.enterType = ENTER_NEWQUESLIST_TYPE_COURSEHOME;
    questionListVC.managerCourseModel = model;
    [self.navigationController pushViewController:questionListVC animated:YES];
}

-(void)goCoreseStandard
{
    ZEQuestionBankWebVC * bankVC = [[ZEQuestionBankWebVC alloc]init];
    bankVC.bankID = _detailManagerModel.POSCODE;
    bankVC.enterType = ENTER_QUESTIONBANK_TYPE_STANDARD;
    [self.navigationController pushViewController:bankVC animated:YES];
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
