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
    NSDictionary * dataDic;
}

//- (void)reloadCellView:(NSDictionary *)dic;

@property (nonatomic,weak) ZEExpertListView * expertListView;
@property (nonatomic,strong) UIView * baseView;

@end

@protocol ZEExpertListViewDelegate <NSObject>

-(void)goExpertVCDetail:(ZEExpertModel *)expertModel;
//
//-(void)goApplyJoinTeam:(ZETeamCircleModel *)teamCircleInfo;

@end

@interface ZEExpertListView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * contentTableView;
}
@property (nonatomic,weak) id <ZEExpertListViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray * teamsDataArr;

-(void)reloadExpertListViw:(NSArray *)dataAr;

@end
