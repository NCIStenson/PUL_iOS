//
//  ZEPULHomeModel.h
//  PUL_iOS
//
//  Created by Stenson on 17/8/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEPULHomeModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * FILEURL;
@property (nonatomic,copy) NSString * FORKEY;  // 团队创建日期
@property (nonatomic,copy) NSString * EXTRASPARAM;  // 团队创建日期
@property (nonatomic,copy) NSString * MES_STATE; // 团队所属分类code
@property (nonatomic,copy) NSString * MES_TYPE; // 团队所属分类code
@property (nonatomic,copy) NSString * MSG_CONTENT; // 团队名称
@property (nonatomic,copy) NSString * MSG_TITLE; // 团队所属分类name
@property (nonatomic,copy) NSString * SYSCREATEDATE;  // 团队简介
@property (nonatomic,copy) NSString * URLPATH;  // 团队简介

#pragma mark - 没用的

@property (nonatomic,copy) NSString * TEAMMEMBERS;  // 团队成员
@property (nonatomic,copy) NSString * TEAMMANIFESTO;     //  团队宣言
@property (nonatomic,copy) NSString * SYSCREATORID;     //  创建班组圈的工号

@property (nonatomic,copy) NSString * JMESSAGEGROUPID;     //  创建极光群组会话

@property (nonatomic,copy) NSString * DYNAMICTYPE;     //  动态类型  1 提问 2 回答 3 指定提问

@property (nonatomic,copy) NSString * STATUS; //  加入团队状态  0 未加入  1 审核中  2 已加入  3 已创建

+(ZEPULHomeModel *)getDetailWithDic:(NSDictionary *)dic;

@end



@interface ZEPULHomeQuestionBankModel : NSObject

@property (nonatomic,copy) NSString * done_num;
@property (nonatomic,copy) NSArray * module_list;  // 团队创建日期
@property (nonatomic,copy) NSString * right_rate;  // 团队创建日期
@property (nonatomic,copy) NSString * time_pass; // 团队所属分类code

+(ZEPULHomeQuestionBankModel *)getDetailWithDic:(NSDictionary *)dic;

@end

