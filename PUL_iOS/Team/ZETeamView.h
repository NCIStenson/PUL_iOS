//
//  ZETeamView.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/7.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKJCollectionViewFlowLayout.h"
#import "MKJCollectionViewCell.h"
#import "MKJCircleLayout.h"

@class ZETeamView;

@protocol ZETeamViewDelegate <NSObject>

//  添加团队页面
-(void)goFindTeamVC;

-(void)goTeamQuestionVC:(NSInteger)selectIndex;

-(void)cellClikcGoTeamQuestionVC:(NSInteger)selectIndex;

@end

@interface ZETeamViewHeaderView: UIView<MKJCollectionViewFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,weak) ZETeamView * teamView;

@property (nonatomic,strong) NSMutableArray * joinTeam;

#pragma mark - Public Method

-(void)reloadCollectionView:(NSArray *)arr;

@end

@interface ZETeamView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    ZETeamViewHeaderView * _headerView;
    UITableView * contentTableView;
    NSArray * alreadyJoinTeamArr;
}

@property (nonatomic,weak) id <ZETeamViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray * dynamicDatasArr; // 动态数组
@property (nonatomic,copy) NSString * teamCircleCode;

#pragma mark - Public Method

-(void)reloadHeaderView:(NSArray *)arr;

-(void)reloadContentView:(NSArray  *)datasArr;

@end

