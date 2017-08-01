//
//  ZEShowQuestionTypeView.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/17.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZEShowQuestionTypeView;
@protocol ZEShowQuestionTypeViewDelegate <NSObject>

/**
 *  完成选择任务列表
 */

-(void)didSeclect:(ZEShowQuestionTypeView *)showTypeView withData:(NSDictionary *)dic;

@end

@interface ZEShowQuestionTypeView : UIView

@property (nonatomic,weak) id <ZEShowQuestionTypeViewDelegate> delegate;

-(id)initWithOptionArr:(NSArray *)options;

@end
