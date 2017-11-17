//
//  ZENewSearchQuestionView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZENewQuetionLayout.h"
#import "ZENewQuestionListCell.h"
#import "ZEAskQuestionTypeView.h"

@class ZENewSearchQuestionView;

@protocol ZENewSearchQuestionViewDelegate <NSObject>

/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel;

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

-(void)goBack;

-(void)hiddenWithoutTipsView;

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


/**
 进行分类搜索

 @param typeCode 子分类
 @param parentCode 父级分类
 */
-(void)goTypeSearchWithTypeCode:(NSString *)typeCode
                 withParentCode:(NSString *)parentCode;

@end

@interface ZENewSearchQuestionView : UIView

@property (nonatomic,weak) id <ZENewSearchQuestionViewDelegate> delegate;
@property (nonatomic,copy) NSString * searchStr;

-(id)initWithFrame:(CGRect)frame withEnterType:(QUESTION_LIST)enterType;

-(void)reloadFirstView:(NSArray *)array;
-(void)reloadContentViewWithArr:(NSArray *)arr;

-(void)headerEndRefreshing;
-(void)loadNoMoreData;
@end

