//
//  ZEShowOptionView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/16.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEShowOptionView.h"

@interface ZEShowOptionView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView * contentTab;
    UIImageView * backImageView;
}
@end

@implementation ZEShowOptionView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _dataArr = @[@"按热度",@"按时间"];
        _contentViewWidth = 100;
        _contentViewHeight = 88;
        
        _backImageHeight += _contentViewHeight + 15;
        [self initUIView];
    }
    return self;
}

-(void)initUIView{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    backImageView = [[UIImageView alloc]init];
    backImageView.frame = CGRectMake(0, 0, _contentViewWidth, _backImageHeight);
    [self addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    
    contentTab = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, _contentViewWidth - 10 , _contentViewHeight) style:UITableViewStylePlain];
    contentTab.delegate = self;
    contentTab.dataSource  = self;
    [backImageView addSubview:contentTab];
    contentTab.backgroundColor = [UIColor clearColor];
    contentTab.clipsToBounds = YES;
    contentTab.layer.cornerRadius = 5;
    contentTab.userInteractionEnabled = YES;
    contentTab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件(只解除的是cell与手势间的冲突，cell以外仍然响应手势)
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        return NO;
    }
    
    // 若为UITableView（即点击了tableView任意区域），则不截获Touch事件(完全解除tableView与手势间的冲突，cell以外也不会再响应手势)
    if ([touch.view isKindOfClass:[UITableView class]]){
        return NO;
    }
    return YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
//    UIImageView * eyeImage = [[UIImageView alloc]init];
//    [eyeImage setImage:[UIImage imageNamed:@"home_icon_ignoreEye.png"]];
//    [cell.contentView addSubview:eyeImage];
//    eyeImage.left = 10.0f;
//    eyeImage.top = 11.0f;
//    eyeImage.width = 30.0f;
//    eyeImage.height = 20.0f;
//    eyeImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel * textLab = [[UILabel alloc]initWithFrame:CGRectMake(0 + 8.0f, 0 , SCREEN_WIDTH - 200, 44)];
    textLab.textColor = MAIN_SUBTITLE_COLOR;
    textLab.font = [UIFont systemFontOfSize:15];
    textLab.text = _dataArr[indexPath.row];
    [cell.contentView addSubview:textLab];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectOptionWithIndex:)]) {
        [self.delegate didSelectOptionWithIndex:indexPath.row];
    }
    
    [self removeAllSubviews];
    [self removeFromSuperview];
}

-(void)setRect:(CGRect)rect
{
    _rect = rect;
//    backImageView.alpha = 0.5;
    if (rect.origin.y < SCREEN_HEIGHT / 2) {
        backImageView.frame = CGRectMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height , 0, 0);
    }else{
        backImageView.frame = CGRectMake(rect.origin.x, rect.origin.y , 0, 0);
    }
    
//    [UIView animateWithDuration:.29 animations:^{
        //        contentTab.alpha =1;
//        backImageView.alpha = 1;
        if (rect.origin.y < SCREEN_HEIGHT / 2) {
            backImageView.frame = CGRectMake(SCREEN_WIDTH - _contentViewWidth - 10, rect.origin.y + rect.size.height - 10, _contentViewWidth, _backImageHeight);
            UIImage *image = [UIImage imageNamed:@"question_bank_change_bottom"];
            UIImage *newImage = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            [backImageView setImage:newImage];
        }else{
            backImageView.frame = CGRectMake(SCREEN_WIDTH - _contentViewWidth - 10, rect.origin.y - _contentViewHeight - 5 , _contentViewWidth, _backImageHeight);
            UIImage *image = [UIImage imageNamed:@"question_bank_change_top"];
            UIImage *newImage = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
            [backImageView setImage:newImage];
            contentTab.top = 0;
        }
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
