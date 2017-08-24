//
//  ZESchoolWebVC.m
//  nbsj-know
//
//  Created by Stenson on 17/2/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define SCHOOL_WEBURL @"http://dzd.nbuen.com/mobile/media_app.php"

#import "ZESchoolWebVC.h"
#import "PYPhotosView.h"

@interface ZESchoolWebVC ()<UIWebViewDelegate>
{
    UIWebView * webView;
    
    UIButton * closeButton;
}
@end

@implementation ZESchoolWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

    if(_enterType == ENTER_WEBVC_SCHOOL){
        self.leftBtn.width = 80.0f;
        [self.leftBtn setTitle:@"返回" forState:UIControlStateNormal];
        [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [self.leftBtn addTarget:self action:@selector(goBackWebView) forControlEvents:UIControlEventTouchUpInside];
        self.title = @"学堂";
        
        [self.leftBtn setTitle:@"关闭" forState:UIControlStateNormal];
//        self.leftBtn.titleLabel.font = [[UIFont systemFontOfSize:<#(CGFloat)#>]];
        
        closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.navBar addSubview:closeButton];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeButton.left = 80;
        closeButton.top = 20.0f;
        closeButton.size = CGSizeMake(40, 44);
        [closeButton setTitle:@"返回" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(goBackWebHomeView) forControlEvents:UIControlEventTouchUpInside];
    }else if (_enterType == ENTER_WEBVC_ABOUT){
        self.title =  @"关于电知道";
    }else if (_enterType == ENTER_WEBVC_OPERATION){
        self.title = @"操作手册";
    }else if (_enterType == ENTER_WEBVC_MY_PRACTICE){
        self.title = @"我的练习";
    }else if (_enterType == ENTER_WEBVC_SYSTEMNOTI){
        self.title = @"系统通知";
    }
    
    [self initWebView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [webView loadRequest:[NSURL URLWithString:nil]];
//    [webView removeFromSuperview];
//    webView = nil;
//    webView.delegate = nil;
//    [webView stopLoading];
}


-(void)initWebView
{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView sizeToFit];
    webView.scalesPageToFit = YES;

    if(_enterType == ENTER_WEBVC_SCHOOL){
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dzd.nbuen.com/mobile/media_app.php"]]];
    }else if (_enterType == ENTER_WEBVC_OPERATION){
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/file/about/operation.pdf",Zenith_Server]]]];
    }else if (_enterType == ENTER_WEBVC_MY_PRACTICE){
        NSString * serverStr  = Zenith_Server;
        if ([serverStr containsString:@"117.149.2.229"]) {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://117.149.2.229:1623/ecm/ZUI/pages/dzd/practice.html?userID=%@",[ZESettingLocalData getUSERCODE]]]]];
        }else{
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.27.152.63:7788/ecm/ZUI/pages/dzd/practice.html?userID=%@",[ZESettingLocalData getUSERCODE]]]]];
        }
    }else if (_enterType == ENTER_WEBVC_ABOUT){
        
        webView.hidden = YES;
        
        UIImageView * qrcodeImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, SCREEN_WIDTH - 40)];
        qrcodeImg.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
        qrcodeImg.image = [UIImage imageNamed:@"qrcode.png"];
        [self.view addSubview:qrcodeImg];
        
        UILabel * qrcodeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, qrcodeImg.top + qrcodeImg.height , SCREEN_WIDTH, 30.0f)];
        qrcodeLab.text = @"扫一扫下载安装";
        qrcodeLab.font = [UIFont boldSystemFontOfSize:22];
        qrcodeLab.textColor = kTextColor;
        qrcodeLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:qrcodeLab];
    }else if (_enterType == ENTER_WEBVC_WORK_STANDARD){
        self.title = @"行业规范";
        [self addWorkStandardClickCount];
        if(self.webURL.length > 0){
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
        }else{
            [self showTips:@"文件路径错误，请联系管理员" afterDelay:1.5];
            [self performSelector:@selector(leftBtnClick) withObject:nil afterDelay:1.5];
        }
    }else if (_enterType == ENTER_WEBVC_SYSTEMNOTI){
        if(self.webURL.length > 0){
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
        }else if (self.htmlStr.length > 0){
            [webView loadHTMLString:self.htmlStr baseURL:nil];
        }
    }
}

-(void)addWorkStandardClickCount
{
    if (self.workStandardSeqkey.length == 0) {
        return;
    }
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_STANDARD_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.standard.ClickCount",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":self.workStandardSeqkey};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_STANDARD_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                             } fail:^(NSError *errorCode) {
                             }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
} 

-(void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    if (_enterType == ENTER_WEBVC_MY_PRACTICE) {
        [webView stringByEvaluatingJavaScriptFromString:@"saveExamCase1();"];
    }
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
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SCHOOL_WEBURL]]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (_enterType == ENTER_WEBVC_SCHOOL) {
        NSString *urlString = [[request URL] absoluteString];
        if ([urlString isEqualToString:@"about:blank"]) {
            return YES;
        }
        if ([urlString isEqualToString:SCHOOL_WEBURL]) {
            closeButton.hidden = YES;
        }else{
            closeButton.hidden = NO;
        }
        
    }
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
