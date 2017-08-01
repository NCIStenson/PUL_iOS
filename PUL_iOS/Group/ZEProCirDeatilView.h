//
//  ZEProCirDeatilView.h
//  PUL_iOS
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEExpertModel.h"
@class ZEProCirDetailView;
@protocol ZEProCirDeatilViewDelegate <NSObject>


/**
 展示动态
 */
-(void)goDynamic;


/**
 更多经典案例
 */
-(void)goMoreCaseVC;


/**
 *  @author Stenson, 17-03-17 10:07:18
 *
 *  去经典案例详情
 */
-(void)goTypicalDetail:(NSDictionary *)detailDic;


/**
 更多专家
 */
-(void)goMoreExpertVC;

/**
 专家详情界面

 @param detailDic <#detailDic description#>
 */
-(void)goExpertDetail:(ZEExpertModel *)expertM;


/**
 更多行业规范
 */
-(void)goMoreWorkStandard;


/**
 行业规范详情
 */
-(void)goWorkStandardDetail:(NSDictionary *)standardDic;
/**
 排行榜更多详情
 */
-(void)moreRankingMessage;
@end

@interface ZEProCirDeatilView : UIView

@property (nonatomic,weak) id <ZEProCirDeatilViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)reloadSection:(NSInteger)section
            scoreDic:(NSDictionary *)dic
          memberData:(id)data;

-(void)reloadCaseView:(NSArray *)arr;

-(void)reloadExpertView:(NSArray *)arr;

-(void)reloadWorkStandardView:(NSArray *)arr;

@end
