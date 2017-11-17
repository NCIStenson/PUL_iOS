//
//  ZENewQuetionLayout.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kSingleImageHeight (SCREEN_WIDTH - 40) / 2
#define kMultiImageHeight (SCREEN_WIDTH - 60)/3

#define kMaxExplainHeight 70

#define kPersonalMessageMarginTop 15
#define kPersonalMessageHeight 40.0f

#define kTextContentMarginPersonalMessage 10.0f
#define kImageContentMarginTextContent kTextContentMarginPersonalMessage
#define kTypeContentMarginImageContent kTextContentMarginPersonalMessage
#define kTypeContentHeight 15.0f

#define kModelContentMarginTypeContent kTextContentMarginPersonalMessage
#define kModelContentHeight 35.0f

#import <Foundation/Foundation.h>

@interface ZENewQuetionLayout : NSObject

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfo;

@property (nonatomic,assign) float textHeight;

@property (nonatomic,assign) BOOL isShowMode; // 问题详情页面不需要回答 点赞 状态栏

@property (nonatomic,copy) NSString *typeStr;

@property (nonatomic,assign) float height;
@property (nonatomic, assign) CGFloat titleHeight; //标题栏高度，0为没标题栏

- (instancetype)initWithModel:(ZEQuestionInfoModel *)questionInfo;

- (instancetype)initWithModel:(ZEQuestionInfoModel *)questionInfo ishiddenMode:(BOOL)isShowMode;

@end
