//
//  ZETeamWebVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/4/27.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamWebVC.h"
#import <WebKit/WebKit.h>

@interface ZETeamWebVC ()<WKNavigationDelegate>
{
    WKWebView * wkWebView;
}
@end

@implementation ZETeamWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    switch (_enterType) {
        case ENTER_WKWEBVC_PRACTICE:
            self.title = @"练习管理";
            break;
            
        case ENTER_WKWEBVC_TEST:
            self.title = @"考试管理";
            break;

        default:
            break;
    }
    
    [self getUrlWithEnterType:_enterType];
    
}


-(void)getUrlWithEnterType:(ENTER_WKWEBVC)type
{
    NSString * method = @"";
    switch (type) {
        case ENTER_WKWEBVC_PRACTICE:
            method = @"DailyDeploy";
            break;
            
        case ENTER_WKWEBVC_TEST:
            method = @"CheckDeploy";
            break;
   
        default:
            break;
    }
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"",
                                     @"METHOD":method,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.exam.examCaseTeam",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_teamCircleM.SEQKEY};
    if (_teamCircleM.TEAMCODE.length > 0) {
        fieldsDic =@{@"SEQKEY":_teamCircleM.TEAMCODE};
    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSDictionary * dic = [ZEUtil getCOMMANDDATA:data];
                                 NSString * targetURL = [dic objectForKey:@"target"];
                                 if (targetURL.length > 0) {
                                     NSLog(@"targetURL >>>  %@",targetURL);
                                     wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
                                     if (_enterType == ENTER_WKWEBVC_TEST) {
                                         self.navBar.hidden = YES;

                                         wkWebView.top = 20;
                                         wkWebView.height = SCREEN_HEIGHT - 20;
                                         
                                         UIView * statusBackgroundView = [UIView new];
                                         statusBackgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
                                         [self.view addSubview:statusBackgroundView];
                                         [ZEUtil addGradientLayer:statusBackgroundView];
                                     }else{
                                         self.navBar.hidden = NO;
                                     }
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
