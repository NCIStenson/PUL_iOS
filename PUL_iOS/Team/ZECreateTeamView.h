//
//  ZECreateTeamView.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEAskQuestionTypeView.h"
#import "ZETeamCircleModel.h"
@class ZECreateTeamView;

@interface ZECreateTeamManagerView : UIView

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic,weak) ZECreateTeamView * createTeamView;

@end

@interface ZECreateTeamMessageView : UIView<UITextFieldDelegate,UITextViewDelegate,ZEAskQuestionTypeViewDelegate>
{
    UITextView * _manifestoTextView;
    UITextField * _teamNameField;
    
    UITextView * _profileTextView; // 团队简介输入框
    UIButton * _teamHeadImgBtn;
    ZETeamCircleModel * teamCircleInfo;
}
@property (nonatomic, assign) NSInteger textLocation;//这里声明一个全局属性，用来记录输入位置
@property (nonatomic,weak) ZECreateTeamView * createTeamView;
@property (nonatomic,strong) ZEAskQuestionTypeView * teamTypeView;
@property (nonatomic,strong) UITextField * teamNameField;    // 团队名称
@property (nonatomic,strong) UIButton * teamTypeBtn;
@property (nonatomic,strong) UITextView * manifestoTextView; // 团队宣言
@property (nonatomic,strong) UITextView * profileTextView;   //  团队简介
@property (nonatomic,copy) NSString * TEAMCIRCLECODENAME;    //  班组圈分类名称
@property (nonatomic,copy) NSString * TEAMCIRCLECODE;        //  班组圈分类编码

@property (nonatomic,copy) NSString * teamNameStr;        // 团队名称字符
@property (nonatomic,copy) NSString * inputManifestoStr;        //  班组宣言字符
@property (nonatomic,copy) NSString * inputProfileStr;        // 团队简介字符


- (void)reloadTeamHeadImageView:(UIImage *)headImage;

-(id)initWithFrame:(CGRect)frame withTeamCircleInfo:(ZETeamCircleModel *)teamCircleM;

-(void)allowEdit;

@end;

@interface ZECreateTeamNumbersView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * _collectionView;
    ENTER_TEAM _enterTeamType;
}

@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * alreadyInviteNumbersArr;
@property (nonatomic,weak) ZECreateTeamView * createTeamView;

-(void)reloadNumbersView:(NSArray *)numbersArr withEnterType:(ENTER_TEAM)type;

@end

@protocol ZECreateTeamViewDelegate  <NSObject>


/**
 添加人员界面
 */
-(void)goQueryNumberView;

/**
 删除人员界面
 */
-(void)goRemoveNumberView;


/**
 拍照或者相册选择
 */
-(void)takePhotosOrChoosePictures;


/**
 是否同意加入团队
 */
-(void)whetherAgreeJoinTeam:(ZEUSER_BASE_INFOM *)userinfo;


/**
 是否转让团队
 */
-(void)whetherTransferTeam:(ZEUSER_BASE_INFOM *)userinfo;

/**
 是否解散团队
 */
-(void)whetherDeleteTeam;


/**
 指定管理员
 */
-(void)designatedAdministrator:(ZEUSER_BASE_INFOM *)userinfo;

/**
 撤销管理员
 */
-(void)revokeAdministrator:(ZEUSER_BASE_INFOM *)userinfo;


-(void)goTeamNotiCenter;

-(void)goPracticeManager;

-(void)goExamManager;

@end

@interface ZECreateTeamView : UIView
{
    ZETeamCircleModel * teamCircleInfo;
}
-(id)initWithFrame:(CGRect)frame withTeamCircleInfo:(ZETeamCircleModel *)teamCircleM;

/**
 刷新管理员界面

 @param isManager 是否是管理员
 */
-(void)reloadManagertView:(BOOL)isManager;

@property (nonatomic,strong) ZECreateTeamManagerView * managerView;
@property (nonatomic,strong) ZECreateTeamMessageView * messageView;
@property (nonatomic,strong) ZECreateTeamNumbersView * numbersView;
@property (nonatomic,weak) id <ZECreateTeamViewDelegate> delegate;

@end
