//
//  ZESearchWorkStandardView.h
//  PUL_iOS
//
//  Created by Stenson on 17/4/25.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZESearchWorkStandardView;

@protocol ZESearchWorkStandardViewDelegate <NSObject>

/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goWorkStandardDetail:(NSDictionary *)dic;

-(void)goSearch:(NSString *)str;

/**
 *  刷新界面
 */
-(void)loadNewData;

/**
 *  加载更多数据
 */
-(void)loadMoreData;


@end

@interface ZESearchWorkStandardView : UIView

@property (nonatomic,weak) id <ZESearchWorkStandardViewDelegate> delegate;
@property (nonatomic,copy) NSString * searchStr;
-(id)initWithFrame:(CGRect)frame;

-(void)reloadFirstView:(NSArray *)array;
-(void)reloadContentViewWithArr:(NSArray *)arr;

-(void)headerEndRefreshing;
-(void)loadNoMoreData;
@end
