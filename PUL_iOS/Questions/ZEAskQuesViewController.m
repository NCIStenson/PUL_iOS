//
//  ZEAskQuesViewController.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAskQuesViewController.h"
#import "ZEAskQuesView.h"
#import "ZEAskQuestionTypeView.h"

#import "ZEShowQuestionVC.h"

#import "ZELookViewController.h"
#import "ZEQuestionTypeCache.h"

#import "ZEShowQuestionVC.h"
#import "ZEHomeVC.h"
#define textViewStr @"试着将问题尽可能清晰的描述出来，这样回答者们才能更完整、更高质量的为您解答。"

@interface ZEAskQuesViewController ()<ZEAskQuesViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZELookViewControllerDelegate>
{
    ZEAskQuesView * askView;
    ZEAskQuestionTypeView * askTypeView;
    NSDictionary * showQuesTypeDic;
    
    NSString * questionTypeCode;
}

@property (nonatomic,retain) NSMutableArray * imagesArr;

@end

@implementation ZEAskQuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imagesArr = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackShowView) name:kNOTI_CHANGE_ASK_SUCCESS object:nil];;
    
    [self initView];
}
-(void)goBackShowView
{
    NSArray *temArray = self.navigationController.viewControllers;
    
    for(UIViewController *temVC in temArray){
        if ([temVC isKindOfClass:[ZEShowQuestionVC class]]) {
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_CHANGE_ASK_SUCCESS object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [self cacheQuestionType];
    [self sendMyBONUSPOINTSRequest];
}
-(void)cacheQuestionType
{
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES ];
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":V_KLB_QUESTION_TYPE,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_TYPE]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES ];
                                 [[ZEQuestionTypeCache instance]setQuestionTypeCaches:[ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_TYPE]];
                                 [askTypeView reloadTypeData];
                             } fail:^(NSError *errorCode) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES ];
                             }];
}

-(void)sendMyBONUSPOINTSRequest
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":[NSString stringWithFormat:@"USERCODE = '%@'",[ZESettingLocalData getUSERCODE]],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * infoArr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
                                 if (infoArr.count > 0) {
                                     NSDictionary * dic = infoArr[0];
                                     [askView reloadRewardGold:[dic objectForKey:@"SUMPOINTS"]];
                                 }
                             } fail:^(NSError *errorCode) {

                             }];
}

