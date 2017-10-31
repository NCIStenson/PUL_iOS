//
//  ZEAskTeamQuestionVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAskTeamQuestionVC.h"
#import "ZEAskTeamQuestionView.h"
#import "ZEAskQuestionTypeView.h"

#import "ZEShowQuestionVC.h"
#import <ZLPhotoActionSheet.h>
#import "ZEQuestionTypeCache.h"

#import "ZEChooseNumberVC.h"

#import "ZEShowQuestionVC.h"
#import "ZETeamQuestionVC.h"
#define textViewStr @"试着将问题尽可能清晰的描述出来，这样回答者们才能更完整、更高质量的为您解答。"

@interface ZEAskTeamQuestionVC ()<ZEAskTeamQuestionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    ZEAskTeamQuestionView * askView;
    ZEAskQuestionTypeView * askTypeView;
    NSDictionary * showQuesTypeDic;
    
    NSString * questionTypeCode;
    NSString * targetMembersStr; // 指定人员回答
    NSString * targetMembersUsername; // 指定人员回答
}

@property (nonatomic,retain) NSMutableArray * imagesArr;
@property (nonatomic,retain) NSMutableArray * cachesImagesArr; // 已经上传过的图片
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@end

@implementation ZEAskTeamQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.imagesArr = [NSMutableArray array];
    self.lastSelectAssets = [NSMutableArray array];
    self.cachesImagesArr = [NSMutableArray array];

    targetMembersStr = _QUESINFOM.TARGETUSERCODE;
    targetMembersUsername = [NSString stringWithFormat:@"指定回答者：%@",_QUESINFOM.TARGETUSERNAME];

//    targetMembersUsername = _QUESINFOM.TARGETUSERNAME;
    if(targetMembersStr.length == 0){
        targetMembersStr = @"";
    }
    if (targetMembersUsername == 0) {
        targetMembersUsername = @"";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackShowView) name:kNOTI_CHANGE_ASK_SUCCESS object:nil];;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishChooseTeamMember:) name:kNOTI_FINISH_CHOOSE_TEAMCIRCLENUMBERS object:nil];;
    
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
-(void)finishChooseTeamMember:(NSNotification*)noti
{
    targetMembersUsername = @"";
    targetMembersStr = @"";
    
    for (id obj in noti.object) {
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:obj];
        if(targetMembersStr.length == 0){
            targetMembersStr = userinfo.USERCODE;
        }else{
            targetMembersStr = [NSString stringWithFormat:@"%@,%@",targetMembersStr,userinfo.USERCODE];
        }
        
        if (targetMembersUsername.length == 0) {
            targetMembersUsername = [NSString stringWithFormat:@"指定回答者：%@",userinfo.USERNAME];
        }else{
            targetMembersUsername = [NSString stringWithFormat:@"%@,%@",targetMembersUsername,userinfo.USERNAME];
        }
    }
    if (targetMembersStr.length > 0) {
//        askView.designatedNumberBtn.backgroundColor = MAIN_ARM_COLOR;
//        askView.designatedNumberBtn.height = [ZEUtil heightForString:targetMembersStr font:askView.designatedNumberBtn.titleLabel.font andWidth:askView.designatedNumberBtn.width];
        [askView.designatedNumberBtn setTitle:targetMembersUsername forState:UIControlStateNormal];
    }else{
        [askView.designatedNumberBtn  setTitle:@"指定回答者：只能选取团队中的人，可多选" forState:UIControlStateNormal];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_CHANGE_ASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_FINISH_CHOOSE_TEAMCIRCLENUMBERS object:nil];
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
                                     @"CLASSNAME":@"com.nci.klb.app.procirclestatus.ProcirclePosition",
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
        [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];

        askView = [[ZEAskTeamQuestionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withQuestionInfoM:self.QUESINFOM];
        
        targetMembersStr = _QUESINFOM.TARGETUSERNAME;
        targetMembersUsername = _QUESINFOM.TARGETUSERNAME;
        
        if (targetMembersStr.length > 0) {
            [askView.designatedNumberBtn setTitle:[NSString stringWithFormat:@"指定回答者：%@",targetMembersUsername] forState:UIControlStateNormal];
        }else{
            [askView.designatedNumberBtn  setTitle:@"指定回答者：只能选取团队中的人，可多选" forState:UIControlStateNormal];
        }

        for (NSString * str in self.QUESINFOM.FILEURLARR) {
            NSString * strUrl =[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str];
            UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strUrl];
            if([ZEUtil isNotNull:cachedImage]){
                [self.cachesImagesArr addObject:cachedImage];
                [self.imagesArr addObject:cachedImage];
                [askView reloadChoosedImageView:self.cachesImagesArr];
            }
        }
    }else{
        self.title = [NSString stringWithFormat:@"%@中提问",_teamInfoModel.TEAMCIRCLENAME];
        askView = [[ZEAskTeamQuestionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    askView.delegate = self;
    [self.view addSubview:askView];
    [self.view sendSubviewToBack:askView];
}

#pragma mark - ZEAskQuesViewDelegate

-(void)changeAskTeamQuestionTitle:(NSString *)titleStr{
    self.title = titleStr;
}
-(void)takePhotosOrChoosePictures
{
    
    UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * takeAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickController:YES];
    }];
    UIAlertAction * chooseAction = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    [[self getPas] showPhotoLibrary];
}
- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 3;
    //设置照片最大选择数
    actionSheet.maxSelectCount = 3 - self.imagesArr.count;
    //设置允许选择的视频最大时长
    actionSheet.allowSelectVideo = NO;
    //设置照片cell弧度
    actionSheet.cellCornerRadio = 5;
    //单选模式是否显示选择按钮
    actionSheet.showSelectBtn = NO;
    //是否在选择图片后直接进入编辑界面
    actionSheet.editAfterSelectThumbnailImage = NO;
    //设置编辑比例
    //是否在已选择照片上显示遮罩层
    actionSheet.showSelectedMask = NO;
