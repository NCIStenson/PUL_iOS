//
//  ZENewDetailLayout.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENewDetailLayout.h"

@implementation ZENewDetailLayout

-(id)initWithModel:(ZEAnswerInfoModel *)answertInfo
 withQuestionModel:(ZEQuestionInfoModel *)questionInfo;
{
    self = [super init];
    _questionInfo = questionInfo;
    _answerInfo = answertInfo;
    [self layout];
    return self;
}

-(void)layout{
    
    _height = 0;
    
    _textHeight = 0;
    
    _height += kContentMarginTop;
    [self layoutAnswerExplain];
    
    if(_textHeight > 20){
        _height += 20;
        _height += _textHeight;
    }else{
        _height += 40;
    }
    
    if (_answerInfo.FILEURLARR.count > 0) {
        if (_answerInfo.FILEURLARR.count == 3) {
            _height += kTypeContentMarginImageContent;
            _height += kMultiImageHeight;
        }else{
            _height += kTypeContentMarginImageContent;
            _height += kSingleImageHeight;
        }
    }
    
    if (_answerInfo.FILEURLARR.count > 0) {
        [self layoutReplyHeight];
        _height += _replayHeight;
        _height += kTypeContentMarginImageContent;
    }
    
    _height += kMessageViewMarginContentHeigth;
    _height += kMessageViewHeight;
    
}

- (void)layoutAnswerExplain {
    
    float textH = [_answerInfo.ANSWEREXPLAIN heightForFont:[UIFont systemFontOfSize:kTiltlFontSize] width:SCREEN_WIDTH - 90];
    
    _textHeight = textH;
}

-(void)layoutReplyHeight{
    _replayHeight = 0;
    
    float textH = [_answerInfo.ANSWEREXPLAIN heightForFont:[UIFont systemFontOfSize:kTiltlFontSize] width:SCREEN_WIDTH - 90];
    _replayHeight += textH;
    _replayHeight += 10;
    
}

@end
