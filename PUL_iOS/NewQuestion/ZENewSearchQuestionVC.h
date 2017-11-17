//
//  ZENewSearchQuestionVC.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZEExpertModel.h"
#import "ZEChatVC.h"
#import "ZENewAnswerQuestionVC.h"

@interface ZENewSearchQuestionVC : ZESettingRootVC

@property (nonatomic,assign) QUESTION_LIST showQuestionListType;

@property (nonatomic,copy) NSString * QUESTIONTYPENAME;

@property (nonatomic,copy) NSString * typeSEQKEY;
@property (nonatomic,copy) NSString * typeParentID;

@property (nonatomic,copy) NSString * currentInputStr;

@property (nonatomic,strong) ZEExpertModel * expertModel;

@end
