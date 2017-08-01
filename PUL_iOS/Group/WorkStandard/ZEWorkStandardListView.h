//
//  ZEWorkStandardListView.h
//  PUL_iOS
//
//  Created by Stenson on 17/4/25.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEWorkStandardListView;

@protocol ZEWorkStandardListViewDelegate <NSObject>

/**
 进入经典案例详情
 
 @param obj 案例详情
 */
-(void)goWorkStandardDetail:(id)obj;
/**
 下拉刷新
 */
-(void)loadNewData;
/**
 上提加载
 */
-(void)loadMoreData;


/**
 筛选技能分类
*/
-(void)showType;


/**
 最新 或者 最热排序
 
 @param condition 排序条件
 */
-(void)sortConditon:(NSString *)condition;

@end

@interface ZEWorkStandardListView : UIView

@property (nonatomic,weak) id <ZEWorkStandardListViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;


-(void)reloadNavView:(NSString *)str;

-(void)reloadFirstView:(NSArray *)arrData;
-(void)reloadMoreDataView:(NSArray *)arrData;


/**
 *  停止刷新
 */
-(void)headerEndRefreshing;

-(void)loadNoMoreData;
@end
