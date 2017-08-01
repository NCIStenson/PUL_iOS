//
//  ZEUserCenterView.h
//  NewCentury
//
//  Created by Stenson on 16/4/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEUserCenterView;

@protocol ZEUserCenterViewDelegate <NSObject>

/************** 我的问题  ****************/
-(void)goMyQuestionList;
/************** 我的回答列表  ****************/
-(void)goMyAnswerList;
/************** 个人信息设置列表 ****************/
-(void)goSettingVC:(ENTER_SETTING_TYPE)type;

/************** 个人信息设置列表 ****************/
-(void)goMyGroup;
/************** 我的收藏 ****************/
-(void)goMyCollect;

/************** 头像上传 ****************/
-(void)takePhotosOrChoosePictures;

/************** 意见反馈 ****************/
-(void)changePersonalMsg:(CHANGE_PERSONALMSG_TYPE)type;

-(void)goSinginVC;

-(void)goNotiVC;

-(void)goSchollVC:(ENTER_WEBVC)type;

@end

@interface ZEUserCenterView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id <ZEUserCenterViewDelegate> delegate;

@property(nonatomic,strong)UIButton * notiBtn;
@property(nonatomic,strong)UIView * userMessage;

-(void)reloadHeaderB;

-(void)reloadHeaderMessage:(NSString *)questionCount answerCount:(NSString *)answerCount;

@end
