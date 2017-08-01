//
//  ZEHomeLayout.m
//  PUL_iOS
//
//  Created by Stenson on 17/2/22.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEHomeLayout.h"

@implementation ZEHomeLayout

- (instancetype)initWithStatus{

    self = [super init];
    [self layout];
    return self;
}

-(void)layout{
    _height += kZEHomeCellUserMsgViewHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
