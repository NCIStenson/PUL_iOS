//
//  ZEQueryNumberVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEQueryNumberVC.h"

@interface ZEQueryNumberVC ()
{
    ZEQueryNumberView * queryNumberView;
}
@end

@implementation ZEQueryNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftBtn.superview.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}
-(void)initView
{
    queryNumberView = [[ZEQueryNumberView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    queryNumberView.delegate = self;
    [self.view addSubview:queryNumberView];
    queryNumberView.alreadyInviteNumbersArr = [NSMutableArray arrayWithArray:self.alreadyInviteNumbersArr];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goSearch:(NSString *)searchStr
{
    NSString * whereSQL = @"";
    NSString * tipsContent = @"";
    if ([self isChineseFirst:searchStr]) {
        whereSQL = [NSString stringWithFormat:@"USERNAME like '%%%@%%'",searchStr];
        tipsContent = @"查无此人，请检查输入名称";
    }else{
        whereSQL = [NSString stringWithFormat:@"USERCODE like '%%%@%%'",searchStr];
        tipsContent = @"查无此人，请检查输入工号";
    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":V_KLB_USER_BASE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":whereSQL,
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.userinfo.UserInfo",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_USER_BASE_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:V_KLB_USER_BASE_INFO] ;
                                 if ([arr count] > 0) {
                                     [queryNumberView showSearchNumberResult:arr];
                                 }else{
                                     [self showTips:tipsContent afterDelay:1.5];
                                 }
                             } fail:^(NSError *errorCode) {
                                 
                             }];
}


-(BOOL)isChineseFirst:(NSString *)firstStr
{
    //是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
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
