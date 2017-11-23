//
//  ZEWorkStandardDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/20.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//


#import "ZEWorkStandardDetailVC.h"
#import "ZEWorkStandardDetailView.h"
#import "ZESchoolWebVC.h"
@interface ZEWorkStandardDetailVC ()<ZEWorkStandardDetailViewDelegate>

@end

@implementation ZEWorkStandardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"行业规范详情";
    [self initView];
}
-(void)initView
{
    ZEWorkStandardDetailView * detailView = [[ZEWorkStandardDetailView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) withWorkStandard:_workStandardDetailDic];
    detailView.delegate = self;
    [self.view addSubview:detailView];
}

-(void)goWorkStandardDetailWithURL:(NSString *)urlStr withWorkStandardSeqkey:(NSString *)workSeqkey
{
    ZESchoolWebVC * webVC = [[ZESchoolWebVC alloc]init];
    webVC.enterType = ENTER_WEBVC_WORK_STANDARD;
    webVC.webURL = ZENITH_IMAGE_FILESTR([ZEUtil changeURLStrFormat:urlStr]);
    webVC.workStandardSeqkey = workSeqkey;
    [self.navigationController pushViewController:webVC animated:YES];
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
