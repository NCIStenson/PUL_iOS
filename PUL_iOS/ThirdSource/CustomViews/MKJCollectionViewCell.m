//
//  MKJCollectionViewCell.m
//  PhotoAnimationScrollDemo
//
//  Created by MKJING on 16/8/9.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJCollectionViewCell.h"

@implementation MKJCollectionViewCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView
{
    self.heroImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, SCREEN_WIDTH / 3)];
    [self addSubview:self.heroImageVIew];
    
    self.heroImageVIew.layer.cornerRadius = 5.0f;
    self.heroImageVIew.layer.masksToBounds = YES;

    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    
    self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _nameLab.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.nameLab];
    
    
}

@end
