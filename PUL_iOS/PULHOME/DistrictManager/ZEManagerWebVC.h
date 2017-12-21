//
//  ZEManagerWebVC.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/14.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

typedef enum : NSUInteger {
    ENTER_MANAGERWEB_COURSEDETAIL,
} ENTER_MANAGERWEB;

#import "ZESettingRootVC.h"

@interface ZEManagerWebVC : ZESettingRootVC

@property (nonatomic,assign) ENTER_MANAGERWEB enterType;

@end
