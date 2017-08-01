//
//  ZEQuestionsView.h
//  PUL_iOS
//
//  Created by Stenson on 16/7/29.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEQuestionTypeCache.h"
#import "ZEQuestionInfoModel.h"
#import "ZEQuestionTypeModel.h"

typedef NS_ENUM(NSInteger,QUESTION_SECTION_TYPE){
    QUESTION_SECTION_TYPE_RECOMMEND,
    QUESTION_SECTION_TYPE_NEWEST
};

@class ZEQuestionsView;

@protocol ZEQuestionsViewDelegate <NSObject>

/**
 *  @author Stenson, 16-07-29 16:07:10
 *
 *  更多推荐
 */
-(void)goMoreRecommend;
/**
 *  @author Stenson, 16-08-04 09:08:55
 *
 *  进入问题详情页
 *
 *  @param indexPath 选择第几区第几个问题
 */
-(void)goQuestionDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                         withQuestionType:(ZEQuestionTypeModel *)typeModel;

/**
 *  @author Stenson, 16-08-19 11:08:05
 *
 *  开始搜索
 */
-(void)goSearchWithStr:(NSString *)inputStr;

@end


@interface ZEQuestionsView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) id <ZEQuestionsViewDelegate> delegate;

#pragma mark - Public Method

-(void)reloadContentViewWithArr:(NSArray *)arr;
-(id)initWithFrame:(CGRect)frame;

@end
