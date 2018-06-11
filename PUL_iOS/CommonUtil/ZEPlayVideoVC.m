//
//  ZEPlayVideoVC.m
//  PUL_iOS
//
//  Created by Stenson on 2018/5/28.
//  Copyright © 2018年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPlayVideoVC.h"

@interface ZEPlayVideoVC ()

@end

@implementation ZEPlayVideoVC

-(id)initWithHTTPLiveStreamingMediaURL:(NSURL *)urlStr
{
    self = [super init];
    if (self) {
        _videoUrlStr = urlStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建播放器
    //创建播放器视图，其中contentView为UIView实例，自己根据业务需求创建一个视图即可
    /*self.mediaPlayer:NSObject类型，需要UIView来展示播放界面。
     self.contentView：承载mediaPlayer图像的UIView类。
     */
    AliyunVodPlayerView *playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, SCREEN_HEIGHT) andSkin:AliyunVodPlayerViewSkinBlue];
    //设置播放器代理
    [playerView setDelegate:self];
    //将播放器添加到需要展示的界面上
    [self.view addSubview:playerView];
    //NSURL *url = [NSURL URLWithString:@""];//网络视频，填写网络url地址
    //playViewPrepareWithURL:参数为NSURL类。
    [playerView playViewPrepareWithURL:_videoUrlStr];
    [playerView start];
    playerView.circlePlay = NO;
//    self.mediaPlayer = [[AliVcMediaPlayer alloc] init];
//    [self.mediaPlayer create:playerView];
//    //设置播放类型，0为点播、1为直播，默认使用自动
//    self.mediaPlayer.mediaType = MediaType_AUTO;
//    //设置超时时间，单位为毫秒
//    self.mediaPlayer.timeout = 25000;
//    //缓冲区超过设置值时开始丢帧，单位为毫秒。直播时设置，点播设置无效。范围：500～100000
//    self.mediaPlayer.dropBufferDuration = 8000;
//    [self.mediaPlayer prepareToPlay:_videoUrlStr];
//    [self.mediaPlayer play];
    
    
}

- (void)onBackViewClickWithAliyunVodPlayerView:(AliyunVodPlayerView*)playerView{
    //点击播放器界面的返回按钮时触发，可以用来处理界面跳转
//    [self dismissModalViewControllerAnimated:YES];
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
