//
//  ZEChatVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/12/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChatVC.h"

#import "ZEChatView.h"

@interface ZEChatVC ()<ZEChatViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    ZEChatView * _chatView;
}
@end

@implementation ZEChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.automaticallyAdjustsScrollViewInsets = NO;

    if([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]){
        if([_questionInfo.ISSOLVE boolValue]){
            [self.rightBtn setTitle:@"已采纳" forState:UIControlStateNormal];
        }else{
            [self.rightBtn setTitle:@"采纳" forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(acceptAnswer) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    if (_enterChatVCType == 1) {
        self.title = @"";
        [self sendAnswerModelRequest];
    }else{
        [self sendSearchAnswerRequest];
        self.title = [NSString stringWithFormat:@"%@的回答",_answerInfo.NICKNAME];
        [self initContentView];
    }
}

-(void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_BACK_QUEANSVIEW object:nil];
}

-(void)sendAnswerModelRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"QUESTIONID='%@' and ANSWERUSERCODE = '%@'",_questionInfo.SEQKEY,[ZESettingLocalData getUSERCODE]],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerGood",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@""];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_ANSWER_INFO];
                                 if (arr.count > 0) {
                                     self.answerInfo = [ZEAnswerInfoModel getDetailWithDic:arr[0]];
                                     self.title = [NSString stringWithFormat:@"%@的回答",_answerInfo.NICKNAME];
                                     [self initContentView];
                                     [self sendSearchAnswerRequest];
                                 }
                            } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

-(void)sendSearchAnswerRequestWithoutOPERATETYPE
{
    NSString * operatetype = @"";
    
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_QUE_ANS_DETAIL,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE asc",
                                     @"WHERESQL":[NSString stringWithFormat:@"ANSWERCODE='%@'",_answerInfo.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.QueAnsDetail",
                                     @"DETAILTABLE":@"",
                                     @"OPERATETYPE":operatetype};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUE_ANS_DETAIL]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray *  _datasArr = [ZEUtil getServerData:data withTabelName:KLB_QUE_ANS_DETAIL];
                                 [_chatView reloadDataWithArr:_datasArr];
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
                                     @"MASTERTABLE":KLB_QUE_ANS_DETAIL,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE asc",
                                     @"WHERESQL":[NSString stringWithFormat:@"ANSWERCODE='%@'",_answerInfo.SEQKEY],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.QueAnsDetail",
                                     @"DETAILTABLE":@"",
                                     @"OPERATETYPE":operatetype};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUE_ANS_DETAIL]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray *  _datasArr = [ZEUtil getServerData:data withTabelName:KLB_QUE_ANS_DETAIL];
                                 [_chatView reloadDataWithArr:_datasArr];
                             } fail:^(NSError *errorCode) {
                             }];
}


-(void)initContentView
{    
     _chatView = [[ZEChatView alloc]initWithFrame:self.view.frame
                                withQuestionInfoM:_questionInfo
                                  withAnswerInfoM:_answerInfo];
    _chatView.backgroundColor = MAIN_LINE_COLOR;
    _chatView.delegate = self;
    [self.view addSubview:_chatView];
    [self.view sendSubviewToBack:_chatView];
}

#pragma mark - ZEChatDelegate

-(void)didSelectCameraBtn
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
    
    [self presentViewController:alertCont animated:YES completion:nil];
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
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * chooseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    [self uploadChatImage:chooseImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadChatImage:(UIImage *)chatImage
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_QUE_ANS_DETAIL,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.QueAnsDetail",
                                     @"DETAILTABLE":@"",};
        
    NSDictionary * fieldsDic =@{@"ANSWERCODE":_answerInfo.SEQKEY};
    if ([_answerInfo.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]] ){
        fieldsDic =@{@"ANSWERCODE":_answerInfo.SEQKEY,
                     @"OPERATETYPE":@"2"};
    }else if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]){
        fieldsDic =@{@"ANSWERCODE":_answerInfo.SEQKEY,
                     @"OPERATETYPE":@"1"};
    }
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUE_ANS_DETAIL]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer uploadImageWithJsonDic:packageDic
                            withImageArr:@[chatImage]
                           showAlertView:YES
                                 success:^(id data) {
                                     [self sendSearchAnswerRequestWithoutOPERATETYPE];
                            } fail:^(NSError *error) {
                                
                            }];

}


-(void)didSelectSend:(NSString *)inputText
{
    if (inputText.length > 0) {
        [self insertQuestionDetail:inputText isQuestion:NO];
    }
}
-(void)insertQuestionDetail:(NSString *)text isQuestion:(BOOL)isQuestion
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_QUE_ANS_DETAIL,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.QueAnsDetail",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"ANSWERCODE":_answerInfo.SEQKEY,
                                @"EXPLAIN":text};
    if ([_answerInfo.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]] ){
        fieldsDic =@{@"ANSWERCODE":_answerInfo.SEQKEY,
                     @"OPERATETYPE":@"2",
                     @"EXPLAIN":text};
    }else if ([_questionInfo.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]){
        fieldsDic =@{@"ANSWERCODE":_answerInfo.SEQKEY,
                     @"OPERATETYPE":@"1",
                     @"EXPLAIN":text};
    }
    _chatView.inputView.inputField.text = @"";

    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUE_ANS_DETAIL]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [_chatView uploadTextSuccess];
                                 [self sendSearchAnswerRequestWithoutOPERATETYPE];
                             } fail:^(NSError *errorCode) {

                             }];
}


#pragma mark - 采纳

-(void)acceptAnswer
{
    UIAlertController *  alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定采纳该回答？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateKLB_ANSWER_INFOWithQuestionInfo:_questionInfo withAnswerInfo:_answerInfo];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:cancelAction];
    [alertC addAction:confirmAction];

    [self presentViewController:alertC animated:YES completion:nil];
}

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
                                 [self.rightBtn setTitle:@"已采纳" forState:UIControlStateNormal];
                                 [self.rightBtn setEnabled:NO];
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ACCEPT_SUCCESS object:nil];
                             } fail:^(NSError *errorCode) {
                             }];
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
