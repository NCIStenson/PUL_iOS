//
//  ZECreateTeamVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZECreateTeamVC.h"
#import "ZECreateTeamView.h"

#import "ZEQueryNumberVC.h"
#import "ZEChooseNumberVC.h"

#import "ZETeamCircleModel.h"
#import "ZETeamNotiCenVC.h"

#import "ZEFindTeamVC.h"
#import "ZETeamWebVC.h"

#define textViewStr @"请输入团队宣言（不超过20字）"
#define textViewProfileStr @"请输入团队简介，建议不超过100字！"

@interface ZECreateTeamVC ()<ZECreateTeamViewDelegate>
{
    ZECreateTeamView * createTeamView;
    UIImage * _choosedImage;
    
    NSMutableArray * _originMembersArr; // 进入界面时的人员
}
@end

@implementation ZECreateTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];

    if(_enterType == ENTER_TEAM_CREATE){
        self.title = @"创建团队";
        [self.rightBtn setTitle:@"确认创建" forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(createTeamData) forControlEvents:UIControlEventTouchUpInside];

        [createTeamView.numbersView reloadNumbersView:@[] withEnterType:ENTER_TEAM_CREATE];
    }else{
        self.title = _teamCircleInfo.TEAMCIRCLENAME;
        if([[ZESettingLocalData getUSERCODE] isEqualToString:_teamCircleInfo.SYSCREATORID]){
            [self.rightBtn setTitle:@"确认修改" forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(updateTeamData) forControlEvents:UIControlEventTouchUpInside];
        }else{
        }
    }
    
    if (_enterType == ENTER_TEAM_DETAIL) {
        [self sendNumbersRequest];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNumbersView:) name:kNOTI_FINISH_INVITE_TEAMCIRCLENUMBERS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMembers:) name:kNOTI_FINISH_DELETE_TEAMCIRCLENUMBERS object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_CHANGE_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_FINISH_INVITE_TEAMCIRCLENUMBERS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_FINISH_DELETE_TEAMCIRCLENUMBERS object:nil];
}

-(void)reloadNumbersView:(NSNotification *)noti
{
    _originMembersArr = [NSMutableArray arrayWithArray:noti.object];
    [createTeamView.numbersView reloadNumbersView:noti.object withEnterType:_enterType];
}

-(void)deleteMembers:(NSNotification *)noti
{
    _originMembersArr = [NSMutableArray arrayWithArray:noti.object];
    [createTeamView.numbersView reloadNumbersView:noti.object withEnterType:ENTER_TEAM_DETAIL];
}

-(void)initView{
    createTeamView = [[ZECreateTeamView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withTeamCircleInfo:_teamCircleInfo];
    createTeamView.delegate = self;
    [self.view addSubview:createTeamView];
    [self.view sendSubviewToBack:createTeamView];
}

-(void)leftBtnClick{
    if ([ZEUtil isNotNull:createTeamView.messageView.teamTypeView]) {
        [createTeamView.messageView.teamTypeView removeAllSubviews];
        [createTeamView.messageView.teamTypeView removeFromSuperview];
        createTeamView.messageView.teamTypeView = nil;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 创建班组圈发送请求

-(void)sendNumbersRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"USERTYPE DESC , SYSCREATEDATE DESC",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":@"",
                                @"TEAMCIRCLECODE":_teamCircleInfo.SEQKEY,
                                @"USERCODE":@"",
                                @"USERNAME":@"",
                                @"FILEURL":@"",
                                @"USERTYPE":@""};
    if ( _TEAMCODE.length > 0) {
        fieldsDic =@{@"SEQKEY":@"",
                     @"TEAMCIRCLECODE":_TEAMCODE,
                     @"USERCODE":@"",
                     @"USERNAME":@"",
                     @"FILEURL":@"",
                     @"USERTYPE":@""};
        
    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_REL_USER];
                                 if (arr.count > 0) {
                                     [createTeamView.numbersView reloadNumbersView:arr withEnterType:ENTER_TEAM_DETAIL];
                                     
                                     _originMembersArr = [NSMutableArray arrayWithArray: arr];
                                     for (NSDictionary * dic in _originMembersArr ){
                                         ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:dic];
                                         if ([[ZESettingLocalData getUSERCODE] isEqualToString:userinfo.USERCODE] && ![[ZESettingLocalData getUSERCODE] isEqualToString:_teamCircleInfo.SYSCREATORID]) {
                                             if ([userinfo.USERTYPE integerValue] == 3) {
                                                 [self.rightBtn setTitle:@"确认修改" forState:UIControlStateNormal];
                                                 [self.rightBtn addTarget:self action:@selector(updateTeamData) forControlEvents:UIControlEventTouchUpInside];
                                                 [createTeamView reloadManagertView:YES];
                                             }else{
                                                 [self.rightBtn setTitle:@"退出团队" forState:UIControlStateNormal];
                                                 [self.rightBtn addTarget:self action:@selector(quitTeam) forControlEvents:UIControlEventTouchUpInside];
                                                 [createTeamView reloadManagertView:NO];
                                             }
                                             break;
                                         }
                                     }
                                 }else{
                                     //                                         [self showTips:@"暂无相关成员~"];
                                 }
                             } fail:^(NSError *error) {
                             }];
    
}

