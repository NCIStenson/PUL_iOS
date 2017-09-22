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
    
    UIImageView * tipImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, _frame.size.width - 40, _frame.size.height - 40)];
    tipImage.image = [UIImage imageNamed:@"without_tips"];
    tipImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:tipImage];
    
    tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, tipImage.bottom + 5,  _frame.size.width, 30)];
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textColor = kTextColor;
    [self addSubview:tipsLab];
    tipsLab.text = @"好心塞，居然是空的";
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
