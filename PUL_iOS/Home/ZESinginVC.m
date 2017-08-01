//
//  ZESinginVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/7/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESinginVC.h"
#import "JFCalendarPickerView.h"

@interface ZESinginVC ()<JFCalendarPickerViewDelegate>
{
    JFCalendarPickerView *calendarPicker;
}
@end

@implementation ZESinginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签到";
    [self initCalendarPickView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self sendRequestWithMonth:[ZEUtil getCurrentDate:@"yyyy-MM"]];
}

-(void)sendRequestWithMonth:(NSString *)monthStr
{
    NSString * whereSQL = [NSString stringWithFormat:@"PERIOD='%@'",monthStr];
    
    NSDictionary * parametersDic = @{@"limit":@"32",
                                     @"MASTERTABLE":KLB_SIGNIN_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":whereSQL,
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"USERCODE",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    

    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"USERNAME":@"",
                                @"SIGNINDATE":@"",
                                @"PERIOD":@"",
                                @"STATUS":@""};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_SIGNIN_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];

    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [calendarPicker reloadDateData:[ZEUtil getServerData:data withTabelName:KLB_SIGNIN_INFO]];
                             } fail:^(NSError *errorCode) {

                             }];
}

-(void)initCalendarPickView
{
    calendarPicker = [[JFCalendarPickerView alloc]initWithFrame:CGRectZero];
    calendarPicker.delegate = self;
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 64, SCREEN_WIDTH, 360);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@">>  %@",[NSString stringWithFormat:@"\n日：%ld\n月：%ld\n年：%ld",(long)day, (long)month, (long)year]);
    };
    [self.view addSubview:calendarPicker];
}

#pragma mark - JFCalendarPickerViewDelegate

-(void)reloadDataWithMonth:(NSString *)monthStr
{
    [self sendRequestWithMonth:monthStr];
}

-(void)goSignin
{
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_SIGNIN_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.signin.SigninPoints",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"USERNAME":[ZESettingLocalData getUSERNAME],
                                @"SIGNINDATE":[ZEUtil getCurrentDate:@"YYYY-MM-dd"],
                                @"PERIOD":[ZEUtil getCurrentDate:@"YYYY-MM"],
                                @"STATUS":@"1"};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_SIGNIN_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:YES
                             success:^(id data) {
                                 [self sendRequestWithMonth:[ZEUtil getCurrentDate:@"YYYY-MM"]];
                                 [self showTips:[[ZEUtil getCOMMANDDATA:data] objectForKey:@"target"]];
                                 [calendarPicker signinSuccess];
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
