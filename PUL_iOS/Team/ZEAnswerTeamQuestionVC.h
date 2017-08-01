//
//  ZEAnswerQuestionVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/14.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

@interface ZEAnswerTeamQuestionVC : ZESettingRootVC

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;
@property (nonatomic,copy) NSString * questionSEQKEY;

@end
