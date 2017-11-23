//
//  ZEExpertModel.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/29.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEExpertModel.h"

static ZEExpertModel * expertM = nil;


@implementation ZEExpertModel


+(ZEExpertModel *)getDetailWithDic:(NSDictionary *)dic
{
    expertM = [[ZEExpertModel alloc]init];
    
    expertM.SEQKEY           = [dic objectForKey:@"SEQKEY"];
    expertM.DESCRIBE = [dic objectForKey:@"DESCRIBE"];
    expertM.EXPERTDATE = [dic objectForKey:@"EXPERTDATE"];
    expertM.EXPERTFRADE = [dic objectForKey:@"EXPERTFRADE"];
    expertM.EXPERTID = [dic objectForKey:@"EXPERTID"];
    expertM.EXPERTTYPE = [dic objectForKey:@"EXPERTTYPE"];
    expertM.FILEURL = [[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    expertM.GOODFIELD = [dic objectForKey:@"GOODFIELD"];
    expertM.PROCIRCLECODE = [dic objectForKey:@"PROCIRCLECODE"];
    expertM.PROFESSIONAL = [dic objectForKey:@"PROFESSIONAL"];
    expertM.STATUS = [dic objectForKey:@"STATUS"];
    expertM.USERCODE = [dic objectForKey:@"USERCODE"];
    expertM.USERNAME = [dic objectForKey:@"USERNAME"];
    
    expertM.SCORE = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SCORE"]];
    expertM.ISONLINE = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ISONLINE"]];
    expertM.CLICKCOUNT = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CLICKCOUNT"]];
//    expertM.DESCRIBE = [dic objectForKey:@"DESCRIBE"];
//    quesInfoM.INFOCOUNT        =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"INFOCOUNT"]];
//    quesInfoM.ISANONYMITY      = [[dic objectForKey:@"ISANONYMITY"] boolValue];
//    quesInfoM.ISANSWER      = [[dic objectForKey:@"ISANSWER"] boolValue];
//    quesInfoM.HEADIMAGE        = [[[dic objectForKey:@"HEADIMAGE"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
//    quesInfoM.FILEURL          = [[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
//    
//    NSArray * urlArr = [quesInfoM.FILEURL componentsSeparatedByString:@","];
//    NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
//    if(imageUrlArr.count > 0){
//        [imageUrlArr removeObjectAtIndex:0];
//    }
//    quesInfoM.FILEURLARR = imageUrlArr;
    
    return expertM;
}

@end
