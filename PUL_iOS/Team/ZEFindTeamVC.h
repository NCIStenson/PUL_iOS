//
//  ZEFindTeamVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZEFindTeamView.h"
@interface ZEFindTeamVC : ZESettingRootVC<ZEFindTeamViewDelegate>

@property(nonatomic,assign) ENTER_FINDTEAM enterType;

@end
