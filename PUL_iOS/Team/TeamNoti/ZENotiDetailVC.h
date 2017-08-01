//
//  ZENotiDetailVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/5/5.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZETeamNotiCenModel.h"

@interface ZENotiDetailVC : ZESettingRootVC

@property (nonatomic,copy) NSString * teamID;
@property (nonatomic,strong) ZETeamNotiCenModel * notiCenModel;

@property (nonatomic,assign) ENTER_TEAMNOTI_TYPE enterTeamNotiType;

@end
