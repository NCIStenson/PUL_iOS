//
//  ZEPULHomeModel.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPULHomeModel.h"

static ZEPULHomeModel * pulHomeM = nil;
static ZEPULHomeQuestionBankModel * bankModel = nil;


@implementation ZEPULHomeModel

+(ZEPULHomeModel *)getDetailWithDic:(NSDictionary *)dic
{
    pulHomeM = [[ZEPULHomeModel alloc]init];
    
    pulHomeM.SEQKEY         = [dic objectForKey:@"SEQKEY"];
    pulHomeM.EXTRASPARAM  = [dic objectForKey:@"EXTRASPARAM"];
    pulHomeM.FILEURL  = [dic objectForKey:@"FILEURL"];
    pulHomeM.FORKEY  = [dic objectForKey:@"FORKEY"];
    pulHomeM.MES_STATE  = [dic objectForKey:@"MES_STATE"];
    pulHomeM.MES_TYPE    = [dic objectForKey:@"MES_TYPE"];
    pulHomeM.MES_NAME    = [dic objectForKey:@"MES_NAME"];
    pulHomeM.MSG_CONTENT = [dic objectForKey:@"MSG_CONTENT"];
    pulHomeM.MSG_TITLE = [dic objectForKey:@"MSG_TITLE"];
    pulHomeM.SYSCREATEDATE = [dic objectForKey:@"SYSCREATEDATE"];
    pulHomeM.URLPATH = [dic objectForKey:@"URLPATH"];

    pulHomeM.SYSCREATORID = [dic objectForKey:@"SYSCREATORID"];
    pulHomeM.TEAMMEMBERS = [dic objectForKey:@"TEAMMEMBERS"];
    pulHomeM.JMESSAGEGROUPID = [dic objectForKey:@"JMESSAGEGROUPID"];
    pulHomeM.STATUS = [dic objectForKey:@"STATUS"];
    pulHomeM.DYNAMICTYPE = [dic objectForKey:@"DYNAMICTYPE"];
    
    return pulHomeM;
}

@end

@implementation ZEPULHomeQuestionBankModel

+(ZEPULHomeQuestionBankModel *)getDetailWithDic:(NSDictionary *)dic
{
    bankModel = [[ZEPULHomeQuestionBankModel alloc]init];
    
    bankModel.done_num = [dic objectForKey:@"done_num"];
    bankModel.module_list = [[dic objectForKey:@"module_list"] objectForKey:@"DATAS"];
    bankModel.right_rate = [dic objectForKey:@"right_rate"];
    bankModel.time_pass = [dic objectForKey:@"time_pass"];
    bankModel.module_id = [dic objectForKey:@"module_id"];
    bankModel.module_name = [dic objectForKey:@"module_name"];
    bankModel.module_code = [dic objectForKey:@"module_code"];

    return bankModel;
}

@end