#pragma required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    actionSheet.arrSelectedAssets = self.lastSelectAssets;
    
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        strongSelf.imagesArr = [NSMutableArray arrayWithArray:_cachesImagesArr];
        [strongSelf.imagesArr addObjectsFromArray:images];
        [askView reloadChoosedImageView:strongSelf.imagesArr];
        strongSelf.lastSelectAssets = assets.mutableCopy;
    }];
    
    return actionSheet;
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * chooseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [askView reloadChoosedImageView:chooseImage];
    [self.imagesArr addObject:chooseImage];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (index < _cachesImagesArr.count) {
        [self.cachesImagesArr removeObjectAtIndex:index];
    }else{
        if (_cachesImagesArr.count > 0) {
            [self.lastSelectAssets removeObjectAtIndex:index - self.cachesImagesArr.count];
        }else{
            [self.lastSelectAssets removeObjectAtIndex:index];
        }
    }
}

#pragma mark - 确认输入信息

-(void)leftBtnClick
{
    if ([ZEUtil isNotNull:askView.askTypeView]) {
        self.title = [NSString stringWithFormat:@"%@中提问",_teamInfoModel.TEAMCIRCLENAME];
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
    }else if (askView.inputView.text.length < 6){
        [self showAlertView:@"请输入不少于6个字的问题描述" isBack:NO];
        return;
    }else if ([ZEUtil isEmpty:askView.inputView.text]){
        [self showAlertView:@"不能发表空白问题" isBack:NO];
        return;
    }else if (askView.inputView.text.length > 200){
        [self showAlertView:@"请输入不多于200字的问题描述" isBack:NO];
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
        
        UIAlertController * alertCont= [UIAlertController alertControllerWithTitle: @"确定要提交这个提问吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self insertData];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertCont addAction:okAction];
        [alertCont addAction:cancelAction];
        
        [self presentViewController:alertCont animated:YES completion:nil];
    }
}

-(void)insertData
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":@"",
                                @"QUESTIONTYPECODE":askView.quesTypeSEQKEY,
                                @"QUESTIONEXPLAIN":askView.inputView.text,
                                @"QUESTIONIMAGE":@"",
                                @"QUESTIONUSERCODE":[ZESettingLocalData getUSERCODE],
                                @"QUESTIONUSERNAME":[ZESettingLocalData getCurrentUsername],
                                @"QUESTIONLEVEL":@"1",
                                @"IMPORTLEVEL":@"1",
                                @"ISLOSE":@"0",
                                @"ISEXPERTANSWER":@"0",
                                @"ISSOLVE":@"0",
                                @"TEAMCIRCLECODE":_teamInfoModel.TEAMCODE,
                                @"TARGETUSERCODE":targetMembersStr,
                                @"TARGETUSERNAME":[targetMembersUsername stringByReplacingOccurrencesOfString:@"指定回答者：" withString:@""],
                                };
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_QUESTION_INFO]
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
                                         [self showTips:@"问题发表成功"];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_ASK_SUCCESS object:nil];
                                         [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
                                     }
                                 } fail:^(NSError *error) {
                                     [self showTips:@"问题发表失败，请稍后重试。"];
                                 }];
}

#pragma mark - 修改问题发送请求

-(void)updateData
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_TEAMCIRCLE_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_UPDATE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.teamcircle.TeamcircleQuestion",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":_QUESINFOM.SEQKEY,
                                @"QUESTIONTYPECODE":askView.quesTypeSEQKEY,
                                @"QUESTIONEXPLAIN":askView.inputView.text,
                                @"TEAMCIRCLECODE":_teamInfoModel.TEAMCODE,
                                @"TARGETUSERCODE":targetMembersStr,
                                @"TARGETUSERNAME":[targetMembersUsername stringByReplacingOccurrencesOfString:@"指定回答者：" withString:@""],
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_TEAMCIRCLE_QUESTION_INFO]
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
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_TEAM_CHANGE_QUESTION_SUCCESS object:nil];
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
            if ([controller isKindOfClass:[ZETeamQuestionVC class]]) {
                ZETeamQuestionVC *A =(ZETeamQuestionVC *)controller;
                [self.navigationController popToViewController:A animated:YES];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)goChoooseMemberVC
{
    ZEChooseNumberVC * chooseNumber = [[ZEChooseNumberVC alloc]init];
    chooseNumber.TEAMCODE = _teamInfoModel.TEAMCODE;
    chooseNumber.enterType = ENTER_CHOOSE_TEAM_MEMBERS_ASK;
    [self presentViewController:chooseNumber animated:YES completion:nil];
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