-(void)initView
{
    self.rightBtn.enabled = YES;
    [self.rightBtn setTitle:@"发送" forState:UIControlStateNormal];

    if (_enterType == ENTER_GROUP_TYPE_CHANGE) {
        self.title = @"修改你的问题";
        askView = [[ZEAskQuesView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) withQuestionInfoM:self.QUESINFOM];
        
        for (NSString * str in self.QUESINFOM.FILEURLARR) {
            NSString * strUrl =[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str];
            UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strUrl];
            if([ZEUtil isNotNull:cachedImage]){
                [askView reloadChoosedImageView:cachedImage];
                [self.imagesArr addObject:cachedImage];
            }
        }

    }else{
        self.title = @"描述你的问题";
        askView = [[ZEAskQuesView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    askView.delegate = self;
    [self.view addSubview:askView];
    [self.view sendSubviewToBack:askView];
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
    [askView reloadChoosedImageView:chooseImage];
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
    [askView reloadChoosedImageView:imageArr];
}

-(void)deleteSelectedImageWIthIndex:(NSInteger)index
{
    [self.imagesArr removeObjectAtIndex:index];
    [askView reloadChoosedImageView:self.imagesArr];
}

#pragma mark - 确认输入信息

-(void)leftBtnClick
{
    if ([ZEUtil isNotNull:askView.askTypeView]) {
        [askView.askTypeView removeAllSubviews];
        [askView.askTypeView removeFromSuperview];
        askView.askTypeView = nil;
        return;
    }
    
    if (_enterType == ENTER_GROUP_TYPE_CHANGE && [askView.inputView.text isEqualToString:self.QUESINFOM.QUESTIONEXPLAIN]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if ([askView.inputView.text isEqualToString:textViewStr] || [askView.inputView.text length] == 0 ) {
        if (_enterType == ENTER_GROUP_TYPE_TABBAR) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:@"现在退出编辑，你输入的内容将不会被保存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goBack];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCont addAction:okAction];
    [alertCont addAction:cancelAction];
    
    [self presentViewController:alertCont animated:YES completion:nil];
}

-(void)rightBtnClick
{    
    if ([askView.inputView.text isEqualToString:textViewStr]) {
        [self showAlertView:@"请输入问题说明" isBack:NO];
        return;
    }else if (askView.inputView.text.length < 5){
        [self showAlertView:@"请详细输入问题说明" isBack:NO];
        return;
    }else{
        
        if (_enterType == ENTER_GROUP_TYPE_CHANGE) {
            UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:@"是否确定修改问题" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateData];
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertCont addAction:okAction];
            [alertCont addAction:cancelAction];
            
            [self presentViewController:alertCont animated:YES completion:nil];

            return;
        }
        
        UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:askView.isAnonymousAsk ? @"是否确定提交匿名问题" : @"是否确定提交问题" message:@"" preferredStyle:UIAlertControllerStyleAlert];
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
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
        
    NSDictionary * fieldsDic =@{@"SEQKEY":@"",
                                @"QUESTIONTYPECODE":askView.quesTypeSEQKEY,
                                @"QUESTIONEXPLAIN":askView.inputView.text,
                                @"QUESTIONIMAGE":@"",
                                @"USERHEADIMAGE":[ZESettingLocalData getUSERHHEADURL],
                                @"QUESTIONUSERCODE":[ZESettingLocalData getUSERCODE],
                                @"QUESTIONUSERNAME":[ZESettingLocalData getNICKNAME],
                                @"QUESTIONLEVEL":@"1",
                                @"IMPORTLEVEL":@"1",
                                @"ISLOSE":@"0",
                                @"ISEXPERTANSWER":@"0",
                                @"ISSOLVE":@"0",
                                @"ISANONYMITY":[NSString stringWithFormat:@"%d",askView.isAnonymousAsk],
                                @"BONUSPOINTS":[ZEUtil isStrNotEmpty:askView.goldScore] ? askView.goldScore : @""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
   
    [self progressBegin:@"问题提交中，请稍后..."];
    [ZEUserServer uploadImageWithJsonDic:packageDic
                            withImageArr:self.imagesArr
                           showAlertView:YES
                                 success:^(id data) {
                                     NSArray * arr = [ZEUtil getEXCEPTIONDATA:data];
                                     if(arr.count > 0){
                                         NSDictionary * failReason = arr[0];
                                         [self showTips:[NSString stringWithFormat:@"%@\n",[failReason objectForKey:@"reason"]] afterDelay:1.5];
                                     }else{
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ASK_SUCCESS object:nil];
                                         [self showTips:[[ZEUtil getCOMMANDDATA:data] objectForKey:@"target"] afterDelay:1.5];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                                     }
                                 } fail:^(NSError *error) {
                                     [self showTips:@"问题发表失败，请稍后重试。"];
                                 }];
}

#pragma mark - 修改问题发送请求

-(void)updateData
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.question.QuestionPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* s1 = [formatter stringFromDate:datenow];
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_QUESINFOM.SEQKEY,
                                @"QUESTIONTYPECODE":askView.quesTypeSEQKEY,
                                @"QUESTIONEXPLAIN":askView.inputView.text,
                                @"QUESTIONIMAGE":@"",
                                @"SYSCREATEDATE":s1,
                                @"FILEURL":@"",
                                @"QUESTIONUSERCODE":[ZESettingLocalData getUSERCODE],
                                @"QUESTIONUSERNAME":[ZESettingLocalData getNICKNAME],
                                @"QUESTIONLEVEL":@"1",
                                @"IMPORTLEVEL":@"1",
                                @"ISLOSE":@"0",
                                @"ISEXPERTANSWER":@"0",
                                @"ISSOLVE":_QUESINFOM.ISSOLVE,
                                @"ISANONYMITY":[NSString stringWithFormat:@"%d",askView.isAnonymousAsk],
                                @"BONUSPOINTS":[ZEUtil isStrNotEmpty:askView.goldScore] ? askView.goldScore : @""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [self progressBegin:@"问题修改中，请稍后..."];
    [ZEUserServer uploadImageWithJsonDic:packageDic
                            withImageArr:self.imagesArr
                           showAlertView:YES
                                 success:^(id data) {
                                     NSArray * arr = [ZEUtil getEXCEPTIONDATA:data];
                                     if(arr.count > 0){
                                         NSDictionary * failReason = arr[0];
                                         [self showTips:[NSString stringWithFormat:@"%@\n",[failReason objectForKey:@"reason"]] afterDelay:1.5];
                                     }else{
                                         [self showTips:@"问题修改成功"];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_CHANGE_ASK_SUCCESS object:nil];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
                                     }
                                 } fail:^(NSError *error) {
                                     [self showTips:@"问题发表失败，请稍后重试。"];
                                 }];
}

-(void)goBack{
    if (_enterType == ENTER_GROUP_TYPE_TABBAR ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ZEHomeVC class]]) {
                ZEHomeVC *A =(ZEHomeVC *)controller;
                [self.navigationController popToViewController:A animated:YES];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)showAlertView:(NSString *)alertMsg isBack:(BOOL)isBack
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isBack) {
            if (_enterType == ENTER_GROUP_TYPE_TABBAR) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
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
