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
    SDMajletView * menuView;
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
    menuView = [[SDMajletView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    menuView.inUseTitles = [NSMutableArray array];
    menuView.unUseTitles = [NSMutableArray array];
    for (int i = 0 ; i < inuseIconArr.count; i ++) {
        NSDictionary * dic = inuseIconArr [i];
        
        NSDictionary * arrDic = @{@"iconName":[[dic objectForKey:@"FUNCTIONURL"] stringByReplacingOccurrencesOfString:@"," withString:@""],@"title":[dic objectForKey:@"FUNCTIONNAME"]};
        
        [menuView.inUseTitles addObject:arrDic];
    }
        
    [self addSubview:menuView];

}

-(void)reloadUnuseArr:(NSArray *)arr
{
    [menuView reloadUnuseArr:arr];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