-(void)createTeamData
{
    [self.view endEditing:YES];
    
    NSString * TEAMCIRCLENAME = createTeamView.messageView.teamNameField.text;
    NSString * TEAMMANIFESTO = createTeamView.messageView.manifestoTextView.text;
    NSString * TEAMCIRCLEREMARK = createTeamView.messageView.profileTextView.text;
    NSString * TEAMCIRCLECODE = createTeamView.messageView.TEAMCIRCLECODE;
    NSString * TEAMCIRCLECODENAME =createTeamView.messageView.TEAMCIRCLECODENAME;
    
    if (TEAMCIRCLENAME.length == 0|| TEAMCIRCLEREMARK.length == 0 ||  TEAMMANIFESTO.length == 0 || TEAMCIRCLECODENAME.length == 0) {
        [self showTips:@"请完善班组圈信息"];
        return;
    }
    if ([TEAMMANIFESTO isEqualToString:textViewStr] || [TEAMCIRCLEREMARK isEqualToString:textViewProfileStr]) {
        [self showTips:@"请完善班组圈信息"];
        return;
    }
    
    [self.rightBtn setEnabled:NO];
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_INFO,
                                     @"DETAILTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"TEAMCIRCLECODE",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleManager",
                                     };
    
    NSDictionary * fieldsDic =@{@"TEAMCIRCLENAME":TEAMCIRCLENAME,
                                @"TEAMCIRCLEREMARK":TEAMCIRCLEREMARK,
                                @"TEAMMANIFESTO":TEAMMANIFESTO,
                                @"TEAMCIRCLECODE":TEAMCIRCLECODE,
                                @"TEAMCIRCLECODENAME":TEAMCIRCLECODENAME,
                                };
    NSMutableArray * tableArr = [NSMutableArray arrayWithArray:@[KLB_TEAMCIRCLE_INFO]];
    NSMutableArray * fieldsArr = [NSMutableArray arrayWithArray:@[fieldsDic]];
    
    for (int i = 0; i < createTeamView.numbersView.alreadyInviteNumbersArr.count; i ++) {
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:createTeamView.numbersView.alreadyInviteNumbersArr[i]];
        NSDictionary * numbersFieldsDic = @{@"USERCODE":userinfo.USERCODE,
                                            @"USERNAME":userinfo.USERNAME,
                                            @"USERTYPE":@"0"};
        if (i == 0) {
            numbersFieldsDic = @{@"USERCODE":userinfo.USERCODE,
                                 @"USERNAME":userinfo.USERNAME,
                                 @"USERTYPE":@"4"};
        }
        
        [tableArr addObject:KLB_TEAMCIRCLE_REL_USER];
        [fieldsArr addObject:numbersFieldsDic];
    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:tableArr
                                                                           withFields:fieldsArr
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:@"创建团队中，请稍后..."];
    if([ZEUtil isNotNull:_choosedImage]){
        [ZEUserServer uploadImageWithJsonDic:packageDic
                                withImageArr:@[_choosedImage]
                               showAlertView:NO
                                     success:^(id data) {
                                         [self showTips:@"创建成功"];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                                     } fail:^(NSError *errorCode) {
                                         [self.rightBtn setEnabled:YES];
                                     }];
    }else{
        [ZEUserServer getDataWithJsonDic:packageDic
                               showAlertView:YES
                                     success:^(id data) {
                                         [self showTips:@"创建成功"];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                                     } fail:^(NSError *error) {
                                         [self.rightBtn setEnabled:YES];
                                     }];

    }
}
#pragma mark - 修改班组圈信息

