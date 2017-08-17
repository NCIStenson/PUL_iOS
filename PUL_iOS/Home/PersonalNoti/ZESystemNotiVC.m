//
//  ZESystemNotiVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/18.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESystemNotiVC.h"

@interface ZESystemNotiVC ()

@end

@implementation ZESystemNotiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YYImage *image = [YYImage imageNamed:@"building.gif"];
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, NAV_HEIGHT + 60.0f, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT - 84.0f );
    [self.view addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
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
