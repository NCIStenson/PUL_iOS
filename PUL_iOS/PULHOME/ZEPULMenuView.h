//
//  ZEPULMenuView.h
//  PUL_iOS
//
//  Created by Stenson on 17/8/3.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZEPULMenuView : UIView

-(id)initWithFrame:(CGRect)frame withInUseArr:(NSArray *)inuseArr;

-(void)reloadUnuseArr:(NSArray *)arr;

@end
