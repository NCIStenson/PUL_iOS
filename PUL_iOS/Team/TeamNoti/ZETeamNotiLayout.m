//
//  ZETeamNotiLayout.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kFontSize 16.0f

#define kCellTopMargin 5.0f
#define kCellBottomMargin 5.0f
#define kMaxWidth SCREEN_WIDTH - 40

#import "ZETeamNotiLayout.h"

@implementation ZETeamNotiLayout

- (instancetype)initWithContent:(ZETeamNotiCenModel *)teamNotiModel
{
    self = [super init];
    _teamNotiModel = teamNotiModel;

    [self layout];
    return self;
}

- (void)layout {
    [self layoutTitle];
    [self layoutDetail];
    _height = 0;
    _height += kCellTopMargin;
    _height += _titleHeight;
    _height += _detailHeight;
    _height += kCellBottomMargin;
}


-(void)layoutTitle
{
    _titleHeight = 0;
    
    NSString * contentStr = @"";
    contentStr = _teamNotiModel.MESSAGE;
    
    if (contentStr.length == 0) return;
    
    float textW = [contentStr widthForFont:[UIFont systemFontOfSize:kFontSize]];
    float textH = [contentStr heightForFont:[UIFont systemFontOfSize:kFontSize] width:kMaxWidth];
    if (textW > kMaxWidth) {
        textH =[ZEUtil boundingRectWithSize:CGSizeMake(kMaxWidth, MAXFLOAT) WithStr:contentStr andFont:[UIFont systemFontOfSize:kFontSize] andLinespace:kLabel_LineSpace];
    }
    if (textH < 21) {
        textH = 21;  // 如果 字体只有一行 设置高度为21
    }
    
    _titleHeight = textH;
}

-(void)layoutDetail
{
    _detailHeight = 25;
}

@end
