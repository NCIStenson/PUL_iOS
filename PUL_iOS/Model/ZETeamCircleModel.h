//
//  ZETeamCircleModel.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZETeamCircleModel : NSObject

@property (nonatomic,copy) NSString * SEQKEY;
@property (nonatomic,copy) NSString * FILEURL;   // 团队头像
@property (nonatomic,copy) NSString * SYSCREATEDATE;  // 团队创建日期
@property (nonatomic,copy) NSString * TEAMCIRCLECODE; // 团队所属分类code
@property (nonatomic,copy) NSString * TEAMCODE; // 团队所属分类code
@property (nonatomic,copy) NSString * TEAMCIRCLENAME; // 团队名称
@property (nonatomic,copy) NSString * TEAMCIRCLECODENAME; // 团队所属分类name

@property (nonatomic,copy) NSString * TEAMCIRCLEREMARK;  // 团队简介
@property (nonatomic,copy) NSString * TEAMMEMBERS;  // 团队成员
@property (nonatomic,copy) NSString * TEAMMANIFESTO;     //  团队宣言
@property (nonatomic,copy) NSString * SYSCREATORID;     //  创建班组圈的工号

@property (nonatomic,copy) NSString * JMESSAGEGROUPID;     //  创建极光群组会话

@property (nonatomic,copy) NSString * DYNAMICTYPE;     //  动态类型  1 提问 2 回答 3 指定提问

@property (nonatomic,copy) NSString * STATUS; //  加入团队状态  0 未加入  1 审核中  2 已加入  3 已创建
+(ZETeamCircleModel *)getDetailWithDic:(NSDictionary *)dic;

@end
