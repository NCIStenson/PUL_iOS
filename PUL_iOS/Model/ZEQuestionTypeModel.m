//
//  ZEQuestionTypeModel.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionTypeModel.h"

static ZEQuestionTypeModel * _quesTypeM = nil;
@implementation ZEQuestionTypeModel
+(ZEQuestionTypeModel *)getDetailWithDic:(NSDictionary *)dic
{
    _quesTypeM = [[ZEQuestionTypeModel alloc]init];
    if ([ZEUtil isNotNull: [dic objectForKey:@"SEQKEY"] ]) {
        _quesTypeM.SEQKEY             = [dic objectForKey:@"SEQKEY"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"QUESTIONTYPECODE"] ]) {
        _quesTypeM.QUESTIONTYPECODE   = [dic objectForKey:@"QUESTIONTYPECODE"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"QUESTIONTYPENAME"] ]) {
        _quesTypeM.QUESTIONTYPENAME   = [dic objectForKey:@"QUESTIONTYPENAME"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"QUESTIONTYPEREMARK"] ]) {
        _quesTypeM.QUESTIONTYPEREMARK = [dic objectForKey:@"QUESTIONTYPEREMARK"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"ISENABLED"] ]) {
        _quesTypeM.ISENABLED          = [dic objectForKey:@"ISENABLED"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"SYSCREATEDATE"] ]) {
        _quesTypeM.SYSCREATEDATE      = [dic objectForKey:@"SYSCREATEDATE"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"NAME"] ]) {
        _quesTypeM.NAME      = [dic objectForKey:@"NAME"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"CODE"] ]) {
        _quesTypeM.CODE      = [dic objectForKey:@"CODE"];
    }

    return _quesTypeM;
}

@end
