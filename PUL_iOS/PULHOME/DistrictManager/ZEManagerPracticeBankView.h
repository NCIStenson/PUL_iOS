//
//  ZEManagerPracticeBankView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
typedef enum : NSUInteger {
    CONTENT_TYPE_BASE,
    CONTENT_TYPE_PROMOTION,
    CONTENT_TYPE_EXCELLENT,
} CONTENT_TYPE;
#import <UIKit/UIKit.h>
#import "ZEManageCircle.h"

@class ZEManagerPracticeBankView;

@protocol ZEManagerPracticeBankViewDelegate <NSObject>

-(void)goManagerBank:(NSDictionary *)dic withIndex:(NSInteger)index;

@end


@interface ZEManagerPracticeBankView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView * _contentScrollView;
    UIScrollView * _navScrollView;
    UIView * tabbarView;
    
    CONTENT_TYPE _currentContentType;
    UIButton *_currentSelectContentBtn;
    ZEManageCircle * _circle;
    
    NSMutableArray * banksDataArr;
}

@property (nonatomic,weak) id <ZEManagerPracticeBankViewDelegate> delegate;

-(void)reloadContentView:(NSArray *)dataArr;

@end
