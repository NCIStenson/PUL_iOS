//
//  MKJCollectionViewCell.h
//  PhotoAnimationScrollDemo
//
//  Created by MKJING on 16/8/9.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKJCollectionViewCell : UICollectionViewCell

-(id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UIImageView *heroImageVIew;

@property (nonatomic,strong) UILabel * nameLab;

@end
