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

@end

@interface ZENewQuestionDetailView : UIView<UITableViewDelegate,UITableViewDataSource,ZENewQuestionDetailCellDelegate>
{
    ZEWithoutDataTipsView *tipsView;
    UITableView * contentTableView;
}

@property (nonatomic,weak) id <ZENewQuestionDetailViewDelegate> delegate;
@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;

@property (nonatomic,strong) NSMutableArray * answerInfoArr;
@property (nonatomic,strong) UIButton * praiseBtn;

-(id)initWithFrame:(CGRect)frame
  withQuestionInfo:(ZEQuestionInfoModel *)questionInfo;

-(void)reloadViewWithData:(NSArray *)arr;

@end
