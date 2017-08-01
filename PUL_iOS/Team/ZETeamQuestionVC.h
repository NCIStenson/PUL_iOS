//
//  ZETeamQuestionVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/13.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZETeamCircleModel.h"

@interface ZETeamQuestionVC : ZESettingRootVC

@property (nonatomic,assign) TEAM_CONTENT currentContent;
@property (nonatomic,strong) ZETeamCircleModel * teamCircleInfo;

@end
