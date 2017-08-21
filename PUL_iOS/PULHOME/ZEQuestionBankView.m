//
//  ZEQuestionBankView.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kMyAchievementViewHeight  (IPHONE5 ? 110 : 140)

#define kMyBankBtnViewHeight (SCREEN_HEIGHT - kMyBankViewHeight - kMyAchievementViewHeight - NAV_HEIGHT)
#define kMyBankViewHeight 80.0f

#define kLineWidth 2
#define endPointMargin 4

#define kServerBtnWidth (SCREEN_WIDTH - 40 ) / 4

#define kBankFlowerWidth (SCREEN_WIDTH - 60)


#import "ZEQuestionBankView.h"
#import "XLCircle.h"
#import "ZEButton.h"

@interface ZEQuestionBankView()<ZEChangeQuestionBankViewDelegate>
{
    UIView * _redDot;
    
    XLCircle * _circle;
    UILabel * _timeLab;
    UILabel * _numLab;
    
    UILabel * changeBankLab;
}

@end

@implementation ZEQuestionBankView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initTabBar];
    }
    return self;
}

-(void)initView{
    [self  initMyAchievementView];
    [self initBankBtn];
}

-(void)initMyAchievementView
{
    UIView * achiView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 140)];
    [self addSubview:achiView];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [achiView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UILabel * textLab = [[UILabel alloc]initWithFrame:CGRectMake((IPHONE5 ? 20 : 40), 10, 100, 20)];
    textLab.textColor = MAIN_TITLEBLACK_COLOR;
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.text = @"我的成就";
    [achiView addSubview:textLab];
    
    _circle = [[XLCircle alloc] initWithFrame:CGRectMake((IPHONE5 ? 30 : 50), 35, (IPHONE5 ? 70 : 100), (IPHONE5 ? 70 : 100)) lineWidth:(IPHONE5 ? 3 : 4)];
    _circle.progress = 0.2;
    [achiView addSubview:_circle];
    
    for (int i = 0; i < 2; i ++) {
        UIImageView * imageView = [UIImageView new];
        imageView.frame = CGRectMake(SCREEN_WIDTH - 170, (IPHONE5 ? (_circle.top + 5 + 40 * i): (_circle.top + 15 + 45 * i)), 25, 25);
        [achiView addSubview:imageView];
        
        UILabel * textLab = [UILabel new];
        textLab.frame = CGRectMake(imageView.right + 10.0f, imageView.top, 120, 25);
        [achiView addSubview:textLab];
        textLab.font = [UIFont systemFontOfSize:12];
        
        switch (i) {
                case 0:
                imageView.image = [UIImage imageNamed:@"time"];
                    textLab.text = @"总时长     0h";
                    _timeLab = textLab;
                break;
                
                case 1:
                imageView.image = [UIImage imageNamed:@"number"];
                    textLab.text = @"刷题数     0";
                    _numLab = textLab;
                break;
                
            default:
                break;
        }
        
    }
}

