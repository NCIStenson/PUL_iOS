//
//  ZEPointRegChooseCountView.h
//  NewCentury
//
//  Created by Stenson on 16/3/15.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZEChooseMonthViewDelegate <NSObject>
/**
 *  取消
 */
-(void)cancelChooseCount;
/**
 *  确定
 */
-(void)confirmChooseCount:(NSString *)countStr;

@end
@interface ZEChooseMonthView : UIView

@property (nonatomic,weak) id <ZEChooseMonthViewDelegate> delegate;

@end
