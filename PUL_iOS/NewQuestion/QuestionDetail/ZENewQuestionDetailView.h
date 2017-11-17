//
//  ZENewQuestionDetailView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEWithoutDataTipsView.h"
#import "ZENewQuestionDetailCell.h"
#import "ZEShowOptionView.h"

@class ZENewQuestionDetailView;

@protocol ZENewQuestionDetailViewDelegate <NSObject>

-(void)answerQuestion;

/**
 答案点赞
 
 @param questionInfo 问题详情
 */
-(void)giveAnswerPraise:(ZEAnswerInfoModel *)answerInfo;

/**
 点赞
 
 @param questionInfo 问题详情
 */
-(void)giveQuestionPraise;

-(void)acceptBestAnswer:(ZEAnswerInfoModel *)answerInfo;

-(void)enterAnswerDetailView:(ZEAnswerInfoModel *)answerInfo;

-(void)sendRequestWithOrder:(NSInteger)order;

@end

@interface ZENewQuestionDetailView : UIView<UITableViewDelegate,UITableViewDataSource,ZENewQuestionDetailCellDelegate,ZEShowOptionViewDelegate>
{
    ZEWithoutDataTipsView *tipsView;
    UITableView * contentTableView;
    
    NSInteger _currentSelectOrder;
}

@property (nonatomic,weak) id <ZENewQuestionDetailViewDelegate> delegate;
@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;

@property (nonatomic,strong) NSMutableArray * answerInfoArr;
@property (nonatomic,strong) UIButton * praiseBtn;
@property (nonatomic,strong) UIButton * orderBtn;

-(id)initWithFrame:(CGRect)frame
  withQuestionInfo:(ZEQuestionInfoModel *)questionInfo;

-(void)reloadViewWithData:(NSArray *)arr;

@end
