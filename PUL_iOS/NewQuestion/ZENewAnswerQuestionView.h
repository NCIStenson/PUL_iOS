//
//  ZEAnswerQuestionsView.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

//
//  ZEAskQuesView.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZENewAnswerQuestionView;

@protocol ZENewAnswerQuestionViewDelegate <NSObject>

/**
 *  @author Stenson, 16-08-17 15:08:49
 *
 *  拍照还是选择图片
 */
-(void)takePhotosOrChoosePictures;
/**
 *  @author Stenson, 16-08-17 15:08:08
 *
 *  删除图片
 *  @param index 图片的顺序
 */
-(void)deleteSelectedImageWIthIndex:(NSInteger)index;

@end

@interface ZENewAnswerQuestionView : UIView

@property (nonatomic,weak) id <ZENewAnswerQuestionViewDelegate> delegate;

@property (nonatomic,strong) UIScrollView * questionExplainView;
@property (nonatomic,strong) UITextView * inputView;
@property (nonatomic,strong) UILabel * lengthLab;
/************** 问题主键 *************/
@property (nonatomic,copy) NSString * quesTypeSEQKEY;

-(id)initWithFrame:(CGRect)frame withQuestionInfoModel:(ZEQuestionInfoModel *)questionInfoM;

-(void)reloadChoosedImageView:(id)choosedImage;

@end

