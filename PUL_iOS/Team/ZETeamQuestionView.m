//
//  ZEHomeView.m
//  PUL_iOS
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#define kTypeScrollViewTag 1000    //  分类列表
#define kContentSrollViewTag 2017 // 内容列表

#define kTypeScrollLabTag 1008    //  分类列表的文字
#define kTypeScrollLineImageTag 1999  // 下划线

#define kPracticeWebViewTag 1994

#define kQuestionTitleFontSize      kTiltlFontSize
#define kQuestionSubTitleFontSize   kSubTiltlFontSize

#define kHomeMarkFontSize       16.0f
#define kHomeTitleFontSize      kTiltlFontSize
#define kHomeSubTitleFontSize   kSubTiltlFontSize

#define kNavBarMarginLeft   0.0f
#define kNavBarMarginTop    0.0f
#define kNavBarWidth        SCREEN_WIDTH

#define kContentMarginTop  (64.0f + SCREEN_WIDTH / 4 + _maskImageHeight)

#define kLabelScrollViewMarginTop  0.0f

// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 15.0f
#define kLeftButtonMarginTop 20.0f + 2.0f

#define kSearchTFMarginLeft   70.0f
#define kSearchTFMarginTop    27.0f
#define kSearchTFWidth        SCREEN_WIDTH - 90.0f
#define kSearchTFHeight       30.0f

#define kTypicalViewMarginLeft  0.0f
#define kTypicalViewMarginTop   0.0f
#define kTypicalViewWidth       SCREEN_WIDTH
#define kTypicalViewHeight      135.0f

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   35.0f
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      (SCREEN_HEIGHT - NAV_HEIGHT - kContentTableMarginTop)

#import "ZETeamQuestionView.h"
#import "PYPhotoBrowser.h"
#import "ZEKLB_CLASSICCASE_INFOModel.h"
#import "ZEButton.h"

@interface ZETeamQuestionView ()
{
    UITextField * searchTF;
    
    UIView * optionView;  // 团队不同功能选项按钮
    
    UIView * questionView; // 问一问界面
    UIView * practiceView; // 练一练界面
    UIView * rankingListView; // 比一比界面
    
    TEAM_VIEW _currentTeamShowView;
    
    YYAnimatedImageView * gifImageView;  //  GIF 动态
    
    NSArray * _allTypeArr;
    NSArray * _allCompareTypeArr;
    NSArray * _allPracticeTypeArr;
    
    float _historyY;
    
    NSInteger _currentHomeContentPage; // 当前显示的页面 0 你问我答 1 指定回答 2已采纳 3我的问题
    NSInteger _currentRankingListPage; // 当前显示的页面 0 提问榜 1 回答榜
    NSInteger _currentPracticePage; // 当前显示的页面 0 提问榜 1 回答榜
    
    NSInteger  _currentAskYearMonth;  // 当前选择的提问榜的月份
    NSInteger  _currentAnswerYearMonth;  // 当前选择的提问榜的月份
    
    BOOL _isPractice; // 是否正在练习界面
    
    TEAM_WILL_SHOWVIEW _willShowView;
    
    float _maskImageHeight;
    
    UILabel * _currentSelectMonthLab; //  比一比  选中的当前月份
    
    NSString * _yearMonthStr;
}

@property (nonatomic,strong) NSMutableArray * newestQuestionArr; //   最新

@property (nonatomic,strong) NSMutableArray * targetQuestionArr;  //  你问我答

@property (nonatomic,strong) NSMutableArray * solvedQuestionArr;  //  已解决

@property (nonatomic,strong) NSMutableArray * myQuestionArr;  //  我的问题


@property (nonatomic,strong) NSMutableArray * askRankingListArr;  //  提问榜

@property (nonatomic,strong) NSMutableArray * answerRankingListArr;  //  回答榜

@end

@implementation ZETeamQuestionView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _allTypeArr = @[@"我来挑战",@"你问我答",@"已解决",@"我的问题"];
    _allCompareTypeArr = @[@"提问榜",@"回答榜"];
    _allPracticeTypeArr = @[@"每日一练",@"团队测试"];
    _currentHomeContentPage = TEAM_CONTENT_NEWEST;
    _currentRankingListPage = TEAM_RANKING_ASK;
    
    [self initOptionView];

    questionView = [UIView new];
    [self addSubview:questionView];
    questionView.frame = CGRectMake(0, kContentMarginTop, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    practiceView = [UIView new];
    [self addSubview:practiceView];
    practiceView.frame = CGRectMake(0, kContentMarginTop, SCREEN_WIDTH, SCREEN_HEIGHT);

    rankingListView = [UIView new];
    [self addSubview:rankingListView];
    rankingListView.frame = CGRectMake(0, kContentMarginTop, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self initQuestionView];
    [self initRankingListView];
    [self initPracticeView];
    
    _currentTeamShowView = TEAM_VIEW_QUESTION;
    practiceView.hidden = YES;
    rankingListView.hidden = YES;
}

#pragma mark - 四个选项按钮

-(void)initOptionView
{
    UIImage * pointImage =  [UIImage imageNamed:@"yy_pointer.png"];
    float asp = pointImage.size.width / pointImage.size.height;
    float imageHeight = SCREEN_WIDTH / 4 / asp;
    _maskImageHeight = imageHeight;
    
    optionView = [UIView new];
    [self addSubview:optionView];
    optionView.left = 0.0;
    optionView.top = NAV_HEIGHT;
    optionView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / 4 + imageHeight );
    
    for (int i = 0 ; i < 4; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(SCREEN_WIDTH / 4 * i, 0, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
        [optionView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 200;
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        [optionBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateSelected];
        
        switch (i) {
            case 0:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_wyw"] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_wyw-_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"问一问" forState:UIControlStateNormal];
                break;
            case 1:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_lyl" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_lyl_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"练一练" forState:UIControlStateNormal];
                break;
            case 2:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_byb" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_byb_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"比一比" forState:UIControlStateNormal];
                break;
            case 3:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_nn" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_nn1_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"聊一聊" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        if (i == 0) {
            [optionBtn setSelected:YES];
        }
    }
    
    UIImageView * mobileLineView = [UIImageView new];
    mobileLineView.frame = CGRectMake(0, SCREEN_WIDTH / 4 - 10 , SCREEN_WIDTH / 4, imageHeight);
    mobileLineView.tag = 100;
    [optionView addSubview:mobileLineView];
    mobileLineView.image = pointImage;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBA(245, 245, 245, 1).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, SCREEN_WIDTH / 4 + imageHeight - 12, SCREEN_WIDTH, 10);
    [optionView.layer addSublayer:gradientLayer];
}

#pragma mark - 创建问一问界面

