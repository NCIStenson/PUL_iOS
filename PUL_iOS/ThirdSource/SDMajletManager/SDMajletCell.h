//
//  TestCellCollectionViewCell.h
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/27.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDMajletCell : UICollectionViewCell


/**
 是否在移动
 */
@property (nonatomic, assign) BOOL isMoving;


/**
 icon名
 */
@property (nonatomic, strong) NSString *iconName;



/**
 右上角添加删除按钮
 */
@property (nonatomic,strong) UIImageView * cornerImage;

/**
 标题
 */
@property (nonatomic, strong) NSString *title;


@property (nonatomic, assign) CGFloat font;





@end
