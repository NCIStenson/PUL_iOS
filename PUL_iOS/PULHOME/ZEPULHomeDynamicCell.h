//
//  ZEPULHomeDynamicCell.h
//  PUL_iOS
//
//  Created by Stenson on 17/8/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEQuestionInfoModel.h"
@interface ZEPULHomeDynamicCell : UITableViewCell

@property (nonatomic,strong) UIImageView * dynamicImageView;  // 动态类型图片
@property (nonatomic,strong) UILabel * textLab;         // 动态名称 ： 签到 能力学堂
@property (nonatomic,strong) UILabel * timeLab;         // 动态时间
@property (nonatomic,strong) UILabel * contentLab;      // 动态内容
@property (nonatomic,strong) UILabel * subContentLab;   // 动态副文本
@property (nonatomic,strong) UILabel * tipsLab;          // 立即查看按钮
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)reloadCellView:(ZEQuestionInfoModel *)model;

@end
