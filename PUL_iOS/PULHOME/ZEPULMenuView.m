//
//  ZEPULMenuView.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/3.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPULMenuView.h"
#import "SDMajletView.h"

@interface ZEPULMenuView()
{
    NSArray * inuseIconArr;
}

@end

@implementation ZEPULMenuView

-(id)initWithFrame:(CGRect)frame withInUseArr:(NSArray *)inuseArr;
{
    self = [super initWithFrame:frame];
    if (self) {
        inuseIconArr = inuseArr;
        [self initView];
    }
    return self;
}

-(void)initView{
   SDMajletView * menuView = [[SDMajletView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    menuView.inUseTitles = [NSMutableArray array];
    for (int i = 0 ; i < inuseIconArr.count; i ++) {
        NSDictionary * dic = inuseIconArr [i];
        
        NSDictionary * arrDic = @{@"iconName":[[dic objectForKey:@"FUNCTIONURL"] stringByReplacingOccurrencesOfString:@"," withString:@""],@"title":[dic objectForKey:@"FUNCTIONNAME"]};
        [menuView.inUseTitles addObject:arrDic];
    }
    
    NSArray *arrUnuses = @[@{@"iconName":@"game",@"title":@"游戏中心"},
                           @{@"iconName":@"jd",@"title":@"京东特卖"},
                           @{@"iconName":@"life",@"title":@"生活缴费"},
                           @{@"iconName":@"shanghu",@"title":@"商户通"}
                           ];
    menuView.unUseTitles = [NSMutableArray arrayWithArray:@[]];
    
    [self addSubview:menuView];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
