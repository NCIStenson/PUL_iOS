//
//  ZEUtil.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//


@interface ZEUtil : NSObject
// 检查对象是否为空
+ (BOOL)isNotNull:(id)object;

// 检查字符串是否为空
+ (BOOL)isStrNotEmpty:(NSString *)str;

// 计算文字高度
+ (double)heightForString:(NSString *)str font:(UIFont *)font andWidth:(float)width;

+ (double)widthForString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
//  MD5
+ (NSString*)getmd5WithString:(NSString *)string;
// 根据颜色生成图片
+ (UIImage *)imageFromColor:(UIColor *)color;

//  年月日格式化
+ (NSString *)formatDate:(NSString *)date;

// 包含小时 分钟 格式化
+ (NSString *)formatContainTime:(NSString *)date;

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  @author Stenson, 16-07-28 16:07:44
 *
 *  比较当前时间是多少分钟前
 *
 *  @param str 传入时间
 *
 *  @return 返回时间是多少分钟前
 */
+ (NSString *) compareCurrentTime:(NSString *)str;

/**
 *  @author Stenson, 16-07-28 16:07:44
 *
 *  获取手机信息
 *
 */
+ (NSDictionary *)getSystemInfo;
/**
 *  @author Stenson, 16-08-15 15:08:07
 *
 *  服务器固定格式提取工具类 进行简化提取
 *
 *  @param dic       服务器返回字符串
 *  @param tableName 查询表名
 *
 *  @return 数据数组
 */
+ (NSDictionary *)getServerDic:(NSDictionary *)dic withTabelName:(NSString *)tableName;
+ (NSArray *)getServerData:(NSDictionary *)dic withTabelName:(NSString *)tableName;

+(NSDictionary *)getCOMMANDDATA:(NSDictionary *)dic;
/**
 获取敏感词反馈信息

 @param dic <#dic description#>
 @return <#return value description#>
 */
+(NSArray *)getEXCEPTIONDATA:(NSDictionary *)dic;

/**
 *  @author Stenson, 16-08-16 09:08:20
 *
 *  获取操作是否成功
 *
 *  @param dicStr 请求返回参数
 *
 *  @return 是否成功
 */
+(BOOL)isSuccess:(NSString *)dicStr;

/**
 *  @author Stenson, 16-08-16 09:08:20
 *
 *  获取当前日期
 *
 */
+(NSString *)getCurrentDate:(NSString *)dateFormatter;

//  字典转换Json格式
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

// json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (void)showAlertView:(NSString *)str viewController:(UIViewController *)viewCon;

+(UIViewController *)getCurrentVC;

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

/**
 *  改变  “\\” === >  "/"
 */
+(NSString *)changeURLStrFormat:(NSString *)str;


/**
 四舍五入

 @param format <#format description#>
 @param floatV <#floatV description#>

 @return <#return value description#>
 */
+(NSString *)notRounding:(float)price afterPoint:(int)position;

#pragma mark - 设置Label行间距

+(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;
+(float)boundingRectWithSize:(CGSize)size WithStr:(NSString*)string andFont:(UIFont *)font andLinespace:(CGFloat)space;
+(float)boundingWidthWithSize:(CGSize)size WithStr:(NSString*)string andFont:(UIFont *)font andLinespace:(CGFloat)space;
//  动画效果
+(void)shakeToShow:(UIView*)aView;

//  H绘制虚线视图
+(void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

#pragma mark - 添加渐变色
+(void)addGradientLayer:(UIView *)view;

#pragma mark - 添加线条
+(void)addLineLayer:(UIView *)view;

+(void)addLineLayerMarginLeft:(CGFloat)left
                    marginTop:(CGFloat)top
                        width:(CGFloat)width
                       height:(CGFloat)height
                    superView:(UIView *)view;

#pragma mark - 获取题库首页中文
+(NSString *)getQuestionBankWebVCTitle:(ENTER_QUESTIONBANK_TYPE)type;


#pragma mark - 缓存分类列表
+(void)cacheQuestionType;

#pragma mark - 输入全部为空格判断
+ (BOOL) isEmpty:(NSString *) str ;

#pragma mark - 输入是否包含表情
+(BOOL)isContainsTwoEmoji:(NSString *)string;

#pragma mark - 输入字符长度 一个汉字 = 两个英文字符
+(NSInteger)sinaCountWord:(NSString *)s;

#pragma mark - 正则表达式判断链接位置
+ (NSRange)getRangeOfURL:(NSString *)string;
@end