-(void)initQuestionView
{
    [questionView addSubview:[self createDetailOptionView:_allTypeArr]];
    
    UIScrollView * _contentScrollView = [[UIScrollView alloc]init];
    [questionView addSubview:_contentScrollView];
    _contentScrollView.left = kContentTableMarginLeft;
    _contentScrollView.top = kContentTableMarginTop;
    _contentScrollView.size = CGSizeMake(kContentTableWidth, kContentTableHeight);
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _allTypeArr.count, kContentTableHeight);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.contentOffset = CGPointMake(100, 100);
    _contentScrollView.tag = kContentSrollViewTag;

    for (int i = 0; i < _allTypeArr.count; i ++) {
        UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        [_contentScrollView addSubview:contentTableView];
        contentTableView.showsVerticalScrollIndicator = NO;
        contentTableView.frame = CGRectMake(kContentTableMarginLeft + SCREEN_WIDTH * i, 0, kContentTableWidth, kContentTableHeight);
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.tag = 100 + i;
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNewestData:)];
        contentTableView.mj_header = header;
    }
}

-(void)initRankingListView
{
    [rankingListView addSubview:[self createDetailOptionView:_allCompareTypeArr]];
    
    UIView * headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 35.0f, SCREEN_WIDTH, 50.0f);
        NSString * monthStr =  [ZEUtil getCurrentDate:@"MM"];
        for (int i = 1; i < 7; i ++) {
            UIButton * monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [monthBtn addTarget:self action:@selector(chooseMonthRankingList:) forControlEvents:UIControlEventTouchUpInside];
            monthBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - (SCREEN_WIDTH - 20) / 6 * i, 0, (SCREEN_WIDTH - 20) / 6, 50);
            [headerView addSubview:monthBtn];
            
            UILabel * monthLab = [[UILabel alloc]init];
            monthLab.frame = CGRectMake(0, 0, 40, 40);
            monthLab.center = CGPointMake(monthBtn.width / 2, monthBtn.height / 2);
            monthLab.textAlignment = NSTextAlignmentCenter;
            monthLab.textColor = kTextColor;
            monthLab.font = [UIFont systemFontOfSize:12];
            [monthBtn addSubview:monthLab];
            monthLab.tag = 13;
            
            if ([monthStr integerValue] > 5) {
                monthBtn.tag = [monthStr integerValue] - i + 1;
                monthLab.text = [self getMonthStringWithIndex:[monthStr integerValue] - i + 1];
            }else {
                monthLab.text = [self getMonthStringWithIndex:[monthStr integerValue] - i + 1];
                monthBtn.tag = [monthStr integerValue] - i + 1;
                if ([monthStr integerValue] - i + 1 <= 0) {
                    monthBtn.tag = [monthStr integerValue] - i + 13;
                    monthLab.text = [self getMonthStringWithIndex:[monthStr integerValue] - i + 13];
                }
            }
            
            if (_currentAskYearMonth == monthBtn.tag && _currentRankingListPage == TEAM_RANKING_ASK) {
                NSLog(@"===============TEAM_RANKING_ASK================");
                _currentSelectMonthLab = monthLab;
                
                monthLab.clipsToBounds = YES;
                monthLab.layer.cornerRadius = monthLab.height / 2;
                monthLab.layer.borderColor = [MAIN_NAV_COLOR CGColor];
                monthLab.layer.borderWidth = 2;
            }else if(_currentAnswerYearMonth == monthBtn.tag && _currentRankingListPage == TEAM_RANKING_ANSWER){
                NSLog(@"===============TEAM_RANKING_ANSWER================");
                _currentSelectMonthLab = monthLab;
                
                monthLab.clipsToBounds = YES;
                monthLab.layer.cornerRadius = monthLab.height / 2;
                monthLab.layer.borderColor = [MAIN_NAV_COLOR CGColor];
                monthLab.layer.borderWidth = 2;
            }else if( i == 1){
                _currentSelectMonthLab = monthLab;
                
                monthLab.clipsToBounds = YES;
                monthLab.layer.cornerRadius = monthLab.height / 2;
                monthLab.layer.borderColor = [MAIN_NAV_COLOR CGColor];
                monthLab.layer.borderWidth = 2;
            }
            
        }
    
    [rankingListView addSubview:headerView];
    
    UIScrollView * _contentScrollView = [[UIScrollView alloc]init];
    [rankingListView addSubview:_contentScrollView];
    _contentScrollView.left = kContentTableMarginLeft;
    _contentScrollView.top = kContentTableMarginTop + headerView.height;
    _contentScrollView.size = CGSizeMake(kContentTableWidth, SCREEN_HEIGHT - kContentMarginTop - 85.0f - 20.0f);
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _allCompareTypeArr.count, SCREEN_HEIGHT - kContentMarginTop - 85.0f - 20.0f);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.contentOffset = CGPointMake(0, 0);
    _contentScrollView.tag = kContentSrollViewTag;
    
    for (int i = 0; i < _allCompareTypeArr.count; i ++) {
        UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        [_contentScrollView addSubview:contentTableView];
        contentTableView.showsVerticalScrollIndicator = NO;
        contentTableView.frame = CGRectMake(kContentTableMarginLeft + SCREEN_WIDTH * i, 0, kContentTableWidth, SCREEN_HEIGHT - NAV_HEIGHT - 85.0f);
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.tag = 100 + i;
//        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewRankingData:)];
//        contentTableView.mj_header = header;
    }
}

#pragma mark - 练一练界面

-(void)initPracticeView
{
//    [practiceView addSubview:[self createDetailOptionView:_allPracticeTypeArr]];
    
    WKWebView * web = [[WKWebView alloc]initWithFrame:CGRectMake(0,0.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - SCREEN_WIDTH/ 4)];
    web.tag = kPracticeWebViewTag;
    [practiceView addSubview:web];
//    web.UIDelegate = self;
    web.scrollView.delegate = self;
    web.navigationDelegate = self;
    
}

#pragma mark - 子分类选项滑动

