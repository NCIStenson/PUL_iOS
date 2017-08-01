//
//  ZETypicalCaseView.h
//  PUL_iOS
//
//  Created by Stenson on 16/10/31.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

@class ZETypicalCaseView;

@protocol ZETypicalCaseViewDelegate <NSObject>


/**
 进入经典案例详情

 @param obj 案例详情
 */
-(void)goTypicalCaseDetailVC:(id)obj;
/**
 下拉刷新
 */
-(void)loadNewData;
/**
 上提加载
 */
-(void)loadMoreData;


/**
 筛选经典案例

 @param fileType 文件类型
 */
-(void)screenFileType:(NSString *)fileType;


/**
  最新 或者 最热排序

 @param condition 排序条件
 */
-(void)sortConditon:(NSString *)condition;


/**
 
 */
-(void)showType;

@end

#import <UIKit/UIKit.h>

@interface ZETypicalCaseView : UIView

@property (nonatomic,weak) id <ZETypicalCaseViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withEnterType:(ENTER_CASE_TYPE)type;

-(void)reloadFirstView:(NSArray *)arrData;
-(void)reloadMoreDataView:(NSArray *)arrData;


/**
 *  停止刷新
 */
-(void)headerEndRefreshing;

-(void)loadNoMoreData;
@end
