//
//  ZEQuestionTypeModel.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEQuestionTypeModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * QUESTIONTYPECODE;
@property (nonatomic,copy) NSString * QUESTIONTYPENAME;
@property (nonatomic,copy) NSString * QUESTIONTYPEREMARK;
@property (nonatomic,copy) NSString * ISENABLED;
@property (nonatomic,copy) NSString * SYSCREATEDATE;

@property (nonatomic,copy) NSString * NAME;
@property (nonatomic,copy) NSString * CODE;


+(ZEQuestionTypeModel *)getDetailWithDic:(NSDictionary *)dic;

@end
