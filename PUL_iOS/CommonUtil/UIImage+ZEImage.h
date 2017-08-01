//
//  UIImage+ZEImage.h
//  dripo
//
//  Created by Stenson on 10/17/14.
//  Copyright (c) 2014 Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (ZEImage)

+ (UIImage *)imageNamed:(NSString *)name color:(UIColor *)color;

+ (UIImage *)imageNamed:(NSString *)name tintColor:(UIColor *)tintColor;

+ (UIImage *)imageNamed:(NSString *)name gradientTintColor:(UIColor *)tintColor;

/**
 *  根据比例生成新图片
 *
 *  @param scaleSize 缩放比例
 *
 *  @return 新图片
 */
- (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据比例生成新图片
 *
 *  @param scaleSize 缩放比例
 *
 *  @return 新图片
 */
- (UIImage *)scaleImage:(float)scaleSize;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)cropToCircleInRect:(CGRect)rect;

@end
