//
//  ZEQuestionBankView.h
//  PUL_iOS
//
//  Created by Stenson on 17/8/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEPULHomeModel.h"

@class ZEQuestionBankView;
@class ZEChangeQuestionBankView;

@protocol ZEQuestionBankViewDelegate <NSObject>

-(void)goQuestionBankWebView:(ENTER_QUESTIONBANK_TYPE)type;

-(void)goSearchBankList;
@end

@interface ZEQuestionBankView : UIView

@property (nonatomic,strong) ZEPULHomeQuestionBankModel * bankModel;
@property (nonatomic,copy) NSString * bankID;
@property (nonatomic,weak) id <ZEQuestionBankViewDelegate> delegate;

@end

@protocol ZEChangeQuestionBankViewDelegate <NSObject>

-(void)finshChooseBank:(NSDictionary * )dic withIndex:(NSInteger)index;

@end

@interface ZEChangeQuestionBankView : UIView

@property (nonatomic,weak) id <ZEChangeQuestionBankViewDelegate> delegate;
@property (nonatomic,strong) NSArray * banksArr;

@end
