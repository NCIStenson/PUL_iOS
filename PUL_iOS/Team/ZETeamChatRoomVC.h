//
//  ZETeamChatRoomVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/25.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMUIChattingKit/JMUIChattingViewController.h>
#import "ZETeamCircleModel.h"

@interface ZETeamChatRoomVC : JMUIConversationViewController

@property (nonatomic,strong) ZETeamCircleModel * teamcircleModel;

@end
