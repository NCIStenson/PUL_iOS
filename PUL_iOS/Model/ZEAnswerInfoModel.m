//
//  ZEAnswerInfoModel.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAnswerInfoModel.h"

static ZEAnswerInfoModel * ansertInfoM = nil;

@implementation ZEAnswerInfoModel

+(ZEAnswerInfoModel *)getDetailWithDic:(NSDictionary *)dic
{
    ansertInfoM = [[ZEAnswerInfoModel alloc]init];
    
    ansertInfoM.SEQKEY         = [dic objectForKey:@"SEQKEY"];
    ansertInfoM.QUESTIONID     = [dic objectForKey:@"QUESTIONID"];
    ansertInfoM.ANSWEREXPLAIN  = [dic objectForKey:@"ANSWEREXPLAIN"];
    ansertInfoM.ANSWERIMAGE    = [dic objectForKey:@"ANSWERIMAGE"];
    ansertInfoM.ANSWERUSERCODE = [dic objectForKey:@"ANSWERUSERCODE"];
    ansertInfoM.ANSWERUSERNAME = [dic objectForKey:@"ANSWERUSERNAME"];
    ansertInfoM.ANSWERLEVEL    = [dic objectForKey:@"ANSWERLEVEL"];
    ansertInfoM.ISPASS         = [dic objectForKey:@"ISPASS"];
    ansertInfoM.ISENABLED      = [dic objectForKey:@"ISENABLED"];
    ansertInfoM.ISGOOD      = [dic objectForKey:@"ISGOOD"];
    ansertInfoM.GOODNUMS       = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GOODNUMS"]];
    ansertInfoM.QACOUNT       = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QACOUNT"]];
    ansertInfoM.ANSWERCOUNT       = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ANSWERCOUNT"]];
    ansertInfoM.INFOCOUNT       = [NSString stringWithFormat:@"%@",[dic objectForKey:@"INFOCOUNT"]];
    ansertInfoM.QUESTIONCOUNT       = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QUESTIONCOUNT"]];
    ansertInfoM.SYSCREATEDATE  = [dic objectForKey:@"SYSCREATEDATE"];
    ansertInfoM.NICKNAME       = [dic objectForKey:@"NICKNAME"];
    ansertInfoM.HEADIMAGE        = [[[dic objectForKey:@"HEADIMAGE"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    ansertInfoM.FILEURL        = [[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    NSArray * urlArr = [ansertInfoM.FILEURL componentsSeparatedByString:@","];
    NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
    if(imageUrlArr.count > 0){
        [imageUrlArr removeObjectAtIndex:0];
    }
    ansertInfoM.FILEURLARR = imageUrlArr;

    return ansertInfoM;
}

@end
