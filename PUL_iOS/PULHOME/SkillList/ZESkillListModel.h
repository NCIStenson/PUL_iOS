//
//  ZESkillListModel.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/18.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZESkillListModel : NSObject

@property (nonatomic,copy) NSString * ABILITYCODE;
@property (nonatomic,copy) NSString * ABILITYNAME;
@property (nonatomic,copy) NSString * ABILITYTYPE;
@property (nonatomic,copy) NSString * ABILITYTYPECODE;
@property (nonatomic,copy) NSString * ABILITY_LEVEL;
@property (nonatomic,copy) NSString * PRACTICALWEIGHT;
@property (nonatomic,copy) NSString * ABILITY_LEVEL_DESC;

+(ZESkillListModel *)getDetailWithDic:(NSDictionary *)dic;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
