//
//  ZEAskTeamQuestionView.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEAskQuestionTypeView.h"

@class ZEAskTeamQuestionView;

@protocol ZEAskTeamQuestionViewDelegate <NSObject>

/**
 *  @author Stenson, 16-08-17 15:08:49
 *
 *  拍照还是选择图片
 */
-(void)takePhotosOrChoosePictures;

/**
 *  @author Stenson, 16-08-17 15:08:27
 *
 *  选择问题分类
 */
//-(void)showQuestionType:(ZEAskQuesView *)askQuesView;

-(void)deleteSelectedImageWIthIndex:(NSInteger)index;


/**
 指定人员回答
 */
-(void)goChoooseMemberVC;


/**
 选择分类时修改问题title
 */
-(void)changeAskTeamQuestionTitle;

@end

@interface ZEAskTeamQuestionView : UIView

@property (nonatomic,weak) id <ZEAskTeamQuestionViewDelegate> delegate;

@property (nonatomic,copy) NSString * SUMPOINTS; // 当前账户的总积分
@property (nonatomic,assign) BOOL isAnonymousAsk; //  是否匿名提问
@property (nonatomic,copy) NSString * goldScore;  // 悬赏值

@property (nonatomic,strong) UIButton * designatedNumberBtn;
@property (nonatomic,strong) UITextView * inputView;
/************** 问题主键 *************/
@property (nonatomic,copy) NSString * quesTypeSEQKEY;

/************** 修改问题时传入的问题Model *************/

@property (nonatomic,strong) ZEQuestionInfoModel * QUESINFOM;

@property (nonatomic,strong) ZEAskQuestionTypeView * askTypeView;

-(id)initWithFrame:(CGRect)frame;

-(id)initWithFrame:(CGRect)frame withQuestionInfoM:(ZEQuestionInfoModel *)quesInfoM;

-(void)reloadChoosedImageView:(id)choosedImage;

/**
 刷新当前拥有积分分数
 */
-(void)reloadRewardGold:(NSString *)sumpoints;


/**
 刷新

 */
-(void)reloadChooseMembersBtn:(NSString *)nameSre;

@end
