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

#pragma mark - 自定义功能区跳转页面

/**
 跳转专业圈
 */
-(void)goZYQ;

/**
 跳转专业圈
 */
-(void)goGWCP;

/**
 职业性格测评
 */
-(void)goZYXGCP;

/**
 岗位体系
 */
-(void)goGWTX;

/**
 专家在线
 */
-(void)goZJZX;

/**
 行为规范
 */
-(void)goXWGF;


/**
 在线测试
 */
-(void)goZXCS;

/**
 更多功能
 */
-(void)goMoreFunction;


/**
 签到
 */
-(void)goSinginView;

/**
 发现团队
 */
-(void)goFindTeamView;
/**
 主页问题动态点击
 */
-(void)goQuestionView:(NSString *)QUESTIONID;


/**
 首页搜索

 @param searchStr <#searchStr description#>
 */
-(void)goQuestionSearchView:(NSString *)searchStr;

@end

@interface ZEPULHomeView : UIView

@property(nonatomic,weak) id <ZEPULHomeViewDelegate> delegate;


-(id)initWithFrame:(CGRect)frame;

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


-(void)reloadHeaderView:(NSArray *)arr;


@end
