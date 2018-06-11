//
//  ZETypicalCaseWebVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/11/11.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETypicalCaseWebVC.h"
#import <WebKit/WebKit.h>

@interface ZETypicalCaseWebVC ()<UIWebViewDelegate,WKNavigationDelegate>
{
    WKWebView  * web;
}

@property (nonatomic,copy) NSString * pagebegintime;  // 进入页面的时间
@property (nonatomic,copy) NSString * pageendtime;  // 退出页面的时间
@property (nonatomic,copy) NSString * playtime;   // 播放进度

@end

@implementation ZETypicalCaseWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = nil;
    _pagebegintime = [self getNowTimeTimestamp3];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    web = [[WKWebView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    [self.view addSubview:web];
    web.navigationDelegate = self;

    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_filePath]];
    [web loadRequest:urlRequest];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    [web addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
- (void)dealloc {
    [web removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = web.estimatedProgress;
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
    [MBProgressHUD hideHUDForView:webView animated:YES];
    MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud3.mode = MBProgressHUDModeText;
    hud3.labelText = @"加载完成";
    [hud3 hide:YES afterDelay:1.0f];
}

-(void)leftBtnClick{
    
    _pageendtime = [self getNowTimeTimestamp3];
    _playtime = @"1.0";
    
    NSDictionary * uploadDataDic = @{@"pagebegintime":_pagebegintime,
                                     @"pageendtime":_pageendtime,
                                     @"playtime":_playtime,
                                     };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSAVE_PLAY_RECORD object:uploadDataDic];;
    [self.navigationController popViewControllerAnimated:YES];

}


-(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
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
