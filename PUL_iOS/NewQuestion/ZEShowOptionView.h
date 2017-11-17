//
//  ZEShowOptionView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/16.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEShowOptionView ;

@protocol ZEShowOptionViewDelegate <NSObject>

-(void)didSelectOptionWithIndex:(NSInteger)index;

@end

@interface ZEShowOptionView : UIView

@property(nonatomic,weak) id <ZEShowOptionViewDelegate> delegate;

@property (nonatomic,assign) CGFloat contentViewWidth;
@property (nonatomic,assign) CGFloat contentViewHeight;

@property (nonatomic,assign) CGFloat backImageHeight;

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,assign) CGRect rect;

@end
