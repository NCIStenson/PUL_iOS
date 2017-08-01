//
//  ZETypicalCaseDetailView.h
//  PUL_iOS
//
//  Created by Stenson on 16/11/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZETypicalCaseView;

@protocol ZETypicalCaseViewDelegate <NSObject>

-(void)showCourseView;

-(void)showCommentView;

-(void)publishComment:(NSString *)commentStr;

-(void)loadMoreData;

-(void)playCourswareVideo:(NSString *)filepath;

-(void)playLocalVideoWithPath:(NSString *)videoPath;

-(void)playCourswareImagePath:(NSString *)filepath;

-(void)loadFile:(NSString *)filePath;
@end

@interface ZETypicalCaseDetailView : UIView

@property (nonatomic,weak) id <ZETypicalCaseViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dataDic;

-(void)publishCommentSuccess;

-(void)reloadFirstView:(NSArray *)arrData;
-(void)reloadMoreDataView:(NSArray *)arrData;

-(void)reloadSectionView:(NSDictionary *)detailDic;

/**
 *  停止刷新
 */
-(void)headerEndRefreshing;

-(void)loadNoMoreData;
@end
