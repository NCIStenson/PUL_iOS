//
//  ZEChatView.h
//  PUL_iOS
//
//  Created by Stenson on 16/12/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEChatBaseCell.h"
@class ZEChatView;

@interface ZEChatInputView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UITextField * inputField;

@property (nonatomic,weak) ZEChatView *chatView;

@end

@protocol ZEChatViewDelegate;

@interface ZEChatView : UIView <ZEChatBaseCellDelegate>

@property (nonatomic,weak) id <ZEChatViewDelegate> delegate;
@property (nonatomic,strong) ZEChatInputView * inputView;

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoM;
@property (nonatomic,strong) ZEAnswerInfoModel * answerInfoM;

-(id)initWithFrame:(CGRect)frame
 withQuestionInfoM:(ZEQuestionInfoModel *)quesinfo
   withAnswerInfoM:(ZEAnswerInfoModel *)answerInfo;

-(void)reloadDataWithArr:(NSArray *)arr;

-(void)uploadTextSuccess;

@end

@protocol ZEChatViewDelegate <NSObject>

@optional

/******* 选择图片 *******/
-(void)didSelectCameraBtn;

/******* 发送 *******/
-(void)didSelectSend:(NSString *)inputText;
@end