-(UIView *)createDetailOptionView:(NSArray *)arr
{
    UIScrollView * _labelScrollView = [[UIScrollView alloc]init];
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.left = 0.0f;
    _labelScrollView.top = kLabelScrollViewMarginTop;
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.height = 35.0f;
    _labelScrollView.tag = kTypeScrollViewTag;
    
    UIImageView * _lineImageView = [[UIImageView alloc]init];
    _lineImageView.frame = CGRectMake(0, 33.0f, SCREEN_WIDTH / arr.count, 2.0f);
    _lineImageView.backgroundColor = MAIN_GREEN_COLOR;
    [_labelScrollView addSubview:_lineImageView];
    _lineImageView.tag = kTypeScrollLineImageTag;
    
    float marginLeft = 0;
    
    for (int i = 0 ; i < arr.count; i ++) {
        UIButton * labelContentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        labelContentBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [_labelScrollView addSubview:labelContentBtn];
        [labelContentBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        if(i == 0){
            [labelContentBtn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
        }
        labelContentBtn.top = 0.0f;
        labelContentBtn.height = 33.0f;
        [labelContentBtn setTitle:arr[i] forState:UIControlStateNormal];
        [labelContentBtn addTarget:self action:@selector(selectDifferentType:) forControlEvents:UIControlEventTouchUpInside];
        labelContentBtn.tag = 100 + i;
        labelContentBtn.width = SCREEN_WIDTH / arr.count;
        labelContentBtn.left = marginLeft;
        
        marginLeft += labelContentBtn.width;
    }
    
    return _labelScrollView;
}

#pragma mark - 选择不同选项 比一比 练一练等

-(void)didSelectMyOption:(UIButton *)btn
{
    _willShowView = btn.tag - 200;

    if(_isPractice){
        [self showWebViewAlert];
        return;
    }
    
    if (btn.tag == 203) {
        _willShowView = TEAM_WILL_SHOWVIEW_CHAT;
        if ([self.delegate respondsToSelector:@selector(goTeamChatRoom)]) {
            [self.delegate goTeamChatRoom];
        }
        return;
    }

    UIImageView * maskImageView = [optionView viewWithTag:100];
    
    for (int i = 0; i < optionView.subviews.count; i ++ ) {
        id obj = optionView.subviews[i];
        if ([obj isKindOfClass:[ZEButton class]]) {
            ZEButton * button = (ZEButton *) obj;
            if (i + 200 == btn.tag) {
                maskImageView.centerX = button.centerX;
                [button setSelected:YES];
            }else{
                [button setSelected:NO];
            }
        }
    }
    
    if (btn.tag == 200) {
        [self showQuestionView];
    }else if(btn.tag == 201){
        [self showPracticeView];
    }else if (btn.tag == 202){
        [self showRankingList];
        
        if (_yearMonthStr.length > 0 ) {
            if ([self.delegate respondsToSelector:@selector(selectMonthStr:)]) {
                [self.delegate selectMonthStr:_yearMonthStr];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(selectMonthStr:)]) {
                [self.delegate selectMonthStr:[ZEUtil getCurrentDate:@"yyyyMM"]];
            }
        }
        
    }
    
}
-(void)showQuestionView
{
    _currentTeamShowView = TEAM_VIEW_QUESTION;
    if (!rankingListView.hidden) {
        rankingListView.hidden = YES;
    }
    if (!practiceView.hidden) {
        practiceView.hidden = YES;
    }
    questionView.hidden = NO;
}

-(void)showRankingList
{
    _currentTeamShowView = TEAM_VIEW_RANKINGLIST;
    if (!questionView.hidden) {
        questionView.hidden = YES;
    }
    if (!practiceView.hidden) {
        practiceView.hidden = YES;
    }
    rankingListView.hidden = NO;
    if (_currentTeamShowView == TEAM_RANKING_ANSWER) {
        [self reloadTeamViewRankingList:self.answerRankingListArr withRankingContent:_currentRankingListPage];
    }else if (_currentRankingListPage == TEAM_RANKING_ASK){
        [self reloadTeamViewRankingList:self.askRankingListArr withRankingContent:_currentRankingListPage];
    }
}

-(void)showPracticeView
{
    _currentTeamShowView = TEAM_VIEW_PRACTICE;
    if (!questionView.hidden) {
        questionView.hidden = YES;
    }
    if (!rankingListView.hidden) {
        rankingListView.hidden = YES;
    }
    practiceView.hidden = NO;
    [self refreshPracticeWebView];
}

#pragma mark - 选择上方分类

-(void)selectDifferentType:(UIButton *)btn
{
    UIScrollView *_typeScrollView;
    UIScrollView *_contentScrollView;
    NSArray * typeArr;
    UIImageView * _lineImageView;
    
    if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
        _currentHomeContentPage = btn.tag - 100;
        _typeScrollView = [questionView viewWithTag:kTypeScrollViewTag];
        _contentScrollView = [questionView viewWithTag:kContentSrollViewTag];
        typeArr = _allTypeArr;
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        _typeScrollView = [rankingListView viewWithTag:kTypeScrollViewTag];
        _contentScrollView = [rankingListView viewWithTag:kContentSrollViewTag];
        typeArr = _allCompareTypeArr;
    }else if (_currentTeamShowView == TEAM_VIEW_PRACTICE){
        _typeScrollView = [practiceView viewWithTag:kTypeScrollViewTag];
        typeArr = _allPracticeTypeArr;
        _currentPracticePage = btn.tag - 100;
        WKWebView * web = [practiceView viewWithTag:kPracticeWebViewTag];
        switch (btn.tag) {
            case 100:
                [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
                break;
            case 101:
                [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://blog.csdn.net/iosworker/article/details/50833531"]]];
                break;
            default:
                break;
        }
    }
    _lineImageView = [_typeScrollView viewWithTag:kTypeScrollLineImageTag];

    if(_currentTeamShowView != TEAM_VIEW_PRACTICE){
        UITableView * contentView;
        if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
            _currentHomeContentPage = btn.tag - 100;
            contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentHomeContentPage];
        }
        else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST) {
            _currentRankingListPage = btn.tag - 100;
            contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentRankingListPage];
        }
        [contentView reloadData];
    }
    
    float marginLeft = 0;
    for (int i = 0 ; i < typeArr.count; i ++) {
        UIButton * button = [btn.superview viewWithTag:100 + i];
        [button setTitleColor:kTextColor forState:UIControlStateNormal];
        float btnWidth = SCREEN_WIDTH / typeArr.count;
        if (btn.tag - 100 == i) {
            [UIView animateWithDuration:0.35 animations:^{
                _lineImageView.frame = CGRectMake(marginLeft, 33.0f, btnWidth, 2.0f);
                if(_currentTeamShowView != TEAM_VIEW_PRACTICE) {
                    _contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * i, 0);
                }
            }];
        }
        marginLeft += btnWidth;
    }
    [btn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];

    if ([self.delegate respondsToSelector:@selector(loadNewData:)]) {
        [self.delegate loadNewData:_currentHomeContentPage];
    }
    
}

#pragma mark - 显示建设中页面

-(void)showBuildingView:(UIView *)superView
{
    if (!gifImageView) {
        gifImageView = [YYAnimatedImageView new];
        [superView addSubview:gifImageView];
        gifImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        gifImageView.center = CGPointMake(superView.centerX, superView.centerY + 30);
        NSURL *path = [[NSBundle mainBundle]URLForResource:@"building" withExtension:@"gif"];
        gifImageView.imageURL = path;
        gifImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel * tipLab = [UILabel new];
        tipLab.frame = CGRectMake(0, SCREEN_HEIGHT - 110, SCREEN_WIDTH, 40);
        tipLab.text = @"功能建设中,敬请期待!";
        tipLab.textColor = kTextColor;
        tipLab.font = [UIFont boldSystemFontOfSize:20];
        [gifImageView addSubview:tipLab];
        [tipLab setTextAlignment:NSTextAlignmentCenter];
        
        [superView sendSubviewToBack:tipLab];
        [superView sendSubviewToBack:gifImageView];
    }else{
        gifImageView.hidden = NO;
    }
}

-(void)hiddenBuildingView
{
    gifImageView.hidden = YES;
}


#pragma mark - Public Method

#pragma mark - 最新页面

/**
 刷新第一页面最新数据
 
 @param dataArr 数据内容
 */
