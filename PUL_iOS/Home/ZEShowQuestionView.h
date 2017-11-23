//
//  ZEShowQuestionView.h
//  PUL_iOS
//
//  Created by Stenson on 16/7/29.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZENewQuetionLayout.h"
#import "ZENewQuestionListCell.h"

@class ZEShowQuestionView;

@protocol ZEShowQuestionViewDelegate <NSObject>

-(void)goSearch:(NSString *)str;

/**
 *  刷新界面
 */
-(void)loadNewData;

/**
 *  加载更多数据
 */
-(void)loadMoreData;


-(void)deleteMyQuestion:(NSString *)questionSEQKEY;

-(void)deleteMyAnswer:(NSString *)questionSEQKEY;

/**
 回答问题
 
 @param questionInfo 问题详情
 */
-(void)answerQuestion:(ZEQuestionInfoModel *)questionInfo;

/**
 点赞
 
 @param questionInfo 问题详情
 */
-(void)giveQuestionPraise:(ZEQuestionInfoModel *)questionInfo;
-(void)presentWebVCWithUrl:(NSString *)urlStr;
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel;

@end

@interface ZEShowQuestionView : UIView<UIScrollViewDelegate>

@property (nonatomic,weak) id <ZEShowQuestionViewDelegate> delegate;
@property (nonatomic,copy) NSString * searchStr;

-(id)initWithFrame:(CGRect)frame withEnterType:(QUESTION_LIST)enterType;

-(void)reloadFirstView:(NSArray *)array;
-(void)reloadContentViewWithArr:(NSArray *)arr;

-(void)headerEndRefreshing;
-(void)loadNoMoreData;
@end
