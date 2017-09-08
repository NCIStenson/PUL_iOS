//
//  ZEQuestionBankWebVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionBankWebVC.h"

#import <WebKit/WebKit.h>

@interface ZEQuestionBankWebVC ()<WKNavigationDelegate,UIGestureRecognizerDelegate>
{
    WKWebView * wkWebView;
    NSString * webUrl;
}

@property (nonatomic,assign) BOOL isCanSideBack;

@end

@implementation ZEQuestionBankWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [ZEUtil getQuestionBankWebVCTitle:_enterType];

    if(_enterType > ENTER_QUESTIONBANK_TYPE_NOTE){
        [self getHomeUrl:_enterType];
    }else{
        [self getUrlWithEnterType:_enterType];
    }
    
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
/**
 *恢复边缘返回
 */
- (void)resetSideBack {
    self.isCanSideBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}



-(void)getHomeUrl:(ENTER_QUESTIONBANK_TYPE)type{
    NSString * actionFlag = @"";
    NSString * className = HOME_URL_CLASS;
    switch (type) {
            case ENTER_QUESTIONBANK_TYPE_ABISCHOOL:
            actionFlag = @"CourseHome";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_STAFFDEV:
            actionFlag = @"DevelopNavigation";
            break;
            
        case ENTER_QUESTIONBANK_TYPE_ONLINEEXAM:
            actionFlag = @"onlineExam";
            className = HOME_ONLINEEXAM_CLASS;
            break;
            
        case ENTER_QUESTIONBANK_TYPE_MYRECORD:
            actionFlag = @"myRecord";
            break;
        case ENTER_QUESTIONBANK_TYPE_MYTRAIN:
            actionFlag = @"myTrain";
            break;
        case ENTER_QUESTIONBANK_TYPE_DEVPOINT:
            actionFlag = @"developIntegral";
            break;
        case ENTER_QUESTIONBANK_TYPE_MYAWARDS:
            actionFlag = @"myAwards";
            break;            
            
        default:
            break;
    }
    
    
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_FUNCTION_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":actionFlag,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":className,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];
                                 NSString * targetURL = [dic objectForKey:@"target"];
                                 if (targetURL.length > 0 &&  [ZEUtil isNotNull:targetURL]  ) {
                                     NSLog(@"targetURL >>>  %@",targetURL);
                                     self.navBar.hidden = YES;
                                     
                                     wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
                                     wkWebView.top = 20;
                                     wkWebView.height = SCREEN_HEIGHT - 20;
                                     
                                     UIView * statusBackgroundView = [UIView new];
                                     statusBackgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);

                                     [self.view addSubview:statusBackgroundView];
                                     [ZEUtil addGradientLayer:statusBackgroundView];
                                     
                                     [self.view addSubview:wkWebView];
                                     wkWebView.navigationDelegate = self;
                                     
                                     NSMutableURLRequest * reuqest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:targetURL]];
                                     webUrl = targetURL;
                                     
                                     [wkWebView loadRequest:reuqest];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}


-(void)getUrlWithEnterType:(ENTER_QUESTIONBANK_TYPE)type
{
    NSString * actionFlag = @"";
    switch (type) {
            case ENTER_QUESTIONBANK_TYPE_EXAM:
                actionFlag = @"chapterPractice";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_RANDOM:
                actionFlag = @"randomPractice";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_TEST:
                actionFlag = @"mockExam";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_DIFFCULT:
            actionFlag = @"problemTake";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_DAILY:
            actionFlag = @"dailyPractice";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_MYERROR:
            actionFlag = @"errorSubject";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_MYCOLL:
            actionFlag = @"myCollect";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_RECORD:
            actionFlag = @"exerciseRecord";
            break;
            
            case ENTER_QUESTIONBANK_TYPE_NOTE:
            actionFlag = @"myNotes";
            break;

        default:
            break;
    }
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
                                     @"module_id":self.bankID};
    
    NSDictionary * fieldsDic =@{};

    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];
                                 NSString * targetURL = [dic objectForKey:@"target"];
                                 if (targetURL.length > 0 &&  [ZEUtil isNotNull:targetURL]  ) {
                                     NSLog(@"targetURL >>>  %@",targetURL);
                                     self.navBar.hidden = YES;
                                     
                                     wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
                                     wkWebView.top = 20;
                                     wkWebView.height = SCREEN_HEIGHT - 20;
                                     
                                     UIView * statusBackgroundView = [UIView new];
                                     statusBackgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
                                     [self.view addSubview:statusBackgroundView];
                                     [ZEUtil addGradientLayer:statusBackgroundView];
                                     
                                     [self.view addSubview:wkWebView];
                                     wkWebView.navigationDelegate = self;
                                     [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetURL]]];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}



#pragma mark - WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if([navigationAction.request.URL.absoluteString containsString:@"javasscriptss:back"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    self.navBar.hidden = NO;
    wkWebView.hidden = YES;
}


- (void)deleteWebCache {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
        //        NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
        //                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
        //                                                        WKWebsiteDataTypeMemoryCache,
        //                                                        WKWebsiteDataTypeLocalStorage,
        //                                                        WKWebsiteDataTypeCookies,
        //                                                        WKWebsiteDataTypeSessionStorage,
        //                                                        WKWebsiteDataTypeIndexedDBDatabases,
        //                                                        WKWebsiteDataTypeWebSQLDatabases]];
        
        //// All kinds of data
        
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}

-(void)dealloc
{
    wkWebView = nil;
    wkWebView.navigationDelegate = nil;
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
