//
//  ZEQuestionInfoModel.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEQuestionInfoModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * QUESTIONTYPECODE;
@property (nonatomic,copy) NSString * QUESTIONEXPLAIN;
@property (nonatomic,copy) NSString * QUESTIONIMAGE;
@property (nonatomic,copy) NSString * QUESTIONUSERCODE;
@property (nonatomic,copy) NSString * QUESTIONUSERNAME;
@property (nonatomic,copy) NSString * QUESTIONLEVEL;
@property (nonatomic,copy) NSString * STATISTICALSRC;
@property (nonatomic,copy) NSString * IMPORTLEVEL;
@property (nonatomic,copy) NSString * ISLOSE;
@property (nonatomic,copy) NSString * ISEXPERTANSWER;
@property (nonatomic,copy) NSString * ISSOLVE;
@property (nonatomic,copy) NSString * SYSCREATEDATE;
@property (nonatomic,copy) NSString * ANSWERSUM;
@property (nonatomic,copy) NSString * FILEURL;
@property (nonatomic,copy) NSString * HEADIMAGE;
@property (nonatomic,copy) NSString * NICKNAME;
@property (nonatomic,copy) NSString * BONUSPOINTS;  // 奖赏积分
@property (nonatomic,copy) NSString * INFOCOUNT;  // 新消息提醒
@property (nonatomic,assign) BOOL ISANONYMITY;  // 奖赏积分
@property (nonatomic,assign) BOOL ISANSWER;  // 奖赏积分

@property (nonatomic,copy) NSString * TARGETUSERCODE; //指定人员code
@property (nonatomic,copy) NSString * TARGETUSERNAME; //指定人员姓名

@property (nonatomic,strong) NSArray * FILEURLARR;

+(ZEQuestionInfoModel *)getDetailWithDic:(NSDictionary *)dic;

@end

@interface ZEQuesAnsDetail : NSObject

@property (nonatomic,copy) NSString * ANSWERCODE;
@property (nonatomic,copy) NSString * EXPLAIN;
@property (nonatomic,copy) NSString * FILEURL;
@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * SYSCREATORID;
@property (nonatomic,copy) NSString * SYSUPDATORID;
@property (nonatomic,copy) NSString * SYSCREATEDATE;
@property (nonatomic,copy) NSString * HEADIMAGE;

@property (nonatomic,strong) NSArray * FILEURLARR;

+(ZEQuesAnsDetail *)getDetailWithDic:(NSDictionary *)dic;


@end

@interface ZEUSER_BASE_INFOM : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * USERNAME;
@property (nonatomic,copy) NSString * USERCODE;
@property (nonatomic,copy) NSString * FILEURL;
@property (nonatomic,copy) NSString * USERTYPE;

@property (nonatomic,strong) NSArray * FILEURLARR;

+(ZEUSER_BASE_INFOM *)getDetailWithDic:(NSDictionary *)dic;


@end
