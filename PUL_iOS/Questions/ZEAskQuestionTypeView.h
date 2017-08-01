//
//  ZEAskQuestionTypeView.h
//  PUL_iOS
//
//  Created by Stenson on 16/11/15.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEAskQuestionTypeView;

@protocol ZEAskQuestionTypeViewDelegate <NSObject>

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode fatherCode:(NSString *)fatherCode;

@end

@interface ZEAskQuestionTypeView : UIView

@property (nonatomic,weak) id <ZEAskQuestionTypeViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadTypeData;

@end
