//
//  ZETeamCircleModel.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamCircleModel.h"

static ZETeamCircleModel * teamCircleInfo = nil;

@implementation ZETeamCircleModel

+(ZETeamCircleModel *)getDetailWithDic:(NSDictionary *)dic
{
    teamCircleInfo = [[ZETeamCircleModel alloc]init];
    
    teamCircleInfo.SEQKEY         = [dic objectForKey:@"SEQKEY"];
    teamCircleInfo.TEAMCIRCLECODE  = [dic objectForKey:@"TEAMCIRCLECODE"];
    teamCircleInfo.TEAMCODE  = [dic objectForKey:@"TEAMCODE"];
    teamCircleInfo.TEAMCIRCLECODENAME  = [dic objectForKey:@"TEAMCIRCLECODENAME"];
    teamCircleInfo.TEAMCIRCLENAME    = [dic objectForKey:@"TEAMCIRCLENAME"];
    teamCircleInfo.TEAMCIRCLEREMARK = [dic objectForKey:@"TEAMCIRCLEREMARK"];
    teamCircleInfo.TEAMMANIFESTO = [dic objectForKey:@"TEAMMANIFESTO"];
    teamCircleInfo.SYSCREATORID = [dic objectForKey:@"SYSCREATORID"];
    teamCircleInfo.TEAMMEMBERS = [dic objectForKey:@"TEAMMEMBERS"];
    teamCircleInfo.JMESSAGEGROUPID = [dic objectForKey:@"JMESSAGEGROUPID"];
    teamCircleInfo.FILEURL        = [[[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    teamCircleInfo.STATUS = [dic objectForKey:@"STATUS"];
    teamCircleInfo.DYNAMICTYPE = [dic objectForKey:@"DYNAMICTYPE"];

    return teamCircleInfo;
}

@end
