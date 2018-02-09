//
//  ZEChangePwdVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/9/22.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChangePwdVC.h"

@interface ZEChangePwdVC ()
{
    UITextField * _oldField;
    UITextField * _newPwdField;
    UITextField * _newConfirmField;
}
@end

@implementation ZEChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [self.view addGestureRecognizer:tap];
    
    [self initView];
}

-(void)initView{
    UIView * inputView = [UIView new];
    inputView.frame = CGRectMake(20, NAV_HEIGHT + 20, SCREEN_WIDTH  -40, 140);
    [self.view addSubview:inputView];
//    inputView.backgroundColor = MAIN_ARM_COLOR;
    
    UIView * oldPwdView = [UIView new];
    oldPwdView.frame = CGRectMake(0, 0, inputView.width, 40);
    [inputView addSubview:oldPwdView];
    oldPwdView.layer.borderWidth = 1;
    oldPwdView.layer.borderColor = [MAIN_NAV_COLOR CGColor];
    
    UIView * newPwdView = [UIView new];
    newPwdView.frame = CGRectMake(0, 60, inputView.width, 80);
    [inputView addSubview:newPwdView];
    newPwdView.layer.borderWidth = 1;
    newPwdView.layer.borderColor = [MAIN_NAV_COLOR CGColor];
    
    [ZEUtil addLineLayerMarginLeft:10 marginTop:40 width:newPwdView.width - 20 height:0.5 superView:newPwdView];
    

    for (int i = 0; i < 3; i ++) {
        UIImageView * usernameImage = [[UIImageView alloc]init];
        usernameImage.contentMode = UIViewContentModeScaleAspectFit;
        usernameImage.left = 12;
        usernameImage.top = 12;
        usernameImage.size = CGSizeMake(16, 16);
        usernameImage.image = [UIImage imageNamed:@"login_password.png" color:kSubTitleColor];
        
        UITextField * _usernameField = [[UITextField alloc]initWithFrame:CGRectMake(40,0 ,oldPwdView.width - 40, 40)];
        _usernameField.secureTextEntry = YES;
        _usernameField.font = [UIFont systemFontOfSize:14];
        _usernameField.placeholder = @"请输入当前密码";
        _usernameField.textColor = kTextColor;
        [_usernameField setValue:kSubTitleColor forKeyPath:@"_placeholderLabel.textColor"];

        switch (i) {
            case 0:
                usernameImage.top = 12;
                _usernameField.placeholder = @"请输入当前密码";
                _oldField = _usernameField;
                [oldPwdView addSubview:usernameImage];
                [oldPwdView addSubview:_usernameField];
                break;
                
            case 1:
                usernameImage.top = 12;
                _usernameField.placeholder = @"请输入新密码";
                _newPwdField = _usernameField;
                [newPwdView addSubview:usernameImage];
                [newPwdView addSubview:_usernameField];
                break;

            case 2:
                usernameImage.top = 12 + 40;
                _usernameField.top = 40;
                _usernameField.placeholder = @"请确认新密码";
                _newConfirmField = _usernameField;
                [newPwdView addSubview:usernameImage];
                [newPwdView addSubview:_usernameField];
                break;

            default:
                break;
        }
    }
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(20, 180 + NAV_HEIGHT, SCREEN_WIDTH - 40, 40);
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [confirmBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [confirmBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [confirmBtn addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.clipsToBounds = YES;
    confirmBtn.layer.cornerRadius = 3;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#41b76a"].CGColor,  (__bridge id)RGBA(33, 132, 136, 0.8).CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    gradientLayer.frame = CGRectMake(0, 0, confirmBtn.width, confirmBtn.height);
    gradientLayer.frame = confirmBtn.frame;
    gradientLayer.cornerRadius = 3;
    [self.view.layer addSublayer:gradientLayer];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

#pragma mark - 首次登陆

-(void)changePassword
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认修改密码？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * field1 = _oldField;
        UITextField * field2 = _newPwdField;
        UITextField * field3 = _newConfirmField;
        if (field2.text.length < 6 || field3.text.length < 6){
            [self alertMessage:@"新密码不能少于6位"];
        }else if (field1.text.length > 0 && field2.text.length > 0 && field3.text.length > 0 ) {
            [self changePasswordRequestOldPassword:field1.text
                                       newPassword:field2.text
                                   confirmPassword:field3.text];
        }else{
            [self alertMessage:@"密码不能为空"];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)alertMessage:(NSString * )str
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)changePasswordRequestOldPassword:(NSString *)OLDPASSWORD
                            newPassword:(NSString *)NEWPASSWORD
                        confirmPassword:(NSString *)NEWPASSWORD1

{
    NSDictionary * parametersDic = @{@"limit":@"2000",
                                     @"MASTERTABLE":@"EPM_USER_PWD",
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"saveSelfPwd",
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.epm.biz.hr.EpmHr",
                                     };
    
    NSDictionary * fieldsDic =@{@"OLDPASSWORD":OLDPASSWORD,
                                @"NEWPASSWORD":NEWPASSWORD,
                                @"NEWPASSWORD1":NEWPASSWORD1};
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[@"EPM_USER_PWD"]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 if ([[data objectForKey:@"RETMSG"] isEqualToString:@"操作成功！"]) {
                                     [self alertMessage:@"操作成功"];
                                     [ZESettingLocalData setUSERPASSWORD:NEWPASSWORD];
                                 }else{
                                     NSArray * dataArr = [data objectForKey:@"EXCEPTIONDATA"];
                                     if ([dataArr count] > 0) {
                                         [self alertMessage:[dataArr[0] objectForKey:@"reason"]];
                                     }
                                 }
                             } fail:^(NSError *errorCode) {
                                 NSLog(@" eeeeee=== %@",errorCode);
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
