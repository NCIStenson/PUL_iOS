//
//  ZESkillDetailView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/18.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZESkillListModel.h"
@class ZESkillDetailView;

@protocol ZESkillDetailViewDelegate <NSObject>

-(void)goCourseDetail:(NSDictionary *)dic;

@end
@interface ZESkillDetailView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _contentView;
    ZESkillListModel * _skillListModel;
    
    NSMutableArray * _dataArr;
}

@property (nonatomic,weak) id <ZESkillDetailViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withData:(ZESkillListModel *)listM;

-(void)reloadContentWithData:(NSArray *)arr;

@end
