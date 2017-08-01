//
//  ZETeamWebVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/4/27.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZETeamCircleModel.h"
@interface ZETeamWebVC : ZESettingRootVC

@property (nonatomic,assign) ENTER_WKWEBVC enterType;
@property (nonatomic,strong) ZETeamCircleModel * teamCircleM;

@end
