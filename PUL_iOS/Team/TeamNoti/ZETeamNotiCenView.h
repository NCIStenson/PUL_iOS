//
//  ZETeamNotiCenView.h
//  PUL_iOS
//
//  Created by Stenson on 17/5/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZETeamNotiLayout.h"

@interface ZETeamNotiCenTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel * contentLab;     // 内容
@property (nonatomic,strong) UILabel * disUsername;  // 发布人名称
@property (nonatomic,strong) UILabel * receiptCount;  // 回执数量
@property (nonatomic,strong) UILabel * dateLab;        // 日期
@property (nonatomic,strong) UIView * lineView;        // 日期

- (void)setLayout:(ZETeamNotiLayout *)layout;

@end

@class ZETeamNotiCenView;

@protocol ZETeamNotiCenViewDelegate <NSObject>

-(void)didSelectNoti:(ZETeamNotiCenModel *)notiModel;

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


@end

@interface ZETeamNotiCenView : UIView

@property (nonatomic,weak) id <ZETeamNotiCenViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadFirstView:(NSArray *)array;
-(void)reloadContentViewWithArr:(NSArray *)arr;

-(void)headerEndRefreshing;
-(void)loadNoMoreData;

@end
