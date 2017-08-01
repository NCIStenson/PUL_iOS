//
//  UIColor+DPColor.m
//  dripo
//
//  Created by xiubo2008@gmail.com on 14-4-5.
//  Copyright (c) 2014年 xuejili. All rights reserved.
//

#import "UIColor+DPColor.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIColor (DPColor)

+ (UIColor *)dpLineColor{
    return  [UIColor colorWithRed:208 green:208 blue:208 alpha:1];
    
}

+ (UIColor *)dpBackgroundColor
{
    return [UIColor colorWithRed:0.67451 green:0.254902 blue:0.929412 alpha:1.0];
}

+ (UIColor *)testColor{
    return  [UIColor colorWithHexString:@"xxxx" andAlpha:1.0];
    
}

+ (UIColor *)controlOnColor  { return [UIColor colorWithHexString:@"f5a626" andAlpha:1]; }
+ (UIColor *)controlOffColor { return [UIColor colorWithHexString:@"fce9c8" andAlpha:1]; }

// Primary colors
+ (UIColor *)DPColorPrimary     { return [UIColor colorWithHexString:@"AC29ED" andAlpha:1]; }
+ (UIColor *)DPColorReverse     { return [UIColor colorWithHexString:@"FFFFFF" andAlpha:1]; }

// Colors for gradient background
+ (UIColor *)DPColorBackground1 { return [UIColor colorWithHexString:@"AC29ED" andAlpha:1]; }
+ (UIColor *)DPColorBackground2 { return [UIColor colorWithHexString:@"CC66FF" andAlpha:1]; }
+ (UIColor *)DPColorBackground3 { return [UIColor colorWithHexString:@"EABFFF" andAlpha:1]; }

// Colors for the card's footer's background
+ (UIColor *)DPColorCardFooter1 { return [UIColor colorWithHexString:@"FFECBA" andAlpha:1]; }
+ (UIColor *)DPColorCardFooter2 { return [UIColor colorWithHexString:@"FFF8E3" andAlpha:1]; }

// Color for texts
+ (UIColor *)DPColorText        { return [UIColor colorWithHexString:@"000000" andAlpha:1]; }
+ (UIColor *)DPColorTextScore1  { return [UIColor colorWithHexString:@"7D30CA" andAlpha:1]; }
+ (UIColor *)DPColorTextScore2  { return [UIColor colorWithHexString:@"F339FF" andAlpha:1]; }

+ (UIColor *)DPColorHighlight   { return [UIColor colorWithHexString:@"F5A623" andAlpha:1]; }

// Color for lines
+ (UIColor *)DPColorLine1       { return [UIColor colorWithHexString:@"000000" andAlpha:0.2]; }
+ (UIColor *)DPColorLine2       { return [UIColor colorWithHexString:@"FFFFFF" andAlpha:0.2]; }






+ (UIColor *)settingLineColor
{
    return  [UIColor dpColorWithRed:208 green:208 blue:208 alpha:0.4];
}

+ (UIColor *)settingBackgroundColor
{
    return  [UIColor dpColorWithRed:110 green:70 blue:133 alpha:1];
}

+ (UIColor *)settingGroupTitleColor
{
    return  [UIColor dpColorWithRed:190 green:164 blue:187 alpha:0.6];
}

+ (UIColor *)settingLeftFontColor
{
     return  [UIColor dpColorWithRed:255 green:255 blue:255 alpha:1];
}

+ (UIColor *)settingRightFontColor
{
     return  [UIColor dpColorWithRed:255 green:255 blue:255 alpha:0.6];
}

+ (UIColor *)SettingRightSmallFontColor
{
    return  [UIColor dpColorWithRed:158 green:123 blue:157 alpha:1];
}

+ (UIColor *)settingSwitchColor
{
    return  [UIColor dpColorWithRed:138 green:103 blue:157 alpha:1];
}

+(UIColor *)dpColor153{
    return [UIColor dpColorWithRed:153 green:153 blue:153 alpha:1];
    
}

+(UIColor *)dpColor61{
    return [UIColor dpColorWithRed:61 green:66 blue:69 alpha:1];
    
}

+(UIColor *)dpColor102{
    return [UIColor dpColorWithRed:102 green:102 blue:102 alpha:1];
    
}
+(UIColor *)dpColor249{
    return [UIColor dpColorWithRed:249 green:249 blue:249 alpha:1];
    
}

+(UIColor *)dpColor238{
    return [UIColor dpColorWithRed:238 green:238 blue:238 alpha:1];
}

+ (UIColor *)dpColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return  [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}

+ (UIColor*)colorWithHexString:(NSString*)hex andAlpha:(float)alpha
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (alpha == 0) {
        alpha = 1;
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}


//添加渐变的颜色组合
+ (CAGradientLayer *)shadowAsInverse:(UIView *)view
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0, 0, 320, view.frame.size.height);
    newShadow.frame = newShadowFrame;
    newShadow.colors = [NSArray arrayWithObjects:(id)[self DPColorBackground1].CGColor,(id)[self DPColorBackground2].CGColor,(id)[self DPColorBackground3].CGColor,nil];
    newShadow.startPoint=CGPointMake(0.5, 0);
    newShadow.endPoint=CGPointMake(0.5, 1);
    return newShadow;
}

+ (UIColor *)infoColor
{
    return [UIColor colorWithHexString:@"BD29FE" andAlpha:1.0];
}

+ (UIColor *)lightPurple
{
    return [UIColor colorWithHexString:@"CD29FF" andAlpha:1.0];
}

+ (UIColor *)getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image
{
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:
                          inImage];
    if (cgctx == NULL) {
        return nil; /* error */
    }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
                 (blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) {
        free(data);
    }
    return color;
}

+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    unsigned long bitmapByteCount;
    unsigned long bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    #else
        int bitmapInfo = kCGImageAlphaPremultipliedLast;
    #endif
    context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

@end