-(void)reloadFirstView:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page;
{
    UITableView * contentTableView;
    
    switch (content_page) {
        case TEAM_CONTENT_NEWEST:
            self.newestQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        case TEAM_CONTENT_TARGETASK:
            self.targetQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        case TEAM_CONTENT_SOLVED:
            self.solvedQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        case TEAM_CONTENT_MYQUESTION:
            self.myQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        default:
            break;
    }
    
    UIScrollView * _contentScrollView;
    if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
       _contentScrollView  = [questionView viewWithTag:kContentSrollViewTag];
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        _contentScrollView  = [rankingListView viewWithTag:kContentSrollViewTag];
    }
    contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        [contentTableView reloadData];
        return;
    }
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    contentTableView.mj_footer = footer;
    
    [contentTableView.mj_header endRefreshingWithCompletionBlock:nil];
    [contentTableView reloadData];
}
/**
 刷新其他页面最新数据
 
 @param dataArr 数据内容
 */

-(void)reloadContentViewWithArr:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page;
{
    UIScrollView * _contentScrollView;
    _contentScrollView  = [questionView viewWithTag:kContentSrollViewTag];

    UITableView * contentTableView;
    
    switch (content_page) {
        case TEAM_CONTENT_NEWEST:
            [self.newestQuestionArr addObjectsFromArray:dataArr];
            break;
        case TEAM_CONTENT_TARGETASK:
            [self.targetQuestionArr addObjectsFromArray:dataArr];
            break;
        case TEAM_CONTENT_SOLVED:
            [self.solvedQuestionArr addObjectsFromArray:dataArr];
            break;
        case TEAM_CONTENT_MYQUESTION:
            [self.myQuestionArr addObjectsFromArray:dataArr];
            break;
        default:
            break;
    }
    contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    
    [contentTableView.mj_header endRefreshing];
    [contentTableView.mj_footer endRefreshing];
    [contentTableView reloadData];
}
-(void)reloadContentViewWithNoMoreData:(NSArray *)dataArr withHomeContent:(TEAM_CONTENT)content_page
{
    
}
/**
 没有更多最新问题数据
 */
-(void)loadNoMoreDataWithHomeContent:(TEAM_CONTENT)content_page;
{
    UIScrollView * _contentScrollView;
    if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
        _contentScrollView  = [questionView viewWithTag:kContentSrollViewTag];
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        _contentScrollView  = [rankingListView viewWithTag:kContentSrollViewTag];
    }

    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_footer endRefreshingWithNoMoreData];
}

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshingWithHomeContent:(TEAM_CONTENT)content_page;
{
    UIScrollView * _contentScrollView;
    if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
        _contentScrollView  = [questionView viewWithTag:kContentSrollViewTag];
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        _contentScrollView  = [rankingListView viewWithTag:kContentSrollViewTag];
    }

    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_header endRefreshing];
}

-(void)endRefreshingWithHomeContent:(TEAM_CONTENT)content_page;
{
    UIScrollView * _contentScrollView;
    if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
        _contentScrollView  = [questionView viewWithTag:kContentSrollViewTag];
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        _contentScrollView  = [rankingListView viewWithTag:kContentSrollViewTag];
    }

    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_footer endRefreshing];
    [contentTableView.mj_header endRefreshing];
}

-(void)scrollContentViewToIndex:(TEAM_CONTENT)toContent
{
    UIScrollView * _contentScrollView;

    _contentScrollView  = [questionView viewWithTag:kContentSrollViewTag];
    _contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * toContent, 0);
    _currentHomeContentPage = toContent;
    [self scrollViewDidEndDecelerating:_contentScrollView];
}
/**
 刷新比一比界面
 */
-(void)reloadTeamViewRankingList:(NSArray *)arr withRankingContent:(TEAM_RANKING)ranking
{
    UIScrollView * _contentScrollView;
    _contentScrollView  = [rankingListView viewWithTag:kContentSrollViewTag];
    
    UITableView * contentTableView;
    
    switch (ranking) {
        case TEAM_RANKING_ASK:
            self.askRankingListArr = [NSMutableArray arrayWithArray:arr];
            break;
        case TEAM_RANKING_ANSWER:
            self.answerRankingListArr = [NSMutableArray arrayWithArray:arr];
            break;
        default:
            break;
    }
    contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + ranking];
    
    [contentTableView.mj_header endRefreshing];
    [contentTableView.mj_footer endRefreshing];
    [contentTableView reloadData];
}

-(void)refreshPracticeWebView
{
    WKWebView * web = [practiceView viewWithTag:kPracticeWebViewTag];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.practiceURL]]];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_currentTeamShowView == TEAM_VIEW_QUESTION){
        switch (_currentHomeContentPage) {
            case TEAM_CONTENT_NEWEST:
                return self.newestQuestionArr.count;
                break;
                
            case TEAM_CONTENT_TARGETASK:
                return self.targetQuestionArr.count;
                break;
                
            case TEAM_CONTENT_SOLVED:
                return self.solvedQuestionArr.count;
                break;
                
            case TEAM_CONTENT_MYQUESTION:
                return self.myQuestionArr.count;
                break;
                
            default:
                break;
        }
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        switch (_currentRankingListPage) {
            case TEAM_RANKING_ASK:
                return self.askRankingListArr.count;
                break;
                
            case TEAM_RANKING_ANSWER:
                return self.answerRankingListArr.count;
                break;
                
            default:
                break;
        }
    }
    return  0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(void)chooseMonthRankingList:(UIButton *)btn
{    
    _currentSelectMonthLab.textColor = kTextColor;
    _currentSelectMonthLab.layer.borderWidth = 0;
    _currentSelectMonthLab.layer.borderColor = [[UIColor clearColor] CGColor];

    _currentSelectMonthLab = (UILabel *)[btn viewWithTag:13];
    _currentSelectMonthLab.clipsToBounds = YES;
    _currentSelectMonthLab.layer.cornerRadius = _currentSelectMonthLab.height / 2;
    _currentSelectMonthLab.textColor = MAIN_NAV_COLOR;
    _currentSelectMonthLab.layer.borderColor = [MAIN_NAV_COLOR CGColor];
    _currentSelectMonthLab.layer.borderWidth = 2;
    
    if (_currentRankingListPage == TEAM_RANKING_ASK) {
        _currentAskYearMonth = btn.tag;
    }else if (_currentRankingListPage == TEAM_RANKING_ANSWER){
        _currentAnswerYearMonth = btn.tag;
    }

    NSString * monthStr =  [ZEUtil getCurrentDate:@"MM"];
    if ([monthStr integerValue] > 5) {
        NSString * yearMonth = @"";
        if ([monthStr integerValue] < 10) {
            yearMonth = [NSString stringWithFormat:@"%@0%ld",[ZEUtil getCurrentDate:@"yyyy"],(long)btn.tag];
        }else{
            yearMonth = [NSString stringWithFormat:@"%@%ld",[ZEUtil getCurrentDate:@"yyyy"],(long)btn.tag];
        }
        _yearMonthStr = yearMonth;
        if([self.delegate respondsToSelector:@selector(selectMonthStr:)]){
            [self.delegate selectMonthStr:yearMonth ];
        }
    }else{
        NSString * yearMonth = @"";
        if(btn.tag > 7 && btn.tag < 10){
            yearMonth = [NSString stringWithFormat:@"%ld0%ld",[[ZEUtil getCurrentDate:@"yyyy"] longValue] - 1,(long)btn.tag];
        }else if (btn.tag > 9){
            yearMonth = [NSString stringWithFormat:@"%ld%ld",[[ZEUtil getCurrentDate:@"yyyy"] longValue] - 1,(long)btn.tag];
        }else{
            yearMonth = [NSString stringWithFormat:@"%@0%ld",[ZEUtil getCurrentDate:@"yyyy"],(long)btn.tag];
        }
        _yearMonthStr = yearMonth;
        
        if([self.delegate respondsToSelector:@selector(selectMonthStr:)]){
            [self.delegate selectMonthStr:yearMonth ];
        }
    }
    
}

