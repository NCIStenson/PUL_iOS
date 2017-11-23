//
//  ZEWorkStandardDetailView.h
//  PUL_iOS
//
//  Created by Stenson on 2017/11/20.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEWorkStandardDetailView;

@protocol ZEWorkStandardDetailViewDelegate <NSObject>

-(void)goWorkStandardDetailWithURL:(NSString *)urlStr withWorkStandardSeqkey:(NSString *)workSeqkey;

@end

@interface ZEWorkStandardDetailView : UIView

@property (nonatomic,weak) id <ZEWorkStandardDetailViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame withWorkStandard:(NSDictionary *)dic;

@end
