//
//  ZENewQuestionDetailVC.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESettingRootVC.h"
#import "ZETeamNotiCenModel.h"
#import "ZENewQuestionDetailView.h"

@interface ZENewQuestionDetailVC : ZESettingRootVC<ZENewQuestionDetailViewDelegate>

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfo;

@property (nonatomic,assign) QUESTIONDETAIL_TYPE enterDetailIsFromNoti; // 是否从通知进入的详情页面

@property (nonatomic,strong) ZETeamNotiCenModel * notiCenM;
@property (nonatomic,copy) NSString * QUESTIONID;

@end
