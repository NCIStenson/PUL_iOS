//
//  ZESendNotiView.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/5.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESendNotiView.h"
@interface ZESendNotiView()<UITextViewDelegate>
{
    
}

@end

@implementation ZESendNotiView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isReceipt = NO;
        [self initView];
    }
    return self;
}

-(void)initView
{
    UILabel * notiLab = [UILabel new];
    notiLab.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 30);
    [self addSubview:notiLab];
    notiLab.text = @"通知：";
    notiLab.textColor = kTextColor;
    
    _notiTextView = [[UITextView alloc]init];
    _notiTextView.frame = CGRectMake(10, notiLab.bottom + 5, SCREEN_WIDTH - 20, 50);
    _notiTextView.font = [UIFont systemFontOfSize:14];
    _notiTextView.textColor = kTextColor;
    _notiTextView.delegate = self;
    [self addSubview:_notiTextView];
    [_notiTextView becomeFirstResponder];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, _notiTextView.bottom + 5, SCREEN_WIDTH, 1.0f);
    [self.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UILabel * notiDetailLab = [UILabel new];
    notiDetailLab.frame = CGRectMake(10, _notiTextView.bottom + 10, SCREEN_WIDTH - 20, 30);
    [self addSubview:notiDetailLab];
    notiDetailLab.text = @"补充说明：";
    notiDetailLab.textColor = [UIColor lightGrayColor];
    
    _notiDetailTextView = [[UITextView alloc]init];
    _notiDetailTextView.frame = CGRectMake(10, notiDetailLab.bottom + 5, SCREEN_WIDTH - 20, 90);
    _notiDetailTextView.font = [UIFont systemFontOfSize:14];
    _notiDetailTextView.textColor = kTextColor;
    _notiDetailTextView.delegate = self;
    [self addSubview:_notiDetailTextView];
    
    CALayer * detailLineLayer = [CALayer layer];
    detailLineLayer.frame = CGRectMake(0, _notiDetailTextView.bottom + 5, SCREEN_WIDTH, 1.0f);
    [self.layer addSublayer:detailLineLayer];
    detailLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UIButton * receiptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    receiptBtn.frame = CGRectMake(SCREEN_WIDTH - 90, _notiDetailTextView.bottom + 10, 80, 30);
    [receiptBtn setTitle:@"需要回执" forState:UIControlStateNormal];
    [receiptBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [receiptBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    [receiptBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateSelected];
    receiptBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [receiptBtn setImage:[UIImage imageNamed:@"icon_team_receipt" color:kTextColor] forState:UIControlStateNormal];
    [receiptBtn setImage:[UIImage imageNamed:@"icon_team_receipt_choosed" color:MAIN_NAV_COLOR] forState:UIControlStateSelected];
    [self addSubview:receiptBtn];
    [receiptBtn addTarget:self action:@selector(confirmReceipt:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)confirmReceipt:(UIButton *)btn
{
    _isReceipt = !_isReceipt;
    btn.selected = !btn.selected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
