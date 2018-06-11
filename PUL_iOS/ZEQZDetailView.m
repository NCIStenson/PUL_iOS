//
//  ZEManagerPracticeBankView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kServerBtnWidth (IPHONE4S_LESS ? 50 : (SCREEN_WIDTH - 40 ) / 4)

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   (NAV_HEIGHT + 40)
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      (SCREEN_HEIGHT - NAV_HEIGHT - kServerBtnWidth)

#import "ZEManagerPracticeBankView.h"
#import "ZEButton.h"
#import "ZEQZDetailView.h"
#import "HcdProcessView.h"

@implementation ZEQZDetailView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)initView
{
    UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.frame = CGRectMake(kContentViewMarginLeft , 0, kContentViewWidth, kContentViewHeight);
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTableView.tag = 100 ;
}

-(void)initTabBar
{
    UIView * tabBarView = [UIView new];
    tabBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tabBarView];
    tabBarView.frame = CGRectMake(0, SCREEN_HEIGHT - NAV_HEIGHT - kServerBtnWidth, SCREEN_WIDTH, kServerBtnWidth);
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [tabBarView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    for (int i = 0 ; i < 4; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(20 + (IPHONE4S_LESS ? (SCREEN_WIDTH - 40 ) / 4 : kServerBtnWidth) * i, 0, (IPHONE4S_LESS ? (SCREEN_WIDTH - 40 ) / 4 : kServerBtnWidth), kServerBtnWidth);
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
                [optionBtn setTitle:@"我的练习" forState:UIControlStateNormal];
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

#pragma mark - PublicMethod

-(void)reloadContentView:(NSArray *)dataArr withCellDataArr:(NSArray *)cellDataArr
{
    _scoreDataArr = [NSMutableArray arrayWithArray:dataArr];
    _cellDataArr = [NSMutableArray arrayWithArray:cellDataArr];
    
    [self initView];
    [self initTabBar];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellDataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180 ;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    NSDictionary * dic;
//    dic = banksDataArr[0];
//    ZEPULHomeQuestionBankModel * _bankModel =[ZEPULHomeQuestionBankModel getDetailWithDic:dic];
    
    UIView * achiView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 140)];
    [self addSubview:achiView];
    achiView.backgroundColor = MAIN_LINE_COLOR;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [achiView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    for(int i = 0 ; i < _scoreDataArr.count ; i++){
        
        NSDictionary * dic = _scoreDataArr[i];
        
        UIView * backgroundView= [[UIView alloc]initWithFrame:CGRectMake(0 + SCREEN_WIDTH / 2 * i, 0, SCREEN_WIDTH / 2, 180)];
        [achiView addSubview:backgroundView];
        
        UILabel * textLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, backgroundView.frame.size.width - 20, 30)];
        textLab.textColor = MAIN_TITLEBLACK_COLOR;
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        textLab.text = dic[@"autevalname"];

        [backgroundView addSubview:textLab];
        
//        HcdProcessView *customView = [[HcdProcessView alloc] initWithFrame:
//                                      CGRectMake((IPHONE5 ? 30 : 50), 50, (IPHONE5 ? 70 : 100), (IPHONE5 ? 70 : 100))];
//        customView.percent = 0.6;
//        customView.showBgLineView = YES;
//
//        [backgroundView addSubview:customView];

        
        ZEManageCircle * _circleView = [[ZEManageCircle alloc] initWithFrame:CGRectMake((IPHONE5 ? 30 : 50), 50, (IPHONE5 ? 70 : 100), (IPHONE5 ? 70 : 100)) lineWidth:(IPHONE5 ? 3 : 4)];
        if (IPHONE4S_LESS) {
            _circleView = [[ZEManageCircle alloc] initWithFrame:CGRectMake(30, 45, 70, 70) lineWidth:3 ];
        }
        _circleView.centerX = backgroundView.frame.size.width / 2;
        [backgroundView addSubview:_circleView];
        if(i == 0){
            _circleView.score = [dic[@"score"] floatValue] ;
        }else{
            _circleView.progress = [dic[@"score"] floatValue] / 100 ;
        }
    }
    
    return achiView;
}

#pragma mark - changeDetailOrComment

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = MAIN_LINE_COLOR;
    
    [self initUI:cell.contentView withIndexpath:indexPath];
    
    return cell;
}

