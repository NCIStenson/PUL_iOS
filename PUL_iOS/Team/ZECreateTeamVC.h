//
//  ZECreateTeamVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZETeamCircleModel.h"

@interface ZECreateTeamVC : ZESettingRootVC<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,assign) ENTER_TEAM enterType;

@property (nonatomic,strong) ZETeamCircleModel * teamCircleInfo;

@property (nonatomic,copy) NSString * TEAMCODE;
@property (nonatomic,copy) NSString * TEAMSEQKEY;

@end
