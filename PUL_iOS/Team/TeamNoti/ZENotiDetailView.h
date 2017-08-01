//
//  ZENotiDetailView.h
//  PUL_iOS
//
//  Created by Stenson on 17/5/5.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZETeamNotiCenModel.h"
@class ZENotiDetailView;

@interface ZENotiDetailHeaderView : UIView

@property (nonatomic,assign) float totalHeight;

@property (nonatomic,strong)UILabel * notiLab;
@property (nonatomic,strong)UILabel * notiTextLab;
@property (nonatomic,strong)UILabel * notiDetailLab;
@property (nonatomic,strong)UILabel * notiDetailTextLab;
@property (nonatomic,strong)CALayer * lineLayer;
@property (nonatomic,strong)CALayer * detailLineLayer;
@property (nonatomic,strong) UILabel * disUsername;
@property (nonatomic,strong) UILabel * dateLab;
@property (nonatomic,strong) UIButton * receiptBtn;
@property (nonatomic,strong)UISegmentedControl *segmentedControl;

@property (nonatomic,weak) ZENotiDetailView * detailView;

-(void)setViewFrames:(ZETeamNotiCenModel *)notiModel withEnterTeamNotiType:(ENTER_TEAMNOTI_TYPE)type;
-(void)setReceiptSelectIndex:(BOOL)isReceipt;

@end
@class ZENotiDetailView;

@protocol ZENotiDetailViewDelegate <NSObject>

-(void)confirmTeamReceipt;

@end


@interface ZENotiDetailView : UIView

@property (nonatomic,weak) id <ZENotiDetailViewDelegate> delegate;
@property (nonatomic,assign) BOOL isReceipt;

@property (nonatomic,strong) NSMutableArray * notiYesReceiptArr;
@property (nonatomic,strong) NSMutableArray * notiNoReceiptArr;

-(void)reloadViewWithArr:(NSArray *)arr withNotiModel:(ZETeamNotiCenModel *)notiModel withIsReceipt:(BOOL)isReceipt;
-(void)reloadViewWithISReceipt:(BOOL)isReceipt;


/**
 不需要回执页面
 */
-(void)reloadPersonalNoReceiptView:(ZETeamNotiCenModel *)notiM;

/**
 需要回执页面
 */
-(void)reloadPersonalYesReceiptView:(ZETeamNotiCenModel *)notiM isReceipt:(BOOL)isReceipt;
@end
