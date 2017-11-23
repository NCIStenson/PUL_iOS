//
//  ZENewQuestionListView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZENewQuestionListView;

@protocol ZENewQuestionListViewDelegate <NSObject>
/**
 返回上级界面
 */
-(void)goBack;

/**
 提问按钮被点击
 */
-(void)askQuestion;

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
 加载新最新数据
 */
-(void)loadNewData:(HOME_CONTENT)contentPage;

/**
 加载更多最新数据
 */
-(void)loadMoreData:(HOME_CONTENT)contentPage;

/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel;

/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题链接
 *
 */
-(void)presentWebVCWithUrl:(NSString *)urlStr;

/**
 进入问题搜索界面
 */
-(void)goSearchView;
@end

@interface ZENewQuestionListView : UIView

@property (nonatomic,weak) id <ZENewQuestionListViewDelegate> delegate;

@property (nonatomic,strong) UISegmentedControl * segmentedControl;

-(void)reloadFirstView:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;

-(void)reloadContentViewWithArr:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;

-(void)loadNoMoreDataWithHomeContent:(HOME_CONTENT)content_page;

-(void)headerEndRefreshingWithHomeContent:(HOME_CONTENT)content_page;

-(void)endRefreshingWithHomeContent:(HOME_CONTENT)content_page;

@end
