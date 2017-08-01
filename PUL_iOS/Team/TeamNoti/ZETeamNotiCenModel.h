//
//  ZETeamNotiCenModel.h
//  PUL_iOS
//
//  Created by Stenson on 17/5/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZETeamNotiCenModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * MESSAGE;
@property (nonatomic,copy) NSString * REMARK;
@property (nonatomic,copy) NSString * TEAMID;
@property (nonatomic,copy) NSString * USETID;
@property (nonatomic,copy) NSString * ISRECEIPT;
@property (nonatomic,copy) NSString * RECEIPTCOUNT;
@property (nonatomic,copy) NSString * MRSTYLE;
@property (nonatomic,copy) NSString * SYSCREATEDATE;
@property (nonatomic,copy) NSString * USERNAME;
@property (nonatomic,copy) NSString * CREATORNAME;

@property (nonatomic,copy) NSString * MESTYPE; //  1 团队通知 或者 2 个人问题通知
@property (nonatomic,copy) NSString * DYNAMICTYPE;

@property (nonatomic,copy) NSString * ISREAD;


@property (nonatomic,copy) NSString * TIPS;
@property (nonatomic,copy) NSString * QUESTIONEXPLAIN;
@property (nonatomic,copy) NSString * QUESTIONID;
@property (nonatomic,copy) NSString * ANSWEREXPLAIN;
@property (nonatomic,copy) NSString * ANSWERID;


+(ZETeamNotiCenModel *)getDetailWithDic:(NSDictionary *)dic;

@end
