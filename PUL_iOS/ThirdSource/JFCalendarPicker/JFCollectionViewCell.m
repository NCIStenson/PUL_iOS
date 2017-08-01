//
//  JFCollectionViewCell.m
//  JFCalendarPicker
//
//  Created by 保修一站通 on 15/9/29.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#define kDateLabelWidth 40.0f

#import "JFCollectionViewCell.h"

@implementation JFCollectionViewCell

//-(id)init

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDateLabelWidth, kDateLabelWidth)];
        _dateLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dateLabel];
        _dateLabel.clipsToBounds = YES;
        _dateLabel.layer.cornerRadius = kDateLabelWidth / 2;
        
    }
    return _dateLabel;
}

@end
