//
//  ZEQuestionsDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/4.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamQuestionDetailVC.h"

#import "ZEQuestionsDetailView.h"
#import "ZEAnswerTeamQuestionVC.h"

#import "ZEAskTeamQuestionVC.h"

#import "ZETeamCircleChatVC.h"

@interface ZETeamQuestionDetailVC ()<ZEQuestionsDetailViewDelegate>
{
    ZEQuestionsDetailView * _quesDetailView;
    UIAlertController * alertC;
}

@property (nonnull,nonatomic,strong) NSArray * datasArr;

@end

@implementation ZETeamQuestionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = [NSString stringWithFormat:@"%@的提问",_questionInfoModel.QUESTIONUSERNAME];
    if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        [self.rightBtn setTitle:@"修改" forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:@"回答" forState:UIControlStateNormal];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self sendSearchAnswerRequest];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(acceptSuccess) name:kNOTI_ACCEPT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendSearchAnswerRequestWithoutOperateType) name:kNOTI_BACK_QUEANSVIEW object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_ACCEPT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_BACK_QUEANSVIEW object:nil];
}

-(void)acceptSuccess{
    _questionInfoModel.ISSOLVE = @"1";
}


-(void)sendSearchAnswerRequestWithoutOperateType
{
    NSString * operatetype = @"";
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"ISPASS desc, GOODNUMS desc, QACOUNT desc,SYSCREATEDATE asc",
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@'",_questionInfoModel.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.AnswerGood",
                                     @"DETAILTABLE":@"",
                                     @"OPERATETYPE":operatetype};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 _datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_ANSWER_INFO];
                                 [_quesDetailView reloadData:_datasArr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)sendSearchAnswerRequest
{
    NSString * operatetype = @"";
    
    if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        operatetype = @"2";
    }else{
        operatetype = @"1";
    }
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_TEAMCIRCLE_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"ISPASS desc, GOODNUMS desc, QACOUNT desc,SYSCREATEDATE asc",
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@'",_questionInfoModel.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.AnswerGood",
                                     @"DETAILTABLE":@"",
                                     @"OPERATETYPE":operatetype};

    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_TEAMCIRCLE_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 _datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_TEAMCIRCLE_ANSWER_INFO];
                                 [_quesDetailView reloadData:_datasArr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)initView
{
    _quesDetailView = [[ZEQuestionsDetailView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                 withQuestionInfo:_questionInfoModel
                                                       withIsTeam:YES];
    _quesDetailView.delegate = self;
    [self.view addSubview:_quesDetailView];
    [self.view sendSubviewToBack:_quesDetailView];
}

-(void)rightBtnClick
{
    if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        [self changePersonalQuestion];
        return;
    }
    
    for (NSDictionary * dic in _datasArr) {
        ZEAnswerInfoModel * answerInfo = [ZEAnswerInfoModel getDetailWithDic:dic];
        if ([answerInfo.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            [self acceptTheAnswerWithQuestionInfo:_questionInfoModel
                                   withAnswerInfo:answerInfo];
            return;
        }
    }
    
    if ([_questionInfoModel.ISSOLVE boolValue]) {
        [self showTips:@"该问题已有答案被采纳"];
        return;
    }
    
    ZEAnswerTeamQuestionVC * answerQuesVC = [[ZEAnswerTeamQuestionVC alloc]init];
    answerQuesVC.questionSEQKEY = _questionInfoModel.SEQKEY;
    answerQuesVC.questionInfoModel = _questionInfoModel;
    [self.navigationController pushViewController:answerQuesVC animated:YES];
}

#pragma mark - ZEQuestionsDetailViewDelegate

-(void)acceptTheAnswerWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                        withAnswerInfo:(ZEAnswerInfoModel *)answerModel
{
    ZETeamCircleChatVC * chatVC = [[ZETeamCircleChatVC alloc]init];
    chatVC.questionInfo = infoModel;
    chatVC.answerInfo = answerModel;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

#pragma mark - 点赞

-(void)giveLikes:(NSString *)answerSeqkey
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_ANSWER_GOOD,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     };
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"QUESTIONID":_questionInfoModel.SEQKEY,
                                @"ANSWERID":answerSeqkey,
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_ANSWER_GOOD]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {                                 
                                 [self sendSearchAnswerRequest];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - 修改问题

-(void)changePersonalQuestion
{
    ZEAskTeamQuestionVC * askQues = [[ZEAskTeamQuestionVC alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_CHANGE;
    askQues.QUESINFOM = self.questionInfoModel;
    askQues.teamInfoModel = _teamCircleInfo;
    [self.navigationController pushViewController:askQues animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[SDImageCache sharedImageCache] clearDisk];
    
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
