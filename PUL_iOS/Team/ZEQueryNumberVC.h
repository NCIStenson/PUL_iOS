//
//  ZEQueryNumberVC.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZEQueryNumberView.h"

@interface ZEQueryNumberVC : ZESettingRootVC<ZEQueryNumberViewDelegate>

@property (nonatomic,strong) NSMutableArray * alreadyInviteNumbersArr;  // 当前页面已将邀请过的人员

@end
