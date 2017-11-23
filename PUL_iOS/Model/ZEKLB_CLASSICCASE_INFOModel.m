//
//  ZEKLB_CLASSICCASE_INFOModel.m
//  PUL_iOS
//
//  Created by Stenson on 16/11/8.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEKLB_CLASSICCASE_INFOModel.h"

static ZEKLB_CLASSICCASE_INFOModel * model;
@implementation ZEKLB_CLASSICCASE_INFOModel

+(ZEKLB_CLASSICCASE_INFOModel *)getDetailWithDic:(NSDictionary *)dic
{
    model = [[ZEKLB_CLASSICCASE_INFOModel alloc]init];
    
    model.CASEEXPLAIN           = [dic objectForKey:@"CASEEXPLAIN"];
    model.CASENAME              = [dic objectForKey:@"CASENAME"];
    model.CASEAUTHOR            = [dic objectForKey:@"CASEAUTHOR"];
    model.CASESCORE             = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CASESCORE"]];
    model.CLICKCOUNT            = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CLICKCOUNT"]];
    model.FILECODE              = [dic objectForKey:@"FILECODE"];
    model.FILENAME              = [[dic objectForKey:@"FILENAME"] componentsSeparatedByString:@","];
    
    model.FILEURL               = [[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    model.H5URL                 = [[dic objectForKey:@"H5URL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    model.H5URLNAME             = [dic objectForKey:@"H5URLNAME"];
    
    NSArray * urlArr = [model.FILEURL componentsSeparatedByString:@","];
    NSMutableArray * imageUrlArr = [NSMutableArray arrayWithArray:urlArr];
    [imageUrlArr removeObjectAtIndex:0];
    if (imageUrlArr.count > 0) {
        model.FILEURL = imageUrlArr[0];
    }

    model.FILETYPE              = [dic objectForKey:@"FILETYPE"];
    model.QUESTIONTYPECODE      = [dic objectForKey:@"QUESTIONTYPECODE"];
    model.QUESTIONTYPENAME      = [dic objectForKey:@"QUESTIONTYPENAME"];
    model.SYSCREATEDATE         = [dic objectForKey:@"SYSCREATEDATE"];
    model.SEQKEY                = [dic objectForKey:@"SEQKEY"];
    
    if ([ZEUtil isStrNotEmpty:[dic objectForKey:@"COURSEFILEURL"]]) {
        model.COURSEFILEURL               = [[dic objectForKey:@"COURSEFILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSArray * courseUrlStrArr = [model.COURSEFILEURL componentsSeparatedByString:@","];
        NSMutableArray * courseUrlArr = [NSMutableArray arrayWithArray:courseUrlStrArr];
        [courseUrlArr removeObjectAtIndex:0];
        if (courseUrlArr.count > 0) {
            model.COURSEFILEURLARR = courseUrlArr;
        }
    }
    if([[dic objectForKey:@"COURSEFILENAME"] length] > 0){
        model.COURSEFILENAMEARR             = [[dic objectForKey:@"COURSEFILENAME"] componentsSeparatedByString:@","];
    }
    if([[dic objectForKey:@"COURSEFILETYPE"] length] > 0){
        model.COURSEFILETYPEARR             = [[dic objectForKey:@"COURSEFILETYPE"] componentsSeparatedByString:@","];
    }

    return model;
}

+( id )parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    return responseJSON;
}


@end
