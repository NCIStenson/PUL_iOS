//
//  ZEAnswerInfoModel.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/18.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEAnswerInfoModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * QUESTIONID;
@property (nonatomic,copy) NSString * ANSWEREXPLAIN;
@property (nonatomic,copy) NSString * ANSWERIMAGE;
@property (nonatomic,copy) NSString * ANSWERUSERCODE;
@property (nonatomic,copy) NSString * ANSWERUSERNAME;
@property (nonatomic,copy) NSString * ANSWERLEVEL;
@property (nonatomic,copy) NSString * ISPASS;
@property (nonatomic,copy) NSString * ISENABLED;
@property (nonatomic,copy) NSString * GOODNUMS;
@property (nonatomic,copy) NSString * ISGOOD;
@property (nonatomic,copy) NSString * SYSCREATEDATE;
@property (nonatomic,copy) NSString * FILEURL;
@property (nonatomic,copy) NSString * NICKNAME;
@property (nonatomic,copy) NSString * HEADIMAGE;
@property (nonatomic,copy) NSString * QACOUNT;
@property (nonatomic,copy) NSString * ANSWERCOUNT;
@property (nonatomic,copy) NSString * INFOCOUNT;
@property (nonatomic,copy) NSString * QUESTIONCOUNT;

@property (nonatomic,strong) NSArray * FILEURLARR;

+(ZEAnswerInfoModel *)getDetailWithDic:(NSDictionary *)dic;

@end
