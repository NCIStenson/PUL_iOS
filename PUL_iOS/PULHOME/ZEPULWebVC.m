//
//  ZEPULWebVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/7/6.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPULWebVC.h"

@interface ZEPULWebVC () <UIWebViewDelegate>
{
    UIWebView * webView;
}
@end

@implementation ZEPULWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWebView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_enterPULWebVCType == PULHOME_WEB_SCHOOL) {
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    }else{
        self.tabBarController.tabBar.hidden = YES;
    }
}

-(void)initWebView
{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView sizeToFit];
    webView.scalesPageToFit = YES;
    
    if(_enterPULWebVCType == PULHOME_WEB_MAP){
        self.title = @"能力地图";
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://117.149.2.229:1624/ecm/ZUI/pages/ecm/capacity.html?userId=12178503"]];
        [webView loadRequest:request];
    }else if (_enterPULWebVCType == PULHOME_WEB_PRACTICE){
        self.title = @"每日一练";
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://117.149.2.229:1624/ecm/mobile/MobileExamCaseModule2.jspx?isApp=1&userID=12178783&authStr=id&lesson_Id=ed3852dc-f411-429b-810a-9a9b93d6c1bb"]];
        [webView loadRequest:request];
    }else if (_enterPULWebVCType == PULHOME_WEB_Course){
        self.title = @"必修课";
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://117.149.2.229:1624/ecm/ZUI/pages/ecm/myStudy.html?userId=%@",[ZESettingLocalData getUSERNAME]]]];
        [webView loadRequest:request];
    }else if (_enterPULWebVCType == PULHOME_WEB_SCHOOL){
        self.title = @"学堂";
        webView.height = SCREEN_HEIGHT - NAV_HEIGHT - TAB_BAR_HEIGHT;
        self.leftBtn.hidden = YES;
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://117.149.2.229:1624/ecm/ZUI/pages/ecm/courseHome.html?userId=12178503"]]];
        [webView loadRequest:request];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

-(void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goBackWebView
{
    if([webView canGoBack]){
        [webView goBack];
    }
}

-(void)goBackWebHomeView
{
    [webView stopLoading];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    if (_enterType == ENTER_WEBVC_SCHOOL) {
//        NSString *urlString = [[request URL] absoluteString];
//        if ([urlString isEqualToString:@"about:blank"]) {
//            return YES;
//        }
//        if ([urlString isEqualToString:SCHOOL_WEBURL]) {
//            closeButton.hidden = YES;
//        }else{
//            closeButton.hidden = NO;
//        }
//        
//    }
    return YES;
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
