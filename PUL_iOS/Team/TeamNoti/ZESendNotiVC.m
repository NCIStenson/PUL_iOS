//
//  ZESendNotiVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/5.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESendNotiVC.h"
#import "ZESendNotiView.h"
@interface ZESendNotiVC ()
{
    ZESendNotiView * _sendNotiView;
}
@end

@implementation ZESendNotiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"团队通知";
    [self.rightBtn setTitle:@"发送通知" forState:UIControlStateNormal];
    [self initView];
}

-(void)initView{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    _sendNotiView = [[ZESendNotiView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    [self.view addSubview:_sendNotiView];
}

-(void)hiddenKeyboard
{
    [self.view endEditing:YES];
}

-(void)rightBtnClick
{
    NSLog(@" 通知主题 >>>> %@",_sendNotiView.notiTextView.text);
    NSLog(@" 详情描述 >>>> %@",_sendNotiView.notiDetailTextView.text);
    NSLog(@" 是否回执 >>>> %d",_sendNotiView.isReceipt);
    
    if(_sendNotiView.notiTextView.text.length < 5 ){
        [self showTips:@"请输入详细通知主题"];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"是否发送通知" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmSendMessage];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)confirmSendMessage
{
    [self showTips:@"正在发送通知"];
    NSDictionary * parametersDic = @{@"limit":@"1",
                                     @"MASTERTABLE":KLB_MESSAGE_SEND,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_INSERT,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.message.TeamMessageManage",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"TEAMID":_teamID,
                                @"MESSAGE":_sendNotiView.notiTextView.text,
                                @"REMARK":_sendNotiView.notiDetailTextView.text,
                                @"ISRECEIPT":[NSString stringWithFormat:@"%d",_sendNotiView.isReceipt]
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_MESSAGE_SEND]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"sendmessage"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_MESSAGE_SEND];
                                 if ([ZEUtil isNotNull:arr]) {
                                     [self showTips:@"通知发送成功" afterDelay:1.5];
                                     [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_TEAM_SENDMESSAGE_NOTI object:nil];
                                 }
                             } fail:^(NSError *errorCode) {
                                 [self showTips:@"通知发送失败，请重试" afterDelay:1];
                             }];
}

-(void)goBack
{
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
