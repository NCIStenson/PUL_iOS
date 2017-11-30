//
//  ZEChatTextCell.h
//  PUL_iOS
//
//  Created by Stenson on 16/12/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kMaxWidth SCREEN_WIDTH * 0.7

#define kLeftHeadImageMarginLeft 10
#define kRightHeadImageMarginRight 10
#define kHeadImgaeMarginTop 10
#define kHeadImageWidth 40
#define kHeadImageHight kHeadImageWidth

#define kBubbleMarginLeft 55
#define kBubbleMarginTop 10

#define kContentMarginTop kBubbleMarginTop + 8
#define kContentMarginLeft ( kBubbleMarginLeft + 18 )


#import <UIKit/UIKit.h>
#import "ZEChatLayout.h"


@class  ZEChatBaseCell;
@protocol ZEChatBaseCellDelegate <NSObject>

@optional

- (void)contentImageClick:(NSString *)contentImageURL;

-(void)showWebVC:(NSString *)urlStr;

@end


@interface ZEChatBaseView : UIView

@property (nonatomic, strong) UIView *contentView;              // 容器

@property (nonatomic, strong) UIImageView *headImageView;       // 头像
@property (nonatomic, strong) UIImageView *bubbleView;       // 背景气泡

@end


@interface ZEChatTextView : ZEChatBaseView

@property (nonatomic, strong) UITextView *contentLab;              // 容器
@property (nonatomic,weak) ZEChatBaseCell * cell;
-(void)setContent:(id)infoM withLayout:(ZEChatLayout *)layout;
@end

@interface ZEChatImageView : ZEChatBaseView

-(void)setContent:(ZEChatLayout *)layout;

@property (nonatomic, copy) NSString * chatImageUrl;
@property (nonatomic, strong) UIButton * contentImageBtn;

@property (nonatomic,weak) ZEChatBaseCell * cell;


@end


@interface ZEChatBaseCell : UITableViewCell

@property (nonatomic, weak) id<ZEChatBaseCellDelegate> delegate;

/* 内容 */ 
@property (nonatomic, strong) ZEChatTextView * contentTextView;
@property (nonatomic, strong) ZEChatImageView * contentImageView;

- (void)setLayout:(ZEChatLayout *)layout withContentType:(NSString *)typeStr;

@end
