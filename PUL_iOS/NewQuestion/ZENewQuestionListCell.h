//
//  ZENewQuestionListCell.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZENewQuetionLayout.h"

@class ZENewQuestionListCell;


@protocol ZENewQuestionListCellDelegate <NSObject>


/**
 回答问题
 
 @param questionInfo 问题详情
 */
-(void)answerQuestion:(ZEQuestionInfoModel *)questionInfo;

/**
 点赞

 @param questionInfo 问题详情
 */
-(void)giveQuestionPraise:(ZEQuestionInfoModel *)questionInfo;

@end

#pragma mark - 处理问题方式  回答 点赞
@interface ZEListCellQuestionModeContent:UIView

@property (nonatomic,strong) UIButton * answerButton;
@property (nonatomic,strong) UIButton * praiseButton;

@property (nonatomic,strong) ZENewQuetionLayout * layout;
@property (nonatomic,weak) ZENewQuestionListCell * listCell;

@end

#pragma mark - 指定回答
@interface ZEListCellQuestionTargetAskContent:UIView

@property (nonatomic,weak) ZENewQuestionListCell * listCell;

@end


#pragma mark - 标签分类
@interface ZEListCellQuestionTypeContent:UIView
@property (nonatomic,strong) UILabel * typeContentLab;
@property (nonatomic,weak) ZENewQuestionListCell * listCell;

@end

#pragma mark - 问题图片
@interface ZEListCellImageContent:UIView

@property (nonatomic,strong) PYPhotosView *linePhotosView;
@property (nonatomic,strong) ZENewQuetionLayout *layout;
@property (nonatomic,weak) ZENewQuestionListCell * listCell;

@end

#pragma mark - 问题文本
@interface ZEListCellTextContent:UIView

@property (nonatomic,strong) UILabel * contentLab;

@property (nonatomic,strong) UILabel * seeAllExplainLab;

@property (nonatomic,weak) ZENewQuestionListCell * listCell;

@end

#pragma mark - 个人信息
@interface ZEListCellPersonalMessage:UIView

@property (nonatomic,strong) UIImageView * headerImageView;
@property (nonatomic,strong) UILabel * nameLab;
@property (nonatomic,strong) UILabel * timeLab;

@property (nonatomic,strong) UIImageView * bounsImage;
@property (nonatomic,strong) UILabel * bounsLab;

@property (nonatomic,weak) ZENewQuestionListCell * listCell;

@end

@interface ZENewQuestionListCell : UITableViewCell

-(id)initQuestionDetailHeaderView;

@property (nonatomic,weak) id <ZENewQuestionListCellDelegate> delegate;

@property (nonatomic,strong) ZEListCellPersonalMessage * personalMessageView;
@property (nonatomic,strong) ZEListCellTextContent * textContenView;
@property (nonatomic,strong) ZEListCellImageContent * imageContentView;
@property (nonatomic,strong) ZEListCellQuestionTypeContent * typeContentView;
@property (nonatomic,strong) ZEListCellQuestionTargetAskContent * targetAskContent;
@property (nonatomic,strong) ZEListCellQuestionModeContent * modelContentView;

- (void)setLayout:(ZENewQuetionLayout *)layout;

@end
