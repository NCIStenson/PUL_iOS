//
//  ZEExpertModel.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/29.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEExpertModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;   // 专家主键
@property (nonatomic,copy) NSString * DESCRIBE;  // 
@property (nonatomic,copy) NSString * EXPERTDATE;
@property (nonatomic,copy) NSString * EXPERTFRADE;
@property (nonatomic,copy) NSString * EXPERTID;
@property (nonatomic,copy) NSString * EXPERTTYPE;
@property (nonatomic,copy) NSString * FILEURL;
@property (nonatomic,copy) NSString * GOODFIELD;
@property (nonatomic,copy) NSString * PROCIRCLECODE;
@property (nonatomic,copy) NSString * PROFESSIONAL;
@property (nonatomic,copy) NSString * STATUS;
@property (nonatomic,copy) NSString * USERCODE;
@property (nonatomic,copy) NSString * USERNAME;

@property (nonatomic,copy) NSString * SCORE;
@property (nonatomic,copy) NSString * ISONLINE;
@property (nonatomic,copy) NSString * CLICKCOUNT;

@property (nonatomic,strong) NSArray * FILEURLARR;

+(ZEExpertModel *)getDetailWithDic:(NSDictionary *)dic;


@end
