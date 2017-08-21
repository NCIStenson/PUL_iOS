//
//  ZEPersonalNotiVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kLabelScrollViewTag 999
#define kLabelScrollLineImageViewTag 1999

#define kBADGE @"badge"

#import "ZEPersonalNotiVC.h"

#import "ZEPersonalDynamicVC.h"
#import "ZEPersonalChatListVC.h"
#import "ZESystemNotiVC.h"
#import "LBTabBarController.h"

@interface ZEPersonalNotiVC ()
{
    NSArray * _allTypeArr;
    UIViewController * _currentVC;
    
    ZEPersonalDynamicVC * dynamicVC;
    ZEPersonalChatListVC * chatVC;
    ZESystemNotiVC * systemNotiVC;
    
    UILabel* notiUnreadTipsLab;
    UILabel* chatUnreadTipsLab;
    
    UIScrollView * _labelScrollView;
}
@end

@implementation ZEPersonalNotiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initVC];

    self.title = @"消息";
    self.leftBtn.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceUnreadCount:) name:kNOTI_READDYNAMIC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTableEditingState) name:kNOTI_PERSONAL_WITHOUTDYNAMIC object:nil];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_READDYNAMIC object:nil];;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_PERSONAL_WITHOUTDYNAMIC object:nil];;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if([[JMSGConversation getAllUnreadCount] integerValue] > 0){
        chatUnreadTipsLab.hidden = NO;
        [chatUnreadTipsLab setText:[NSString stringWithFormat:@"%@",[JMSGConversation getAllUnreadCount]]];
    }else{
        [chatUnreadTipsLab setText:@"0"];
        chatUnreadTipsLab.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

-(void)reduceUnreadCount:(NSNotification *)noti
{
    _notiCount -= 1;
    if (_notiCount > 0) {
        notiUnreadTipsLab.hidden = NO;
        [notiUnreadTipsLab setText:[NSString stringWithFormat:@"%ld",(long)_notiCount]];
    }else{
        notiUnreadTipsLab.hidden = YES;
    }
}

-(void)initView{
    _allTypeArr = @[@"通知",@"系统",@"会话"];
    [self.view addSubview:[self createDetailOptionView:_allTypeArr]];
}

-(void)initVC
{
    dynamicVC = [[ZEPersonalDynamicVC alloc]init];
    [self addChildViewController:dynamicVC];
    
    chatVC = [[ZEPersonalChatListVC alloc]init];
    [self addChildViewController:chatVC];
    
    systemNotiVC = [[ZESystemNotiVC alloc]init];
    [self addChildViewController:systemNotiVC];
    
    _currentVC = dynamicVC;
    
    [self.view addSubview:dynamicVC.view];
    [self.view sendSubviewToBack:dynamicVC.view];
    
    [self.view bringSubviewToFront:self.navBar];

    if (_enterPerNotiType == ENTER_PERSONALNOTICENTER_TYPE_NOTI_CHAT) {
        self.rightBtn.hidden = YES;
        UIButton * btn = [_labelScrollView viewWithTag:102];
        [self selectDifferentType:btn];
    }else{
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

-(void)leftBtnClick
{
    if (_enterPerNotiType == ENTER_PERSONALNOTICENTER_TYPE_DEFAULT) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (_enterPerNotiType == ENTER_PERSONALNOTICENTER_TYPE_NOTI || _enterPerNotiType == ENTER_PERSONALNOTICENTER_TYPE_NOTI_CHAT){
//        LBTabBarController *tab = [[LBTabBarController alloc] init];
//        UIWindow * window = [UIApplication sharedApplication].keyWindow;
//        window.rootViewController = tab;
    }
}

-(void)rightBtnClick
{
    if ([_currentVC isKindOfClass:[ZEPersonalDynamicVC class]]) {
        ZEPersonalDynamicVC * personalVC = (ZEPersonalDynamicVC *)_currentVC;
        UITableView * table = personalVC.personalNotiView.notiContentView ;
        
        if ([self.rightBtn.titleLabel.text isEqualToString:@"编辑"]) {
            [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
            [table setEditing:YES animated:YES];
            [personalVC.personalNotiView showEitingView:YES];
        }else{
            [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [table setEditing:NO animated:YES];
            [personalVC.personalNotiView showEitingView:NO];
        }
    }
}

-(void)cancelTableEditingState
{
    if ([_currentVC isKindOfClass:[ZEPersonalDynamicVC class]]) {
        ZEPersonalDynamicVC * personalVC = (ZEPersonalDynamicVC *)_currentVC;
        UITableView * table = personalVC.personalNotiView.notiContentView ;
        
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [table setEditing:NO animated:YES];
        [personalVC.personalNotiView showEitingView:NO];
    }
}

#pragma mark - 子分类选项滑动

-(UIView *)createDetailOptionView:(NSArray *)arr
{
    _labelScrollView = [[UIScrollView alloc]init];
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.left = 0.0f;
    _labelScrollView.top = NAV_HEIGHT;
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.height = 60.0f;
    _labelScrollView.tag = kLabelScrollViewTag;
    
    UIImageView * _lineImageView = [[UIImageView alloc]init];
    _lineImageView.frame = CGRectMake(20, 48.0f, SCREEN_WIDTH / arr.count - 40, 2.0f);
    _lineImageView.backgroundColor = MAIN_GREEN_COLOR;
    [_labelScrollView addSubview:_lineImageView];
    _lineImageView.tag = kLabelScrollLineImageViewTag;
    _lineImageView.clipsToBounds = YES;
    _lineImageView.layer.cornerRadius = _lineImageView.height / 2;
    if (_enterPerNotiType == ENTER_PERSONALNOTICENTER_TYPE_NOTI_CHAT) {
        _lineImageView.frame = CGRectMake(SCREEN_WIDTH / arr.count * 2 + 20, 48.0f, SCREEN_WIDTH / arr.count - 40, 2.0f);
    }
    
    float marginLeft = 0;
    
    for (int i = 0 ; i < arr.count; i ++) {
        UIButton * labelContentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_labelScrollView addSubview:labelContentBtn];
        [labelContentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(i == 0 && _enterPerNotiType != ENTER_PERSONALNOTICENTER_TYPE_NOTI_CHAT ){
            [labelContentBtn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
        } else if (i == 2  && _enterPerNotiType == ENTER_PERSONALNOTICENTER_TYPE_NOTI_CHAT ) {
            [labelContentBtn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
        }
        labelContentBtn.top = 0.0f;
        labelContentBtn.height = 50.0f;
        [labelContentBtn setTitle:arr[i] forState:UIControlStateNormal];
        [labelContentBtn addTarget:self action:@selector(selectDifferentType:) forControlEvents:UIControlEventTouchUpInside];
        labelContentBtn.tag = 100 + i;
        labelContentBtn.width = SCREEN_WIDTH / arr.count;
        labelContentBtn.left = marginLeft;
        
        if(i == 0 && _notiCount > 0){
            notiUnreadTipsLab = [[UILabel alloc]init];
            [_labelScrollView addSubview:notiUnreadTipsLab];
            notiUnreadTipsLab.backgroundColor = [UIColor redColor];
            notiUnreadTipsLab.top = 5;
            notiUnreadTipsLab.height = 20;
            notiUnreadTipsLab.width = 20;
            notiUnreadTipsLab.clipsToBounds = YES;
            notiUnreadTipsLab.layer.cornerRadius = 10;
            notiUnreadTipsLab.left = labelContentBtn.centerX + 18;
            [notiUnreadTipsLab setText:[NSString stringWithFormat:@"%ld",(long)_notiCount]];
            [notiUnreadTipsLab adjustsFontSizeToFitWidth];
            [notiUnreadTipsLab setFont:[UIFont systemFontOfSize:notiUnreadTipsLab.font.pointSize - 3]];
            notiUnreadTipsLab.textColor = [UIColor whiteColor];
            notiUnreadTipsLab.textAlignment = NSTextAlignmentCenter;
        }
        if (i == 2 && [[JMSGConversation getAllUnreadCount] integerValue]> 0) {
            chatUnreadTipsLab = [[UILabel alloc]init];
            [_labelScrollView addSubview:chatUnreadTipsLab];
            chatUnreadTipsLab.backgroundColor = [UIColor redColor];
            chatUnreadTipsLab.top = 5;
            chatUnreadTipsLab.height = 20;
            chatUnreadTipsLab.width = 20;
            chatUnreadTipsLab.clipsToBounds = YES;
            chatUnreadTipsLab.layer.cornerRadius = 10;
            chatUnreadTipsLab.left = labelContentBtn.centerX + 18;
            [chatUnreadTipsLab setText:[NSString stringWithFormat:@"%@",[JMSGConversation getAllUnreadCount]]];
            [chatUnreadTipsLab adjustsFontSizeToFitWidth];
            [chatUnreadTipsLab setFont:[UIFont systemFontOfSize:chatUnreadTipsLab.font.pointSize - 3]];
            chatUnreadTipsLab.textColor = [UIColor whiteColor];
            chatUnreadTipsLab.textAlignment = NSTextAlignmentCenter;
        }
        
        marginLeft += labelContentBtn.width;
    }
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 50.0f, SCREEN_WIDTH, 10.0f);
    [_labelScrollView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    return _labelScrollView;
}

#pragma mark - 选择上方分类

-(void)selectDifferentType:(UIButton *)btn
{
    UIScrollView *_typeScrollView;
    UIImageView * _lineImageView;
    
    _typeScrollView = [self.view viewWithTag:kLabelScrollViewTag];
    _lineImageView = [_typeScrollView viewWithTag:kLabelScrollLineImageViewTag];
    
    float marginLeft = 0;
    for (int i = 0 ; i < _allTypeArr.count; i ++) {
        UIButton * button = [btn.superview viewWithTag:100 + i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        float btnWidth = SCREEN_WIDTH / _allTypeArr.count;
        if (btn.tag - 100 == i) {
            [UIView animateWithDuration:0.35 animations:^{
                _lineImageView.frame = CGRectMake(marginLeft + 20, 48.0f, btnWidth - 40, 2.0f);
            }];
        }
        marginLeft += btnWidth;
    }
    [btn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
    
    if (btn.tag == 100) {
        if([_currentVC isEqual:dynamicVC]){
            return;
        }
        self.rightBtn.hidden = NO;
        [self transitionFromViewController:_currentVC
                          toViewController:dynamicVC
                                  duration:0.29
                                   options:UIViewAnimationOptionCurveLinear
                                animations:nil
                                completion:^(BOOL finished) {
                                    _currentVC = dynamicVC;
                                }];
    }else if (btn.tag == 101){
        if([_currentVC isEqual:systemNotiVC]){
            return;
        }
        self.rightBtn.hidden = YES;
        [self transitionFromViewController:_currentVC
                          toViewController:systemNotiVC
                                  duration:0.29
                                   options:UIViewAnimationOptionCurveLinear
                                animations:nil
                                completion:^(BOOL finished) {
                                    _currentVC = systemNotiVC;
                                }];
    }else if (btn.tag == 102){
        if([_currentVC isEqual:chatVC]){
            return;
        }
        self.rightBtn.hidden = YES;
        [self transitionFromViewController:_currentVC
                          toViewController:chatVC
                                  duration:0.29
                                   options:UIViewAnimationOptionCurveLinear
                                animations:nil
                                completion:^(BOOL finished) {
                                    _currentVC = chatVC;
                                }];

    }
    
    [self.view bringSubviewToFront:self.navBar];
    [self.view bringSubviewToFront:_labelScrollView];
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
