//
//  ZENewQuestionDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENewQuestionDetailVC.h"
#import "ZENewAnswerQuestionVC.h"
#import "ZEAskQuesViewController.h"
#import "ZEChatVC.h"

@interface ZENewQuestionDetailVC ()<ZENewQuestionDetailViewDelegate>
{
    ZENewQuestionDetailView * _detailView;
    NSArray * _datasArr;
}
@end

@implementation ZENewQuestionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问题详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (_enterDetailIsFromNoti == QUESTIONDETAIL_TYPE_DEFAULT) {
        [self initView];
        self.title = [NSString stringWithFormat:@"%@的提问",_questionInfo.NICKNAME];
        if(_questionInfo.ISANONYMITY){
            self.title = [NSString stringWithFormat:@"%@的提问",@"匿名用户"];
        }
        if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            [self.rightBtn setTitle:@"修改" forState:UIControlStateNormal];
            if([_questionInfo.ISSOLVE boolValue]){
                self.rightBtn.hidden = YES;
            }
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendSearchAnswerRequestWithoutOperateType) name:kNOTI_BACK_QUEANSVIEW object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendSearchAnswerRequestWithoutOperateType) name:kNOTI_ANSWER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeQuestionInfoBack) name:kNOTI_CHANGE_ASK_SUCCESS object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self sendSearchAnswerRequest];
}

-(void)initView{
    _detailView = [[ZENewQuestionDetailView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT,SCREEN_WIDTH , SCREEN_HEIGHT - NAV_HEIGHT) withQuestionInfo:_questionInfo];
    _detailView.delegate = self;
    [self.view addSubview:_detailView];
}

-(void)rightBtnClick
{
    if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        [self changePersonalQuestion];
        return;
    }
}

-(void)changePersonalQuestion
{
    ZEAskQuesViewController * askQues = [[ZEAskQuesViewController alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_CHANGE;
    askQues.QUESINFOM = self.questionInfo;
    [self.navigationController pushViewController:askQues animated:YES];
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
                                     _questionInfo = [ZEQuestionInfoModel getDetailWithDic:dataArr[0]];
                                     
                                     while ([_detailView.subviews lastObject]) {
                                         [_detailView.subviews.lastObject removeFromSuperview];
                                     }
                                     _detailView = nil;
                                     
                                     [self initView];
                                     self.title = [NSString stringWithFormat:@"%@的提问",_questionInfo.NICKNAME];
                                     if(_questionInfo.ISANONYMITY){
                                         self.title = [NSString stringWithFormat:@"%@的提问",@"匿名用户"];
                                     }
                                     if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
                                         [self.rightBtn setTitle:@"修改" forState:UIControlStateNormal];
                                     }
                                     [self sendSearchAnswerRequest];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
    
}


-(void)sendSearchAnswerRequest
{
    NSString * operatetype = @"";
    
    if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        operatetype = @"2";
    }else{
        operatetype = @"1";
    }

    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@'",_questionInfo.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerGood",
                                     @"DETAILTABLE":@"",
                                     @"OPERATETYPE":operatetype};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"answerInfo"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 _datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_ANSWER_INFO];
                                 NSLog(@"  coutn ===  %d",_datasArr.count);
                                 [_detailView reloadViewWithData:_datasArr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)changeQuestionInfoBack
{
    NSString * WHERESQL = [NSString stringWithFormat:@"SEQKEY = '%@'",_questionInfo.SEQKEY];
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
                                     _questionInfo = [ZEQuestionInfoModel getDetailWithDic:dataArr[0]];
                                     
                                     while ([_detailView.subviews lastObject]) {
                                         [_detailView.subviews.lastObject removeFromSuperview];
                                     }
                                     [_detailView removeFromSuperview];
                                     _detailView = nil;
                                     
                                     [self initView];
                                     if(_questionInfo.ISANONYMITY){
                                         self.title = [NSString stringWithFormat:@"%@的提问",@"匿名用户"];
                                     }
                                     if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
                                         [self.rightBtn setTitle:@"修改" forState:UIControlStateNormal];
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
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@'",_questionInfo.SEQKEY],
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
                                                                       withActionFlag:@"answerInfo"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 _datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_ANSWER_INFO];
                                 [_detailView reloadViewWithData:_datasArr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

#pragma mark - ZENewQuestionListViewDelegate

-(void)giveQuestionPraiseRequest
{
    NSLog(@" ======= 点赞点赞点赞点赞 %@",_questionInfo.SEQKEY);
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
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerGood",
                                     };
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"QUESTIONID":_questionInfo.SEQKEY,
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_GOOD]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"questionGood"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 //                                 button.enabled = YES;
                                 //                                 [self sendSearchAnswerRequest];
                             } fail:^(NSError *errorCode) {
                                 //                                 button.enabled = YES;
                             }];
    
}

