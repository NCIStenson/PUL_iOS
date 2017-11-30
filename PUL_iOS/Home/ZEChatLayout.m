//
//  ZEChatLayout.m
//  PUL_iOS
//
//  Created by Stenson on 16/12/6.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kFontSize 16.0f
#define kMaxWidth SCREEN_WIDTH * 0.7

#import "ZEChatLayout.h"

@implementation ZEChatLayout

- (instancetype)initWithTextContent:(ZEQuestionInfoModel *)questionInfo
                     withAnswerInfo:(ZEAnswerInfoModel *)answerInfo
{
    self = [super init];
    _questionInfo = questionInfo;
    _answerInfo = answerInfo;
    [self layout];
    return self;
}

- (instancetype)initWithDetailTextContent:(ZEQuesAnsDetail *)quesAnsM
                            withHeadImage:(NSString *)imageUrl
{
    self = [super init];
    _quesAnsM = quesAnsM;
    self.headImageUrl = imageUrl;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
    _titleHeight = 0;
    
    [self _layoutTitle];

    _height = 0;
    _height += kCellTopMargin;
    _height += _titleHeight;
    _height += kCellBottomMargin;
}

- (void)_layout {
    [self _layoutTitle];
}

- (void)_layoutTitle {
    _titleHeight = 0;
    _titleTextLayout = nil;
    
    NSString * contentStr = @"";
    if ([ZEUtil isNotNull:_questionInfo]) {
        contentStr = _questionInfo.QUESTIONEXPLAIN;
        if(_questionInfo.ISANONYMITY){
            self.headImageUrl = @"";
        }else{
            self.headImageUrl = _questionInfo.HEADIMAGE;
        }
    }else if ([ZEUtil isNotNull:_quesAnsM]){
        contentStr = _quesAnsM.EXPLAIN;
    }else if ([ZEUtil isNotNull:_answerInfo]){
        contentStr = _answerInfo.ANSWEREXPLAIN;
        self.headImageUrl = _answerInfo.HEADIMAGE;
    }
    
    if (contentStr.length == 0) return;
    
    float textW = [contentStr widthForFont:[UIFont systemFontOfSize:kFontSize]];
    float textH = [contentStr heightForFont:[UIFont systemFontOfSize:kFontSize] width:kMaxWidth];
    if (textW > kMaxWidth) {
        textH = [ZEUtil boundingRectWithSize:CGSizeMake(kMaxWidth, MAXFLOAT) WithStr:contentStr andFont:[UIFont systemFontOfSize:kTiltlFontSize] andLinespace:kLabel_LineSpace];
    }
    if (textH < 21) {
        textH = 21;  // 如果 字体只有一行 设置高度为45
    }

    _titleHeight = textH;
}

/******** 初始问题的图片和回答的图片 **********/
- (instancetype)initWithImgaeUrl:(NSString *)url
                        usercode:(NSString *)usercode
                    headImageUrl:(NSString *)headImageUrl
{
    self = [super init];
    
    _imageURL = url;
    _usercode = usercode;
    _headImageUrl = headImageUrl;
    
    self.height = SCREEN_WIDTH * .5f + kCellTopMargin + kCellBottomMargin;
    
    return self;
}

/******** 聊天内容的图片 **********/
- (instancetype)initWithChatImgaeUrl:(NSString *)url
                        chatUsercode:(NSString *)usercode
                    chatHeadImageUrl:(NSString *)headImageUrl
{
    self = [super init];
    
    _imageURL = url;
    _usercode = usercode;
    _headImageUrl = headImageUrl;
    
    self.height = SCREEN_WIDTH * .5f + kCellTopMargin + kCellBottomMargin;
    
    return self;
}

@end
