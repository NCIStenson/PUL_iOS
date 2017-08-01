//
//  ZEPULHomeView.h
//  PUL_iOS
//
//  Created by Stenson on 17/7/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEPULHomeView;

@protocol ZEPULHomeViewDelegate <NSObject>


/**
 加载新最新数据
 */
-(void)loadNewData;

/**
 加载更多最新数据
 */
-(void)loadMoreData;


-(void)serverBtnClick:(NSInteger)tag;

-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel;

-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel;
@end

@interface ZEPULHomeView : UIView

@property(nonatomic,weak) id <ZEPULHomeViewDelegate> delegate;

@property (nonatomic, strong) dispatch_source_t bannerTimer;
@property (nonatomic, strong) dispatch_source_t commandStudyTimer;


-(id)initWithFrame:(CGRect)frame;

-(void)reloadCommandStudy:(NSArray *)arr;

// 刷新 第一页 最新的问题数据
-(void)reloadFirstView:(NSArray *)dataArr;

// 刷新 以后 最新的问题数据
-(void)reloadContentViewWithArr:(NSArray *)dataArr ;

/**
 没有更多最新问题数据
 */
-(void)loadNoMoreData;

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshing;

-(void)endRefreshing;

-(void)reloadContentViewWithNoMoreData:(NSArray *)dataArr;


@end
