//
//  ZEQuestionBankWebVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionBankWebVC.h"
#import "ZEAppDelegate.h"
#import <WebKit/WebKit.h>

@interface ZEQuestionBankWebVC ()<WKNavigationDelegate,UIGestureRecognizerDelegate,WKScriptMessageHandler>
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

    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
#pragma - mark  视频全屏问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
    

    if (_functionCode.length > 0) {
        [self getCustomFunctionList];
        return;
    }
    
    if(_enterType > ENTER_QUESTIONBANK_TYPE_NOTE){
        [self getHomeUrl:_enterType];
    }else{
        [self getUrlWithEnterType:_enterType];
    }
    
}

#pragma - mark  视频进入全屏
-(void)windowVisible:(NSNotification *)notification
{
    ZEAppDelegate *appDelegate = (ZEAppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = YES;
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
    ZEAppDelegate *appDelegate = (ZEAppDelegate *)  [UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = NO;
    
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

-(void)getCustomFunctionList
{
    NSString * actionFlag = _functionCode;
    NSString * className = HOME_HTML_CLASS;
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_FUNCTION_LIST,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"ToHtml",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":className,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_FUNCTION_LIST]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:actionFlag];
    
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
            
        case ENTER_QUESTIONBANK_TYPE_PROEXAM:
            actionFlag = @"characterAppraisal";
            className = HOME_EXAMFUNCTION_CLASS;
            break;
            
        case ENTER_QUESTIONBANK_TYPE_SKILLLIST:
            actionFlag = @"skillInventory";
            className = HOME_EXAMFUNCTION_CLASS;
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
                                     WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
                                     configuration.userContentController = [WKUserContentController new];
                                     
                                     if(_enterType == ENTER_QUESTIONBANK_TYPE_ABISCHOOL){
                                         [configuration.userContentController addScriptMessageHandler:self name:@"ShowMessageFromWKWebView"];
                                     }
     
                                     wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, SCREEN_HEIGHT - 20) configuration:configuration];
                                     wkWebView.top = 20;
                                     wkWebView.height = SCREEN_HEIGHT - 20;

                                     UIView * statusBackgroundView = [UIView new];
                                     statusBackgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);

                                     [self.view addSubview:statusBackgroundView];
                                     [ZEUtil addGradientLayer:statusBackgroundView];
                                     
                                     wkWebView.navigationDelegate = self;
                                     NSMutableURLRequest * reuqest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:targetURL]];
                                     webUrl = targetURL;
                                     
                                     [wkWebView loadRequest:reuqest];
                                     [self.view addSubview:wkWebView];

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
    if (_enterType == ENTER_QUESTIONBANK_TYPE_ABISCHOOL) {
        [wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"ShowMessageFromWKWebView"];
    }
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
