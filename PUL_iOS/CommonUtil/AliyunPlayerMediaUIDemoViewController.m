//
//  AliyunPlayerMediaUIDemoViewController.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/21.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "AliyunPlayerMediaUIDemoViewController.h"
#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>

#import <sys/utsname.h>

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@interface AliyunPlayerMediaUIDemoViewController ()<AliyunVodPlayerViewDelegate>
//播放器
@property (nonatomic,strong)AliyunVodPlayerView *playerView;
//控制锁屏
@property (nonatomic, assign)BOOL isLock;

//每5秒打印，边播边下内容大小，使用时 取消[self fileSize]方法注释。
@property (nonatomic,strong)NSTimer *timer;

//是否隐藏navigationbar
@property (nonatomic,assign)BOOL isStatusHidden;

//进入前后台时，对界面旋转控制
@property (nonatomic, assign)BOOL isBecome;

// 视频总时长
@property(nonatomic, copy) NSString * videoDuration;


@property (nonatomic,copy) NSString * pagebegintime;  // 进入页面的时间
@property (nonatomic,copy) NSString * pageendtime;  // 退出页面的时间
@property (nonatomic,copy) NSString * videotime;
@property (nonatomic,copy) NSString * videobegintime;
@property (nonatomic,copy) NSString * videoendtime;
@property (nonatomic,copy) NSString * videocurrenttime;
@property (nonatomic,copy) NSString * playtime;   // 播放进度

@property (nonatomic,copy) NSString * playProgress;

@end

@implementation AliyunPlayerMediaUIDemoViewController

#pragma mark - viewDidLoad

-(id)initWithHTTPLiveStreamingMediaURL:(NSURL *)urlStr withTitle:(NSString *)videoTitle withPlayProgress:(NSString *)playProgress;
{
    self = [super init];
    if (self) {
        _videoUrl = urlStr;
        _videoTitle = videoTitle;
        _playProgress = playProgress;
        
        _pagebegintime = @"";  // 进入页面的时间
        _pageendtime = @"";  // 退出页面的时间
        _videotime = @"";
        _videobegintime = @"";
        _videoendtime = @"";
        _videocurrenttime = @"";
        _playtime = @"";   // 播放进度
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pagebegintime =[NSString stringWithFormat:@"%@",[self getNowTimeTimestamp3]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat topHeight = 0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
        topHeight = 0;
    }else{
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
        topHeight = 0;
    }
    /****************UI播放器集成内容**********************/
    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,topHeight, width, height) andSkin:AliyunVodPlayerViewSkinRed];
    [self.playerView setDelegate:self];
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI_2);
    [self.playerView setTransform:transform];
    self.playerView.center = self.view.center;

    //边下边播缓存沙箱位置
//    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [pathArray objectAtIndex:0];
//    //maxsize:单位 mb    maxDuration:单位秒 ,在prepare之前调用。
//    [self.playerView setPlayingCache:NO saveDir:docDir maxSize:3000 maxDuration:100000];
    
    //查看缓存文件时打开。
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerun) userInfo:nil repeats:YES];
    
    //播放本地视频
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"set.mp4" ofType:nil];
//    [self.playerView playViewPrepareWithURL:[NSURL URLWithString:@"http://vod-test5.cn-shanghai.aliyuncs.com/84c80abba5e04fe9b57564d204a59585/b5a2911dd2c44c5d81ec568eb3b14431-f30978e8480a8c3a231ab2127d839b0c.mp4?auth_key=1512310022-0-0-c2f3ebd18ba1f4350edf1c5155f1e2dd"]];
    //播放器播放方式
    [self.playerView setAutoPlay:YES];
    [self.playerView playViewPrepareWithURL:_videoUrl];
    [self.view addSubview:self.playerView];

    self.isStatusHidden = YES  ;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.playerView setTitle:_videoTitle];
    [self.playerView setPrintLog:NO];

    /**************************************/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoPrepared:) name:AliVcMediaPlayerLoadDidPreparedNotification
                                               object:nil];
}

