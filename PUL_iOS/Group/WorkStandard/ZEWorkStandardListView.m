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
#define kNavViewHeight 85.0f

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT + kNavViewHeight
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT + kNavViewHeight )

#define kWorkStandardCellHeight 80

#import "ZEWorkStandardListView.h"
#import "ZEWorkStandardListCell.h"

#import "ZEKLB_CLASSICCASE_INFOModel.h"
@interface ZEWorkStandardListView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
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
    navView.top = 0;
    [self addSubview:navView];
    [ZEUtil addGradientLayer:navView];
    navView.top = NAV_HEIGHT;
    
    UIView * searchView = [UIView new];
    searchView.frame = CGRectMake(30 , 5, SCREEN_WIDTH - 60, 35);
    [navView addSubview:searchView];
    [searchView addSubview:[self searchTextfieldView]];
    
    UIView * orederView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, kNavViewHeight - 45)];
    orederView.backgroundColor = [UIColor whiteColor];
    [navView addSubview:orederView];
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:5 superView:orederView];
    
    newestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newestBtn setTitle:@"最新" forState:UIControlStateNormal];
    [newestBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    [newestBtn setFrame:CGRectMake(20, 5, 80, orederView.height)];
    newestBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [newestBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [orederView addSubview:newestBtn];
//    [newestBtn setImage:[UIImage imageNamed:@"icon_case_order"] forState:UIControlStateNormal];
//    [newestBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
//    [newestBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];

    hotestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotestBtn setTitle:@"最热" forState:UIControlStateNormal];
    [hotestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hotestBtn setFrame:CGRectMake(120, 5, 80, orederView.height)];
    hotestBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [hotestBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [orederView addSubview:hotestBtn];
//    [hotestBtn setImage:[UIImage imageNamed:@"icon_case_order"] forState:UIControlStateNormal];
//    [hotestBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
//    [hotestBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];

}

-(UIView *)searchTextfieldView
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
    searchTFView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5 ];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 18)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon"];
    [searchTFView addSubview:searchTFImg];
    
    _questionSearchTF =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 30)];
    [searchTFView addSubview:_questionSearchTF];
    _questionSearchTF.placeholder = @"关键词筛选";
    [_questionSearchTF setReturnKeyType:UIReturnKeySearch];
    _questionSearchTF.font = [UIFont systemFontOfSize:14];
    _questionSearchTF.leftViewMode = UITextFieldViewModeAlways;
    _questionSearchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    _questionSearchTF.delegate=self;
    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = 5;
    
    return searchTFView;
}


-(void)initContentView
{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight) style:UITableViewStylePlain];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_questionSearchTF resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.text.length > 0){
        if([self.delegate respondsToSelector:@selector(goSearchWithSearchStr:)]){
            [self.delegate goSearchWithSearchStr:textField.text];
        }
    }
    
    return YES;
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
