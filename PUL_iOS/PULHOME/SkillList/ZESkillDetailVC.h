//
//  ZESkillDetailVC.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/18.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZESkillListModel.h"
#import "ZESkillDetailView.h"

@interface ZESkillDetailVC : ZESettingRootVC<ZESkillDetailViewDelegate>

@property (nonatomic,strong) ZESkillListModel * skillModel;

@end
