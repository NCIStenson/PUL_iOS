//
//  ZEQuestionInfoModel.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionInfoModel.h"

static ZEQuestionInfoModel * quesInfoM = nil;
static ZEQuesAnsDetail * quesAnsM = nil;
static ZEUSER_BASE_INFOM * userinfo = nil;


@implementation ZEQuestionInfoModel


+(ZEQuestionInfoModel *)getDetailWithDic:(NSDictionary *)dic
{
    quesInfoM = [[ZEQuestionInfoModel alloc]init];
    
    quesInfoM.SEQKEY           = [dic objectForKey:@"SEQKEY"];
    quesInfoM.QUESTIONTYPECODE = [dic objectForKey:@"QUESTIONTYPECODE"];
    quesInfoM.QUESTIONEXPLAIN  = [dic objectForKey:@"QUESTIONEXPLAIN"];
    quesInfoM.QUESTIONIMAGE    = [dic objectForKey:@"QUESTIONIMAGE"];
    quesInfoM.QUESTIONUSERCODE = [dic objectForKey:@"QUESTIONUSERCODE"];
    quesInfoM.QUESTIONUSERNAME = [dic objectForKey:@"QUESTIONUSERNAME"];
    quesInfoM.QUESTIONLEVEL    = [dic objectForKey:@"QUESTIONLEVEL"];
    quesInfoM.STATISTICALSRC   = [dic objectForKey:@"STATISTICALSRC"];
    quesInfoM.IMPORTLEVEL      = [dic objectForKey:@"IMPORTLEVEL"];
    quesInfoM.ISEXPERTANSWER   = [dic objectForKey:@"ISEXPERTANSWER"];
    quesInfoM.ISSOLVE          = [dic objectForKey:@"ISSOLVE"];
    quesInfoM.ISGOOD          = [[dic objectForKey:@"ISGOOD"] boolValue];
    quesInfoM.GOODNUMS          = [dic objectForKey:@"GOODNUMS"];
    quesInfoM.SYSCREATEDATE    = [dic objectForKey:@"SYSCREATEDATE"];
    quesInfoM.ANSWERSUM        = [dic objectForKey:@"ANSWERSUM"];
    quesInfoM.NICKNAME         = [dic objectForKey:@"NICKNAME"];
    quesInfoM.BONUSPOINTS      = [dic objectForKey:@"BONUSPOINTS"];
    quesInfoM.TARGETUSERNAME      = [dic objectForKey:@"TARGETUSERNAME"];
    quesInfoM.TARGETUSERCODE      = [dic objectForKey:@"TARGETUSERCODE"];
    quesInfoM.INFOCOUNT        =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"INFOCOUNT"]];
    quesInfoM.ISANONYMITY      = [[dic objectForKey:@"ISANONYMITY"] boolValue];
    quesInfoM.ISANSWER      = [[dic objectForKey:@"ISANSWER"] boolValue];
    quesInfoM.HEADIMAGE        = [[[dic objectForKey:@"HEADIMAGE"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    quesInfoM.FILEURL          = [[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];

    NSArray * urlArr = [quesInfoM.FILEURL componentsSeparatedByString:@","];
    NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
    if(imageUrlArr.count > 0){
        [imageUrlArr removeObjectAtIndex:0];
    }
    quesInfoM.FILEURLARR = imageUrlArr;
    
    return quesInfoM;
}

@end

@implementation ZEQuesAnsDetail

+(ZEQuesAnsDetail *)getDetailWithDic:(NSDictionary *)dic
{
    quesAnsM = [[ZEQuesAnsDetail alloc]init];
    
    quesAnsM.SEQKEY           = [dic objectForKey:@"SEQKEY"];
    quesAnsM.SYSCREATORID = [dic objectForKey:@"SYSCREATORID"];
    quesAnsM.SYSUPDATORID = [dic objectForKey:@"SYSUPDATORID"];
    quesAnsM.SYSCREATEDATE  = [dic objectForKey:@"SYSCREATEDATE"];
    quesAnsM.ANSWERCODE    = [dic objectForKey:@"ANSWERCODE"];
    quesAnsM.FILEURL = [dic objectForKey:@"FILEURL"];
    quesAnsM.EXPLAIN = [dic objectForKey:@"EXPLAIN"];
    quesAnsM.HEADIMAGE        = [[[dic objectForKey:@"HEADIMAGE"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSArray * urlArr = [quesAnsM.FILEURL componentsSeparatedByString:@","];
    NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
    if(imageUrlArr.count > 0){
        [imageUrlArr removeObjectAtIndex:0];
    }
    quesAnsM.FILEURLARR = imageUrlArr;
    
    return quesAnsM;
}

@end

@implementation ZEUSER_BASE_INFOM

+(ZEUSER_BASE_INFOM *)getDetailWithDic:(NSDictionary *)dic
{
    userinfo = [[ZEUSER_BASE_INFOM alloc]init];
    
    userinfo.SEQKEY           = [dic objectForKey:@"SEQKEY"];
    userinfo.USERNAME           = [dic objectForKey:@"USERNAME"];
    userinfo.USERTYPE           = [dic objectForKey:@"USERTYPE"];
    userinfo.USERCODE           = [dic objectForKey:@"USERCODE"];
    userinfo.FILEURL          = [[[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
//    NSArray * urlArr = [quesAnsM.FILEURL componentsSeparatedByString:@","];
//    NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
//    if(imageUrlArr.count > 0){
//        [imageUrlArr removeObjectAtIndex:0];
//    }
//    quesAnsM.FILEURLARR = imageUrlArr;
    
    return userinfo;
}

@end


