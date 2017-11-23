//
//  ZEPersonalNotiView.h
//  PUL_iOS
//
//  Created by Stenson on 17/5/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZETeamNotiCenModel.h"

@class ZEPersonalNotiView;

@protocol ZEPersonalNotiViewDelegate <NSObject>

-(void)didSelectTeamMessage:(ZETeamNotiCenModel *)notiModel;

-(void)didSelectQuestionMessage:(ZETeamNotiCenModel *)notiModel;

-(void)didSelectWebViewWithIndex:(ZETeamNotiCenModel *)notiModel;

/**
 *  刷新界面
 */
-(void)loadNewData;

/**
 *  加载更多数据
 */
-(void)loadMoreData;


/**
 删除数据

 @param notiModel 
 */
-(void)didSelectDeleteBtn:(ZETeamNotiCenModel *)notiModel;


/**
 确认全部删除
 
 @param deleteSeqkeys 多选删除的seqkey
 */
-(void)didSelectDeleteNumberOfDynamic:(NSString *)deleteSeqkeys;


/**
 确认全部删除

 @param deleteSeqkeys <#deleteSeqkeys description#>
 */
-(void)didSelectDeleteAllDynamic;


/**
 全部标为已读
 */
-(void)clearUnreadDynamic;

@end

@interface ZEPersonalNotiView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id <ZEPersonalNotiViewDelegate> delegate;
@property (nonatomic,strong)  UITableView * notiContentView;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadFirstView:(NSArray *)array;
-(void)reloadContentViewWithArr:(NSArray *)arr;

-(void)headerEndRefreshing;
-(void)loadNoMoreData;

- (void)showEitingView:(BOOL)isShow;

@end
