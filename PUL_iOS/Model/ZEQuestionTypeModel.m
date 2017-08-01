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
    
    _quesTypeM.SEQKEY             = [dic objectForKey:@"SEQKEY"];
    _quesTypeM.QUESTIONTYPECODE   = [dic objectForKey:@"QUESTIONTYPECODE"];
    _quesTypeM.QUESTIONTYPENAME   = [dic objectForKey:@"QUESTIONTYPENAME"];
    _quesTypeM.QUESTIONTYPEREMARK = [dic objectForKey:@"QUESTIONTYPEREMARK"];
    _quesTypeM.ISENABLED          = [dic objectForKey:@"ISENABLED"];
    _quesTypeM.SYSCREATEDATE      = [dic objectForKey:@"SYSCREATEDATE"];
    _quesTypeM.NAME      = [dic objectForKey:@"NAME"];
    _quesTypeM.CODE      = [dic objectForKey:@"CODE"];

    return _quesTypeM;
}

@end
