    //
//  ZETeamVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/7.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamVC.h"
#import "ZETeamView.h"

#import "ZEFindTeamVC.h"
#import "ZETeamQuestionVC.h"

#import "ZEPersonalNotiVC.h"

#define kTipsImageTag 1234

@interface ZETeamVC ()<ZETeamViewDelegate>
{
    ZETeamView * teamView;
    ZETeamCircleModel * _teamCircleInfo;
    
    NSInteger _currentSelectTeam;
    
    NSArray * alreadyJoinTeam;
    NSArray * _dynamicArr;
    
    NSString * notiUnreadCount;
}
@end

@implementation ZETeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.title = @"团队";
    self.leftBtn.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAskState:) name:kNOTI_ASK_TEAM_QUESTION object:nil];;

    [self.rightBtn setImage:[UIImage imageNamed:@"icon_noti"] forState:UIControlStateNormal];
    
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self teamHomeRequest];
    [self isHaveNewMessage];
}

-(void)changeAskState:(NSNotification *)noti
{
    
    if ([ZEUtil isNotNull:noti] && [noti.object isKindOfClass:[ZETeamCircleModel class]]) {
        _teamCircleInfo = noti.object;
        for (int i = 0 ; i < alreadyJoinTeam.count ; i ++) {
            ZETeamCircleModel * teaminfo = [ZETeamCircleModel getDetailWithDic:alreadyJoinTeam[i]];
            if ([teaminfo.SEQKEY isEqualToString:_teamCircleInfo.SEQKEY]) {
                _currentSelectTeam = i;
                break;
            }
        }
    }else{
        _currentSelectTeam = 0;
        _teamCircleInfo = NULL;
    }
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

-(void)teamHomeRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMUSER_TEAMNAME,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@'",[ZESettingLocalData getUSERCODE]],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamUserName",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMUSER_TEAMNAME]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMUSER_TEAMNAME];
                                 if ([dataArr count] > 0) {
                                     alreadyJoinTeam = dataArr;
                                     [teamView reloadHeaderView:dataArr];
                                     [self teamDynamics];
//                                     _teamCircleInfo = [ZETeamCircleModel getDetailWithDic:dataArr[0]];
//                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ASK_TEAM_QUESTION object:_teamCircleInfo];
                                 }else{
                                     [teamView reloadHeaderView:dataArr];
                                     [self showTips:@"您还没有加入任何团队，快去加一个吧"];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

//  团队动态
-(void)teamDynamics
{
    NSString * str = nil;
    
    for (int i = 0 ; i < alreadyJoinTeam.count; i ++) {
        ZETeamCircleModel * teaminfo = [ZETeamCircleModel getDetailWithDic:alreadyJoinTeam[i]];

        if (str.length > 0) {
            str = [NSString stringWithFormat:@"%@,%@",str,teaminfo.TEAMCODE];
        }else{
            str = teaminfo.TEAMCODE;
        }

    }
    NSDictionary * parametersDic = @{@"limit":@"30",
                                     @"MASTERTABLE":V_KLB_DYNAMIC_INFO_TEAM,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":[NSString stringWithFormat:@"TEAMCIRCLECODE in (%@)",str],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleDynamic",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_DYNAMIC_INFO_TEAM]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_DYNAMIC_INFO_TEAM];
                                 if ([dataArr count] > 0) {
                                     _dynamicArr = dataArr;
                                     [teamView reloadContentView:dataArr];
                                 }else{

                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)initView
{
    teamView = [[ZETeamView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    teamView.delegate = self;
    [self.view addSubview:teamView];
    [self.view sendSubviewToBack:teamView];
}

#pragma mark - ZETeamViewDelegate

-(void)goFindTeamVC
{
    ZEFindTeamVC * findTeamVC = [[ZEFindTeamVC alloc]init];
    
    [self.navigationController pushViewController:findTeamVC animated:YES];
}

-(void)goTeamQuestionVC:(NSInteger)selectIndex
{
    _teamCircleInfo = [ZETeamCircleModel getDetailWithDic:alreadyJoinTeam[selectIndex]];

    ZETeamQuestionVC * questionVC = [[ZETeamQuestionVC alloc]init];
    questionVC.teamCircleInfo = _teamCircleInfo;
    [self.navigationController pushViewController:questionVC animated:YES];
}

-(void)cellClikcGoTeamQuestionVC:(NSInteger)selectIndex
{
    NSDictionary * currentSelectDic = _dynamicArr[selectIndex];
    
    ZETeamCircleModel * cirecleInfo = [ZETeamCircleModel getDetailWithDic:currentSelectDic];
    
    for (int i = 0 ; i < alreadyJoinTeam.count ; i ++) {
        ZETeamCircleModel * teaminfo = [ZETeamCircleModel getDetailWithDic:alreadyJoinTeam[i]];
        if ([teaminfo.TEAMCODE isEqualToString:cirecleInfo.TEAMCIRCLECODE]) {
            _teamCircleInfo = teaminfo;
            
            ZETeamQuestionVC * questionVC = [[ZETeamQuestionVC alloc]init];
            questionVC.teamCircleInfo = _teamCircleInfo;
            [self.navigationController pushViewController:questionVC animated:YES];
            NSLog(@" =======  %@",teaminfo.DYNAMICTYPE);
            switch ([cirecleInfo.DYNAMICTYPE integerValue]) {
                case 1:
                    questionVC.currentContent = TEAM_CONTENT_NEWEST;
                    break;
                    
                case 2:
                    questionVC.currentContent = TEAM_CONTENT_MYQUESTION;
                    break;
                   
                case 3:
                    questionVC.currentContent = TEAM_CONTENT_TARGETASK;
                    break;

                default:
                    break;
            }

            break;
        }
    }
}


-(void)rightBtnClick
{
    ZEPersonalNotiVC * personalNotiVC = [[ZEPersonalNotiVC alloc]init];
    personalNotiVC.notiCount = [notiUnreadCount integerValue];
    [self.navigationController pushViewController:personalNotiVC animated:YES];
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
