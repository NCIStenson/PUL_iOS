//
//  ZENewQuestionListVC.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZEDistrictManagerModel.h"


@interface ZENewQuestionListVC : ZESettingRootVC

@property (nonatomic,strong) ZEDistrictManagerModel * managerCourseModel;
@property (nonatomic,assign) ENTER_NEWQUESLIST_TYPE enterType;

@end
