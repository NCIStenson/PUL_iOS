//
//  ZEManagerDetailVC.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZEManagerDetailView.h"
#import "ZEDistrictManagerModel.h"
@interface ZEManagerDetailVC : ZESettingRootVC<ZEManagerDetailViewDelegate>

@property (nonatomic,strong) ZEDistrictManagerModel * detailManagerModel;

@end
