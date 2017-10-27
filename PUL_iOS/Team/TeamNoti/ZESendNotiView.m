//
//  ZESendNotiView.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/5.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kMaxTextLength 50
#define kMaxDetailTextLength 1000

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
    
    self.notiTextLengthLab = [UILabel new];
    _notiTextLengthLab.frame = CGRectMake(_notiTextView.left, _notiTextView.bottom, _notiTextView.width, 20);
    _notiTextLengthLab.font = [UIFont systemFontOfSize:14];
    _notiTextLengthLab.textColor = kTextColor;
    _notiTextLengthLab.text = [NSString stringWithFormat:@"0/%ld",(long)kMaxTextLength];
    _notiTextLengthLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_notiTextLengthLab];

    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, _notiTextLengthLab.bottom + 5, SCREEN_WIDTH, 1.0f);
    [self.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UILabel * notiDetailLab = [UILabel new];
    notiDetailLab.frame = CGRectMake(10, _notiTextLengthLab.bottom + 10, SCREEN_WIDTH - 20, 30);
    [self addSubview:notiDetailLab];
    notiDetailLab.text = @"补充说明：";
    notiDetailLab.textColor = [UIColor lightGrayColor];
    
    _notiDetailTextView = [[UITextView alloc]init];
    _notiDetailTextView.frame = CGRectMake(10, notiDetailLab.bottom + 5, SCREEN_WIDTH - 20, 90);
    _notiDetailTextView.font = [UIFont systemFontOfSize:14];
    _notiDetailTextView.textColor = kTextColor;
    _notiDetailTextView.delegate = self;
    [self addSubview:_notiDetailTextView];
    
    self.notiDetailTextLengthLab = [UILabel new];
    _notiDetailTextLengthLab.frame = CGRectMake(_notiDetailTextView.left, _notiDetailTextView.bottom, _notiDetailTextView.width, 20);
    _notiDetailTextLengthLab.font = [UIFont systemFontOfSize:14];
    _notiDetailTextLengthLab.textColor = kTextColor;
    _notiDetailTextLengthLab.text = [NSString stringWithFormat:@"0/%ld",(long)kMaxDetailTextLength];
    _notiDetailTextLengthLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_notiDetailTextLengthLab];
    
    CALayer * detailLineLayer = [CALayer layer];
    detailLineLayer.frame = CGRectMake(0, _notiDetailTextLengthLab.bottom + 5, SCREEN_WIDTH, 1.0f);
    [self.layer addSublayer:detailLineLayer];
    detailLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UIButton * receiptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    receiptBtn.frame = CGRectMake(SCREEN_WIDTH - 90, _notiDetailTextLengthLab.bottom + 10, 80, 30);
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


-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger leng = [ZEUtil sinaCountWord:textView.text];
    BOOL flag=[ZEUtil isContainsTwoEmoji:textView.text];
    if ([textView isEqual:_notiTextView]) {
        if (flag){
            _notiTextView.text = [textView.text substringToIndex:_notiStr.length];
            return;
        }else{
            if (leng <= kMaxTextLength) {
            _notiStr = _notiTextView.text;
            }
        }
    }else if ([textView isEqual:_notiDetailTextView]){
        if (flag){
            _notiDetailTextView.text = [textView.text substringToIndex:_notiDetailStr.length];
            return;
        }else{
            if (leng <= kMaxDetailTextLength) {
            _notiDetailStr = _notiDetailTextView.text;
            }
        }
    }

    
//    NSInteger leng = [ZEUtil sinaCountWord:textView.text];
    if ([textView isEqual:_notiTextView]) {
        _notiTextLengthLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)leng,(long)kMaxTextLength];
        if (leng > kMaxTextLength) {
            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud3.mode = MBProgressHUDModeText;
            hud3.detailsLabelText = @"最多显示50个字";
            hud3.detailsLabelFont = [UIFont systemFontOfSize:14];
            [hud3 hide:YES afterDelay:1.0f];

            textView.text = [textView.text substringToIndex:_notiStr.length];
            _notiTextLengthLab.text = [NSString stringWithFormat:@"%ld/%ld",(long) [ZEUtil sinaCountWord:_notiStr],(long)kMaxTextLength];
        }
    }else if ([textView isEqual:_notiDetailTextView]){
        _notiDetailTextLengthLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)leng,(long)kMaxDetailTextLength];
        if (leng > kMaxDetailTextLength) {
            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud3.mode = MBProgressHUDModeText;
            hud3.detailsLabelText = @"最多显示1000个字";
            hud3.detailsLabelFont = [UIFont systemFontOfSize:14];
            [hud3 hide:YES afterDelay:1.0f];

            textView.text = [textView.text substringToIndex:_notiDetailStr.length];
            _notiTextLengthLab.text = [NSString stringWithFormat:@"%ld/%ld",(long) [ZEUtil sinaCountWord:_notiDetailStr],(long)kMaxTextLength];
        }
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
