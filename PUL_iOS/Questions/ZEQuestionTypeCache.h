//
//  ZEQuestionTypeCache.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEQuestionTypeCache : NSObject

+ (ZEQuestionTypeCache*)instance;

/**
 *  存储用户第一次请求问题分类列表，APP运行期间 只请求一次问题分类列表
 */
- (void)setQuestionTypeCaches:(NSArray *)typeArr;
- (NSArray *)getQuestionTypeCaches;

/**
 *  存储用户第一次请求问题分类列表，APP运行期间 只请求一次问题分类列表
 */
- (void)setProCircleCaches:(NSArray *)typeArr;
- (NSArray *)getProCircleCaches;


- (void)clear;

@end
