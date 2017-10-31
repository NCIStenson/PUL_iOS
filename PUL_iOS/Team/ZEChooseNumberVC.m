//
//  ZEChooseNumberVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChooseNumberVC.h"

#import "ZEFindTeamVC.h"
#import "ZETeamQuestionVC.h"

@interface ZEChooseNumberVC ()
{
    ZEChooseNumberView * chooseNumberView;
    
    ZEUSER_BASE_INFOM * leaderUserinfo;
}
@end

@implementation ZEChooseNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_enterType == ENTER_CHOOSE_TEAM_MEMBERS_DELETE) {
        self.title = @"删除成员";
        [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(deleteNumbers) forControlEvents:UIControlEventTouchUpInside];
    }else if (_enterType == ENTER_CHOOSE_TEAM_MEMBERS_TRANSFERTEAM){
        self.title = @"选择团长";
        [self.rightBtn setTitle:@"升为团长" forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(whetherTransferTeam) forControlEvents:UIControlEventTouchUpInside];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_TEAMCODE.length > 0 &&_enterType == ENTER_CHOOSE_TEAM_MEMBERS_ASK ) {
        [self sendNumbersRequest];
    }
}
-(void)sendNumbersRequest
{
    if (_TEAMCODE.length > 0) {
        self.title = @"选择团队成员";
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.rightBtn removeTarget:self action:@selector(deleteNumbers) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(finishChooseTeamMembers) forControlEvents:UIControlEventTouchUpInside];

    }

    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"USERTYPE DESC",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.UserInfo",
                                     @"DETAILTABLE":@"",};
    
//    NSDictionary * fieldsDic =@{@"TEAMCIRCLECODE":_teamCircleInfo.SEQKEY,
//                                @"USERCODE":@"",
//                                @"USERNAME":@"",
//                                @"FILEURL":@"",
//                                @"USERTYPE":@""};
//    if ( _TEAMCODE.length > 0) {
      NSDictionary *  fieldsDic =@{@"TEAMCIRCLECODE":_TEAMCODE,
                     @"USERCODE":@"",
                     @"USERNAME":@"",
                     @"FILEURL":@"",
                     @"USERTYPE":@""};
        
//    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_REL_USER];
                                 if (arr.count > 0) {
                                     _numbersArr = [NSMutableArray arrayWithArray: arr];
                                     [chooseNumberView reloadViewWithAlreadyInviteNumbers:_numbersArr];

                                     //                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_FINISH_INVITE_TEAMCIRCLENUMBERS object:arr];
                                 }else{
                                     //                                         [self showTips:@"暂无相关成员~"];
                                 }
                             } fail:^(NSError *error) {
                             }];
    
}

#pragma mark - 转让团队

