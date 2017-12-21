//
//  ZESkillListView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/12.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZESkillListView;


@protocol ZESkillListViewDelegate <NSObject>

-(void)goSkillDetailWithObject:(id)obj;

@end

@interface ZESkillListView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _contentView;
    
    NSMutableArray * yesArr;
    NSMutableArray * noArr;
}

@property (nonatomic,weak) id <ZESkillListViewDelegate> delegate;

-(void)reloadDataWithData:(NSArray *)arr withIndex:(NSInteger)index;

@end