-(NSString *)getMonthStringWithIndex:(NSInteger)index
{
    switch (index) {
        case 1:
            return @"一月";
            break;
            
        case 2:
            return @"二月";
            break;

        case 3:
            return @"三月";
            break;

        case 4:
            return @"四月";
            break;

        case 5:
            return @"五月";
            break;

        case 6:
            return @"六月";
            break;

        case 7:
            return @"七月";
            break;

        case 8:
            return @"八月";
            break;

        case 9:
            return @"九月";
            break;

        case 10:
            return @"十月";
            break;
            
        case 11:
            return @"十一月";
            break;

        case 12:
            return @"十二月";
            break;


        default:
            break;
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        return 68;
    }
    
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_TARGETASK:
            datasDic = self.targetQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_SOLVED:
            datasDic = self.solvedQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_MYQUESTION:
            datasDic = self.myQuestionArr[indexPath.row];
            break;
         default:
            break;
    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    if ([quesInfoM.BONUSPOINTS integerValue] > 0) {
        if (quesInfoM.BONUSPOINTS.length == 1) {
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"          %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 2){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"            %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 3){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"              %@",QUESTIONEXPLAINStr];
        }
    }
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kHomeTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    NSArray * typeCodeArr = [quesInfoM.QUESTIONTYPECODE componentsSeparatedByString:@","];
    
    NSString * typeNameContent = @"";
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * questionTypeM = nil;
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        for (int i = 0; i < typeCodeArr.count; i ++) {
            if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                questionTypeM = typeM;
                if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                    typeNameContent = questionTypeM.NAME;
                }else{
                    typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                }
                break;
            }
        }
    }
    // 标签文字过多时会出现两行标签 动态计算标签高度
    float tagHeight = [ZEUtil heightForString:typeNameContent font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 70];
    
    NSString * targetUsernameStr = [NSString stringWithFormat:@"指定人员回答 ：%@",quesInfoM.TARGETUSERNAME];
    float targetUsernameHeight = [ZEUtil heightForString:targetUsernameStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    
    if(quesInfoM.FILEURLARR.count > 0){
        if(_currentHomeContentPage == TEAM_CONTENT_MYQUESTION && quesInfoM.TARGETUSERNAME.length > 0){
            return questionHeight + kCellImgaeHeight + tagHeight + 75.0f + targetUsernameHeight;
        }
        return questionHeight + kCellImgaeHeight + tagHeight + 70.0f;
    }
    
    if(_currentHomeContentPage == TEAM_CONTENT_MYQUESTION && quesInfoM.TARGETUSERNAME.length > 0){
        return questionHeight + tagHeight + 65.0f + targetUsernameHeight;
    }
    return questionHeight + tagHeight + 60.0f;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    if(_currentTeamShowView == TEAM_VIEW_QUESTION){
        [self createAnswerViewWithIndexpath:indexPath withView:cell.contentView] ;
    }else{
        [self cellForRankingListView:indexPath cellView:cell.contentView];
    }
    
    return cell;
}

-(void)cellForRankingListView:(NSIndexPath *)indexPath cellView:(UIView *)cellView
{
    NSDictionary * dic;
    NSString * SUMNUM;
    
    if (_currentRankingListPage == TEAM_RANKING_ASK) {
        dic = self.askRankingListArr[indexPath.row];
        SUMNUM = [dic objectForKey:@"QUESTIONSUM"];
    }else if (_currentRankingListPage == TEAM_RANKING_ANSWER){
        dic = self.answerRankingListArr[indexPath.row];
        SUMNUM = [dic objectForKey:@"ANSWERSUM"];
    }
    NSString * USERNAME = [dic objectForKey:@"USERNAME"];
    NSString * HEADIMAGEURL = [dic objectForKey:@"FILEURL"];
    
    if (indexPath.row < 3) {
        UIImageView * rankingImage = [UIImageView new];
        rankingImage.frame = CGRectMake(10, 20, 30, 30);
        [cellView addSubview:rankingImage];
        
        switch (indexPath.row) {
            case 0:
                rankingImage.image = [UIImage imageNamed:@"yy_one.png"];
                break;
                
            case 1:
                rankingImage.image = [UIImage imageNamed:@"yy_two.png"];
                break;
                
            case 2:
                rankingImage.image = [UIImage imageNamed:@"yy_three.png"];
                break;
                
            default:
                break;
        }
    }
    
    if(indexPath.row > 2){
        UILabel * rankingLab = [UILabel new];
        [cellView addSubview:rankingLab];
        rankingLab.frame = CGRectMake(10, 10, 30, 50);
        rankingLab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
        rankingLab.textAlignment = NSTextAlignmentCenter;
        rankingLab.textColor = kTextColor;
    }
    
    if(HEADIMAGEURL.length > 0){
        UIImageView * headimage = [UIImageView new];
        headimage.frame = CGRectMake(50, 10, 50, 50);
        [cellView addSubview:headimage];
        headimage.clipsToBounds = YES;
        headimage.layer.cornerRadius = headimage.height/ 2;
        [headimage sd_setImageWithURL:ZENITH_IMAGEURL(HEADIMAGEURL) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    }else{
        UILabel * lastName = [UILabel new];
        [cellView addSubview:lastName];
        lastName.frame = CGRectMake(50, 10, 50, 50);
        lastName.backgroundColor = MAIN_ARM_COLOR;
        lastName.clipsToBounds = YES;
        lastName.layer.cornerRadius = lastName.height / 2;
        lastName.text = [USERNAME substringToIndex:1];
        lastName.textAlignment = NSTextAlignmentCenter;
        lastName.textColor = [UIColor whiteColor];
    }

    UILabel * usernameLab = [UILabel new];
    [cellView addSubview:usernameLab];
    usernameLab.frame = CGRectMake(110, 10, 150, 50);
    usernameLab.text = USERNAME;
    usernameLab.textAlignment = NSTextAlignmentLeft;
    usernameLab.textColor = kTextColor;
    
    NSString * countStr = [NSString stringWithFormat:@"%@个",SUMNUM];
    float countWidth = [ZEUtil widthForString:countStr font:[UIFont boldSystemFontOfSize:kTiltlFontSize] maxSize:CGSizeMake(200, usernameLab.height)];
    
    UILabel * countNum = [UILabel new];
    [cellView addSubview:countNum];
    countNum.frame = CGRectMake(0, 10, countWidth, usernameLab.height);
    countNum.text = countStr;
    countNum.textColor = MAIN_NAV_COLOR;
    countNum.right = SCREEN_WIDTH - 30;
    countNum.font = [UIFont boldSystemFontOfSize:kTiltlFontSize];
    
    UIView * LINEVIEW = [UIView new];
    LINEVIEW.backgroundColor = MAIN_LINE_COLOR;
    [cellView addSubview:LINEVIEW];
    LINEVIEW.frame = CGRectMake(10, 67, SCREEN_WIDTH - 20, 1.0f);
    
//    UILabel * questionExplain = [UILabel new];
//    [cellView addSubview:questionExplain];
//    questionExplain.font = [UIFont systemFontOfSize:12];
//    questionExplain.textColor = [UIColor lightGrayColor];
//    questionExplain.left = SCREEN_WIDTH - countWidth - 50 ;
//    questionExplain.top = countNum.top + 10;
//    questionExplain.size = CGSizeMake(40, usernameLab.height);
//    if (_currentRankingListPage == TEAM_RANKING_ASK) {
//        questionExplain.text = @"提问数";
//    }else  if (_currentRankingListPage == TEAM_RANKING_ANSWER) {
//        questionExplain.text = @"回答数";
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST) {
        return;
    }
    
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_TARGETASK:
            datasDic = self.targetQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_SOLVED:
            datasDic = self.solvedQuestionArr[indexPath.row];
            break;
        case TEAM_CONTENT_MYQUESTION:
            datasDic = self.myQuestionArr[indexPath.row];
            break;
        default:
            break;
    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    
    ZEQuestionTypeModel * questionTypeM = nil;
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        if ([typeM.CODE isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
            questionTypeM = typeM;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:withQuestionType:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:quesInfoM withQuestionType:questionTypeM];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];

    if ([scrollView isKindOfClass:[UITableView class]] || _currentTeamShowView == TEAM_VIEW_PRACTICE) {
        _historyY = scrollView.contentOffset.y;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]] || _currentTeamShowView == TEAM_VIEW_PRACTICE) {
        if (scrollView.contentOffset.y < _historyY) {
            if(optionView.hidden){
                [self showOptionView:scrollView];
            }
        } else if (scrollView.contentOffset.y > _historyY) {
            if(!optionView.hidden){
                [self hiddenOptionView:scrollView];
            }
        }
    }
}

