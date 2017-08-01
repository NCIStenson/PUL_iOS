//
//  ZEHomeLayout.h
//  PUL_iOS
//
//  Created by Stenson on 17/2/22.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kZEHomeCellTopMargin 8      // cell 顶部灰色留白
#define kZEHomeCellUserMsgViewHeight 30   // cell 标题高度 (例如"仅自己可见")
#define kZEHomeCellPadding 12       // cell 内边距
#define kZEHomeCellPaddingText 10   // cell 文本与其他元素间留白
#define kZEHomeCellPaddingPic 4     // cell 多张图片中间留白
#define kZEHomeCellProfileHeight 56 // cell 名片高度
#define kZEHomeCellCardHeight 70    // cell card 视图高度
#define kZEHomeCellNamePaddingLeft 14 // cell 名字和 avatar 之间留白
#define kZEHomeCellContentWidth (kScreenWidth - 2 * kZEHomeCellPadding) // cell 内容宽度
#define kZEHomeCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制

#import <UIKit/UIKit.h>

@interface ZEHomeLayout : NSObject

// 总高度
@property (nonatomic, assign) CGFloat height;

@end
