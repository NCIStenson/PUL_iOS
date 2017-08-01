//
//  ZETeamCircleChatVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

@interface ZETeamCircleChatVC : ZESettingRootVC

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfo;

@property (nonatomic,strong) ZEAnswerInfoModel * answerInfo;

@property (nonatomic,assign) BOOL enterChatVCType;

@end