-(void)hiddenOptionView:(UIScrollView *)currentScrollView
{
    UIScrollView *_labelScrollView;
    UITableView * _contentScrollView;
    if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
        _labelScrollView = [questionView viewWithTag:kTypeScrollLabTag];
        _contentScrollView = [questionView viewWithTag:kContentSrollViewTag];
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        _labelScrollView = [rankingListView viewWithTag:kTypeScrollLabTag];
        _contentScrollView = [rankingListView viewWithTag:kContentSrollViewTag];
    }else if (_currentTeamShowView == TEAM_VIEW_PRACTICE){
        [UIView animateWithDuration:0.29 animations:^{
            practiceView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
            WKWebView * webView = [practiceView viewWithTag:kPracticeWebViewTag];
            webView.height = SCREEN_HEIGHT - NAV_HEIGHT;
        } completion:^(BOOL finished) {
            optionView.hidden = YES;
        }];
        return;
    }

    [UIView animateWithDuration:0.29 animations:^{
        optionView.alpha = 0.0;
        if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
            questionView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) ;
            _contentScrollView.frame = CGRectMake(0,  35.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 35.0f);
            _contentScrollView.pagingEnabled = YES;
        }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
            rankingListView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) ;
            _contentScrollView.frame = CGRectMake(0,35.0f + 50.0f, SCREEN_WIDTH, SCREEN_HEIGHT - (NAV_HEIGHT + 35.0f + 50.0f));
            _contentScrollView.backgroundColor = [UIColor greenColor];
            
            _contentScrollView.pagingEnabled = YES;
        }
    } completion:^(BOOL finished) {
        optionView.hidden = YES;
    }];
}

-(void)showOptionView:(UIScrollView *)currentScrollView{
    
    UIScrollView *_labelScrollView;
    UITableView * _contentScrollView;
    if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
        _labelScrollView = [questionView viewWithTag:kTypeScrollLabTag];
        _contentScrollView = [questionView viewWithTag:kContentSrollViewTag];
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        _labelScrollView = [rankingListView viewWithTag:kTypeScrollLabTag];
        _contentScrollView = [rankingListView viewWithTag:kContentSrollViewTag];
    }else if (_currentTeamShowView == TEAM_VIEW_PRACTICE){
        [UIView animateWithDuration:0.29 animations:^{
            practiceView.frame = CGRectMake(0, kContentMarginTop, SCREEN_WIDTH, SCREEN_HEIGHT - kContentMarginTop);
            WKWebView * webView = [practiceView viewWithTag:kPracticeWebViewTag];
            webView.height = SCREEN_HEIGHT - kContentMarginTop;
        } completion:^(BOOL finished) {
            optionView.hidden = NO;
        }];
        return;
    }
    
    [UIView animateWithDuration:0.29 animations:^{
        optionView.alpha = 1.0;
        if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
            questionView.frame = CGRectMake(0, kContentMarginTop, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) ;
        }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
            rankingListView.frame = CGRectMake(0, kContentMarginTop, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) ;
        }

    } completion:^(BOOL finished) {
        optionView.hidden = NO;
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIScrollView *_typeScrollView;
    UIScrollView *_contentScrollView;
    NSArray * typeArr;
    UIImageView * _lineImageView;
    
    if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
        _typeScrollView = [questionView viewWithTag:kTypeScrollViewTag];
        _contentScrollView = [questionView viewWithTag:kContentSrollViewTag];
        typeArr = _allTypeArr;
        
    }else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST){
        _typeScrollView = [rankingListView viewWithTag:kTypeScrollViewTag];
        _contentScrollView = [rankingListView viewWithTag:kContentSrollViewTag];
        typeArr = _allCompareTypeArr;
    }
    _lineImageView = [_typeScrollView viewWithTag:kTypeScrollLineImageTag];

    if ([scrollView isEqual:_contentScrollView]) {
        
        NSInteger currentIndex = 0;
        
        currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        float marginLeft = 0;
        
        for (int i = 0 ; i < typeArr.count; i ++) {
            UIButton * button = [_typeScrollView viewWithTag:100 + i];
            [button setTitleColor:kTextColor forState:UIControlStateNormal];
            
            float btnWidth = SCREEN_WIDTH / typeArr.count;
            
            if (currentIndex == i) {
                [UIView animateWithDuration:0.35 animations:^{
                    _lineImageView.frame = CGRectMake(marginLeft, 33.0f, btnWidth, 2.0f);
                }];
                UITableView * contentView;
                if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
                    _currentHomeContentPage = i;
                    contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentHomeContentPage];
                }
                else if (_currentTeamShowView == TEAM_VIEW_RANKINGLIST) {
                    _currentRankingListPage = i;
                    contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentRankingListPage];
                }
                [contentView reloadData];
                [button setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
                
            }
            marginLeft += btnWidth;
        }
        if (_currentTeamShowView == TEAM_VIEW_QUESTION) {
            if ([self.delegate respondsToSelector:@selector(loadNewData:)]) {
                [self.delegate loadNewData:_currentHomeContentPage];
            }
        }
    }
    
}

