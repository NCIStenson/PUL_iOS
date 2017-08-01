//
//  LookViewController.h
//  HunChaoWang
//
//  Created by wuxin on 15/4/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ZESettingRootVC.h"

@class ZELookViewController;

@protocol ZELookViewControllerDelegate <NSObject>

-(void)goBackViewWithImages:(NSArray *)imageArr;

@end

@interface ZELookViewController : ZESettingRootVC

@property (nonatomic,weak) id <ZELookViewControllerDelegate> delegate;

@property (nonatomic,retain) NSMutableArray * imageArr;
@property (nonatomic,assign) NSInteger currentSecleted;

@end
