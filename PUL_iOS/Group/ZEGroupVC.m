//
//  ZEGroupVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#define kTipsImageTag 1234

#import "ZEGroupVC.h"

#import "ZEProfessionalCirVC.h"
#import "ZETeamCircleVC.h"
#import "ZEPersonalNotiVC.h"

@interface ZEGroupVC ()
{
    ZETeamCircleVC * teamCirVC;
    ZEProfessionalCirVC * profCirVC;
    
    UIButton * _professionalBtn;
    UIButton * _teamBtn;
    
    NSString * notiUnreadCount;
}
@end

@implementation ZEGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_enter_group_type == ENTER_GROUP_TYPE_DEFAULT) {
        self.title = @"圈子";        
    }else if (_enter_group_type == ENTER_GROUP_TYPE_SETTING){
        self.title = @"我的圈子";
    }
//    [self initView];
    
//    teamCirVC =[[ZETeamCircleVC alloc]init];
    profCirVC = [[ZEProfessionalCirVC alloc]init];
    profCirVC.enter_group_type = _enter_group_type;
//    [self addChildViewController:teamCirVC];
    [self addChildViewController:profCirVC];
    
    [self.view addSubview:profCirVC.view];
    [self.view sendSubviewToBack:profCirVC.view];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_QUESTION object:nil];

//    if (_enter_group_type == ENTER_GROUP_TYPE_DEFAULT) {
//        self.tabBarController.tabBar.hidden = NO;
//    }else if (_enter_group_type == ENTER_GROUP_TYPE_SETTING){
//        self.tabBarController.tabBar.hidden = YES;
//    }
//    [self isHaveNewMessage];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 是否有新消息提醒

-(void)isHaveNewMessage
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfoManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"INFOCOUNT":@"",
                                @"QUESTIONCOUNT":@"",
                                @"ANSWERCOUNT":@"",
                                @"TEAMINFOCOUNT":@"",
                                @"PERINFOCOUNT":@"",
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"userbaseinfo"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
                                 if ([arr count] > 0) {
                                     NSString * INFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"INFOCOUNT"]];
                                     NSString * TEAMINFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"TEAMINFOCOUNT"]];
                                     NSString * PERINFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"PERINFOCOUNT"]];
                                     notiUnreadCount = PERINFOCOUNT;
                                     if ([INFOCOUNT integerValue] > 0) {
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                                         item.badgeValue= INFOCOUNT;
                                         if ([INFOCOUNT integerValue] > 99) {
                                             item.badgeValue= @"99+";
                                         }
                                     }else{
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                                         item.badgeValue= nil;
                                     }
                                     if ([TEAMINFOCOUNT integerValue] > 0 ) {
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
                                         item.badgeValue= TEAMINFOCOUNT;
                                         if ([INFOCOUNT integerValue] > 99) {
                                             item.badgeValue= @"99+";
                                         }
                                     }else{
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
                                         item.badgeValue= nil;
                                     }
                                     
                                     long sumCount = [[JMSGConversation getAllUnreadCount] integerValue]+ [PERINFOCOUNT integerValue];
                                     
                                     UILabel* tipsImage;
                                     tipsImage = [self.view viewWithTag:kTipsImageTag];
                                     if (sumCount  > 0) {
                                         if (!tipsImage) {
                                             tipsImage = [[UILabel alloc]init];
                                             [self.view addSubview:tipsImage];
                                             tipsImage.backgroundColor = [UIColor redColor];
                                             tipsImage.top = self.rightBtn.top;
                                             tipsImage.height = 20;
                                             tipsImage.width = 20;
                                             tipsImage.clipsToBounds = YES;
                                             tipsImage.layer.cornerRadius = 10;
                                             tipsImage.left = self.rightBtn.centerX + 8;
                                             tipsImage.tag = kTipsImageTag;
                                             [tipsImage adjustsFontSizeToFitWidth];
                                             [tipsImage setFont:[UIFont systemFontOfSize:tipsImage.font.pointSize - 3]];
                                             tipsImage.textColor = [UIColor whiteColor];
                                             tipsImage.textAlignment = NSTextAlignmentCenter;
                                         }
                                         tipsImage.hidden = NO;
                                         [tipsImage setText:[NSString stringWithFormat:@"%ld",(long)sumCount]];
                                     }else{
                                         tipsImage.hidden = YES;
                                     }
                                     
                                 }
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>  %@",errorCode);
                             }];
}

-(void)rightBtnClick
{
    ZEPersonalNotiVC * personalNotiVC = [[ZEPersonalNotiVC alloc]init];
    personalNotiVC.notiCount = [notiUnreadCount integerValue];
    [self.navigationController pushViewController:personalNotiVC animated:YES];
}

-(void)initView{
    
//    UIView * segmentBGView = [[UIView alloc]initWithFrame:CGRectMake(40, NAV_HEIGHT, SCREEN_WIDTH - 80.0f, 40.0f)];
//    segmentBGView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:segmentBGView];
//    segmentBGView.clipsToBounds = YES;
//    segmentBGView.layer.cornerRadius = 10;
//    segmentBGView.layer.borderWidth = 1;
//    segmentBGView.layer.borderColor = [MAIN_NAV_COLOR CGColor];
//    
//    CALayer * lineLayer = [CALayer layer];
//    [segmentBGView.layer addSublayer:lineLayer];
//    lineLayer.backgroundColor  = MAIN_LINE_COLOR.CGColor ;
    
    _professionalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _professionalBtn.frame = CGRectMake(0, NAV_HEIGHT, (SCREEN_WIDTH  - 80 ) / 2, 45.0f);
    [_professionalBtn setTitle:@"专业圈" forState:UIControlStateNormal];
    [_professionalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _professionalBtn.backgroundColor = MAIN_NAV_COLOR_A(0.5);
    [self.view addSubview:_professionalBtn];
//    [_professionalBtn addTarget:self action:@selector(transVC:) forControlEvents:UIControlEventTouchUpInside];
    

//    _teamBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _teamBtn.frame = CGRectMake((SCREEN_WIDTH  - 80 ) / 2, 0, (SCREEN_WIDTH  - 80 ) / 2, 40.0f);
//    _teamBtn.backgroundColor = [UIColor yellowColor];
//    [_teamBtn setTitle:@"班组圈" forState:UIControlStateNormal];
//    [_teamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _teamBtn.backgroundColor = [UIColor whiteColor];
//    [segmentBGView addSubview:_teamBtn];
//    [_teamBtn addTarget:self action:@selector(transVC:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)transVC:(UIButton *)btn
{
    if ([btn isEqual:_professionalBtn]) {
        [self transitionFromViewController:teamCirVC
                          toViewController:profCirVC
                                  duration:0
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    _professionalBtn.backgroundColor = MAIN_NAV_COLOR;
                                    [_professionalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    _teamBtn.backgroundColor = [UIColor whiteColor];
                                    [_teamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                   } completion:^(BOOL finished) {
                                       [self.view sendSubviewToBack:profCirVC.view];
                                   }];
    }else{
        [self transitionFromViewController:profCirVC
                          toViewController:teamCirVC
                                  duration:0
                                   options:UIViewAnimationOptionCurveLinear
                                animations:^{
                                    _teamBtn.backgroundColor = MAIN_NAV_COLOR;
                                    [_teamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    _professionalBtn.backgroundColor = [UIColor whiteColor];
                                    [_professionalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                } completion:^(BOOL finished) {
                                    [self.view sendSubviewToBack:teamCirVC.view];
                                }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
