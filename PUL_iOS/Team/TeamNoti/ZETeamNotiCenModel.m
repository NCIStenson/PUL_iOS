//
//  ZETeamNotiCenModel.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamNotiCenModel.h"

static ZETeamNotiCenModel *teamNotiM = nil;

@implementation ZETeamNotiCenModel

+(ZETeamNotiCenModel *)getDetailWithDic:(NSDictionary *)dic
{
    teamNotiM = [[ZETeamNotiCenModel alloc]init];
    
    teamNotiM.SEQKEY           = [dic objectForKey:@"SEQKEY"];
    teamNotiM.TEAMID           = [dic objectForKey:@"TEAMID"];
    teamNotiM.USETID           = [dic objectForKey:@"USETID"];
    teamNotiM.MESSAGE           = [dic objectForKey:@"MESSAGE"];
    teamNotiM.ISRECEIPT           = [dic objectForKey:@"ISRECEIPT"];
    teamNotiM.REMARK           = [dic objectForKey:@"REMARK"];
    teamNotiM.SYSCREATEDATE           = [dic objectForKey:@"SYSCREATEDATE"];
    teamNotiM.RECEIPTCOUNT           = [dic objectForKey:@"RECEIPTCOUNT"];
    teamNotiM.USERNAME              = [dic objectForKey:@"USERNAME"];
    teamNotiM.CREATORNAME              = [dic objectForKey:@"CREATORNAME"];
    teamNotiM.ISREAD              = [dic objectForKey:@"ISREAD"];
    teamNotiM.URLPATH              = [dic objectForKey:@"URLPATH"];

    teamNotiM.MESTYPE              = [dic objectForKey:@"MESTYPE"];
    teamNotiM.MESNAME              = [dic objectForKey:@"MESNAME"];
    teamNotiM.DYNAMICTYPE              = [dic objectForKey:@"DYNAMICTYPE"];
    teamNotiM.TIPS              = [dic objectForKey:@"TIPS"];
    teamNotiM.QUESTIONEXPLAIN              = [dic objectForKey:@"QUESTIONEXPLAIN"];
    teamNotiM.QUESTIONID              = [dic objectForKey:@"QUESTIONID"];
    teamNotiM.ANSWERID              = [dic objectForKey:@"ANSWERID"];
    teamNotiM.ANSWEREXPLAIN              = [dic objectForKey:@"ANSWEREXPLAIN"];

    
    return teamNotiM;
}

@end
