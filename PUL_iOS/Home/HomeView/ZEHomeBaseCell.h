//
//  ZEHomeBaseCell.h
//  PUL_iOS
//
//  Created by Stenson on 17/2/22.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEHomeLayout.h"

@class ZEHomeBaseCell;

@interface ZEHomeQuestionUserMessageView : UIView

@property (nonatomic,strong) UIImageView * userMessageImageView; // 提问人头像
@property (nonatomic,strong) UILabel * userNickName; // 提问人昵称
@property (nonatomic,strong) UILabel * questionAskTime;  // 问题发表时间

@property (nonatomic, weak) ZEHomeBaseCell *cell;

@end

@interface ZEHomeQuestionExplainView : UIView

@property (nonatomic,strong) YYAnimatedImageView * bonusImageView;  // 悬赏图标
@property (nonatomic,strong) YYAnimatedImageView * bonusScoreView;  // 悬赏分数图标

@property (nonatomic,strong) YYLabel * questionContentLab;  // 问题提问内容

@property (nonatomic, weak) ZEHomeBaseCell *cell;

@end

@interface ZEHomeQuestionImageView : UIView

@property (nonatomic,strong) YYAnimatedImageView * questionImageView;  // 问题提问带有图片

@property (nonatomic, weak) ZEHomeBaseCell *cell;

@end

@interface ZEHomeTagView : UIView

@property (nonatomic,strong) YYAnimatedImageView * questionTagImageView;  // 标签图标
@property (nonatomic,strong) YYLabel * tagContentLab;  // 标签内容

@property (nonatomic, weak) ZEHomeBaseCell *cell;

@end

@interface ZEHomeAnswerMessageView : UIView

@property (nonatomic,strong) YYLabel * answerNums;  // 回答数
@property (nonatomic,strong) UIButton * answerBtn; // 回答按钮

@property (nonatomic, weak) ZEHomeBaseCell *cell;

@end

@interface ZEHomeBaseView : UIView

@property (nonatomic,strong) ZEHomeQuestionUserMessageView * homeQueUserMsgView; // 用户提问信息
@property (nonatomic,strong) ZEHomeQuestionExplainView * homeQueExplainView; // 用户提问内容
@property (nonatomic,strong) ZEHomeQuestionImageView * homeQueImageView; // 用户提问图片
@property (nonatomic,strong) ZEHomeAnswerMessageView * homeAnswerMsgView; // 用户提问图片
@property (nonatomic,strong) ZEHomeTagView * homeQueTagView; // 问题标签页面

@property (nonatomic, strong) ZEHomeLayout *layout;
@property (nonatomic, weak) ZEHomeBaseCell *cell;

@end

@protocol ZEHomeBaseCellDelegate;

@interface ZEHomeBaseCell : UITableViewCell

@property (nonatomic,strong) ZEHomeBaseView * homeView; // 用户提问信息

@end
@protocol ZEHomeBaseCellDelegate <NSObject>

- (void)cellDidClickAtIndex:(NSUInteger)index;

- (void)cell:(ZEHomeBaseCell *)cell didClickImageAtIndex:(NSUInteger)index;

@end

