//
//  ZEKLB_CLASSICCASE_INFOModel.h
//  PUL_iOS
//
//  Created by Stenson on 16/11/8.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEKLB_CLASSICCASE_INFOModel : NSObject

@property (nonatomic,copy) NSString * CASEEXPLAIN;
@property (nonatomic,copy) NSString * CASENAME;
@property (nonatomic,copy) NSString * CASEAUTHOR;
@property (nonatomic,copy) NSString * CASESCORE;
@property (nonatomic,copy) NSString * CLICKCOUNT;
@property (nonatomic,copy) NSString * FILECODE;
@property (nonatomic,copy) NSArray * FILENAME;
@property (nonatomic,copy) NSString * FILETYPE;
@property (nonatomic,copy) NSString * FILEURL;
@property (nonatomic,copy) NSString * QUESTIONTYPECODE;
@property (nonatomic,copy) NSString * QUESTIONTYPENAME;
@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * SYSCREATEDATE;
@property (nonatomic,copy) NSString * H5URL;
@property (nonatomic,copy) NSString * H5URLNAME;

@property (nonatomic,copy) NSArray * COURSEFILEURLARR;
@property (nonatomic,copy) NSString * COURSEFILEURL;
@property (nonatomic,copy) NSArray * COURSEFILENAMEARR;
@property (nonatomic,copy) NSString * COURSEFILENAME;
@property (nonatomic,copy) NSArray * COURSEFILETYPEARR;


+(ZEKLB_CLASSICCASE_INFOModel *)getDetailWithDic:(NSDictionary *)dic;

@end
