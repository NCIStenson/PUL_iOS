//
//  ZEDistrictManagerHomeView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
typedef enum : NSUInteger {
    SORT_ALL,
    SORT_RECOMMAND,
} SORT_TYPE;

typedef enum : NSUInteger {
    ORDER_BY_DATE = 1,
    ORDER_BY_CLICKCOUNT,
} ORDER_BY_TYPE;

#import <UIKit/UIKit.h>
#import "ZEDistrictManagerCell.h"
#import "ZEShowOptionView.h"

@class ZEDistrictManagerHomeView;

@protocol ZEDistrictManagerHomeViewDelegate<NSObject>

-(void)sendRequestWithOrder:(ORDER_BY_TYPE)index;

-(void)reloadRequest;

-(void)goManagerDetail:(id)obj;

-(void)goRecommondViewRequest;

-(void)loadMoreRecommondRequest:(NSInteger)index;

-(void)goMyCollectCourse;

-(void)goManagerPractice;

-(void)goNewQuestionListVC;

-(void)goChapterPractice:(NSDictionary *)dic;

-(void)goCourseSearchView;

-(void)loadMoreDataWithSection:(NSInteger)index withTypeDic:(NSDictionary *)dic;

@end

@interface ZEDistrictManagerHomeView : UIView<UITableViewDelegate,UITableViewDataSource,ZEShowOptionViewDelegate,UITextFieldDelegate>
{
    UITableView *  _contentView;
    UIView * tabbarView;
    
    UIView * btnUnderlineView;
    UIButton * allBtn;
    UIButton * hotestBtn;
    UIButton *  _orderBtn;
    SORT_TYPE _currentSortType;     //   全部 推荐

    ORDER_BY_TYPE  _currentSelectOrder;  //   按热度 按时间
    
    NSMutableArray * allDataArr;
    NSMutableArray * allDetailDataArr;
    NSMutableArray * allRecommondDataArr;
    
    NSMutableArray * allTotalCountArr;
}

@property (nonatomic,weak)  id <ZEDistrictManagerHomeViewDelegate> delegate;

@property (nonatomic,strong) UITextField * questionSearchTF;

-(void)reloadDataWithArr:(NSArray *)arr;

-(void)reloadSectionWithIndex:(NSInteger)index withArr:(NSArray *)arr;

-(void)reloadFirstRecommandDataWithArr:(NSArray *)arr;

-(void)reloadRecommandDataWithArr:(NSArray *)arr;

-(void)endFooterRefreshingWithNoMoreData;

@end
