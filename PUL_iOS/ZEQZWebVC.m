//
//  ZEQuestionBankWebVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQZWebVC.h"
#import "ZEQuestionBankWebVC.h"
#import <WebKit/WebKit.h>
#import "ZEManagerDetailVC.h"
#import "ZEMyCollectCourseVC.h"
#import "ZEManagerPracticeBankVC.h"
#import "ZENewQuestionListVC.h"

@interface ZEQZWebVC ()<WKNavigationDelegate,UIGestureRecognizerDelegate,WKScriptMessageHandler>
{
    WKWebView * wkWebView;
    NSString * webUrl;
}

@property (nonatomic,assign) BOOL isCanSideBack;

@end

@implementation ZEQZWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [ZEUtil getQuestionBankWebVCTitle:_enterType];
    
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
#pragma - mark  视频全屏问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    if (_enterType == ENTER_QUESTIONBANK_TYPE_TKLL) {
        [self getTKLLUrlWithEnterType];
        return;
    }
    
    [self getUrlWithEnterType:_enterType];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.tabBarController.tabBar.hidden =YES;
}

-(void)loadWebView{
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
    
    NSMutableURLRequest * reuqest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.needLoadRequestUrl]];
    [wkWebView loadRequest:reuqest];
    
    [self initProgressView];
}

-(void)initProgressView{
    if(!self.progressView){
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 2)];
        self.progressView.backgroundColor = [UIColor blueColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:self.progressView];
        
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma - mark  视频进入全屏
-(void)windowVisible:(NSNotification *)notification
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIDeviceOrientationLandscapeLeft;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}

#pragma - mark 视频将退出
-(void)windowHidden:(NSNotification *)notification
{
    //    ZEAppDelegate *appDelegate = (ZEAppDelegate *)  [UIApplication sharedApplication].delegate;
    //    appDelegate.allowRotation = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // 强制归正
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanSideBack;
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
            
        case ENTER_QUESTIONBANK_TYPE_STANDARD:
            actionFlag = @"PracticalNorm";
            break;
            
        default:
            break;
    }
    NSLog(@" ------  %@  ===  %@",self.bankID  ,  self.abilitytypecode);
    if(![ZEUtil isNotNull:self.bankID] || ![ZEUtil isNotNull:self.abilitytypecode]){
        return;
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
                                     @"CLASSNAME":@"com.nci.klb.app.exam.QuestionBankQuery",
                                     @"DETAILTABLE":@"",
                                     @"module_id":self.bankID,
                                     @"abilitytypecode":self.abilitytypecode,
                                     };
    
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
                                     [self initProgressView];
                                     wkWebView.navigationDelegate = self;
                                     [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetURL]]];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)getTKLLUrlWithEnterType
{
    NSLog(@" ------  %@  ===  %@  ===  %@",self.bankID  ,  self.abilitytypecode , self.MODTYPE);
    if(![ZEUtil isNotNull:self.bankID] || ![ZEUtil isNotNull:self.abilitytypecode] ||![ZEUtil isNotNull:self.MODTYPE]){
        return;
    }
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_FUNCTION_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"QuestionBankList",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.exam.QuestionBankQuery",
                                     @"DETAILTABLE":@"",
                                     @"module_id":self.bankID,
                                     @"abilitytypecode":self.abilitytypecode,
                                     @"modtype":self.MODTYPE,
                                     };
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@""];
    
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
                                     [self initProgressView];
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
    // 跳转我的收藏页面
    if([navigationAction.request.URL.absoluteString containsString:@"javasscriptss:goMyCollectCourse"]){
        [self goMyCollectCourse];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"body:%@", message.body);
    if ([message.name isEqualToString:@"ShowMessageFromWKWebView"]) {
        if([[YYReachability reachability] status] == YYReachabilityStatusWiFi){
            NSString *returnJSStr = [NSString stringWithFormat:@"showMessageFromWKWebViewResult('wifi')"];
            [wkWebView evaluateJavaScript:returnJSStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"%@,%@", result, error);
            }];
        }else{
            NSString *returnJSStr = [NSString stringWithFormat:@"showMessageFromWKWebViewResult('')"];
            [wkWebView evaluateJavaScript:returnJSStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"%@,%@", result, error);
            }];
        }
    }
    if ([message.name isEqualToString:@"goCourseDetail"]) {
        NSDictionary *dic = [ZEUtil dictionaryWithJsonString:message.body];
        
        ZEManagerDetailVC * detailVC = [[ZEManagerDetailVC alloc]init];
        detailVC.detailManagerModel = [ZEDistrictManagerModel getDetailWithDic:dic];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    // 我的收藏
    if ([message.name isEqualToString:@"goMyCollectCourse"]) {
        [self goMyCollectCourse];
    }
    
    // 课程首页
    if ([message.name isEqualToString:@"openQuestionBankActivity"]) {
        [self goManagerPractice];
    }
    
    // 课程讨论区
    if ([message.name isEqualToString:@"openDynamicActivity"]) {
        [self goNewQuestionListVC];
    }
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
-(void)goNewQuestionListVC
{
    ZENewQuestionListVC * questionListVC = [[ZENewQuestionListVC alloc]init];
    questionListVC.enterType = ENTER_NEWQUESLIST_TYPE_COURSEHOME;
    [self.navigationController pushViewController:questionListVC animated:YES];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
}


-(void)dealloc
{
    [wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    wkWebView = nil;
    wkWebView.navigationDelegate = nil;
    if (_enterType == ENTER_QUESTIONBANK_TYPE_ABISCHOOL) {
        [wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"ShowMessageFromWKWebView"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
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
