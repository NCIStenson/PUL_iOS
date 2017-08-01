//
//  ZEChooseNumberVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZEChooseNumberView.h"
#import "ZETeamCircleModel.h"
@interface ZEChooseNumberVC : ZESettingRootVC

@property (nonatomic,copy) NSString * TEAMCODE;  // 指定问答时 团队主键

@property (nonatomic,strong) ZETeamCircleModel * teaminfo;



@property (nonatomic,strong) NSMutableArray * numbersArr;

@property (nonatomic,assign) ENTER_CHOOSE_TEAM_MEMBERS enterType;

@end
