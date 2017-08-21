//
//  ZEWorkStandardListView.m
//  PUL_iOS
//
//  Created by Stenson on 17/4/25.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kNavViewMarginLeft 0.0f
#define kNavViewMarginTop NAV_HEIGHT
#define kNavViewWidth SCREEN_WIDTH
#define kNavViewHeight 30.0f

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT + kNavViewHeight
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT + kNavViewHeight )

#define kWorkStandardCellHeight 60

#import "ZEWorkStandardListView.h"
#import "ZEWorkStandardListCell.h"

#import "ZEKLB_CLASSICCASE_INFOModel.h"
@interface ZEWorkStandardListView ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * optionBtn;
    UIButton * newestBtn;
    UIButton * hotestBtn;
    
    UIView * _optionView;
    
    UIButton * _currentBtn;
    
    UITableView * _contentView;
    
}

@property (nonatomic,strong) NSMutableArray * workStandardArr;

@end


@implementation ZEWorkStandardListView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initNavView];
        
        [self initContentView];
    }
    return self;
}

-(void)initNavView
{
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(kNavViewMarginLeft, kNavViewMarginTop, kNavViewWidth, kNavViewHeight)];
    navView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:navView];

    UILabel * screenLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, kNavViewHeight)];
    screenLab.text = @"筛选";
    screenLab.font = [UIFont systemFontOfSize:12];
    [navView addSubview:screenLab];
    
    optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [optionBtn setTitle:@"全部" forState:UIControlStateNormal];
    [optionBtn setImage:[UIImage imageNamed:@"icon_up.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    [optionBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    [optionBtn setFrame:CGRectMake(45, 0, 40, kNavViewHeight)];
    optionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [optionBtn addTarget:self action:@selector(showOptions) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:optionBtn];
    
    newestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newestBtn setTitle:@"按最新" forState:UIControlStateNormal];
    [newestBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    [newestBtn setFrame:CGRectMake(SCREEN_WIDTH - 90, 0, 40, kNavViewHeight)];
    newestBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [newestBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:newestBtn];
    
    hotestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotestBtn setTitle:@"按最热" forState:UIControlStateNormal];
    [hotestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hotestBtn setFrame:CGRectMake(SCREEN_WIDTH - 45, 0, 40, kNavViewHeight)];
    hotestBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [hotestBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:hotestBtn];
}

-(void)initContentView
{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight) style:UITableViewStylePlain];
    
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self addSubview:_contentView];
    MJRefreshHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    _contentView.mj_header = header;
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _contentView.mj_footer = footer;
}

-(void)showOptions
{
    if ([self.delegate respondsToSelector:@selector(showType)]) {
        [self.delegate showType];
    }
}


-(void)sortCondition:(UIButton *)btn
{
    if ([_currentBtn isEqual:btn]) {
        return;
    }
    _currentBtn = btn;
    NSString *  sortOrderSQL = @"SYSCREATEDATE desc";
    if ([btn isEqual:newestBtn]) {
        [newestBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
        [hotestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if ([btn isEqual:hotestBtn]){
        sortOrderSQL = @"CLICKCOUNT desc";
        [newestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [hotestBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    }
    if([self.delegate respondsToSelector:@selector(sortConditon:)]){
        [self.delegate sortConditon:sortOrderSQL];
    }
}

#pragma mark - Public Method

-(void)reloadNavView:(NSString *)str
{
    float btnWidth = [ZEUtil widthForString:str font:optionBtn.titleLabel.font maxSize:CGSizeMake(200, optionBtn.height)];
    optionBtn.width = btnWidth + 15;
    [optionBtn setTitle:str forState:UIControlStateNormal];
}

-(void)reloadFirstView:(NSArray *)arrData
{
    self.workStandardArr = [NSMutableArray array];
    [self reloadMoreDataView:arrData];
}

-(void)reloadMoreDataView:(NSArray *)arrData
{
    [self.workStandardArr addObjectsFromArray:arrData];
    [_contentView.mj_header endRefreshing];
    if (arrData.count % MAX_PAGE_COUNT != 0) {
        [_contentView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_contentView.mj_footer endRefreshing];
    }
    [_contentView reloadData];
}

/**
 *  停止刷新
 */
-(void)headerEndRefreshing
{
    [_contentView.mj_header endRefreshing];
}

-(void)loadNoMoreData
{
    [_contentView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workStandardArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWorkStandardCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZEWorkStandardListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZEWorkStandardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    while ([cell.contentView subviews].lastObject) {
        [[[cell.contentView subviews] lastObject] removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initCellViewWithDic:self.workStandardArr[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(goWorkStandardDetail:)]) {
        [self.delegate goWorkStandardDetail:self.workStandardArr[indexPath.row]];
    }
}

#pragma mark - ZETypicalCaseViewDelegate

-(void)refreshView
{
    if ([self.delegate respondsToSelector:@selector(loadNewData)]) {
        [self.delegate loadNewData];
    }
}
-(void)loadMoreData
{
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
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
