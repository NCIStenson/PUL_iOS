//
//  ZEDistrictManagerHomeVC.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//


#import "ZESettingRootVC.h"
#import "ZEDistrictManagerHomeView.h"
#import "ZEManagerDetailVC.h"
@interface ZEDistrictManagerHomeVC : ZESettingRootVC<ZEDistrictManagerHomeViewDelegate>
{
    ZEDistrictManagerHomeView * managerHomeView;
}

@property(nonatomic,strong) NSString * abilityCode;

@end
