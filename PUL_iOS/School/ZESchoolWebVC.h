//
//  ZESchoolWebVC.h
//  nbsj-know
//
//  Created by Stenson on 17/2/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"

@interface ZESchoolWebVC : ZESettingRootVC

@property (nonatomic,assign) ENTER_WEBVC enterType;

@property (nonatomic,copy) NSString * htmlStr;

@property (nonatomic,copy) NSString * webURL;
@property (nonatomic,copy) NSString * workStandardSeqkey;
@end
