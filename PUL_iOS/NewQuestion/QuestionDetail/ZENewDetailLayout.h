//
//  ZENewDetailLayout.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kSingleImageHeight (SCREEN_WIDTH - 100) / 2
#define kMultiImageHeight (SCREEN_WIDTH - 110)/3

#define kContentMarginTop 10
#define kMessageViewMarginContentHeigth 0
#define kImageContentMarginTextContent 10
#define kTypeContentMarginImageContent kImageContentMarginTextContent
#define kMessageViewHeight 40

#import <Foundation/Foundation.h>

@interface ZENewDetailLayout : NSObject

@property (nonatomic,strong) ZEAnswerInfoModel * answerInfo;
@property (nonatomic,strong) ZEQuestionInfoModel * questionInfo;

@property (nonatomic,assign) float textHeight;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) CGFloat replayHeight;

-(id)initWithModel:(ZEAnswerInfoModel *)answertInfo
 withQuestionModel:(ZEQuestionInfoModel *)questionInfo;

@end
