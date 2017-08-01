//
//  ZEScoreView.h
//  PUL_iOS
//
//  Created by Stenson on 16/11/9.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

//  评分视图

#import <Foundation/Foundation.h>

@class ZEScoreView;

@protocol ZEScoreViewDelegate <NSObject>

-(void)didSelectScore:(NSString *)score;

-(void)dismissTheScoreView;
@end

@interface ZEScoreView : UIView

@property (nonatomic,assign) id delegate;

-(id)initWithFrame:(CGRect)frame;

@end
