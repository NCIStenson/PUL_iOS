//
//  ZETeamQuestionDetailVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/14.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZETeamCircleModel.h"
@interface ZETeamQuestionDetailVC : ZESettingRootVC

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;
@property (nonatomic,strong) ZEQuestionTypeModel * questionTypeModel;

@property (nonatomic,strong) ZETeamCircleModel * teamCircleInfo;

@end
