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
#define kContentViewHeight      (SCREEN_HEIGHT - NAV_HEIGHT - 40 - kServerBtnWidth)

#import "ZEManagerPracticeBankView.h"
#import "ZEButton.h"
#import "ZEPULHomeModel.h"

@implementation ZEManagerPracticeBankView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)initView
{
    _contentScrollView = [[UIScrollView alloc]init];
    [self addSubview:_contentScrollView];
    _contentScrollView.left = kContentViewMarginLeft;
    _contentScrollView.top = kContentViewMarginTop;
    _contentScrollView.size = CGSizeMake(kContentViewWidth, kContentHeight);
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * banksDataArr.count, kContentHeight);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    
    for (int i = 0; i < banksDataArr.count; i ++) {
        UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        [_contentScrollView addSubview:contentTableView];
        contentTableView.showsVerticalScrollIndicator = NO;
        contentTableView.frame = CGRectMake(kContentViewMarginLeft + SCREEN_WIDTH * i, 0, kContentViewWidth, kContentViewHeight);
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.tag = 100 + i;
        
//        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNewestData:)];
//        contentTableView.mj_header = header;
    }

    //    MJRefreshHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    //    _contentView.mj_header = header;
    
    _navScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 40)];
    [self addSubview:_navScrollView];
    _navScrollView.contentSize = CGSizeMake(SCREEN_WIDTH / 3 * banksDataArr.count, 40);
    
    for (int i = 0; i < banksDataArr.count; i ++) {
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(SCREEN_WIDTH / 3 * i , 0 , SCREEN_WIDTH / 3 , 40);
        [_navScrollView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 500;
        ZEPULHomeQuestionBankModel * bankModel = [ZEPULHomeQuestionBankModel getDetailWithDic:banksDataArr[i]];
        [optionBtn setTitle:bankModel.module_name forState:UIControlStateNormal];

        if (i == 0) {
            UIView * underBtnLineView = [UIView new];
            underBtnLineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/6, 2);
            underBtnLineView.backgroundColor = MAIN_NAV_COLOR;
            underBtnLineView.tag = 1000;
            [_navScrollView addSubview:underBtnLineView];
            [optionBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
            underBtnLineView.centerX = optionBtn.centerX;
            underBtnLineView.centerY = optionBtn.bottom - 1;
        }
    }
}

-(void)initTabBar
{
    UIView * tabBarView = [UIView new];
    tabBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tabBarView];
    tabBarView.frame = CGRectMake(0, SCREEN_HEIGHT - kServerBtnWidth, SCREEN_WIDTH, kServerBtnWidth);
    
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
    banksDataArr = [NSMutableArray arrayWithArray:dataArr];
    _cellDataArr = [NSMutableArray arrayWithArray:cellDataArr];
    
    [self initView];
    [self initTabBar];

//    UITableView * currentTableView = [_contentScrollView viewWithTag:_currentContentType + 100];
//    [currentTableView reloadData];
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
    UIView * bgView = [UIView new];
    
    NSDictionary * dic;
    switch (_currentContentType) {
        case CONTENT_TYPE_BASE:
            if (banksDataArr.count > 0) {
                dic = banksDataArr[0];
            }
            break;
            
        case CONTENT_TYPE_PROMOTION:
            if (banksDataArr.count > 1) {
                dic = banksDataArr[1];
            }
            break;

        case CONTENT_TYPE_EXCELLENT:
            if (banksDataArr.count > 2) {
                dic = banksDataArr[2];
            }
            break;

        default:
            break;
    }
    ZEPULHomeQuestionBankModel * _bankModel =[ZEPULHomeQuestionBankModel getDetailWithDic:dic];
    
    UIView * achiView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 140)];
    [self addSubview:achiView];
    achiView.backgroundColor = MAIN_LINE_COLOR;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    [achiView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UILabel * textLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 20)];
    textLab.textColor = MAIN_TITLEBLACK_COLOR;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.text = @"正确率统计";
    [achiView addSubview:textLab];
    
    _circle = [[ZEManageCircle alloc] initWithFrame:CGRectMake((IPHONE5 ? 30 : 50), 40, (IPHONE5 ? 70 : 100), (IPHONE5 ? 70 : 100)) lineWidth:(IPHONE5 ? 3 : 4)];
    if (IPHONE4S_LESS) {
        _circle = [[ZEManageCircle alloc] initWithFrame:CGRectMake(30, 35, 70, 70) lineWidth:3 ];
    }
    _circle.centerX = SCREEN_WIDTH / 2;
    [achiView addSubview:_circle];
    _circle.progress = [_bankModel.right_rate floatValue] / 100;
    
    for (int i = 0; i < 2; i ++) {
        UILabel * textLab = [UILabel new];
        textLab.numberOfLines = 2;
        textLab.frame = CGRectMake(20 ,_circle.top , (SCREEN_WIDTH - 40 -_circle.width) / 2, _circle.height);
        [achiView addSubview:textLab];
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        textLab.textColor = MAIN_TITLEBLACK_COLOR;
        switch (i) {
            case 0:{
                textLab.text = @"总时长     0h";
                textLab.text = [NSString stringWithFormat:@"%.2fh\n总时长",[_bankModel.time_pass floatValue] / 3600];
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textLab.text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:6];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textLab.text length])];
                textLab.attributedText = attributedString;
            }
                break;
                
            case 1:
            {
                textLab.left = _circle.right;
                textLab.text = @"刷题数     0";
                textLab.text = [NSString stringWithFormat:@"%lld\n刷题数",[_bankModel.done_num longLongValue]];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textLab.text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:6];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textLab.text length])];
                textLab.attributedText = attributedString;
            }
                break;
                
            default:
                break;
        }
        textLab.textAlignment = NSTextAlignmentCenter;

    }
    
    UILabel * subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, _circle.bottom + 10, SCREEN_WIDTH - 40, 20)];
    subTitleLab.textColor = MAIN_TITLEBLACK_COLOR;
    subTitleLab.textAlignment = NSTextAlignmentCenter;
    subTitleLab.font = [UIFont systemFontOfSize:14];
    subTitleLab.text = @"你这么厉害，你家人知道吗？";
    [achiView addSubview:subTitleLab];

    
    return achiView;
}

