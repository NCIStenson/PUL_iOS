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
    
    if (_answerInfo.DATALIST.count > 0) {
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
    
    for (int i = 0; i < _answerInfo.DATALIST.count ; i ++) {
        ZEAnswerInfoModel * replyInfoModel =  [ZEAnswerInfoModel getDetailWithDic:_answerInfo.DATALIST[i]];
        
        if (replyInfoModel.EXPLAIN.length > 0) {
            NSString * explainStr = @"";
            if ([replyInfoModel.SYSCREATORID isEqualToString:_questionInfo.SYSCREATORID]) {
                explainStr = [NSString stringWithFormat:@"%@：%@",_questionInfo.NICKNAME,replyInfoModel.EXPLAIN];
            }else if([replyInfoModel.SYSCREATORID isEqualToString:_answerInfo.SYSCREATORID]){
                explainStr = [NSString stringWithFormat:@"%@回复%@ ：%@",_answerInfo.NICKNAME,_questionInfo.NICKNAME,replyInfoModel.EXPLAIN];
            }
            float textH = [ZEUtil boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90 - 16, MAXFLOAT) WithStr:explainStr andFont:[UIFont systemFontOfSize:kTiltlFontSize] andLinespace:kLabel_LineSpace];

//            float textH = [explainStr heightForFont:[UIFont systemFontOfSize:kTiltlFontSize] width:SCREEN_WIDTH - 90 - 16];
            _replayHeight += textH;
        }else if(replyInfoModel.FILEURL.length > 0){
            NSString * explainStr = @"";
            if ([replyInfoModel.SYSCREATORID isEqualToString:_questionInfo.SYSCREATORID]) {
                explainStr = [NSString stringWithFormat:@"%@：%@",_questionInfo.NICKNAME,replyInfoModel.EXPLAIN];
            }else if([replyInfoModel.SYSCREATORID isEqualToString:_answerInfo.SYSCREATORID]){
                explainStr = [NSString stringWithFormat:@"%@回复%@ ：%@",_answerInfo.NICKNAME,_questionInfo.NICKNAME,replyInfoModel.EXPLAIN];
            }
            float textH = [ZEUtil boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90 - 16, MAXFLOAT) WithStr:explainStr   andFont:[UIFont systemFontOfSize:kSubTiltlFontSize] andLinespace:kLabel_LineSpace];

//            float textH = [explainStr heightForFont:[UIFont systemFontOfSize:kTiltlFontSize] width:SCREEN_WIDTH - 90 - 16];

            _replayHeight += kReplyImageHeight ;
            _replayHeight += textH ;
            _replayHeight += 10 ;
        }
        
    }
    if (_answerInfo.DATALIST.count >= 2) {
        _replayHeight += 20;
    }
    _replayHeight += 15;
    
}

@end
