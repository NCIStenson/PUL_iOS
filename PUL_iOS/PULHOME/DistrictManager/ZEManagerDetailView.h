//
//  ZEManagerDetailView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

typedef enum : NSUInteger {
    MANAGERDETAIL_TYPE_INTR,
    MANAGERDETAIL_TYPE_CASE,
    MANAGERDETAIL_TYPE_COMMENT,
} MANAGERDETAIL_TYPE;

#import <UIKit/UIKit.h>
#import "ZEDistrictManagerModel.h"

@class ZEManagerDetailView;

@protocol ZEManagerDetailViewDelegate <NSObject>

-(void)loadMoreData;

-(void)publishComment:(NSString *)commentStr;

-(void)goCourseDetail;

-(void)showCommentView;

-(void)goNextCourseDetail:(id)detail;

-(void)goMyCollectCourse;

-(void)goManagerPractice:(ZEDistrictManagerModel *)managerModel;

-(void)goCoreseStandard;

-(void)goNewQuestionListVC:(ZEDistrictManagerModel *)model;

@end

@interface ZEManagerDetailView : UIView <UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _contentView;
    UIView * tabbarView;
    
    MANAGERDETAIL_TYPE _currentDetailType;
    
    UIView * navSegmentControlView;
    UIView * inputView;
    
    UITextField * inputField;
    
    UITapGestureRecognizer * tap;
    
    NSDictionary * managerDetailDic;
    ZEDistrictManagerModel * detailManagerModel;
    
}

@property (nonatomic,weak) id <ZEManagerDetailViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *aboutArr;
@property (nonatomic,strong) NSMutableArray *commentArr;

-(id)initWithFrame:(CGRect)frame withData:(ZEDistrictManagerModel *)managerModel;

-(void)reloadAboutCourseData:(NSArray *)arr;

-(void)reloadSectionView:(NSDictionary *)detailDic;

-(void)reloadFirstView:(NSArray *)arrData;

-(void)reloadMoreDataView:(NSArray *)arrData;

-(void)headerEndRefreshing;

-(void)loadNoMoreData;

-(void)publishCommentSuccess;

@end
