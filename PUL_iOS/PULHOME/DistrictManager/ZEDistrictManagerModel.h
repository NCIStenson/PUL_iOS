//
//  ZEDistrictManagerModel.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/13.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEDistrictManagerModel : NSObject

@property (nonatomic,copy) NSString * ABILITYTYPE;
@property (nonatomic,copy) NSString * DATALIST;
@property (nonatomic,copy) NSString * POSCODE;
@property (nonatomic,copy) NSString * POSTYPE;
@property (nonatomic,copy) NSString * TYPENAME;


@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * FORMATFILEURL;
@property (nonatomic,copy) NSString * ISCOLLECT;
@property (nonatomic,copy) NSString * ABILITYCODE;
@property (nonatomic,copy) NSString * COURSENAME;
@property (nonatomic,copy) NSString * FILETYPE;
@property (nonatomic,copy) NSString * COMMENTCOUNT;
@property (nonatomic,copy) NSString * ISTHEORY;
@property (nonatomic,copy) NSString * CONTENTLEN;
@property (nonatomic,copy) NSString * CLICKCOUNT;
@property (nonatomic,copy) NSString * FORMATPHOTOURL;
@property (nonatomic,copy) NSString * COURSEXPLAIN;
@property (nonatomic,copy) NSString * SYSCREATEDATE;

+(ZEDistrictManagerModel *)getDetailWithDic:(NSDictionary *)dic;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
