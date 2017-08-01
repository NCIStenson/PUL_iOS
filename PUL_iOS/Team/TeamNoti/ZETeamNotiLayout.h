//
//  ZETeamNotiLayout.h
//  PUL_iOS
//
//  Created by Stenson on 17/5/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZETeamNotiCenModel.h"
@interface ZETeamNotiLayout : NSObject

@property (nonatomic,assign) float height;

@property (nonatomic, assign) CGFloat titleHeight; //标题栏高度，0为没标题栏
@property (nonatomic, assign) CGFloat detailHeight; //发布人栏高

@property (nonatomic,strong) ZETeamNotiCenModel * teamNotiModel;

- (instancetype)initWithContent:(ZETeamNotiCenModel *)teamNotiModel;

@end