-(void)updateTeamData
{
    [self.view endEditing:YES];
    
    NSString * TEAMCIRCLENAME = createTeamView.messageView.teamNameField.text;
    NSString * TEAMMANIFESTO = createTeamView.messageView.manifestoTextView.text;
    NSString * TEAMCIRCLEREMARK = createTeamView.messageView.profileTextView.text;
    NSString * TEAMCIRCLECODE = createTeamView.messageView.TEAMCIRCLECODE;
    NSString * TEAMCIRCLECODENAME =createTeamView.messageView.TEAMCIRCLECODENAME;
    
    if (TEAMCIRCLENAME.length == 0|| TEAMCIRCLEREMARK.length == 0 ||  TEAMMANIFESTO.length == 0 || TEAMCIRCLECODENAME.length == 0) {
        [self showTips:@"请完善班组圈信息"];
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_INFO,
                                     @"DETAILTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"GroupUserMan",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"TEAMCIRCLECODE",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleManager",
                                     };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_teamCircleInfo.SEQKEY,
                                @"TEAMCIRCLENAME":TEAMCIRCLENAME,
                                @"TEAMCIRCLEREMARK":TEAMCIRCLEREMARK,
                                @"TEAMMANIFESTO":TEAMMANIFESTO,
                                @"TEAMCIRCLECODE":TEAMCIRCLECODE,
                                @"TEAMCIRCLECODENAME":TEAMCIRCLECODENAME,
                                @"SYSCREATORID":_teamCircleInfo.SYSCREATORID,
                                @"FILEURL":@"",
                                @"JMESSAGEGROUPID":_teamCircleInfo.JMESSAGEGROUPID,
                                };
    if (_TEAMCODE.length > 0) {
        fieldsDic =@{@"SEQKEY":_teamCircleInfo.TEAMCODE,
                     @"TEAMCIRCLENAME":TEAMCIRCLENAME,
                     @"TEAMCIRCLEREMARK":TEAMCIRCLEREMARK,
                     @"TEAMMANIFESTO":TEAMMANIFESTO,
                     @"TEAMCIRCLECODE":TEAMCIRCLECODE,
                     @"TEAMCIRCLECODENAME":TEAMCIRCLECODENAME,
                     @"SYSCREATORID":_teamCircleInfo.SYSCREATORID,
                     @"FILEURL":@"",
                     @"JMESSAGEGROUPID":_teamCircleInfo.JMESSAGEGROUPID,
                     };
    }
    
    NSMutableArray * tableArr = [NSMutableArray arrayWithArray:@[KLB_TEAMCIRCLE_INFO]];
    NSMutableArray * fieldsArr = [NSMutableArray arrayWithArray:@[fieldsDic]];
    
    for (int i = 0; i < _originMembersArr.count; i ++) {
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:_originMembersArr[i]];
        
        NSDictionary * numbersFieldsDic = @{@"USERCODE":userinfo.USERCODE,
                                            @"USERNAME":userinfo.USERNAME,
                                            @"USERTYPE":userinfo.USERTYPE};

        if ([userinfo.USERTYPE integerValue] == 0) {
            numbersFieldsDic = @{@"USERCODE":userinfo.USERCODE,
                                 @"USERNAME":userinfo.USERNAME,
                                 @"USERTYPE":@"0"};
        }
        [tableArr addObject:KLB_TEAMCIRCLE_REL_USER];
        [fieldsArr addObject:numbersFieldsDic];
    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:tableArr
                                                                           withFields:fieldsArr
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:@"更新团队信息中，请稍后..."];
    if([ZEUtil isNotNull:_choosedImage]){
        [ZEUserServer uploadImageWithJsonDic:packageDic
                                withImageArr:@[_choosedImage]
                               showAlertView:NO
                                     success:^(id data) {
                                         [self showTips:@"更新团队信息成功"];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
                                         ZETeamCircleModel * teamCircleInfo = [ZETeamCircleModel getDetailWithDic:[ZEUtil getServerData:data withTabelName:KLB_TEAMCIRCLE_INFO][0]];
                                         [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_CHANGE_TEAMCIRCLEINFO_SUCCESS object:teamCircleInfo];
                                     } fail:^(NSError *errorCode) {
                                         [self showTips:@"更新失败"];
                                     }];
    }else{
        [ZEUserServer getDataWithJsonDic:packageDic
                           showAlertView:YES
                                 success:^(id data) {
                                     [self showTips:@"更新团队信息成功"];
                                     [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
                                     ZETeamCircleModel * teamCircleInfo = [ZETeamCircleModel getDetailWithDic:[ZEUtil getServerData:data withTabelName:KLB_TEAMCIRCLE_INFO][0]];
                                     [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_CHANGE_TEAMCIRCLEINFO_SUCCESS object:teamCircleInfo];
                                 } fail:^(NSError *error) {
                                     [self showTips:@"更新失败"];
                                 }];
    }
}

