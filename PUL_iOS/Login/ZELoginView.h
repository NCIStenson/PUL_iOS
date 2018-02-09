//
//  ZELoginView.h
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZELoginViewDelegate <NSObject>

-(void)goLogin:(NSString *)username password:(NSString *)pwd;

@end

@interface ZELoginView : UIView

@property(nonatomic,assign) id <ZELoginViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame;

@end
