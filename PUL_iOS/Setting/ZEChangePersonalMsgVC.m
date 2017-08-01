//
//  ZEChangePersonalMsgVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/15.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChangePersonalMsgVC.h"

#import "ZEChangePersonalMsgView.h"
#import "ZEUserServer.h"
@interface ZEChangePersonalMsgVC()<ZEChangePersonalMsgViewDelegate>
{
    ZEChangePersonalMsgView * _changeMsgView;
}
@end

@implementation ZEChangePersonalMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MAIN_LINE_COLOR;
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    switch (_changeType) {
        case CHANGE_PERSONALMSG_NICKNAME:
            self.title = @"修改昵称";
            break;
            
        case CHANGE_PERSONALMSG_ADVICE:
            self.title = @"意见反馈";
            break;
            
        default:
            break;
    }
    [self initView];
    [self becomeFirstResponder];
}

-(void)initView
{
    _changeMsgView = [[ZEChangePersonalMsgView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) withChangeType:_changeType];
    _changeMsgView.delegate = self;
    [self.view addSubview:_changeMsgView];
}

-(void)rightBtnClick
{
    switch (_changeType) {
        case CHANGE_PERSONALMSG_NICKNAME:{
            [self setUSERNAME];
        }
            break;
            
        case CHANGE_PERSONALMSG_ADVICE:{
            [self searchIsExistWithAdvice:_changeMsgView.adviceTextView.text];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 修改昵称

-(void)setUSERNAME
{
    if (![ZEUtil isStrNotEmpty:_changeMsgView.nicknameField.text ]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"updateSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"NICKNAME":_changeMsgView.nicknameField.text,
                                @"SEQKEY":[ZESettingLocalData getUSERSEQKEY]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"保存成功"];
                                 [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
                                 [ZESettingLocalData changeNICKNAME:_changeMsgView.nicknameField.text];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
                                 NSLog(@">>  %@",data);
                             } fail:^(NSError *errorCode) {

                             }];
}

#pragma mark - 保存意见反馈

-(void)searchIsExistWithAdvice:(NSString *)advice
{
    if (![ZEUtil isStrNotEmpty:advice]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self submitAdvice:advice];
}

-(void)submitAdvice:(NSString *)advice
{
//    NSString * method = @"addSave";
//    NSString * MASTERFIELD = @"USERCODE";
//    if (isExist) {
//        method = @"updateSave";
//        MASTERFIELD = @"SEQKEY";
//    }else{
//        method = @"addSave";
//        MASTERFIELD = @"USERCODE";
//    }
//    if (![ZEUtil isStrNotEmpty:SEQKEY]) {
//        SEQKEY = @"";
//    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_SETUP_RECORD,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"USERCODE",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"OPINION":advice,
                                @"SEQKEY":@"",
                                @"USERCODE":[ZESettingLocalData getUSERCODE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_SETUP_RECORD]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"保存成功"];
                                 [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
                             } fail:^(NSError *errorCode) {

                             }];

}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