#pragma mark - changeDetailOrComment

-(void)changeContent:(UIButton *)btn
{
    UIView * underBtnLineView = [self viewWithTag:1000];
    underBtnLineView.centerX = btn.centerX;
    [_navScrollView bringSubviewToFront:underBtnLineView];

    for (int i = 0; i < banksDataArr.count; i ++) {
        UIButton * button = [_navScrollView viewWithTag:500 + i];
        [button setTitleColor:kTextColor forState:UIControlStateNormal];
    }
    [btn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];

    _contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * (btn.tag - 500), 0);
    
    _currentContentType = btn.tag - 500;
    UITableView * contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentContentType];
    [contentView reloadData];
    
//    if([self.delegate respondsToSelector:@selector(loadNewData:)]){
//        [self.delegate loadNewData:_currentHomeContent];
//    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_contentScrollView]) {
        NSInteger currentIndex = 0;
        currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        _currentContentType = currentIndex;
        UITableView * contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentContentType];
        [contentView reloadData];
        
        
        for (int i = 0; i < banksDataArr.count; i ++) {
            UIButton * button = [_navScrollView viewWithTag:500 + i];
            [button setTitleColor:kTextColor forState:UIControlStateNormal];
            if (currentIndex == i) {
                [button setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
                UIView * underBtnLineView = [self viewWithTag:1000];
                underBtnLineView.centerX = button.centerX;
                underBtnLineView.centerY = button.bottom - 1;
                [_navScrollView bringSubviewToFront:underBtnLineView];
            }
        }

//        if([self.delegate respondsToSelector:@selector(loadNewData:)]){
//            [self.delegate loadNewData:_currentHomeContent];
//        }
    }
}


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

    
//    switch (indexpath.row) {
//        case 0:
//            contentLab.text = @"每日激战，争榜首";
//            subContentLab.text = @"今日已有3人参战";
//            [iconImageView setImage:[UIImage imageNamed:@"icon_manager_dailyPra"]];
//            break;
//        case 1:
//            contentLab.text = @"章节练习";
//            subContentLab.text = @"今日已有3人参战";
//            [iconImageView setImage:[UIImage imageNamed:@"icon_manager_chapter"]];
//
//            break;
//        case 2:
//            contentLab.text = @"模拟考试";
//            subContentLab.text = @"来战一场,看看自己的实力";
//            [iconImageView setImage:[UIImage imageNamed:@"icon_manager_test"]];
//            break;
//        case 3:
//            contentLab.text = @"随机练习";
//            subContentLab.text = @"来战一场,看看自己的实力";
//            [iconImageView setImage:[UIImage imageNamed:@"icon_manager_arcdom"]];
//            break;
//        case 4:
//            contentLab.text = @"难题攻克";
//            subContentLab.text = @"来战一场,看看自己的实力";
//            [iconImageView setImage:[UIImage imageNamed:@"icon_manager_diff"]];
//            break;
//        case 5:
//            contentLab.text = @"实操规范";
//            subContentLab.text = @"来战一场,看看自己的实力";
//            [iconImageView setImage:[UIImage imageNamed:@"icon_manager_stand"]];
//            break;
//
//        default:
//            break;
//    }

}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic;
    switch (_currentContentType) {
        case CONTENT_TYPE_BASE:
            if (banksDataArr.count > 0) {
                dic = banksDataArr[0];
            }
            break;
            
        case CONTENT_TYPE_PROMOTION:
            if (banksDataArr.count > 1) {
                dic = banksDataArr[1];
            }
            break;
            
        case CONTENT_TYPE_EXCELLENT:
            if (banksDataArr.count > 2) {
                dic = banksDataArr[2];
            }
            break;
            
        default:
            break;
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
    }
}

-(void)goQuestionBankWebView:(UIButton *)btn
{
    NSDictionary * dic;
    switch (_currentContentType) {
        case CONTENT_TYPE_BASE:
            if (banksDataArr.count > 0) {
                dic = banksDataArr[0];
            }
            break;
            
        case CONTENT_TYPE_PROMOTION:
            if (banksDataArr.count > 1) {
                dic = banksDataArr[1];
            }
            break;
            
        case CONTENT_TYPE_EXCELLENT:
            if (banksDataArr.count > 2) {
                dic = banksDataArr[2];
            }
            break;
            
        default:
            break;
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
