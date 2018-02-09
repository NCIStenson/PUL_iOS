//
//  JFCalendarPickerView.h
//  JFCalendarPicker
//
//  Created by 保修一站通 on 15/9/29.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFCalendarPickerView;
@protocol JFCalendarPickerViewDelegate <NSObject>

/******* 根据选择的月份刷新 ********/
-(void)goSignin;

/******* 根据选择的月份刷新 ********/
-(void)reloadDataWithMonth:(NSString *)monthStr;

@end

@interface JFCalendarPickerView : UIView<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@property(nonatomic,weak) id <JFCalendarPickerViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadDateData:(NSArray *)arr;

-(void)signinSuccess;

@end
