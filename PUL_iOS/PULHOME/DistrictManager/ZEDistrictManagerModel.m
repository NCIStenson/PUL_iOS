//
//  ZEDistrictManagerModel.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/13.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEDistrictManagerModel.h"
static ZEDistrictManagerModel * managerM = nil;

@implementation ZEDistrictManagerModel
+(ZEDistrictManagerModel *)getDetailWithDic:(NSDictionary *)dic
{
    managerM = [[ZEDistrictManagerModel alloc]init];
    
    [managerM setValuesForKeysWithDictionary:dic];
    
    return managerM;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if([key isEqualToString:@"FILEURL"]){
        self.FORMATFILEURL = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    if([key isEqualToString:@"PHOTOURL"]){
        self.FORMATPHOTOURL = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
//
}

@end
