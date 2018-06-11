//
//  ZEPULHomeView.h
//  PUL_iOS
//
//  Created by Stenson on 17/7/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEPULHomeModel.h"

@class ZEPULHomeView;
@class ZEHomeOptionView;

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

-(void)goZJJD;
-(void)goDXAL;
-(void)goHYGF;
-(void)goJNXX;


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
 技能清单
 */
-(void)goJNQD;

-(void)goXXKJ;

-(void)goLXTK;

-(void)goJNBG;


/**
 根据functionCode 跳转 指定网页界面

 @param functionCode 指定的 functionCode = actionFlag
 */
-(void)goWebVC:(NSString *)functionCode;

/**
 更多功能
 */
-(void)goMoreFunction;

#pragma mark - 首页动态点击跳转

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

-(void)didSelectWebViewWithIndex:(NSString *)urlpath;

/**
 首页搜索

 @param searchStr <#searchStr description#>
 */
-(void)goQuestionSearchView:(NSString *)searchStr;

-(void)ignoreHomeDynamic:(ZEPULHomeModel *)model;

-(void)goDistrictManagerHome;

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

@protocol ZEHomeOptionViewDelegate <NSObject>

-(void)ignoreDynamic;

@end

@interface ZEHomeOptionView : UIView

@property(nonatomic,weak) id <ZEHomeOptionViewDelegate> delegate;

@property (nonatomic,assign) CGRect rect;

@end

