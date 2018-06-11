//
//  AliyunPlayerMediaUIDemoViewController.h
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/21.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AliyunPlayerMediaUIDemoViewController : UIViewController
-(id)initWithHTTPLiveStreamingMediaURL:(NSURL *)urlStr withTitle:(NSString *)videoTitle withPlayProgress:(NSString *)playProgress;

@property (nonatomic, strong)NSURL *videoUrl;
@property (nonatomic, copy)NSString * videoTitle;

@end
