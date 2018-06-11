//
//  ZEQZWebVC.h
//  PUL_iOS
//
//  Created by Stenson on 2018/5/26.
//  Copyright © 2018年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

@interface ZEQZWebVC : ZESettingRootVC

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic,assign) ENTER_QUESTIONBANK_TYPE enterType;

@property (nonatomic,copy) NSString * functionCode;

@property (nonatomic,copy) NSString * needLoadRequestUrl;

// 个人消息列表请求需要
@property (nonatomic,copy) NSString * URLPATH;

@property (nonatomic,copy) NSString * bankID;
@property (nonatomic,copy) NSString * abilitytypecode;
@property (nonatomic,copy) NSString * MODTYPE;

@end
