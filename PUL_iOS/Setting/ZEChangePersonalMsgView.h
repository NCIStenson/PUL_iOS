//
//  ZEChangePersonalMsgView.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/15.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//


@class ZEChangePersonalMsgView;

@protocol ZEChangePersonalMsgViewDelegate <NSObject>

//-(void)submit;

@end

@interface ZEChangePersonalMsgView : UIView

@property (nonatomic,strong) UITextField * nicknameField;
@property (nonatomic,strong) UITextView * adviceTextView;
@property (nonatomic,weak) id <ZEChangePersonalMsgViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withChangeType:(CHANGE_PERSONALMSG_TYPE)changType;

@end
