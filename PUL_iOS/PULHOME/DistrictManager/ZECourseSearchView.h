//
//  ZECourseSearchView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/21.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZECourseSearchView;

@protocol ZECourseSearchViewDelegate <NSObject>

-(void)goSearch:(NSString *)str;

/**
 *  刷新界面
 */
-(void)loadNewData;

/**
 *  加载更多数据
 */
-(void)loadMoreData;

-(void)goBack;

-(void)goCourseDetail:(NSDictionary *)dic;

@end

@interface ZECourseSearchView : UIView

@property (nonatomic,weak) id <ZECourseSearchViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadFirstView:(NSArray *)array;
-(void)reloadContentViewWithArr:(NSArray *)arr;

-(void)headerEndRefreshing;
-(void)loadNoMoreData;

@end