-(void)confirmTransferTeam
{
    
    NSMutableArray * fieldsArr = [NSMutableArray array];
    NSMutableArray * tableArr = [NSMutableArray array];
    
    NSMutableArray * USERCODELIST = [NSMutableArray array];
    
    for (NSDictionary * dic in chooseNumberView.alreadyInviteNumbersArr) {
        NSLog(@" ===  %@ ",dic);
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:dic];
        NSDictionary * listDic;
        if ([userinfo.USERTYPE integerValue] == 0 || [userinfo.USERTYPE integerValue] == 4) {
             listDic = @{@"USERCODE":userinfo.USERCODE,
                         @"USERNAME":userinfo.USERNAME,
                         @"USERTYPE":@"0"};
        }else if ([userinfo.USERTYPE integerValue] == 2){
            listDic = @{@"USERCODE":userinfo.USERCODE,
                        @"USERNAME":userinfo.USERNAME,
                        @"USERTYPE":@"2"};
        }else if ([userinfo.USERTYPE integerValue] == 3){
            listDic = @{@"USERCODE":userinfo.USERCODE,
                        @"USERNAME":userinfo.USERNAME,
                        @"USERTYPE":@"3"};
        }
        
        if ([userinfo.USERCODE isEqualToString:chooseNumberView.currentSelectUserinfo.USERCODE]) {
            listDic = @{@"USERCODE":userinfo.USERCODE,
                        @"USERNAME":userinfo.USERNAME,
                        @"USERTYPE":@"4"};
        }
        [USERCODELIST addObject:listDic];
        [tableArr addObject:KLB_TEAMCIRCLE_REL_USER];
    }
    
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_INFO,
                                     @"DETAILTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"GroupUserTran",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"TEAMCIRCLECODE",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleManager",
                                     @"USERCODELIST":USERCODELIST,
                                     };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_teaminfo.SEQKEY,
                                @"JMESSAGEGROUPID":_teaminfo.JMESSAGEGROUPID,
                                @"SYSCREATORID":chooseNumberView.currentSelectUserinfo.USERCODE};
    if (_TEAMCODE.length > 0) {
        fieldsDic =@{@"SEQKEY":_TEAMCODE,
                     @"JMESSAGEGROUPID":_teaminfo.JMESSAGEGROUPID,
                     @"SYSCREATORID":chooseNumberView.currentSelectUserinfo.USERCODE};
    }
    
    [fieldsArr addObject:fieldsDic];
    [fieldsArr addObjectsFromArray:USERCODELIST];
    
    [tableArr insertObject:KLB_TEAMCIRCLE_INFO atIndex:0];
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:tableArr
                                                                           withFields:fieldsArr
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [self showTips:@"转移团队成功" afterDelay:1.5];
                                 [self performSelector:@selector(goBackVC) withObject:nil afterDelay:1.5];
                             } fail:^(NSError *error) {
                                 [self showTips:@"操作失败，请重试" afterDelay:1.5];
                                 [self performSelector:@selector(goBackVC) withObject:nil afterDelay:1.5];
                             }];
    
}
-(void)goBackVC
{
    for (UIViewController *viewCtl in self.navigationController.viewControllers) {
        if([viewCtl isKindOfClass:[ZEFindTeamVC class]]){
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)initView
{
    chooseNumberView = [[ZEChooseNumberView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:chooseNumberView];
    [self.view sendSubviewToBack:chooseNumberView];
    [chooseNumberView reloadViewWithAlreadyInviteNumbers:_numbersArr];
    chooseNumberView.TEAMCODE = _TEAMCODE;
    
    if(_enterType == ENTER_CHOOSE_TEAM_MEMBERS_TRANSFERTEAM){
        chooseNumberView.whetherMultiselect = NO;
    }else{
        chooseNumberView.whetherMultiselect = YES;
    }
}

-(void)deleteNumbers
{
    NSMutableArray * addMembersArr = [NSMutableArray array];
    NSMutableArray * subMembersArr = [NSMutableArray array];
    
    for (int i = 0; i < _numbersArr.count; i ++) {
        BOOL mask  = [chooseNumberView.maskArr[i] boolValue];
        if (!mask) {
            [addMembersArr addObject:_numbersArr[i]];
        }else{
            [subMembersArr addObject:_numbersArr[i]];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_FINISH_DELETE_TEAMCIRCLENUMBERS object:addMembersArr];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)leftBtnClick {
    if (_enterType == ENTER_CHOOSE_TEAM_MEMBERS_TRANSFERTEAM || _enterType == ENTER_CHOOSE_TEAM_MEMBERS_DELETE) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (_enterType == ENTER_CHOOSE_TEAM_MEMBERS_ASK){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)finishChooseTeamMembers
{
    NSMutableArray * addMembersArr = [NSMutableArray array];
    NSMutableArray * subMembersArr = [NSMutableArray array];
    
    for (int i = 0; i < _numbersArr.count; i ++) {
        BOOL mask  = [chooseNumberView.maskArr[i] boolValue];
        if (!mask) {
            [addMembersArr addObject:_numbersArr[i]];
        }else{
            [subMembersArr addObject:_numbersArr[i]];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_FINISH_CHOOSE_TEAMCIRCLENUMBERS object:subMembersArr];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 升为团长

-(void)whetherTransferTeam
{
    if(_enterType == ENTER_CHOOSE_TEAM_MEMBERS_TRANSFERTEAM && ![ZEUtil isNotNull:chooseNumberView.currentSelectUserinfo]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString * alertMsg = [NSString stringWithFormat:@"是否确认转让团队给<%@>，一旦转让，您将无法修改团队任何信息",chooseNumberView.currentSelectUserinfo.USERNAME];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertMsg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认转让" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self confirmTransferTeam];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
