//
//  ZESendNotiView.h
//  PUL_iOS
//
//  Created by Stenson on 17/5/5.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZESendNotiView : UIView

@property (nonnull,strong) UITextView * notiTextView;
@property (nonnull,strong) UILabel * notiTextLengthLab;

@property (nonnull,strong) UITextView * notiDetailTextView;
@property (nonnull,strong) UILabel * notiDetailTextLengthLab;

@property (nonnull,copy) NSString * notiStr;
@property (nonnull,copy) NSString * notiDetailStr;

@property (nonatomic,assign) BOOL isReceipt; // 是否回执

@end
