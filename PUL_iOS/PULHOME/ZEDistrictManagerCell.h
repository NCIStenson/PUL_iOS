//
//  ZEDistrictManagerCell.h
//  PUL_iOS
//
//  Created by Stenson on 2017/12/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZEDistrictManagerCell : UITableViewCell

@property (nonatomic,strong) UIView * lineLayer;

-(void)initUIWithDic:(NSDictionary *)dic;

@end
