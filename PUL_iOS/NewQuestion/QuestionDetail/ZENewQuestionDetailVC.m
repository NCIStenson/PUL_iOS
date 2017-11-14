//
//  ZENewQuestionDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENewQuestionDetailVC.h"
#import "ZENewQuestionDetailView.h"
#import "ZENewAnswerQuestionVC.h"
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
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self sendSearchAnswerRequest];
}

-(void)initView{
    _detailView = [[ZENewQuestionDetailView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT,SCREEN_WIDTH , SCREEN_HEIGHT - NAV_HEIGHT) withQuestionInfo:_questionInfo];
    _detailView.delegate = self;
    [self.view addSubview:_detailView];
}


-(void)sendSearchAnswerRequest
{
    NSString * operatetype = @"";
    
    if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        operatetype = @"2";
    }else{
        operatetype = @"1";
    }
//    @"ISPASS desc, GOODNUMS desc, QACOUNT desc,SYSCREATEDATE asc"
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
                                 [_detailView reloadViewWithData:_datasArr];
//                                 if(_enterQuestionDetailType == QUESTION_LIST_MY_QUESTION && _datasArr.count == 0){
//                                     [self showTips:@"快让小伙伴们来帮助你解答吧！"];
//                                 }
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
//                                 [self.rightBtn setTitle:@"已采纳" forState:UIControlStateNormal];
//                                 [self.rightBtn setEnabled:NO];
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ACCEPT_SUCCESS object:nil];
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
