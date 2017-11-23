//
//  ZEChatVC.h
//  PUL_iOS
//
//  Created by Stenson on 16/12/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZESchoolWebVC.h"

@interface ZEChatVC : ZESettingRootVC

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfo;

@property (nonatomic,strong) ZEAnswerInfoModel * answerInfo;

@property (nonatomic,assign) BOOL enterChatVCType;

@end
