//
//  LBTabBarController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBTabBarController.h"
#import "LBNavigationController.h"

#import "ZEHomeVC.h"
#import "ZETeamVC.h"
#import "ZEGroupVC.h"
#import "ZEUserCenterVC.h"

#import "ZESchoolWebVC.h"

#import "ZEAskQuesViewController.h"
#import "ZEAskTeamQuestionVC.h"

#import "LBTabBar.h"
#import "UIImage+Image.h"

#import "ZETeamCircleModel.h"
@interface LBTabBarController ()<LBTabBarDelegate>
{
    BOOL _isTeamAsk; //是否是班组圈提问
    
    ZETeamCircleModel * _teamCircleInfo;
}
@end

@implementation LBTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem * tabBarItem;
    
    if (IS_IOS8) {
        tabBarItem = [UITabBarItem appearanceWhenContainedIn:self,nil];
    }else{
        tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    }
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllChildVc];

    _isTeamAsk = NO;
    _teamCircleInfo = NULL;
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    LBTabBar *tabbar = [[LBTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];

}

-(void)changeAskStateNO
{
    _isTeamAsk = NO;
}

-(void)changeAskState:(NSNotification *)noti
{
    _isTeamAsk = YES;

    if ([ZEUtil isNotNull:noti] && [noti.object isKindOfClass:[ZETeamCircleModel class]]) {
        _teamCircleInfo = noti.object;
    }else{
        _teamCircleInfo = NULL;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNOTI_ASK_QUESTION object:nil];
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{

    ZEHomeVC *HomeVC = [[ZEHomeVC alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"icon_home" selectedImage:@"icon_home" title:@"首页"];

    ZEGroupVC *FishVC = [[ZEGroupVC alloc] init];
    [self setUpOneChildVcWithVc:FishVC Image:@"icon_circle" selectedImage:@"icon_circle" title:@"圈子"];

    ZETeamVC *MessageVC = [[ZETeamVC alloc] init];
    [self setUpOneChildVcWithVc:MessageVC Image:@"icon_team" selectedImage:@"icon_team" title:@"团队"];

//    ZESchoolWebVC *MessageVC = [[ZESchoolWebVC alloc] init];
//    [self setUpOneChildVcWithVc:MessageVC Image:@"icon_school" selectedImage:@"icon_school" title:@"学堂"];
    
    ZEUserCenterVC *MineVC = [[ZEUserCenterVC alloc] init];
    [self setUpOneChildVcWithVc:MineVC Image:@"icon_user" selectedImage:@"icon_user" title:@"我的"];

}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    LBNavigationController *nav = [[LBNavigationController alloc] initWithRootViewController:Vc];

    Vc.view.backgroundColor = [UIColor whiteColor];

    UIImage *myImage = [UIImage imageNamed:image color:[UIColor grayColor]];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;

    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage color:MAIN_NAV_COLOR];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    Vc.tabBarItem.selectedImage = mySelectedImage;

    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    
//    [self unSelectedTapTabBarItems:Vc.tabBarItem];
//    [self selectedTapTabBarItems:Vc.tabBarItem];

    [self addChildViewController:nav];
    
}
//设置tabBarItem没选中时的字体自颜色
-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12], NSFontAttributeName,[UIColor grayColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
}

//设置tabBarItem选中时的字体颜色
-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12], NSFontAttributeName,MAIN_NAV_COLOR,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
}



#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{
    if (_isTeamAsk) {
        if ([ZEUtil isNotNull:_teamCircleInfo]) {
            ZEAskTeamQuestionVC * askQues = [[ZEAskTeamQuestionVC alloc]init];
            askQues.enterType = ENTER_GROUP_TYPE_TABBAR;
            askQues.teamInfoModel = _teamCircleInfo;
            [self presentViewController:askQues animated:YES completion:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud3.mode = MBProgressHUDModeText;
            hud3.labelText = @"请先选择班组圈";
            [hud3 hide:YES afterDelay:1.5];
        }
        return;
    }
    
    ZEAskQuesViewController * askQues = [[ZEAskQuesViewController alloc]init];
    askQues.enterType = ENTER_GROUP_TYPE_TABBAR;
    [self presentViewController:askQues animated:YES completion:nil];
}


- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

@end