-(void)OnVideoPrepared:(NSNotification *)noti{
    AliVcMediaPlayer * player = (AliVcMediaPlayer *)noti.object;
    NSLog(@" ===  %f",player.duration);
    _videoDuration = [NSString stringWithFormat:@"%f" ,player.duration];
    _videobegintime = [self getNowTimeTimestamp3];
    
    if([_playProgress floatValue] >0){
        NSTimeInterval seekTime =  [_videoDuration  floatValue]* [_playProgress floatValue];
    
        [self.playerView.aliPlayer seekToTime:seekTime / 1000];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)setVideoTitle:(NSString *)videoTitle
{
    _videoTitle = videoTitle;
    [self.playerView setTitle:_videoTitle];
}

- (void)becomeActive{
    self.isBecome = NO;
}

- (void)resignActive{
    self.isBecome = YES;
    if (self.playerView && self.playerView.playerViewState == AliyunVodPlayerStatePlay){
        [self.playerView pause];
    }
}

- (NSString*)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}

//适配iphone x 界面问题，没有在 viewSafeAreaInsetsDidChange 这里做处理 ，主要 旋转监听在 它之后获取。
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//   NSString *platform =  [self iphoneType];
//    CGFloat width = 0;
//    CGFloat height = 0;
//    CGFloat topHeight = 0;
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (orientation == UIInterfaceOrientationPortrait ) {
//        width = SCREEN_HEIGHT;
//        height = SCREEN_WIDTH;
//        topHeight = 0;
//    }else{
//        width = SCREEN_WIDTH;
//        height = SCREEN_HEIGHT;
//        topHeight = 0;
//    }
//    CGRect tempFrame = CGRectMake(0,topHeight, width, height);
//    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI_2);
//    [self.playerView setTransform:transform];
//    self.playerView.center = self.view.center;
//
//    UIDevice *device = [UIDevice currentDevice] ;
//    //iphone x
//    if (![platform isEqualToString:@"iPhone10,3"] && ![platform isEqualToString:@"iPhone10,6"]) {
//        switch (device.orientation) {//device.orientation
//            case UIDeviceOrientationFaceUp:
//            case UIDeviceOrientationFaceDown:
//            case UIDeviceOrientationUnknown:
//            case UIDeviceOrientationPortraitUpsideDown:
//                break;
//            case UIDeviceOrientationLandscapeLeft:
//            case UIDeviceOrientationLandscapeRight:
//                {
//                    self.playerView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
//                }
//                break;
//            case UIDeviceOrientationPortrait:
//                {
//                    self.playerView.frame = tempFrame;
//                }
//                break;
//            default:
//
//                break;
//            }
//        return;
//    }
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
//    switch (device.orientation) {//device.orientation
//        case UIDeviceOrientationFaceUp:
//        case UIDeviceOrientationFaceDown:
//        case UIDeviceOrientationUnknown:
//        case UIDeviceOrientationPortraitUpsideDown:{
//            if (self.isStatusHidden) {
//                CGRect frame = self.playerView.frame;
//                frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
//                frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
//                frame.size.width = SCREEN_WIDTH-VIEWSAFEAREAINSETS(self.view).left*2;
//                frame.size.height = SCREEN_HEIGHT-VIEWSAFEAREAINSETS(self.view).bottom-VIEWSAFEAREAINSETS(self.view).top;
//                self.playerView.frame = frame;
//            }else{videotime
//                CGRect frame = self.playerView.frame;
//                frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
//                //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
//                if (self.playerView.fixedPortrait&&self.isStatusHidden) {
//                    frame.size.height = SCREEN_HEIGHT- VIEWSAFEAREAINSETS(self.view).top- VIEWSAFEAREAINSETS(self.view).bottom;
//                }
//                self.playerView.frame = frame;
//            }
//        }
//            break;
//        case UIDeviceOrientationLandscapeLeft:
//        case UIDeviceOrientationLandscapeRight:
//        {
//            //
//            CGRect frame = self.playerView.frame;
//            frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
//            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
//            frame.size.width = SCREEN_WIDTH-VIEWSAFEAREAINSETS(self.view).left*2;
//            frame.size.height = SCREEN_HEIGHT-VIEWSAFEAREAINSETS(self.view).bottom;
//            self.playerView.frame = frame;
//        }
//
//            break;
//        case UIDeviceOrientationPortrait:
//        {
//            CGRect frame = tempFrame;
//            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
//            //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
//            if (self.playerView.fixedPortrait&&self.isStatusHidden) {
//                frame.size.height = SCREEN_HEIGHT- VIEWSAFEAREAINSETS(self.view).top- VIEWSAFEAREAINSETS(self.view).bottom;
//            }
//            self.playerView.frame = frame;
//        }
//
//            break;
//        default:
//
//            break;
//    }
//
//#else
//
//#endif
//}


#pragma mark - AliyunVodPlayerViewDelegate
- (void)onBackViewClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    
    _pageendtime = [self getNowTimeTimestamp3];
    _videoendtime = [self getNowTimeTimestamp3];
    
    float  playAsp = self.playerView.currentTime * 1000 / [_videoDuration  floatValue];
    _playtime = [NSString stringWithFormat:@"%.2f",playAsp];
    
    NSDictionary * uploadDataDic = @{@"pagebegintime":_pagebegintime,
                                     @"pageendtime":_pageendtime,
                                     @"videotime":_videoDuration,
                                     @"videobegintime":_videobegintime,
                                     @"videoendtime":_videoendtime,
                                     @"videocurrenttime":[NSString stringWithFormat:@"%f",self.playerView.currentTime],
                                     @"playtime":_playtime,
                                     };
    
    
    NSLog(@" == == == %@",uploadDataDic);

    [[NSNotificationCenter defaultCenter] postNotificationName:kSAVE_PLAY_RECORD object:uploadDataDic];;
    
    
    if (self.playerView != nil) {
        [self.playerView stop];
        [self.playerView releasePlayer];
        [self.playerView removeFromSuperview];
        self.playerView = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onPause:(NSTimeInterval)currentPlayTime{
    NSLog(@"onPause");
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onResume:(NSTimeInterval)currentPlayTime{
    NSLog(@"onResume");
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onStop:(NSTimeInterval)currentPlayTime{
    NSLog(@"onStop");
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onSeekDone:(NSTimeInterval)seekDoneTime{
    NSLog(@"onSeekDone");
}
-(void)onFinishWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
     NSLog(@"onFinish");
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen{
    
    NSLog(@" ===== == == = = = = =");
    self.playerView.fixedPortrait = NO;
    self.playerView.isScreenLocked = NO;
    self.isLock = self.playerView.isScreenLocked||self.playerView.fixedPortrait?YES:NO;
//    self.isLock = isLockScreen;
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);

    self.isStatusHidden = isFullScreen  ;
    [self setNeedsStatusBarAppearanceUpdate];
   
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView onVideoDefinitionChanged:(NSString *)videoDefinition {
}

- (void)onCircleStartWithVodPlayerView:(AliyunVodPlayerView *)playerView {
}


/**
 * 功能：获取媒体信息
 */
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView mediaInfo:(AliyunVodPlayerVideo*)mediaInfo{
    
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event
{
    
}

-(void)timerun{
//    [self fileSize];
}

-(void)fileSize{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [pathArray objectAtIndex:0];
    NSString *filePath = docDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:docDir isDirectory:nil]){
        NSArray *subpaths = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
        for (NSString *subpath in subpaths) {
            
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            if ([subpath hasSuffix:@".mp4"]) {
                long long fileSize =  [fileManager attributesOfItemAtPath:fullSubpath error:nil].fileSize;
                NSLog(@"fileSie ---- %lld",fileSize);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 锁屏功能
/**
 * 说明：播放器父类是UIView。
 屏幕锁屏方案需要用户根据实际情况，进行开发工作；
 如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
//    return toInterfaceOrientation = UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationPortrait;
    
    if (self.isBecome) {
        return toInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
    }
    
    if (self.isLock) {
        return toInterfaceOrientation = UIInterfaceOrientationPortrait;
    }else{
        return YES;
    }
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    
    if (self.isBecome) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }

    if (self.isLock) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    }
}

-(BOOL)prefersStatusBarHidden
{
    return self.isStatusHidden;
}

// 获取当前时间戳
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
