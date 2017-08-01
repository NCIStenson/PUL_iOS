//
//  ZEExpertChatVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/29.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMUIChattingKit/JMUIChattingViewController.h>
#import "ZESettingRootVC.h"

#import "ZEExpertModel.h"

@interface ZEExpertChatVC : JMUIConversationViewController

@property (nonatomic,strong) ZEExpertModel * expertModel;

@end
