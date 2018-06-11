//
//  ZEQZHomeView.h
//  PUL_iOS
//
//  Created by Stenson on 2018/5/24.
//  Copyright © 2018年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEQZHomeView;

@protocol ZEQZHomeViewDelegate <NSObject>

-(void)goDetail:(NSDictionary *)dic;

@end

@interface ZEQZHomeView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableDictionary * dataDic;

@property(nonatomic,weak) id <ZEQZHomeViewDelegate> delegate;

@end
