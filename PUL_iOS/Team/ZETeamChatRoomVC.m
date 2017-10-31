//
//  ZETeamChatRoomVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/25.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamChatRoomVC.h"
//#import <JMUIChattingKit/JMUIMessageTableViewCell.h>
@interface ZETeamChatRoomVC ()<PYPhotoBrowseViewDelegate>
{
    PYPhotoBrowseView * browseView;
}

@property (nonatomic,assign) BOOL isCanSideBack;

@end

@implementation ZETeamChatRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MAIN_NAV_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    self.title = _teamcircleModel.TEAMCIRCLENAME;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChatImage:) name:kJMESSAGE_TAP_IMAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPersonalMessage:) name:kJMESSAGE_TAP_HEADVIEW object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanSideBack;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
/**
 *恢复边缘返回
 */
- (void)resetSideBack {
    self.isCanSideBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)showChatImage:(NSNotification *)noti
{
    UIImage * image = noti.object;
    browseView = [[PYPhotoBrowseView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    browseView.images = @[image];
    browseView.delegate = self;
    browseView.dataSource = self;
    [browseView show];
}

- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView willShowWithImages:(NSArray *)images index:(NSInteger)index
{
    self.navigationController.navigationBar.hidden = YES;
}
- (CGRect)frameFormWindow{
    return CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

-(void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView didSingleClickedImage:(UIImage *)image index:(NSInteger)index
{
    self.navigationController.navigationBar.hidden = NO;
    [browseView hidden];
}

-(void)showPersonalMessage:(NSNotification *)noti
{
    if([noti.object isKindOfClass:[NSDictionary class]]){
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.labelText = [NSString stringWithFormat:@"%@",[noti.object objectForKey:@"NICKNAME"]];
        hud3.detailsLabelText = [noti.object objectForKey:@"USERNAME"];
        [hud3 hide:YES afterDelay:1.5];
    }
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