#pragma mark - 同意或者拒绝加入团队

-(void)agreeJoinTheTeam:(ZEUSER_BASE_INFOM *)userinfo
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"DETAILTABLE":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"groupUserCheck",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleManager",
                                     @"GROUPID":_teamCircleInfo.JMESSAGEGROUPID,
                                     };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":userinfo.SEQKEY,
                                @"USERCODE":userinfo.USERCODE,
                                @"USERNAME":userinfo.USERNAME,
                                @"TEAMCIRCLECODE":_teamCircleInfo.SEQKEY,
                                @"USERTYPE":@"0"};
    if (_TEAMCODE.length > 0) {
        fieldsDic =@{@"SEQKEY":userinfo.SEQKEY,
                     @"USERCODE":userinfo.USERCODE,
                     @"USERNAME":userinfo.USERNAME,
                     @"TEAMCIRCLECODE":_TEAMCODE,
                     @"USERTYPE":@"0"};
    }
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [self showTips:[NSString stringWithFormat:@"已同意%@的入团申请",userinfo.USERNAME]];
                                 [self sendNumbersRequest];
                                 //                                     [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                             } fail:^(NSError *error) {
                                 
                             }];
    
    
}
-(void)disagreeJoinTheTeam:(ZEUSER_BASE_INFOM *)userinfo
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"DETAILTABLE":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_DELETE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":userinfo.SEQKEY,};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [self showTips:[NSString stringWithFormat:@"已拒绝%@的入团申请",userinfo.USERNAME]];
                                 [self sendNumbersRequest];
                                 //                                     [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                             } fail:^(NSError *error) {
                                 
                             }];
}

#pragma mark - 退出团队
-(void)quitTeam
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定退出该团队" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmQuitTeam];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)confirmQuitTeam
{
    ZEUSER_BASE_INFOM * userinfo = nil;
    for (NSDictionary * dic in _originMembersArr ){
        userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:dic];
        if ([[ZESettingLocalData getUSERCODE] isEqualToString:userinfo.USERCODE]) {
            break;
        }
    }
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"DETAILTABLE":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"GroupUserQuit",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleManager",
                                     @"GROUPID":_teamCircleInfo.JMESSAGEGROUPID,
                                     };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":userinfo.SEQKEY,};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 self.rightBtn.hidden = YES;
                                 [self showTips:@"退出团队成功"];
                                 [self sendNumbersRequest];
                             } fail:^(NSError *error) {
                                 
                             }];
}


