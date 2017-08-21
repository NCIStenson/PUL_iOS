//
//  TestCellCollectionViewCell.m
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/27.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SDMajletCell.h"

@interface SDMajletCell()
{
    UIImageView *iconImageView;
    UILabel *titleLab;
    CAShapeLayer *_borderLayer;
}
@end

@implementation SDMajletCell


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self buidUI];
    }return self;
}

-(void)buidUI{
    
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    iconImageView = [[UIImageView alloc] init];
    [self addSubview:iconImageView];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.frame = CGRectMake(0, .1* self.size.height, self.size.width, .6 * self.size.height);
    
    titleLab = [[UILabel alloc] init];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor darkTextColor];
    [self addSubview:titleLab];
    titleLab.frame = CGRectMake(0, .8 * self.size.height, self.size.width, 0.15 * self.size.height);
    
    _cornerImage = [[UIImageView alloc] init];
    [self addSubview:_cornerImage];
    _cornerImage.contentMode = UIViewContentModeScaleAspectFit;
    _cornerImage.frame = CGRectMake(self.size.width - 10, 0, 10, 10);
    _cornerImage.backgroundColor = MAIN_ARM_COLOR;
    
    [self addBorderLayer];
}

-(void)addBorderLayer{
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.bounds = self.bounds;
    _borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:_borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    _borderLayer.lineWidth = 1.5f;
    _borderLayer.lineDashPattern = @[@5, @3];
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1].CGColor;
    [self.layer addSublayer:_borderLayer];
    _borderLayer.hidden = true;
}


-(void) setFont:(CGFloat)font{
    _font = font;
    titleLab.font = [UIFont systemFontOfSize:_font];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    titleLab.text = title;
}
-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
//    网络图标调取
    [iconImageView sd_setImageWithURL:ZENITH_IMAGEURL(_iconName) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
}

-(void)setIsMoving:(BOOL)isMoving{
    _isMoving = isMoving;
    if (_isMoving) {
        titleLab.textColor = [UIColor lightGrayColor];
        [iconImageView sd_setImageWithURL:ZENITH_IMAGEURL(_iconName) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        _borderLayer.hidden = false;
    }else{
        titleLab.textColor = [UIColor darkTextColor];
        [iconImageView sd_setImageWithURL:ZENITH_IMAGEURL(_iconName) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        _borderLayer.hidden = true;
    }
}





@end
