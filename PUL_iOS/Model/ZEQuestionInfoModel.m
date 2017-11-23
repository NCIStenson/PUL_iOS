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
    
    if([ZEUtil isNotNull:[dic objectForKey:@"SEQKEY"]]){
        quesInfoM.SEQKEY           = [dic objectForKey:@"SEQKEY"];
    }
    if([ZEUtil isNotNull:[dic objectForKey:@"QUESTIONTYPECODE"]]){
        quesInfoM.QUESTIONTYPECODE = [dic objectForKey:@"QUESTIONTYPECODE"];
    }
    if([ZEUtil isNotNull:[dic objectForKey:@"QUESTIONEXPLAIN"]]){
        quesInfoM.QUESTIONEXPLAIN  = [dic objectForKey:@"QUESTIONEXPLAIN"];
    }
    if([ZEUtil isNotNull:[dic objectForKey:@"QUESTIONIMAGE"]]){
        quesInfoM.QUESTIONIMAGE    = [dic objectForKey:@"QUESTIONIMAGE"];
    }
    if([ZEUtil isNotNull:[dic objectForKey:@"QUESTIONUSERCODE"]]){
        quesInfoM.QUESTIONUSERCODE = [dic objectForKey:@"QUESTIONUSERCODE"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"QUESTIONUSERNAME"]]) {
        quesInfoM.QUESTIONUSERNAME = [dic objectForKey:@"QUESTIONUSERNAME"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"QUESTIONLEVEL"]]) {
        quesInfoM.QUESTIONLEVEL    = [dic objectForKey:@"QUESTIONLEVEL"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"STATISTICALSRC"]]) {
        quesInfoM.STATISTICALSRC   = [dic objectForKey:@"STATISTICALSRC"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"IMPORTLEVEL"]]) {
        quesInfoM.IMPORTLEVEL      = [dic objectForKey:@"IMPORTLEVEL"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"ISEXPERTANSWER"]]) {
        quesInfoM.ISEXPERTANSWER   = [dic objectForKey:@"ISEXPERTANSWER"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"ISSOLVE"]]) {
        quesInfoM.ISSOLVE          = [dic objectForKey:@"ISSOLVE"];
    }
    if([ZEUtil isNotNull:[dic objectForKey:@"ISGOOD"]]){
        quesInfoM.ISGOOD          = [[dic objectForKey:@"ISGOOD"] boolValue];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"GOODNUMS"]]) {
        quesInfoM.GOODNUMS          = [dic objectForKey:@"GOODNUMS"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"SYSCREATEDATE"]]) {
        quesInfoM.SYSCREATEDATE    = [dic objectForKey:@"SYSCREATEDATE"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"SYSCREATORID"]]) {
        quesInfoM.SYSCREATORID    = [dic objectForKey:@"SYSCREATORID"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"ANSWERSUM"]]) {
        quesInfoM.ANSWERSUM        = [dic objectForKey:@"ANSWERSUM"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"NICKNAME"]]) {
        quesInfoM.NICKNAME         = [dic objectForKey:@"NICKNAME"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"BONUSPOINTS"]]) {
        quesInfoM.BONUSPOINTS          = [dic objectForKey:@"BONUSPOINTS"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"TARGETUSERNAME"]]) {
        quesInfoM.TARGETUSERNAME      = [dic objectForKey:@"TARGETUSERNAME"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"TARGETUSERCODE"]]) {
        quesInfoM.TARGETUSERCODE      = [dic objectForKey:@"TARGETUSERCODE"];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"ISANONYMITY"]]) {
        quesInfoM.ISANONYMITY      = [[dic objectForKey:@"ISANONYMITY"] boolValue];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"ISANSWER"]]) {
        quesInfoM.ISANSWER      = [[dic objectForKey:@"ISANSWER"] boolValue];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"INFOCOUNT"]]) {
        quesInfoM.INFOCOUNT        =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"INFOCOUNT"]];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"HEADIMAGE"]]) {
        quesInfoM.HEADIMAGE        = [[[dic objectForKey:@"HEADIMAGE"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    if ([ZEUtil isNotNull:[dic objectForKey:@"FILEURL"]]) {
        quesInfoM.FILEURL          = [[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSArray * urlArr = [quesInfoM.FILEURL componentsSeparatedByString:@","];
        NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
        if(imageUrlArr.count > 0){
            [imageUrlArr removeObjectAtIndex:0];
        }
        quesInfoM.FILEURLARR = imageUrlArr;
    }
    
    return quesInfoM;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"HEADIMAGE"]){
        quesInfoM.HEADIMAGE        = [[value stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    if([key isEqualToString:@"FILEURL"]){
        quesInfoM.FILEURL          = [[value objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSArray * urlArr = [quesInfoM.FILEURL componentsSeparatedByString:@","];
        NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
        if(imageUrlArr.count > 0){
            [imageUrlArr removeObjectAtIndex:0];
        }
        quesInfoM.FILEURLARR = imageUrlArr;
    }
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
    if ([ZEUtil isNotNull: [dic objectForKey:@"SEQKEY"]]) {
        userinfo.SEQKEY           = [dic objectForKey:@"SEQKEY"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"USERNAME"]]) {
        userinfo.USERNAME           = [dic objectForKey:@"USERNAME"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"USERTYPE"]]) {
        userinfo.USERTYPE           = [dic objectForKey:@"USERTYPE"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"USERCODE"]]) {
        userinfo.USERCODE           = [dic objectForKey:@"USERCODE"];
    }
    if ([ZEUtil isNotNull: [dic objectForKey:@"FILEURL"]]) {
        userinfo.FILEURL          = [[[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    return userinfo;
}



@end