#pragma mark - 回答问题

-(UIView *)createAnswerViewWithIndexpath:(NSIndexPath *)indexpath withView:(UIView *)questionsView
{
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexpath.row];
            break;
        case TEAM_CONTENT_TARGETASK:
            datasDic = self.targetQuestionArr[indexpath.row];
            break;
        case TEAM_CONTENT_SOLVED:
            datasDic = self.solvedQuestionArr[indexpath.row];
            break;
        case TEAM_CONTENT_MYQUESTION:
            datasDic = self.myQuestionArr[indexpath.row];
            break;
        default:
            break;
    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    if ([quesInfoM.BONUSPOINTS integerValue] > 0) {
        if (quesInfoM.BONUSPOINTS.length == 1) {
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"          %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 2){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"            %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 3){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"              %@",QUESTIONEXPLAINStr];
        }
        
        UIImageView * bonusImage = [[UIImageView alloc]init];
        [bonusImage setImage:[UIImage imageNamed:@"high_score_icon.png"]];
        [questionsView addSubview:bonusImage];
        bonusImage.left = 20.0f;
        bonusImage.top = 8.0f;
        bonusImage.width = 20.0f;
        bonusImage.height = 20.0f;
        
        UILabel * bonusPointLab = [[UILabel alloc]init];
        bonusPointLab.text = quesInfoM.BONUSPOINTS;
        [bonusPointLab setTextColor:MAIN_GREEN_COLOR];
        [questionsView addSubview:bonusPointLab];
        bonusPointLab.left = 43.0f;
        bonusPointLab.top = bonusImage.top;
        bonusPointLab.width = 27.0f;
        bonusPointLab.font = [UIFont boldSystemFontOfSize:kTiltlFontSize];
        bonusPointLab.height = 20.0f;
    }
    
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * QUESTIONEXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    QUESTIONEXPLAIN.numberOfLines = 0;
    QUESTIONEXPLAIN.text = QUESTIONEXPLAINStr;
    QUESTIONEXPLAIN.font = [UIFont boldSystemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONEXPLAIN];
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    NSMutableArray * urlsArr = [NSMutableArray array];
    for (NSString * str in quesInfoM.FILEURLARR) {
        [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
    }
    
    if (quesInfoM.FILEURLARR.count > 0) {
        PYPhotosView *linePhotosView = [PYPhotosView photosViewWithThumbnailUrls:urlsArr originalUrls:urlsArr layoutType:PYPhotosViewLayoutTypeLine];
        // 设置Frame
        linePhotosView.py_y = userY;
        linePhotosView.py_x = PYMargin;
        linePhotosView.py_width = SCREEN_WIDTH - 40;
        
        // 3. 添加到指定视图中
        [questionsView addSubview:linePhotosView];
        
        userY += kCellImgaeHeight + 10.0f;
    }
    
    NSArray * typeCodeArr = [quesInfoM.QUESTIONTYPECODE componentsSeparatedByString:@","];
    
    NSString * typeNameContent = @"";
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * questionTypeM = nil;
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        for (int i = 0; i < typeCodeArr.count; i ++) {
            if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                questionTypeM = typeM;
                if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                    typeNameContent = questionTypeM.NAME;
                }else{
                    typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                }
                break;
            }
        }
    }
    
    //     圈组分类最右边
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, userY, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"answer_tag"];
    [questionsView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,SCREEN_WIDTH - 70,15.0f)];
    circleLab.text = typeNameContent;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:circleLab];
    circleLab.numberOfLines = 0;
    [circleLab sizeToFit];
    
    if (circleLab.height == 0) {
        circleLab.height = 15.0f;
    }
    
    userY += circleLab.height + 5.0f;
    
    if (_currentHomeContentPage == TEAM_CONTENT_MYQUESTION) {
        if (quesInfoM.TARGETUSERNAME.length > 0) {
            
            NSString * targetUsernameStr = [NSString stringWithFormat:@"指定人员回答 ：%@",quesInfoM.TARGETUSERNAME];

            float targetUsernameHeight = [ZEUtil heightForString:targetUsernameStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
            
            UILabel * TARGETUSERNAMELab = [[UILabel alloc]initWithFrame:CGRectMake(20,userY,SCREEN_WIDTH - 40,targetUsernameHeight)];
            TARGETUSERNAMELab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
            TARGETUSERNAMELab.text = targetUsernameStr;
            TARGETUSERNAMELab.textColor = MAIN_SUBTITLE_COLOR;
            [questionsView addSubview:TARGETUSERNAMELab];
            TARGETUSERNAMELab.numberOfLines = 0;
            
            userY += targetUsernameHeight + 5.0f;
        }
    }
    
    
    UIView * messageLineView = [[UIView alloc]initWithFrame:CGRectMake(0, userY, SCREEN_WIDTH, 0.5)];
    messageLineView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:messageLineView];
    
    userY += 5.0f;
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
    [userImg sd_setImageWithURL:ZENITH_IMAGEURL(quesInfoM.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [questionsView addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * QUESTIONUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(45,userY,100.0f,20.0f)];
    QUESTIONUSERNAME.text = quesInfoM.QUESTIONUSERNAME;
    if(quesInfoM.ISANONYMITY){
        [userImg setImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        QUESTIONUSERNAME.text = @"匿名提问";
    }
    
    [QUESTIONUSERNAME sizeToFit];
    QUESTIONUSERNAME.textColor = MAIN_SUBTITLE_COLOR;
    QUESTIONUSERNAME.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONUSERNAME];
    
    
    UILabel * SYSCREATEDATE = [[UILabel alloc]initWithFrame:CGRectMake(QUESTIONUSERNAME.frame.origin.x + QUESTIONUSERNAME.frame.size.width + 5.0f,userY,100.0f,20.0f)];
    SYSCREATEDATE.text = [ZEUtil compareCurrentTime:quesInfoM.SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = NO;
    SYSCREATEDATE.textColor = MAIN_SUBTITLE_COLOR;
    SYSCREATEDATE.font = [UIFont systemFontOfSize:12];
    [questionsView addSubview:SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = YES;
    
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld 回答",(long)[quesInfoM.ANSWERSUM integerValue]];
    
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 70,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text  = praiseNumLabText;
    praiseNumLab.font = [UIFont boldSystemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:praiseNumLab];
    
    // 10 回答 | （图标）回答  分割线
    
    UIView * answerLineView = [[UIView alloc]initWithFrame:CGRectMake( praiseNumLab.frame.origin.x + praiseNumLab.frame.size.width + 5.0f , userY, 1.0f, 20.0f)];
    answerLineView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:answerLineView];
    
    
    UIButton * answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    answerBtn.frame = CGRectMake(SCREEN_WIDTH - 60 , userY - 20, 50, 40);
    [answerBtn setImage:[UIImage imageNamed:@"center_name_logo.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    [answerBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
    [answerBtn setTitle:@" 回答" forState:UIControlStateNormal];
    [answerBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [answerBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [answerBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    answerBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [questionsView addSubview:answerBtn];
    answerBtn.tag = indexpath.row;
    answerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [answerBtn addTarget:self action:@selector(answerQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([quesInfoM.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        answerBtn.hidden = YES;
        praiseNumLab.left =  answerBtn.left + 10;
    }
    
    if ([quesInfoM.ISSOLVE boolValue]) {
        UIImageView * iconAccept = [[UIImageView alloc]init];
        [questionsView addSubview:iconAccept];
        iconAccept.frame = CGRectMake(SCREEN_WIDTH - 35, 0, 35, 35);
        [iconAccept setImage:[UIImage imageNamed:@"ic_best_answer"]];
    }

    
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, userY + 25.0f, SCREEN_WIDTH, 5.0f)];
    grayView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:grayView];
    
    questionsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, userY + 30.0f);
    
    if ([quesInfoM.INFOCOUNT integerValue] > 0) {
        UILabel * badgeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20.0f)];
        badgeLab.backgroundColor = [UIColor redColor];
        badgeLab.tag = 100;
        badgeLab.center = CGPointMake(SCREEN_WIDTH - 20, (userY + 30.0f) / 2);
        badgeLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        badgeLab.textColor = [UIColor whiteColor];
        badgeLab.textAlignment = NSTextAlignmentCenter;
//        [questionsView addSubview:badgeLab];
        badgeLab.clipsToBounds = YES;
        badgeLab.layer.cornerRadius = badgeLab.height / 2;
        badgeLab.text = quesInfoM.INFOCOUNT;
        if (badgeLab.text.length > 2){
            badgeLab.width = 30.0f;
            badgeLab.center = CGPointMake(SCREEN_WIDTH - 25,  (userY + 30.0f) / 2);
        }
        if ([quesInfoM.INFOCOUNT integerValue] > 99) {
            badgeLab.text = @"99+";
        }
    }

    return questionsView;
}

-(NSMutableAttributedString *)getAttrText:(NSString * )titleText
{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleText];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont boldSystemFontOfSize:16.0]
     
                          range:NSMakeRange(0, 8)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(0, 8)];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:kHomeTitleFontSize]
     
                          range:NSMakeRange(0, 5)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor blackColor]
     
                          range:NSMakeRange(0, 5)];
    
    return AttributedStr;
}

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [searchTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(goSearch:)]) {
        [self.delegate goSearch:textField.text];
    }
    return YES;
}
#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@" ===   %@",[webView.URL absoluteString]);
    if([[webView.URL absoluteString] containsString:@"/ecm_grow/mobile/MobileExamCaseStepDailyPractice.jspx"] || [[webView.URL absoluteString] containsString:@"/ecm_grow/mobile/MobileExamCaseStepTeamTest.jspx"]){
        _isPractice = YES;
    }else{
        _isPractice = NO;
    }
}
// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@" ===  %@",navigationAction.request.URL.absoluteString);
    if([navigationAction.request.URL.absoluteString containsString:@"javasscriptss:tiaozhuang"]){
        _isPractice = NO;
        [self goLeavePracticeWebView];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_LEAVE_PRACTICE_WEBVIEW object:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - WKWebViewDelegate
-(void)showWebViewAlert
{
    NSString *jsFunctStr=@"dropOut()";
    WKWebView * web  = [practiceView viewWithTag:kPracticeWebViewTag];
    [web evaluateJavaScript:jsFunctStr completionHandler:nil];
//    JSContext *context=[web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    [context evaluateScript:jsFunctStr];
}
//
//-(BOOL)webView:(WKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKWebViewNavigationType)navigationType
//{
//    NSString *urlString = [[request URL] absoluteString];
//    urlString = [urlString stringByRemovingPercentEncoding];
//    
//    if([urlString containsString:@"javasscriptss:tiaozhuang"]){
////        NSLog(@"urlString=%@",urlString);
//        _isPractice = NO;
//        [self goLeavePracticeWebView];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_LEAVE_PRACTICE_WEBVIEW object:nil];
//    }
//
//    return YES;
//}
//-(void)webViewDidStartLoad:(WKWebView *)webView
//{
//
//}
//
//-(void)webViewDidFinishLoad:(WKWebView *)webView
//{
//    if([[webView.request.URL path] isEqualToString:@"/ecm/mobile/MobileExamCaseStep.jspx"]){
//        _isPractice = YES;
//    }else{
//        _isPractice = NO;
//    }
//    
//    WKWebView * web  = [practiceView viewWithTag:kPracticeWebViewTag];
//    JSContext *context=[web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *jsFunctStr=@"drop()";
//    [context evaluateScript:jsFunctStr];
//}

-(void)goLeavePracticeWebView{
    ZEButton * btn = [optionView viewWithTag:_willShowView];
//    if (_willShowView == TEAM_WILL_SHOWVIEW_QUESTION) {
        [self didSelectMyOption:btn];
//    }
}

#pragma mark - ZEHomeViewDelegate

-(void)loadNewNewestData:(MJRefreshHeader *)header
{
    if([self.delegate respondsToSelector:@selector(loadNewData:)]){
        [self.delegate loadNewData:header.superview.tag  - 100];
    }
}

-(void)loadMoreData:(MJRefreshFooter *)footer
{
    if([self.delegate respondsToSelector:@selector(loadMoreData:)]){
        [self.delegate loadMoreData:footer.superview.tag - 100];
    }
}

-(void)answerQuestion:(UIButton *)btn
{
    NSDictionary * datasDic = nil;
    switch (_currentHomeContentPage) {
        case TEAM_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[btn.tag];
            break;
        case TEAM_CONTENT_TARGETASK:
            datasDic = self.targetQuestionArr[btn.tag];
            break;
        case TEAM_CONTENT_SOLVED:
            datasDic = self.solvedQuestionArr[btn.tag];
            break;
        case TEAM_CONTENT_MYQUESTION:
            datasDic = self.myQuestionArr[btn.tag];
            break;
        default:
            break;
    }
    
    ZEQuestionInfoModel * questionInfoModel = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    if ([self.delegate respondsToSelector:@selector(goAnswerQuestionVC:)]) {
        [self.delegate goAnswerQuestionVC:questionInfoModel];
    }
}

- (void)deleteWebCache {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
//        NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
//                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
//                                                        WKWebsiteDataTypeMemoryCache,
//                                                        WKWebsiteDataTypeLocalStorage,
//                                                        WKWebsiteDataTypeCookies,
//                                                        WKWebsiteDataTypeSessionStorage,
//                                                        WKWebsiteDataTypeIndexedDBDatabases,
//                                                        WKWebsiteDataTypeWebSQLDatabases]];
        
        //// All kinds of data
        
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}

- (void)dealloc
{
    WKWebView * web = [practiceView viewWithTag:kPracticeWebViewTag];
    web.scrollView.delegate = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
