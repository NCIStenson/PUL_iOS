//
//  ZEExpertListView.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/28.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZETeamCircleModel.h"
#import "ZEExpertModel.h"

@class ZEExpertListView;

@interface ZEExpertListViewCell : UITableViewCell
{
}
@property (nonatomic,strong) ZEExpertModel * expertModel;
@property (nonatomic,weak) ZEExpertListView * expertListView;
@property (nonatomic,strong) UIView * baseView;

@end

@protocol ZEExpertListViewDelegate <NSObject>

-(void)goExpertVCDetail:(ZEExpertModel *)expertModel;
//

-(void)goExpertHistoryAnswer:(ZEExpertModel *)expertModel;
-(void)goExpertOnlineAnswer:(ZEExpertModel *)expertModel;

-(void)goSearchWithSearchStr:(NSString *)str;

/**
 最新 或者 最热排序
 
 @param condition 排序条件
 */
-(void)sortConditon:(NSString *)condition;

-(void)loadNewData;
-(void)loadMoreData;

@end

@interface ZEExpertListView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * contentTableView;
    UIButton * _currentBtn;
    UIButton * levelBtn;
    UIButton * questionNumBtn;
}
@property (nonatomic,weak) id <ZEExpertListViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray * teamsDataArr;

@property (nonatomic,strong) UITextField *  questionSearchTF;

-(void)reloadExpertListViw:(NSArray *)dataAr;

-(void)loadNoMoreData;

-(void)headerEndRefreshing;

-(void)endRefreshing;

@end
