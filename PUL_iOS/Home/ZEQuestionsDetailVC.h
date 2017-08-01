//
//  ZEQuestionsDetailVC.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/4.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZETeamNotiCenModel.h"
@interface ZEQuestionsDetailVC : ZESettingRootVC

@property (nonatomic,assign) QUESTION_LIST enterQuestionDetailType;

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;
@property (nonatomic,strong) ZEQuestionTypeModel * questionTypeModel;

@property (nonatomic,assign) QUESTIONDETAIL_TYPE enterDetailIsFromNoti; // 是否从通知进入的详情页面

@property (nonatomic,strong) ZETeamNotiCenModel * notiCenM;

@end
