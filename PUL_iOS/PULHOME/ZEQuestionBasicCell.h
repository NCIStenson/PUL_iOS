//
//  ZEQuestionBasicCell.h
//  PUL_iOS
//
//  Created by Stenson on 17/7/6.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEQuestionBasicCell;

@protocol ZEQuestionBasicCellDelegate <NSObject>

-(void)didSelectAnswerBtn;

@end

@interface ZEQuestionBasicCell : UITableViewCell

@property (nonatomic,retain) UIButton * answerBtn;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)reloadCellView:(NSDictionary *)dataDic;

@end
