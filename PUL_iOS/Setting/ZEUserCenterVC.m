//
//  ZEUserCenterVC.m
//  NewCentury
//
//  Created by Stenson on 16/4/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZEUserCenterVC.h"
#import "ZEUserCenterView.h"

#import "ZESetPersonalMessageVC.h"

#import "ZEShowQuestionVC.h"
#import "ZEGroupVC.h"
#import "ZESinginVC.h"
#import "ZELookViewController.h"
#import "ZETypicalCaseVC.h"
#import "ZEChangePersonalMsgVC.h"
#import "ZEPersonalNotiVC.h"
#import "ZESchoolWebVC.h"

#define kTipsImageTag 1234

@interface ZEUserCenterVC ()<ZEUserCenterViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    ZEUserCenterView * usView;
    UIImage * _choosedImage;
    
    NSString * notiUnreadCount;
}
@end

@implementation ZEUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_QUESTION object:nil];
    [self isHaveNewMessage];
}

-(void)initView
{
    usView = [[ZEUserCenterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    usView.delegate = self;
    [self.view addSubview:usView];
}

#pragma mark - 是否有新消息提醒

-(void)isHaveNewMessage
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfoManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"INFOCOUNT":@"",
                                @"QUESTIONCOUNT":@"",
                                @"ANSWERCOUNT":@"",
                                @"TEAMINFOCOUNT":@"",
                                @"PERINFOCOUNT":@"",
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"userbaseinfo"];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
                                 if ([arr count] > 0) {
                                     NSString * INFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"INFOCOUNT"]];
                                     NSString * QUESTIONCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"QUESTIONCOUNT"]];
                                     NSString * ANSWERCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"ANSWERCOUNT"]];
                                     NSString * TEAMINFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"TEAMINFOCOUNT"]];
                                     NSString * PERINFOCOUNT = [NSString stringWithFormat:@"%@" ,[arr[0] objectForKey:@"PERINFOCOUNT"]];
                                     notiUnreadCount = PERINFOCOUNT;
                                     
                                     if ([INFOCOUNT integerValue] > 0) {
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                                         item.badgeValue= INFOCOUNT;
                                         if ([INFOCOUNT integerValue] > 99) {
                                             item.badgeValue= @"99+";
                                         }
                                     }else{
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                                         item.badgeValue= nil;
                                     }
                                     
                                     if ([TEAMINFOCOUNT integerValue] > 0 ) {
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
                                         item.badgeValue= TEAMINFOCOUNT;
                                         if ([INFOCOUNT integerValue] > 99) {
                                             item.badgeValue= @"99+";
                                         }
                                     }else{
                                         UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
                                         item.badgeValue= nil;
                                     }

                                     [usView reloadHeaderMessage:QUESTIONCOUNT answerCount:ANSWERCOUNT];
                                     long sumCount = [[JMSGConversation getAllUnreadCount] integerValue]+ [PERINFOCOUNT integerValue];
                                     
                                     UILabel* tipsImage;
                                     tipsImage = [usView.userMessage viewWithTag:kTipsImageTag];
                                     if (sumCount  > 0) {
                                         if (!tipsImage) {
                                             tipsImage = [[UILabel alloc]init];
                                             [usView.userMessage addSubview:tipsImage];
                                             tipsImage.backgroundColor = [UIColor redColor];
                                             tipsImage.top = usView.notiBtn.top - 5;
                                             tipsImage.height = 20;
                                             tipsImage.width = 20;
                                             tipsImage.clipsToBounds = YES;
                                             tipsImage.layer.cornerRadius = 10;
                                             tipsImage.left = usView.notiBtn.centerX + 8;
                                             tipsImage.tag = kTipsImageTag;
                                             [tipsImage adjustsFontSizeToFitWidth];
                                             [tipsImage setFont:[UIFont systemFontOfSize:tipsImage.font.pointSize - 3]];
                                             tipsImage.textColor = [UIColor whiteColor];
                                             tipsImage.textAlignment = NSTextAlignmentCenter;
                                         }
                                         tipsImage.hidden = NO;
                                         [tipsImage setText:[NSString stringWithFormat:@"%ld",(long)sumCount]];
                                     }else{
                                         tipsImage.hidden = YES;
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>  %@",errorCode);
                             }];
    
}