#pragma mark - 确认解散团队

-(void)confirmDeleteTeam
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_INFO,
                                     @"DETAILTABLE":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_DELETE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleManager",
                                     };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_teamCircleInfo.SEQKEY,
                                @"JMESSAGEGROUPID":_teamCircleInfo.JMESSAGEGROUPID};
    if (_TEAMSEQKEY.length > 0) {
        fieldsDic =@{@"SEQKEY":_TEAMCODE,
                     @"JMESSAGEGROUPID":_teamCircleInfo.JMESSAGEGROUPID};
    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [self showTips:@"解散团队成功"];
                                 [self goBackVC];
                             } fail:^(NSError *error) {
                                 
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

#pragma mark - 上传头像

-(void)takePhotosOrChoosePictures
{
    UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * takeAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickController:YES];
    }];
    UIAlertAction * chooseAction = [UIAlertAction actionWithTitle:@"选择一张照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickController:NO];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCont addAction:takeAction];
    [alertCont addAction:chooseAction];
    [alertCont addAction:cancelAction];
    
    [self presentViewController:alertCont animated:YES completion:^{
        
    }];
}


/**
 *  @author Stenson, 16-08-01 16:08:07
 *
 *  选取照片
 *
 *  @param isTaking 是否拍照
 */
-(void)showImagePickController:(BOOL)isTaking;
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && isTaking) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _choosedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [createTeamView.messageView reloadTeamHeadImageView:_choosedImage];
}


#pragma mark - ZECreateTeamViewDelegate

-(void)goQueryNumberView
{
    ZEQueryNumberVC * queryNumberVC = [[ZEQueryNumberVC alloc]init];
    queryNumberVC.alreadyInviteNumbersArr = _originMembersArr;
    [self.navigationController pushViewController:queryNumberVC animated:YES];
    
}

-(void)goRemoveNumberView
{
    ZEChooseNumberVC* chooseNumberVC = [[ZEChooseNumberVC alloc]init];
    chooseNumberVC.enterType = ENTER_CHOOSE_TEAM_MEMBERS_DELETE;
    chooseNumberVC.numbersArr = [NSMutableArray arrayWithArray:_originMembersArr];
    [self.navigationController pushViewController:chooseNumberVC animated:YES];
}


-(void)whetherAgreeJoinTeam:(ZEUSER_BASE_INFOM *)userinfo
{
    NSString * alertMsg = [NSString stringWithFormat:@"是否同意%@加入团队",userinfo.USERNAME];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertMsg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self agreeJoinTheTeam:userinfo];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self disagreeJoinTheTeam:userinfo];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)whetherTransferTeam:(ZEUSER_BASE_INFOM *)userinfo
{
    ZEChooseNumberVC* chooseNumberVC = [[ZEChooseNumberVC alloc]init];
    chooseNumberVC.enterType = ENTER_CHOOSE_TEAM_MEMBERS_TRANSFERTEAM;
    chooseNumberVC.numbersArr = [NSMutableArray arrayWithArray:_originMembersArr];
    chooseNumberVC.teaminfo = _teamCircleInfo;
    chooseNumberVC.TEAMCODE = _TEAMCODE;
    [self.navigationController pushViewController:chooseNumberVC animated:YES];
}

