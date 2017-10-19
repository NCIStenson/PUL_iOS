    //
//  ZEQuestionsDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/4.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQuestionsDetailVC.h"
#import "ZEQuestionsDetailView.h"
#import "ZEAnswerQuestionsVC.h"

#import "ZEAskQuesViewController.h"

#import "ZEChatVC.h"

@interface ZEQuestionsDetailVC ()<ZEQuestionsDetailViewDelegate>
{
    ZEQuestionsDetailView * _quesDetailView;
    UIAlertController * alertC;
}

@property (nonnull,nonatomic,strong) NSArray * datasArr;

@end

@implementation ZEQuestionsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    if (_enterDetailIsFromNoti == QUESTIONDETAIL_TYPE_DEFAULT) {
        [self initView];
        self.title = [NSString stringWithFormat:@"%@的提问",_questionInfoModel.NICKNAME];
        if(_questionInfoModel.ISANONYMITY){
            self.title = [NSString stringWithFormat:@"%@的提问",@"匿名用户"];
        }
        if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            [self.rightBtn setTitle:@"修改" forState:UIControlStateNormal];
            if([_questionInfoModel.ISSOLVE boolValue]){
                self.rightBtn.hidden = YES;
            }
        }else{
            [self.rightBtn setTitle:@"回答" forState:UIControlStateNormal];
        }
        
        [self sendSearchAnswerRequest];
    }else if(_enterDetailIsFromNoti == QUESTIONDETAIL_TYPE_NOTI){
        [self enterFromNotiSendRequest];
        if(![_notiCenM.ISREAD boolValue] ){
            [self clearPersonalNotiUnreadCount];
        }
    }else if (_enterDetailIsFromNoti == QUESTIONDETAIL_TYPE_HOMEDYNAMIC){
        [self enterFromNotiSendRequest];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(acceptSuccess) name:kNOTI_ACCEPT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendSearchAnswerRequestWithoutOperateType) name:kNOTI_BACK_QUEANSVIEW object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendSearchAnswerRequestWithoutOperateType) name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeQuestionInfoBack) name:kNOTI_CHANGE_ASK_SUCCESS object:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_ACCEPT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_BACK_QUEANSVIEW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGE_ASK_SUCCESS object:nil];
}

-(void)acceptSuccess{
    _questionInfoModel.ISSOLVE = @"1";
}

-(void)enterFromNotiSendRequest
{
    NSString * WHERESQL = [NSString stringWithFormat:@"SEQKEY = '%@'",_notiCenM.QUESTIONID];
    if (_enterDetailIsFromNoti == QUESTIONDETAIL_TYPE_HOMEDYNAMIC) {
        WHERESQL = [NSString stringWithFormat:@"SEQKEY = '%@'",_QUESTIONID];

    }
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     _questionInfoModel = [ZEQuestionInfoModel getDetailWithDic:dataArr[0]];
                                     
                                     while ([_quesDetailView.subviews lastObject]) {
                                         [_quesDetailView.subviews.lastObject removeFromSuperview];
                                     }
                                     _quesDetailView = nil;
                                     
                                     [self initView];
                                     self.title = [NSString stringWithFormat:@"%@的提问",_questionInfoModel.NICKNAME];
                                     if(_questionInfoModel.ISANONYMITY){
                                         self.title = [NSString stringWithFormat:@"%@的提问",@"匿名用户"];
                                     }
                                     if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
                                         [self.rightBtn setTitle:@"修改" forState:UIControlStateNormal];
                                     }else{
                                         [self.rightBtn setTitle:@"回答" forState:UIControlStateNormal];
                                     }
                                     [self sendSearchAnswerRequest];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}

-(void)changeQuestionInfoBack
{
    NSString * WHERESQL = [NSString stringWithFormat:@"SEQKEY = '%@'",_questionInfoModel.SEQKEY];
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * dataArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
                                 if (dataArr.count > 0) {
                                     _questionInfoModel = [ZEQuestionInfoModel getDetailWithDic:dataArr[0]];
                                     
                                     while ([_quesDetailView.subviews lastObject]) {
                                         [_quesDetailView.subviews.lastObject removeFromSuperview];
                                     }
                                     [_quesDetailView removeFromSuperview];
                                     _quesDetailView = nil;
                                     
                                     [self initView];
                                     self.title = [NSString stringWithFormat:@"%@的提问",_questionInfoModel.NICKNAME];
                                     if(_questionInfoModel.ISANONYMITY){
                                         self.title = [NSString stringWithFormat:@"%@的提问",@"匿名用户"];
                                     }
                                     if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
                                         [self.rightBtn setTitle:@"修改" forState:UIControlStateNormal];
                                     }else{
                                         [self.rightBtn setTitle:@"回答" forState:UIControlStateNormal];
                                     }
                                     [self sendSearchAnswerRequest];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}


-(void)clearPersonalNotiUnreadCount
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.PersonMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_notiCenM.SEQKEY,};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"questionDetail"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO];
                                 if ([ZEUtil isNotNull:arr]) {
                                     _notiCenM.ISREAD = @"1";
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_READDYNAMIC object:nil];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)sendSearchAnswerRequestWithoutOperateType
{
    NSString * operatetype = @"";
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"ISPASS desc, GOODNUMS desc, QACOUNT desc,SYSCREATEDATE asc",
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@'",_questionInfoModel.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerGood",
                                     @"DETAILTABLE":@"",
                                     @"OPERATETYPE":operatetype};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 _datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_ANSWER_INFO];
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
                                     @"MASTERTABLE":V_KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"ISPASS desc, GOODNUMS desc, QACOUNT desc,SYSCREATEDATE asc",
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@'",_questionInfoModel.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerGood",
                                     @"DETAILTABLE":@"",
                                     @"OPERATETYPE":operatetype};

    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 _datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_ANSWER_INFO];
                                 [_quesDetailView reloadData:_datasArr];
                                 if(_enterQuestionDetailType == QUESTION_LIST_MY_QUESTION && _datasArr.count == 0){
                                     [self showTips:@"快让小伙伴们来帮助你解答吧！"];
                                 }
                             } fail:^(NSError *errorCode) {

                             }];
}

-(void)initView
{
    _quesDetailView = [[ZEQuestionsDetailView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                 withQuestionInfo:_questionInfoModel
                                                       withIsTeam:NO];
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
    
    ZEAnswerQuestionsVC * answerQuesVC = [[ZEAnswerQuestionsVC alloc]init];
    answerQuesVC.questionSEQKEY = _questionInfoModel.SEQKEY;
    answerQuesVC.questionInfoM = _questionInfoModel;
    [self.navigationController pushViewController:answerQuesVC animated:YES];
}

#pragma mark - ZEQuestionsDetailViewDelegate

-(void)acceptTheAnswerWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                        withAnswerInfo:(ZEAnswerInfoModel *)answerModel
{
    ZEChatVC * chatVC = [[ZEChatVC alloc]init];
    chatVC.questionInfo = infoModel;
    chatVC.answerInfo = answerModel;
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - 点赞

-(void)giveLikes:(NSString *)answerSeqkey withButton:(UIButton *)button
{
    button.enabled = NO;
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_GOOD,
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
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_GOOD]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 button.enabled = YES;
                                 [self sendSearchAnswerRequest];
                             } fail:^(NSError *errorCode) {
                                 button.enabled = YES;
                             }];
}

#pragma mark - 修改问题

-(void)changePersonalQuestion
{
    ZEAskQuesViewController * askQues = [[ZEAskQuesViewController alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_CHANGE;
    askQues.QUESINFOM = self.questionInfoModel;
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
