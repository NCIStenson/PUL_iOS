//
//  ZEWorkStandardHomeView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/17.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEKLB_CLASSICCASE_INFOModel.h"

@class ZETypicalCaseHomeView;

@protocol ZETypicalCaseHomeViewDelegate <NSObject>

-(void)goMoreView:(ENTER_CASE_TYPE)enterType ;

/**
 进入经典案例详情
 
 @param obj 案例详情
 */
-(void)goTypicalCaseDetailVC:(id)obj;

@end

@interface ZETypicalCaseHomeView : UIView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * bannerScrollView;
    UIPageControl * pageControl;
    
    UITableView * _contentTableView;
}

@property (nonatomic,weak) id <ZETypicalCaseHomeViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray * recommandClassicalCaseArr;
@property (nonatomic,strong) NSMutableArray * topClassicalCaseArr;
@property (nonatomic,strong) NSMutableArray * hotClassicalCaseArr;

-(void)reloadBannerView:(NSArray *)dataArr;

-(void)reloadRecommandView:(NSArray *)dataArr;
-(void)reloadNewestView:(NSArray *)dataArr;

@end
