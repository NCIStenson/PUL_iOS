//
//  ZEHomeView.h
//  PUL_iOS
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEHomeView;
@protocol ZEHomeViewDelegate <NSObject>

/**
 *  @author Stenson, 16-07-27 10:07:18
 *
 *  去签到
 */
-(void)goSinginView;
/**
 *  @author Stenson, 16-07-27 10:07:18
 *
 *  去经典案例详情
 */
-(void)goTypicalDetail:(NSDictionary *)detailDic;

/**
 *  @author Stenson, 16-07-29 09:07:17
 *
 *  更多问题
 */
-(void)goMoreQuestionsView;
/**
 *  @author Stenson, 16-07-29 09:07:46
 *
 *  更多专家解答
 */
-(void)goMoreExpertAnswerView;

/**
 *  @author Stenson, 16-07-29 09:07:16
 *
 *  更多典型案例
 */
-(void)goMoreCaseAnswerView;

/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel;


/**
 加载新最新数据
 */
-(void)loadNewData:(HOME_CONTENT)contentPage;

/**
 加载更多最新数据
 */
-(void)loadMoreData:(HOME_CONTENT)contentPage;

/**
 搜索

 @param str 
 */
-(void)goSearch:(NSString *)str;


-(void)goNotiVC;


/**
 根据问题分类展示问题列表
 */
-(void)goTypeQuestionVC;


-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel;


/**
 返回上级界面
 */
-(void)goBack;

/**
 提问按钮被点击
 */
-(void)askQuestion;

@end

@interface ZEHomeView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) id <ZEHomeViewDelegate> delegate;

@property(nonatomic,strong) UIButton * notiBtn;

-(id)initWithFrame:(CGRect)frame;


// 刷新 第一页 最新的问题数据
-(void)reloadFirstView:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;

// 刷新 以后 最新的问题数据
-(void)reloadContentViewWithArr:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;

/**
 没有更多最新问题数据
 */
-(void)loadNoMoreDataWithHomeContent:(HOME_CONTENT)content_page;

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshingWithHomeContent:(HOME_CONTENT)content_page;

-(void)endRefreshingWithHomeContent:(HOME_CONTENT)content_page;

-(void)reloadContentViewWithNoMoreData:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;

/**** 已经签到过界面 ***/
-(void)reloadSigninedViewDay:(NSString *)dayStr numbers:(NSString *)number;

-(void)hiddenSinginView;

@end