-(void)giveAnswerPraiseRequest:(ZEAnswerInfoModel *)answerInfo
{
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
                                @"QUESTIONID":_questionInfo.SEQKEY,
                                @"ANSWERID":answerInfo.SEQKEY,
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_GOOD]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
//                                 button.enabled = YES;
                                 [self sendSearchAnswerRequest];
                             } fail:^(NSError *errorCode) {
//                                 button.enabled = YES;
                             }];
}

#pragma mark - 排序查询

-(void)vcSendRequestWithOrder:(NSString *)index
{
    NSString * operatetype = @"";
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@'",_questionInfo.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerGood",
                                     @"DETAILTABLE":@"",
                                     @"OPERATETYPE":operatetype,
                                     @"orderstr":index
                                     };
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"answerOrder"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 _datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_ANSWER_INFO];
                                 [_detailView reloadViewWithData:_datasArr];
                             } fail:^(NSError *errorCode) {
                                 
                             }];

}

#pragma mark - 采纳

-(void)updateKLB_ANSWER_INFOWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
                              withAnswerInfo:(ZEAnswerInfoModel *)answerModel
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_INFO,
                                     @"DETAILTABLE":KLB_QUESTION_INFO,
                                     @"MASTERFIELD":@"QUESTIONID",
                                     @"DETAILFIELD":@"SEQKEY",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerTake",
                                     };
    
    NSDictionary * fieldsDic =@{@"SEQKEY":answerModel.SEQKEY,
                                @"QUESTIONID":answerModel.QUESTIONID,
                                @"ISPASS":@"1",
                                @"ANSWERUSERCODE":answerModel.ANSWERUSERCODE,
                                };
    
    NSDictionary * fieldsDic2 =@{@"ISSOLVE":@"1",
                                 @"BONUSPOINTS":[NSString stringWithFormat:@"%@",_questionInfo.BONUSPOINTS]};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_INFO,KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic,fieldsDic2]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 [self showTips:@"已采纳为最佳答案"];
                                 [self sendSearchAnswerRequest];
//                                 [self.rightBtn setTitle:@"已采纳" forState:UIControlStateNormal];
//                                 [self.rightBtn setEnabled:NO];
//                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ACCEPT_SUCCESS object:nil];
                                 
                             } fail:^(NSError *errorCode) {
                             }];
}

#pragma mark - ZENewQuestionDetailViewDelegate

-(void)answerQuestion
{
//    if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
//        [self changePersonalQuestion];
//        return;
//    }
//
//    for (NSDictionary * dic in _datasArr) {
//        ZEAnswerInfoModel * answerInfo = [ZEAnswerInfoModel getDetailWithDic:dic];
//        if ([answerInfo.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
//            [self acceptTheAnswerWithQuestionInfo:_questionInfoModel
//                                   withAnswerInfo:answerInfo];
//            return;
//        }
//    }
//    if ([_questionInfo.ISSOLVE boolValue]) {
//        [self showTips:@"该问题已有答案被采纳"];
//        return;
//    }
    
    if (_questionInfo.ISANSWER) {
        ZEChatVC * chatVC = [[ZEChatVC alloc]init];
        chatVC.questionInfo = _questionInfo;
        chatVC.enterChatVCType = 1;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else{
        ZENewAnswerQuestionVC * answerQuesVC = [[ZENewAnswerQuestionVC alloc]init];
        answerQuesVC.questionSEQKEY = _questionInfo.SEQKEY;
        answerQuesVC.questionInfoM = _questionInfo;
        [self.navigationController pushViewController:answerQuesVC animated:YES];
    }
}

-(void)giveQuestionPraise
{
    _detailView.praiseBtn.enabled = NO;
    NSInteger googNums = [_questionInfo.GOODNUMS integerValue];
    googNums +=1;
    
    [_detailView.praiseBtn setTitle:[NSString stringWithFormat:@" %ld",(long)googNums] forState:UIControlStateNormal];
    [_detailView.praiseBtn setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];

    [self giveQuestionPraiseRequest];
}

-(void)giveAnswerPraise:(ZEAnswerInfoModel *)answerInfo
{
    [self giveAnswerPraiseRequest:answerInfo];
}

-(void)acceptBestAnswer:(ZEAnswerInfoModel *)answerInfo
{
    UIAlertController *  alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定采纳该回答？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateKLB_ANSWER_INFOWithQuestionInfo:_questionInfo withAnswerInfo:answerInfo];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:cancelAction];
    [alertC addAction:confirmAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)enterAnswerDetailView:(ZEAnswerInfoModel *)answerInfo
{
    ZEChatVC * chatVC = [[ZEChatVC alloc]init];
    chatVC.questionInfo = _questionInfo;
    chatVC.answerInfo = answerInfo;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)sendRequestWithOrder:(NSInteger)order
{
    [self vcSendRequestWithOrder:[NSString stringWithFormat:@"%ld",(long)order]];
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
