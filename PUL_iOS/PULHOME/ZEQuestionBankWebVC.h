//
//  ZEQuestionBankWebVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/8/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

@interface ZEQuestionBankWebVC : ZESettingRootVC

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic,assign) ENTER_QUESTIONBANK_TYPE enterType;

@property (nonatomic,copy) NSString * functionCode;

@property (nonatomic,copy) NSString * needLoadRequestUrl;

// 个人消息列表请求需要
@property (nonatomic,copy) NSString * URLPATH;
@property (nonatomic,copy) NSString * MESTYPE;

@property (nonatomic,copy) NSString * bankID;

@end