-(void)whetherDeleteTeam
{
    NSString * alertMsg = [NSString stringWithFormat:@"团队一旦解散，该团队数据信息就会被清除，确认解散团队？"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertMsg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认解散" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self confirmDeleteTeam];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - 指定管理员

-(void)designatedAdministrator:(ZEUSER_BASE_INFOM *)userinfo
{
    NSString * alertMsg = [NSString stringWithFormat:@"是否指定%@为管理员",userinfo.USERNAME];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertMsg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmDesignatedAdministrator:userinfo];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)confirmDesignatedAdministrator:(ZEUSER_BASE_INFOM *)userinfo
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_REL_USER,
                                     @"DETAILTABLE":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleManager",
                                     };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":userinfo.SEQKEY,
                                @"USERCODE":userinfo.USERCODE,
                                @"USERNAME":userinfo.USERNAME,
                                @"TEAMCIRCLECODE":_teamCircleInfo.SEQKEY,
                                @"USERTYPE":@"3"};
    if (_TEAMCODE.length > 0) {
        fieldsDic =@{@"SEQKEY":userinfo.SEQKEY,
                     @"USERCODE":userinfo.USERCODE,
                     @"USERNAME":userinfo.USERNAME,
                     @"TEAMCIRCLECODE":_TEAMCODE,
                     @"USERTYPE":@"3"};
    }
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"addManager"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [self showTips:[NSString stringWithFormat:@"设置成功"]];
                                 [self sendNumbersRequest];
                             } fail:^(NSError *error) {
                                 
                             }];
}

#pragma mark - 撤销管理员
-(void)revokeAdministrator:(ZEUSER_BASE_INFOM *)userinfo
{
    NSString * alertMsg = [NSString stringWithFormat:@"是否撤销%@的管理员",userinfo.USERNAME];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertMsg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmRevokeAdministrator:userinfo];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)confirmRevokeAdministrator:(ZEUSER_BASE_INFOM *)userinfo
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                      @"MASTERTABLE":KLB_TEAMCIRCLE_REL_USER,
                                      @"DETAILTABLE":@"",
                                      @"MENUAPP":@"EMARK_APP",
                                      @"ORDERSQL":@"",
                                      @"WHERESQL":@"",
                                      @"start":@"0",
                                      @"METHOD":METHOD_UPDATE,
                                      @"MASTERFIELD":@"SEQKEY",
                                      @"DETAILFIELD":@"",
                                      @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleManager",
                                      };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":userinfo.SEQKEY,
                                @"USERCODE":userinfo.USERCODE,
                                @"USERNAME":userinfo.USERNAME,
                                @"TEAMCIRCLECODE":_teamCircleInfo.SEQKEY,
                                @"USERTYPE":@"0"};
    if (_TEAMCODE.length > 0) {
        fieldsDic =@{@"SEQKEY":userinfo.SEQKEY,
                     @"USERCODE":userinfo.USERCODE,
                     @"USERNAME":userinfo.USERNAME,
                     @"TEAMCIRCLECODE":_TEAMCODE,
                     @"USERTYPE":@"0"};
    }
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"removerManager"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [self showTips:[NSString stringWithFormat:@"撤销成功"]];
                                 [self sendNumbersRequest];
                             } fail:^(NSError *error) {
                                 
                             }];
    
}

-(void)goTeamNotiCenter
{    
    ZETeamNotiCenVC * notiCenVC = [[ZETeamNotiCenVC alloc]init];
    notiCenVC.teamID = _teamCircleInfo.SEQKEY;
    if (_teamCircleInfo.TEAMCODE.length > 0) {
        notiCenVC.teamID = _teamCircleInfo.TEAMCODE;
    }
    [self.navigationController pushViewController:notiCenVC animated:YES];
    
}
-(void)goPracticeManager
{
    ZETeamWebVC * teamWebVC = [[ZETeamWebVC alloc]init];
    teamWebVC.enterType = ENTER_WKWEBVC_PRACTICE;
    teamWebVC.teamCircleM = _teamCircleInfo;
    [self.navigationController pushViewController:teamWebVC animated:YES];
}

-(void)goExamManager
{
    ZETeamWebVC * teamWebVC = [[ZETeamWebVC alloc]init];
    teamWebVC.enterType = ENTER_WKWEBVC_TEST;
    teamWebVC.teamCircleM = _teamCircleInfo;
    [self.navigationController pushViewController:teamWebVC animated:YES];
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