-(void)initUI:(UIView *)cellView withIndexpath:(NSIndexPath *)indexpath
{
    UIView * backgroundView = [UIView new];
    backgroundView.frame = CGRectMake(10,0, SCREEN_WIDTH - 20, 90);
    [cellView addSubview:backgroundView];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.clipsToBounds = YES;
    backgroundView.layer.cornerRadius = 5;
    
    UIImageView * iconImageView = [UIImageView new];
    iconImageView.frame = CGRectMake(10, 40, 30, 30);
    [backgroundView addSubview:iconImageView];
    iconImageView.centerY = backgroundView.height / 2;
    
    UILabel * contentLab = [UILabel new];
    contentLab.frame = CGRectMake(iconImageView.right + 10, 15, backgroundView.width - 70, 30);
    [backgroundView addSubview:contentLab];
    contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    contentLab.textColor = kTextColor;
    
    UILabel * subContentLab = [UILabel new];
    subContentLab.frame = CGRectMake(iconImageView.right + 10, contentLab.bottom , backgroundView.width - 70, 30);
    [backgroundView addSubview:subContentLab];
    subContentLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    subContentLab.textColor = kSubTitleColor;
    
    UIImageView * arrowImageView = [UIImageView new];
    arrowImageView.frame = CGRectMake(backgroundView.width - 40, 40, 25, 25);
    [backgroundView addSubview:arrowImageView];
    arrowImageView.centerY = backgroundView.height / 2;
    [arrowImageView setImage:[UIImage imageNamed:@"icon_manager_arrow"]];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSDictionary * dic = _cellDataArr[indexpath.row];
    
    contentLab.text = [dic objectForKey:@"FUNCTIONNAME"];
    subContentLab.text = [dic objectForKey:@"ACTIONURL"];
    NSString * fileURL = [dic objectForKey:@"FUNCTIONURL"];
    [iconImageView sd_setImageWithURL:ZENITH_IMAGEURL([[fileURL stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"\\"]) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic;
    if (_scoreDataArr.count>0) {
        dic = _scoreDataArr[0];
    }
    NSDictionary * functionDic = _cellDataArr[indexPath.row];
    NSString * functionCode = [functionDic objectForKey:@"FUNCTIONCODE"];

    if ([functionCode isEqualToString:@"emc1"]) {
        if ([self.delegate respondsToSelector:@selector(goManagerBank:withIndex:)]) {
            [self.delegate goManagerBank:dic withIndex:0];
        }
    }else if ([functionCode isEqualToString:@"emc2"]) {
        if ([self.delegate respondsToSelector:@selector(goManagerBank:withIndex:)]) {
            [self.delegate goManagerBank:dic withIndex:1];
        }
    }else if ([functionCode isEqualToString:@"emc3"]) {
        if ([self.delegate respondsToSelector:@selector(goManagerBank:withIndex:)]) {
            [self.delegate goManagerBank:dic withIndex:2];
        }
    }else if ([functionCode isEqualToString:@"emc4"]) {
        if ([self.delegate respondsToSelector:@selector(goManagerBank:withIndex:)]) {
            [self.delegate goManagerBank:dic withIndex:3];
        }
    }else if ([functionCode isEqualToString:@"emc5"]) {
        if ([self.delegate respondsToSelector:@selector(goManagerBank:withIndex:)]) {
            [self.delegate goManagerBank:dic withIndex:4];
        }
    }else if ([functionCode isEqualToString:@"emc6"]) {
        if ([self.delegate respondsToSelector:@selector(goManagerBank:withIndex:)]) {
            [self.delegate goManagerBank:dic withIndex:5];
        }
    }else if ([functionCode isEqualToString:@"emc7"]) {
        if ([self.delegate respondsToSelector:@selector(goTKLL:)]) {
            [self.delegate goManagerBank:dic withIndex:6];
        }
    }else if ([functionCode isEqualToString:@"xxkj"]) {
        if ([self.delegate respondsToSelector:@selector(goStudyCourse:)]) {
            [self.delegate goStudyCourse:@""];
        }
    }
}

-(void)goQuestionBankWebView:(UIButton *)btn
{
    NSDictionary * dic;
    if (_scoreDataArr.count>0) {
        dic = _scoreDataArr[0];
    }
    if ([self.delegate respondsToSelector:@selector(goManagerBank:withIndex:)]) {
        [self.delegate goManagerBank:dic withIndex:btn.tag];
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

