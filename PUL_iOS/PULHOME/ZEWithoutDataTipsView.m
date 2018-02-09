//
//  ZEWithoutDataTipsView.m
//  PUL_iOS
//
//  Created by Stenson on 17/9/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEWithoutDataTipsView.h"

@interface ZEWithoutDataTipsView()
{
    CGRect _frame;
    UIImageView * tipImage;
    UILabel * tipsLab;
}

@end

@implementation ZEWithoutDataTipsView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        [self initUI];
    }
    return self;
}

-(void)initUI {
    tipImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, (_frame.size.width - 40 )* .7,( _frame.size.height - 40 )* .7)];
    tipImage.image = [UIImage imageNamed:@"without_tips"];
    tipImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:tipImage];
    tipImage.centerX = SCREEN_WIDTH / 2;
    
    tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, tipImage.bottom + 5,  _frame.size.width, 30)];
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textColor = kTextColor;
    [self addSubview:tipsLab];
    tipsLab.text = @"好心塞，居然是空的";
}

-(void)setImageType:(SHOW_TIPS_IMAGETYPE)imageType
{
    _imageType = imageType;
    switch (imageType) {
        case SHOW_TIPS_IMAGETYPE_COMMON:
            tipImage.image = [UIImage imageNamed:@"without_tips"];
            break;
        case SHOW_TIPS_IMAGETYPE_CRY:
            tipImage.image = [UIImage imageNamed:@"without_tips_cry"];
            break;
        case SHOW_TIPS_IMAGETYPE_LAUGH:
            tipImage.image = [UIImage imageNamed:@"without_tips_laugh"];
            break;
        default:
            tipImage.image = [UIImage imageNamed:@"without_tips"];
            break;
    }
}

-(void)setType:(SHOW_TIPS_TYPE)type
{
    _type = type;
    tipsLab.text = [self getTextWithType:type];
}

-(NSString *)getTextWithType:(SHOW_TIPS_TYPE)type
{
    switch (type) {
        case SHOW_TIPS_TYPE_MYQUESTION:
            return @"好心塞，居然是空的";
            break;
        case SHOW_TIPS_TYPE_MYANSWER:
            return @"好心塞，居然是空的";
            break;
        case SHOW_TIPS_TYPE_QUESTIONDETAIL:
            return @"还没有人回答，快来帮帮TA吧！";
            break;
        case SHOW_TIPS_TYPE_SENDNOTICENTER:
            return @"还没有通知发布哦！";
            break;

        default:
            return @"";
            break;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
