//
//  ZEPlayVideoVC.h
//  PUL_iOS
//
//  Created by Stenson on 2018/5/28.
//  Copyright © 2018年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>

@interface ZEPlayVideoVC : ZESettingRootVC

-(id)initWithHTTPLiveStreamingMediaURL:(NSString *)urlStr;

@property (nonatomic,strong) NSURL * videoUrlStr;

@property (nonatomic,strong)AliyunVodPlayerView *playerView;

@end
