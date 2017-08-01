//
//  ZEAskTeamQuestionVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

#import "ZETeamCircleModel.h"

@interface ZEAskTeamQuestionVC : ZESettingRootVC

@property (nonatomic,strong) ZEQuestionInfoModel * QUESINFOM;
@property (nonatomic,assign) ENTER_GROUP_TYPE enterType;

@property (nonatomic,strong) ZETeamCircleModel * teamInfoModel;

@end
