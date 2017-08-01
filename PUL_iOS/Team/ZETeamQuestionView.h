//
//  ZETeamQuestionView.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/13.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@class ZETeamQuestionView;
@protocol ZETeamQuestionViewDelegate <NSObject>

@optional
/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel;

/**
 加载新最新数据
 */
-(void)loadNewData:(TEAM_CONTENT)contentPage;

/**
 加载更多最新数据
 */
-(void)loadMoreData:(TEAM_CONTENT)contentPage;

/**
 搜索
 
 @param str
 */
-(void)goSearch:(NSString *)str;


-(void)goAnswerQuestionVC:(ZEQuestionInfoModel *)_questionInfoModel;


/**
 点击比一比按钮 发送请求
 */
-(void)showRankingListView;

/**
 进入团队聊天组
 */
-(void)goTeamChatRoom;


/**
 选择月份

 @param yearMonth 选中的年月
 */
-(void)selectMonthStr:(NSString *)yearMonth;

@end

@interface ZETeamQuestionView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,weak) id <ZETeamQuestionViewDelegate> delegate;

@property (nonatomic,copy) NSString * practiceURL;  // 每日一练
@property (nonatomic,copy) NSString * teamTestURL;  // 团队测试

@property (nonatomic,assign) BOOL isPractice;  //  是否正在练习

-(id)initWithFrame:(CGRect)frame;


// 刷新 第一页 最新的问题数据
-(void)reloadFirstView:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page;

// 刷新 以后 最新的问题数据
-(void)reloadContentViewWithArr:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page;

/**
 没有更多最新问题数据
 */
-(void)loadNoMoreDataWithHomeContent:(TEAM_CONTENT)content_page;

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshingWithHomeContent:(TEAM_CONTENT)content_page;

-(void)endRefreshingWithHomeContent:(TEAM_CONTENT)content_page;

-(void)reloadContentViewWithNoMoreData:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page;


/**
 滚动到指定视图

 @param toContent 需要显示的视图索引
 */
-(void)scrollContentViewToIndex:(TEAM_CONTENT)toContent;


/**
 刷新比一比界面
 */
-(void)reloadTeamViewRankingList:(NSArray *)arr withRankingContent:(TEAM_RANKING)ranking;



/**
 刷新练一练界面
 */
-(void)refreshPracticeWebView;


/**
 网页界面弹出框
 */
-(void)showWebViewAlert;

- (void)deleteWebCache;

@end
