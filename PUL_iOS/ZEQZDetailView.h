//
//  ZEQZDetailView.h
//  PUL_iOS
//
//  Created by Stenson on 2018/5/25.
//  Copyright © 2018年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEManageCircle.h"

@class ZEQZDetailView;

@protocol ZEQZDetailViewDelegate <NSObject>

-(void)goManagerBank:(NSDictionary *)dic withIndex:(NSInteger)index;

-(void)goStudyCourse:(NSString *)functionCode;

-(void)goTKLL:(NSString *)functionCode;

@end

@interface ZEQZDetailView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView * _contentScrollView;
    UIView * tabbarView;
    
    UIButton *_currentSelectContentBtn;
    ZEManageCircle * _circle;
    
    NSMutableArray * _cellDataArr;
    NSMutableArray * _scoreDataArr;
}

@property (nonatomic,weak) id <ZEQZDetailViewDelegate> delegate;

-(void)reloadContentView:(NSArray *)dataArr withCellDataArr:(NSArray *)cellDataArr;

@end
