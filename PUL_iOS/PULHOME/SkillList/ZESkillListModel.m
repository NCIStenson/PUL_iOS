//
//  ZESkillListModel.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/18.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESkillListModel.h"

static ZESkillListModel * managerM = nil;

@implementation ZESkillListModel
+(ZESkillListModel *)getDetailWithDic:(NSDictionary *)dic
{
    managerM = [[ZESkillListModel alloc]init];
    
    [managerM setValuesForKeysWithDictionary:dic];
    
    return managerM;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@" ===  %@",key);
    if([key isEqualToString:@"FILEURL"]){

    }
    if([key isEqualToString:@"PHOTOURL"]){

    }
    //
}

@end
