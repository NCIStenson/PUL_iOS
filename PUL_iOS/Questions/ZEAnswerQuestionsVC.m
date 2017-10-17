//
//  ZEAnswerQuestionsVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAnswerQuestionsVC.h"
#import "ZEAnswerQuestionsView.h"

#import "ZELookViewController.h"

#define textViewStr @"这个问题将由您来解答。"

@interface ZEAnswerQuestionsVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZELookViewControllerDelegate,ZEAnswerQuestionsViewDelegate>
{
    ZEAnswerQuestionsView * _answerQuesView;
}

@property (nonatomic,strong) NSMutableArray * imagesArr;

@end

@implementation ZEAnswerQuestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"回答";
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.imagesArr = [NSMutableArray array];
}

-(void)initView
{
    _answerQuesView = [[ZEAnswerQuestionsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withQuestionInfoModel:_questionInfoM];
    _answerQuesView.delegate = self;
    [self.view addSubview:_answerQuesView];
    [self.view sendSubviewToBack:_answerQuesView];
}
#pragma mark - 确认输入信息

-(void)leftBtnClick
{
    if ([_answerQuesView.inputView.text isEqualToString:textViewStr] || _answerQuesView.inputView.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:@"现在退出编辑，你输入的内容将不会被保存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCont addAction:okAction];
    [alertCont addAction:cancelAction];
    
    [self presentViewController:alertCont animated:YES completion:nil];
}


#pragma mark - ZEAskQuesViewDelegate

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
    if (self.imagesArr.count == 3) {
        [self showTips:@"最多上传三张照片"];
        return;
    }
    
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
    [_answerQuesView reloadChoosedImageView:chooseImage];
    [self.imagesArr addObject:chooseImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goLookImageView:(NSArray *)imageArr
{
    ZELookViewController * lookVC = [[ ZELookViewController alloc]init];
    lookVC.delegate = self;
    lookVC.imageArr = self.imagesArr;
    [self.navigationController pushViewController:lookVC animated:YES];
}

-(void)goBackViewWithImages:(NSArray *)imageArr
{
    self.imagesArr = [NSMutableArray arrayWithArray:imageArr];
    [_answerQuesView reloadChoosedImageView:imageArr];
}

-(void)deleteSelectedImageWIthIndex:(NSInteger)index
{
    [self.imagesArr removeObjectAtIndex:index];
    [_answerQuesView reloadChoosedImageView:self.imagesArr];
}


-(void)rightBtnClick
{
    if (_answerQuesView.inputView.text.length == 0 || [_answerQuesView.inputView.text isEqualToString:textViewStr]){
        [self showTips:@"请输入回答内容"];
        return;
    }else if ([ZEUtil isEmpty:_answerQuesView.inputView.text]){
        [self showTips:@"不能回复空白答案"];
        return;
    }
    else{
        UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:@"是否确定提交问题答案" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self insertData];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertCont addAction:okAction];
        [alertCont addAction:cancelAction];
        
        [self presentViewController:alertCont animated:YES completion:nil];
    }
}

-(void)insertData
{
    self.rightBtn.enabled = NO;
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.answer.AnswerPoints",
                                     @"DETAILTABLE":@"",};
    NSString * ANSWERLEVEL = nil;
    if ([ZESettingLocalData getISEXPERT]) {
        ANSWERLEVEL = @"2";
    }else{
        ANSWERLEVEL = @"1";
    }

    NSDictionary * fieldsDic =@{@"SEQKEY":@"",
                                @"QUESTIONID":_questionSEQKEY,
                                @"ANSWEREXPLAIN":_answerQuesView.inputView.text,
                                @"ANSWERIMAGE":@"",
                                @"USERHEADIMAGE":[ZESettingLocalData getUSERHHEADURL],
                                @"ANSWERUSERCODE":[ZESettingLocalData getUSERCODE],
                                @"ANSWERUSERNAME":[ZESettingLocalData getNICKNAME],
                                @"ANSWERLEVEL":ANSWERLEVEL,
                                @"ISPASS":@"0",
                                @"ISENABLED":@"0"};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:@"答案提交中，请稍后..."];
    [ZEUserServer uploadImageWithJsonDic:packageDic
                            withImageArr:self.imagesArr
                           showAlertView:YES
                                 success:^(id data) {
                                     NSArray * arr = [ZEUtil getEXCEPTIONDATA:data];
                                     if(arr.count > 0){
                                         NSDictionary * failReason = arr[0];
                                         [self showTips:[NSString stringWithFormat:@"%@\n",[failReason objectForKey:@"reason"]] afterDelay:1.5];
                                     }else{
                                         [self showTips:[[ZEUtil getCOMMANDDATA:data] objectForKey:@"target"] afterDelay:1.5];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_BACK_QUEANSVIEW object:nil];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ANSWER_SUCCESS object:nil];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                                     }
                                 } fail:^(NSError *error) {
                                     self.rightBtn.enabled = YES;
                                     [self showTips:@"回答问题失败，请稍后重试。"];
                                 }];
}

-(void)showAlertView:(NSString *)alertMsg isBack:(BOOL)isBack
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isBack) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
