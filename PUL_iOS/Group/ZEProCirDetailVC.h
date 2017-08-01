//
//  ZEProCirDetailVC.h
//  PUL_iOS
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

@interface ZEProCirDetailVC : ZESettingRootVC

@property(nonatomic,assign) ENTER_GROUP_TYPE enter_group_type;

@property(nonatomic,copy) NSMutableDictionary * PROCIRCLEDataDic;

@property(nonatomic,copy) NSString * PROCIRCLECODE;
@property(nonatomic,copy) NSString * PROCIRCLENAME;

@end
