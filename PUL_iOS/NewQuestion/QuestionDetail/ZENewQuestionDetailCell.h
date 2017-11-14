//
//  ZENewQuestionDetailCell.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZENewDetailLayout.h"

@class ZENewQuestionDetailCell;

@protocol ZENewQuestionDetailCellDelegate <NSObject>


-(void)acceptAnswer:(ZEAnswerInfoModel *)answerInfo;

/**
 对答案进行点赞

 @param answerInfo <#answerInfo description#>
 */
-(void)giveAnswerPraise:(ZEAnswerInfoModel *)answerInfo;

@end

@interface ZEDetailCellReplyView : UIView

@property (nonatomic,strong) UIView * contentBackgroundView;

@property (nonatomic,strong) UILabel * replyContentLabOne;
@property (nonatomic,strong) UILabel * replyContentLabTwo;
@property (nonatomic,strong) UILabel * totalNum;

@property (nonatomic,strong) ZENewDetailLayout * detailLayout;
@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;
@property (nonatomic,weak) ZENewQuestionDetailCell * detailCell;

@end

@interface ZENewQuetionDetailMessageView : UIView

@property (nonatomic,strong) UILabel * timeLab;
@property (nonatomic,strong) UIButton * acceptBtn;
@property (nonatomic,strong) UIButton * praiseBtn;

@property (nonatomic,strong) ZENewDetailLayout * detailLayout;
@property (nonatomic,weak) ZENewQuestionDetailCell * detailCell;

@end


@interface ZENewQuetionDetailSingleAnswerView : UIView

@property (nonatomic,strong) UIImageView * headerImageView;
@property (nonatomic,strong) UILabel * nameLab;
@property (nonatomic,strong) UILabel * timeLab;

@property (nonatomic,strong) ZENewDetailLayout * detailLayout;
@property (nonatomic,strong) UILabel * contentLab;

@property (nonatomic,weak) ZENewQuestionDetailCell * detailCell;

@end

#pragma mark - 问题图片
@interface ZENewDetailCellImageContent:UIView

@property (nonatomic,strong) PYPhotosView *linePhotosView;
@property (nonatomic,strong) ZENewDetailLayout *layout;
@property (nonatomic,weak) ZENewQuestionDetailCell * listCell;

@end

@interface ZENewQuestionDetailCell : UITableViewCell

@property (nonatomic,weak) id <ZENewQuestionDetailCellDelegate> delegate;

@property (nonatomic,strong) ZENewDetailLayout * detailLayout;

@property (nonatomic,strong) ZENewQuetionDetailSingleAnswerView * answerView;
@property (nonatomic,strong) ZENewQuetionDetailMessageView * messageView;
@property (nonatomic,strong) ZENewDetailCellImageContent * imageContentView;
@property (nonatomic,strong) ZEDetailCellReplyView * replyView;

@end
