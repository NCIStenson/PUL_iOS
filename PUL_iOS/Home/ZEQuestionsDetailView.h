//
//  ZEQuestionsDetailView.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/4.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEQuestionsDetailView;
@protocol ZEQuestionsDetailViewDelegate <NSObject>

/**
 *  @author Stenson, 16-08-19 15:08:41
 *
 *  采纳答案
 *
 *  @param infoModel <#infoModel description#>
 *  @param typeModel <#typeModel description#>
 */
-(void)acceptTheAnswerWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                        withAnswerInfo:(ZEAnswerInfoModel *)answerModel;

-(void)giveLikes:(NSString *)answerSeqkey withButton:(UIButton *)button;

@end

@interface ZEQuestionsDetailView : UIView

@property (nonatomic,weak) id <ZEQuestionsDetailViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame
  withQuestionInfo:(ZEQuestionInfoModel *)infoModel
        withIsTeam:(BOOL)isTeam;

-(void)reloadData:(NSArray *)arr;

-(void)disableSelect;

@end
