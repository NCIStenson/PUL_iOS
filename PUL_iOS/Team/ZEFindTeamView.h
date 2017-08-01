//
//  ZEFindTeamView.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZETeamCircleModel.h"

@class ZEFindTeamView;

@interface ZEFindTeamCell : UITableViewCell
{
    NSDictionary * dataDic;
}

//- (void)reloadCellView:(NSDictionary *)dic;

@property (nonatomic,weak) ZEFindTeamView * findTeamView;
@property (nonatomic,strong) UIView * baseView;

@end

@protocol ZEFindTeamViewDelegate <NSObject>

-(void)goTeamVCDetail:(ZETeamCircleModel *)teamCircleInfo;

-(void)goApplyJoinTeam:(ZETeamCircleModel *)teamCircleInfo;

@end

@interface ZEFindTeamView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * contentTableView;
}
@property (nonatomic,weak) id <ZEFindTeamViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray * teamsDataArr;

-(void)reloadFindTeamView:(NSArray *)dataArr;

@end
