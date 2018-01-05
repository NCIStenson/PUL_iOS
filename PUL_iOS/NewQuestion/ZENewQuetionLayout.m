//
//  ZENewQuetionLayout.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//



#import "ZENewQuetionLayout.h"

@implementation ZENewQuetionLayout

- (instancetype)initWithModel:(ZEQuestionInfoModel *)questionInfo;
{
    self = [super init];
    _isShowMode = YES;
    _questionInfo = questionInfo;
    [self layout];
    return self;
}

- (instancetype)initWithModel:(ZEQuestionInfoModel *)questionInfo ishiddenMode:(BOOL)isShowMode
{
    self = [super init];
    _isShowMode = NO;
    _questionInfo = questionInfo;
    [self layout];
    return self;
}

- (void)layout {
    _textHeight = 0;
    _height = 0;

    _height += kPersonalMessageMarginTop;
    _height += kPersonalMessageHeight;
    
    [self layoutQuestionExplain];
    
    _height += kTextContentMarginPersonalMessage;
    _height += _textHeight;
    if (self.isShowMode && _textHeight > kMaxExplainHeight) {
        _height += 20;
    }
    
    if (_questionInfo.FILEURLARR.count > 0) {
        if (_questionInfo.FILEURLARR.count == 3) {
            _height += kTypeContentMarginImageContent;
            _height += kMultiImageHeight;
        }else{
            _height += kTypeContentMarginImageContent;
            _height += kSingleImageHeight;
        }
    }
    
    [self layoutTypeHeight];
    
    if(_typeStr.length > 0){
        _height += kTypeContentMarginImageContent;
        _height += 15;

    }
    if (_isShowMode) {
        _height += kModelContentMarginTypeContent;
        _height += kModelContentHeight;
    }
}

- (void)layoutQuestionExplain {
    
    float textH = [ZEUtil boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) WithStr:_questionInfo.QUESTIONEXPLAIN andFont:[UIFont systemFontOfSize:kTiltlFontSize] andLinespace:kLabel_LineSpace];

    if (self.isShowMode && textH > kMaxExplainHeight) {
        _textHeight += 85;
    }else{
        _textHeight = textH;
    }
}

-(void)layoutTypeHeight
{
    if(_questionInfo.QUESTIONTYPENAME.length == 0){
        NSArray * typeCodeArr = [_questionInfo.QUESTIONTYPECODE componentsSeparatedByString:@","];
        NSString * typeNameContent = @"";
        
        for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
            ZEQuestionTypeModel * questionTypeM = nil;
            ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
            for (int i = 0; i < typeCodeArr.count; i ++) {
                if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                    questionTypeM = typeM;
                    if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                        typeNameContent = questionTypeM.NAME;
                    }else{
                        typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                    }
                    break;
                }
            }
        }
        _typeStr = typeNameContent;
    }else{
        _typeStr = _questionInfo.QUESTIONTYPENAME;
    }
}

@end
