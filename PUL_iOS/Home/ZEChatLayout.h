//
//  ZEChatLayout.h
//  PUL_iOS
//
//  Created by Stenson on 16/12/6.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kCellTopMargin 15      // cell 顶部灰色留白

#define kCellBottomMargin 15

#import <Foundation/Foundation.h>

@interface ZEChatLayout : NSObject

// 总高度
@property (nonatomic, assign) CGFloat height;

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfo;
@property (nonatomic,strong) ZEAnswerInfoModel * answerInfo;
@property (nonatomic,strong) ZEQuesAnsDetail * quesAnsM;

@property (nonatomic,strong) NSString * imageURL;

@property (nonatomic,strong) NSString * usercode;
@property (nonatomic,strong) NSString * headImageUrl;

// 标题栏
@property (nonatomic, assign) CGFloat titleHeight; //标题栏高度，0为没标题栏
@property (nonatomic, strong) YYTextLayout *titleTextLayout; // 标题栏


- (instancetype)initWithTextContent:(ZEQuestionInfoModel *)questionInfo
                     withAnswerInfo:(ZEAnswerInfoModel *)answerInfo;

- (instancetype)initWithDetailTextContent:(ZEQuesAnsDetail *)quesAnsM
                            withHeadImage:(NSString *)imageUrl;

- (instancetype)initWithImgaeUrl:(NSString *)url
                        usercode:(NSString *)usercode
                    headImageUrl:(NSString *)headImageUrl;

- (instancetype)initWithChatImgaeUrl:(NSString *)url
                        chatUsercode:(NSString *)usercode
                    chatHeadImageUrl:(NSString *)headImageUrl;

- (void)layout; ///< 计算布局

@end