#pragma mark - ZEUserCenterViewDelegate

-(void)goSettingVC:(ENTER_SETTING_TYPE)type;
{
    ZESetPersonalMessageVC * personalMsgVC = [[ZESetPersonalMessageVC alloc]init];
    personalMsgVC.enterType = type;
    [self.navigationController pushViewController:personalMsgVC animated:YES];
}

-(void)goMyQuestionList
{
    ZEShowQuestionVC * showQuesVC = [[ZEShowQuestionVC alloc]init];
    showQuesVC.showQuestionListType = QUESTION_LIST_MY_QUESTION;
    [self.navigationController pushViewController:showQuesVC animated:YES];
}
-(void)goMyAnswerList
{
    ZEShowQuestionVC * showQuesVC = [[ZEShowQuestionVC alloc]init];
    showQuesVC.showQuestionListType = QUESTION_LIST_MY_ANSWER;
    [self.navigationController pushViewController:showQuesVC animated:YES];
}

-(void)goMyGroup
{
    ZEGroupVC * groupVC = [[ZEGroupVC alloc]init];
    groupVC.enter_group_type = ENTER_GROUP_TYPE_SETTING;
    [self.navigationController pushViewController:groupVC animated:YES];
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
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"updateSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"SEQKEY":[ZESettingLocalData getUSERCODE],
                                @"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"FILEURL":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer uploadImageWithJsonDic:packageDic
                            withImageArr:@[_choosedImage]
                           showAlertView:YES
                                 success:^(id data) {
                                    NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_USER_BASE_INFO];
                                     if (arr.count > 0) {
                                         [self getHeadImgUrl];
                                     }
                                 } fail:^(NSError *error) {
                                     }];
}

-(void)getHeadImgUrl
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":V_KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"FILEURL":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_USER_BASE_INFO];
                                 if (arr.count > 0) {
                                     if ([ZEUtil isStrNotEmpty:[arr[0] objectForKey:@"FILEURL"]]) {
                                         NSArray * headUrlArr = [[arr[0] objectForKey:@"FILEURL"] componentsSeparatedByString:@","];
                                         [ZESettingLocalData changeUSERHHEADURL:headUrlArr[1]];
                                         [usView reloadHeaderB];
                                         [self updataJMESSAGEAvatar];
                                     }
                                 }
                             }
                                fail:^(NSError *error) {
                                   }];
}

-(void)updataJMESSAGEAvatar
{
    
    [JMSGUser updateMyInfoWithParameter:UIImageJPEGRepresentation(_choosedImage, 1) userFieldType:kJMSGUserFieldsAvatar completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //updateMyInfoWithPareter success
        } else {
            //updateMyInfoWithPareter fail
        }
    }];
}

-(void)goSinginVC
{
    ZESinginVC * singVC = [[ZESinginVC alloc]init];
    [self.navigationController pushViewController:singVC animated:YES];
}

-(void)goMyCollect
{
    ZETypicalCaseVC * caseVC = [[ZETypicalCaseVC alloc]init];
    caseVC.enterType = ENTER_CASE_TYPE_SETTING;
    [self.navigationController pushViewController:caseVC animated:YES];
}

-(void)changePersonalMsg:(CHANGE_PERSONALMSG_TYPE)type
{
    ZEChangePersonalMsgVC * personalMsgVC = [[ZEChangePersonalMsgVC alloc]init];
    personalMsgVC.changeType = type;
    [self.navigationController pushViewController:personalMsgVC animated:YES];
}

-(void)goSchollVC:(ENTER_WEBVC)type
{
    ZESchoolWebVC * schoolVC = [[ZESchoolWebVC alloc]init];
    schoolVC.enterType = type;
    [self.navigationController pushViewController:schoolVC animated:YES];
    
}
-(void)goNotiVC
{
    ZEPersonalNotiVC * personalNotiVC = [[ZEPersonalNotiVC alloc]init];
    personalNotiVC.notiCount = [notiUnreadCount integerValue];
    [self.navigationController pushViewController:personalNotiVC animated:YES];
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
