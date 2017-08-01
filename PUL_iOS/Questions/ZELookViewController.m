//
//  LookViewController.m
//  HunChaoWang
//
//  Created by wuxin on 15/4/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ZELookViewController.h"


@interface ZELookViewController ()<UIScrollViewDelegate>
{
    UIScrollView * scroll;
}

@end

@implementation ZELookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = [NSString stringWithFormat:@"%ld/%ld",(long)_currentSecleted + 1,(long)self.imageArr.count];
    
    [self initView];
    
    [self.rightBtn setImage:[UIImage imageNamed:@"Trash.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(deleteTheImageInArr) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)initView
{
    if (!scroll){
        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH , SCREEN_HEIGHT - 69)];
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        [self.view addSubview:scroll];

    }
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH * self.imageArr.count, SCREEN_HEIGHT - 69);
    scroll.contentOffset = CGPointMake(SCREEN_WIDTH * _currentSecleted, 0);
    
    for (UIView * view in scroll.subviews){
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.imageArr.count; i ++)
    {
        UIImage * image = self.imageArr[i];
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake( SCREEN_WIDTH * i,0, SCREEN_WIDTH, SCREEN_HEIGHT - 69)];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = image;
        [scroll addSubview:imageview];
    }
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentSecleted = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.title = [NSString stringWithFormat:@"%.0f/%ld",scrollView.contentOffset.x / SCREEN_WIDTH + 1,(long)self.imageArr.count];
}
-(void)deleteTheImageInArr
{
    [self.imageArr removeObjectAtIndex:_currentSecleted];
    
    if(_currentSecleted != 0){
        _currentSecleted = _currentSecleted - 1;

    }
    
    self.title = [NSString stringWithFormat:@"%ld/%ld",(long)_currentSecleted + 1,(long)self.imageArr.count];

    if (self.imageArr.count == 0){
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(goBackViewWithImages:)]) {
            [self.delegate goBackViewWithImages:self.imageArr];
        }
    }
    else{
        [self initView];
    }
    
}

-(void)leftBtnClick
{
    if ([self.delegate respondsToSelector:@selector(goBackViewWithImages:)]) {
        [self.delegate goBackViewWithImages:self.imageArr];
    }
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