-(void)initBankBtn{
    UIView * bankBtnView = [UIView new];
    bankBtnView.frame = CGRectMake(0, NAV_HEIGHT + kMyAchievementViewHeight, SCREEN_WIDTH, kMyBankBtnViewHeight );
    [self addSubview:bankBtnView];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [bankBtnView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    changeBankLab = [UILabel new];
    changeBankLab.frame = CGRectMake(20, 5, SCREEN_WIDTH - 90, 45);
    changeBankLab.text = @"切换题库";
    [bankBtnView addSubview:changeBankLab];
    changeBankLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    
    UIImageView * changeImage = [UIImageView new];
    changeImage.frame = CGRectMake(0, 0, 15, 15);
    [bankBtnView addSubview:changeImage];
    [changeImage setImage:[UIImage imageNamed:@"change"]];
    changeImage.right = SCREEN_WIDTH - 30;
    changeImage.top = 20;
    
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(0, 0, 50, 50);
    changeBtn.center = changeImage.center;
    [bankBtnView addSubview:changeBtn];
    [changeBtn addTarget:self action:@selector(changeBankBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * flowerImageView = [UIImageView new];
    flowerImageView.userInteractionEnabled = YES;
    flowerImageView.frame = CGRectMake(30, 50, kBankFlowerWidth, kBankFlowerWidth);
    [flowerImageView setImage:[UIImage imageNamed:@"complete"]];
    [bankBtnView addSubview:flowerImageView];
    [self initFlowerView:flowerImageView];
    
}
-(void)initFlowerView:(UIView *)flowerImageView
{
    for (int i = 0 ; i < 4; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(0, 0, kBankFlowerWidth/ 2 * 0.65 , kBankFlowerWidth/ 2 * 0.65 );
        [flowerImageView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor clearColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.tag = i + 100;
        [optionBtn addTarget:self action:@selector(goQuestionBankWebView:) forControlEvents:UIControlEventTouchUpInside];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        
        switch (i) {
                case 0:
                optionBtn.center = CGPointMake(flowerImageView.width / 4 - 10, flowerImageView.height / 4 -10);
                [optionBtn setImage:[UIImage imageNamed:@"section"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"章节练习" forState:UIControlStateNormal];
                
                break;
                case 1:
                optionBtn.center = CGPointMake(flowerImageView.width / 4 * 3 + 10, flowerImageView.height / 4 - 10);
                [optionBtn setImage:[UIImage imageNamed:@"random" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"随机练习" forState:UIControlStateNormal];
                break;
                case 2:
                optionBtn.center = CGPointMake(flowerImageView.width / 4 - 10, flowerImageView.height / 4 * 3 + 5);
                [optionBtn setImage:[UIImage imageNamed:@"simulation" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"模拟考试" forState:UIControlStateNormal];
                break;
                case 3:
                optionBtn.center = CGPointMake(flowerImageView.width / 4  * 3 + 10, flowerImageView.height / 4 * 3 + 5);
                [optionBtn setImage:[UIImage imageNamed:@"difficult problem" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"难题攻克" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
    
    UIView * dailyPracticeView =[UIView new];
    [flowerImageView addSubview:dailyPracticeView];
    dailyPracticeView.frame = CGRectMake(0, 0, flowerImageView.width / 2 * 0.8, flowerImageView.width / 2 * 0.8);
    dailyPracticeView.center = CGPointMake(flowerImageView.width / 2, flowerImageView.width / 2);
    dailyPracticeView.backgroundColor = [UIColor whiteColor];
    dailyPracticeView.clipsToBounds = YES;
    dailyPracticeView.layer.cornerRadius = dailyPracticeView.height / 2;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#41b76a"].CGColor,  (__bridge id)RGBA(33, 132, 136, .8).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, dailyPracticeView.width, dailyPracticeView.height);
    [dailyPracticeView.layer addSublayer:gradientLayer];
    gradientLayer.cornerRadius = dailyPracticeView.width / 2;
    
    ZEButton * dailyBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
    dailyBtn.frame = CGRectMake(0, -5, dailyPracticeView.width, dailyPracticeView.height);
    [dailyBtn setImage:[UIImage imageNamed:@"day" ] forState:UIControlStateNormal];
    [dailyBtn setTitle:@"每日一练" forState:UIControlStateNormal];
    dailyBtn.tag = 104;
    [dailyBtn addTarget:self action:@selector(goQuestionBankWebView:) forControlEvents:UIControlEventTouchUpInside];
    [dailyPracticeView addSubview:dailyBtn];
    dailyBtn.clipsToBounds = YES;
    dailyBtn.layer.cornerRadius = dailyBtn.height / 2;
    dailyBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)initTabBar
{
    UIView * tabBarView = [UIView new];
    [self addSubview:tabBarView];
    tabBarView.frame = CGRectMake(0, SCREEN_HEIGHT - kServerBtnWidth, SCREEN_WIDTH, kServerBtnWidth);
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [tabBarView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    for (int i = 0 ; i < 4; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(20 + kServerBtnWidth * i, 0, kServerBtnWidth, kServerBtnWidth);
        [tabBarView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor clearColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(goQuestionBankWebView:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 105;
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        
        switch (i) {
                case 0:
                [optionBtn setImage:[UIImage imageNamed:@"Error"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"我的错题" forState:UIControlStateNormal];
                break;
                case 1:
                [optionBtn setImage:[UIImage imageNamed:@"collection" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
                break;
                case 2:
                [optionBtn setImage:[UIImage imageNamed:@"Exercise record" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"练习记录" forState:UIControlStateNormal];
                break;
                case 3:
                [optionBtn setImage:[UIImage imageNamed:@"note" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"我的笔记" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Public Method

-(void)setBankModel:(ZEPULHomeQuestionBankModel *)bankModel{
    _bankModel = bankModel;
    _timeLab.text = [NSString stringWithFormat:@"总时长     %.2fh",[_bankModel.time_pass floatValue] / 100];
    _numLab.text = [NSString stringWithFormat:@"刷题数     %lld",[_bankModel.done_num longLongValue]];
    _circle.progress = [_bankModel.right_rate floatValue] / 100;
    _circle.progress = 0.2;
    if (_bankModel.module_list.count > 0) {
        NSDictionary * dic = _bankModel.module_list[0];
        changeBankLab.text = [dic objectForKey:@"MODULE_NAME"];
        self.bankID = [dic objectForKey:@"MODULE_ID"];
    }
}

#pragma mark - BankDelegate

-(void)changeBankBtnClick
{
    NSLog(@" =================  %@",self.bankModel.module_list);
    if (![ZEUtil isStrNotEmpty:self.bankID]) {
        if ([self.delegate respondsToSelector:@selector(goSearchBankList)]) {
            [self.delegate goSearchBankList];
        }
        return;
    }
    ZEChangeQuestionBankView * changeQuestionBank = [[ZEChangeQuestionBankView alloc]initWithFrame:CGRectZero];
    changeQuestionBank.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    changeQuestionBank.delegate =self;
    changeQuestionBank.banksArr = self.bankModel.module_list;
    [self addSubview:changeQuestionBank];
}

-(void)goQuestionBankWebView:(UIButton*)button
{
    if (![ZEUtil isStrNotEmpty:self.bankID]) {
        if ([self.delegate respondsToSelector:@selector(goSearchBankList)]) {
            [self.delegate goSearchBankList];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goQuestionBankWebView:)]) {
        [self.delegate goQuestionBankWebView:button.tag];
    }
}

#pragma mark - 完成选择题库

-(void)finshChooseBank:(NSDictionary *)dic
{
    self.bankID = [dic objectForKey:@"MODULE_ID"];
    changeBankLab.text = [dic objectForKey:@"MODULE_NAME"];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

#pragma mark - 切换题库蒙层
@interface ZEChangeQuestionBankView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView * contentTab;
    UIImageView * backImageView;
}
@end

@implementation ZEChangeQuestionBankView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
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
    backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40 , 138);
    backImageView.right = SCREEN_WIDTH - 10;
    backImageView.top = kMyAchievementViewHeight + NAV_HEIGHT + 40.0f;
    [self addSubview:backImageView];
    
    UIImage *image = [UIImage imageNamed:@"question_bank_change_bottom"];
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [backImageView setImage:newImage];
    backImageView.userInteractionEnabled = YES;
    
    contentTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 4, backImageView.width , 132) style:UITableViewStylePlain];
    contentTab.delegate = self;
    contentTab.dataSource  = self;
    [backImageView addSubview:contentTab];
    contentTab.backgroundColor = [UIColor clearColor];
    contentTab.clipsToBounds = YES;
    contentTab.layer.cornerRadius = 5;
    contentTab.userInteractionEnabled = YES;
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
    return self.banksArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary * dic = self.banksArr[indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [dic objectForKey:@"MODULE_NAME"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel  sizeToFit];
    return cell;
}

-(void)setBanksArr:(NSArray *)banksArr
{
    _banksArr = banksArr;
    if (_banksArr.count == 0) {
        backImageView.hidden = YES;
    }else if (_banksArr.count < 3) {
        backImageView.height = _banksArr.count * 44 + 6;
        contentTab.height = _banksArr.count * 44;
    }
    [contentTab reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(finshChooseBank:)]) {
        [self.delegate finshChooseBank:self.banksArr[indexPath.row]];
    }
    
    [self removeAllSubviews];
    [self removeFromSuperview];
}

@end
