//
//  ZECourseSearchView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/21.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kNavBarMarginLeft   0.0f
#define kNavBarMarginTop    0.0f
#define kNavBarWidth        SCREEN_WIDTH
#define kNavBarHeight       NAV_HEIGHT

// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 10.0f
#define kLeftButtonMarginTop (IPHONEX ? 40.0f : 18.0f)

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   kNavBarHeight
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - NAV_HEIGHT

#import "ZECourseSearchView.h"
#import "ZEDistrictManagerCell.h"

@interface ZECourseSearchView()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _contentTableView;
    UITextField * _questionSearchTF;
}

@property (nonatomic,strong) NSMutableArray * datasArr;

@end

@implementation ZECourseSearchView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.datasArr = [NSMutableArray array];
        [self initNavBar];
        [self initContentTableView];
    }
    return self;
}

-(void)initNavBar
{
    UIView * navView = [[UIView alloc] initWithFrame:CGRectZero];
    navView.backgroundColor = MAIN_NAV_COLOR;
    [self addSubview:navView];
    navView.frame = CGRectMake(kNavBarMarginLeft, kNavBarMarginTop, kNavBarWidth, kNavBarHeight);
    
    [ZEUtil addGradientLayer:navView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, kLeftButtonWidth, kLeftButtonHeight);
    if(IPHONE6_MORE){
        backBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, 50, 50);
    }
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0, 0.0f, 0.0f);
    backBtn.contentMode = UIViewContentModeScaleAspectFill;
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [backBtn setImage:[UIImage imageNamed:@"icon_back" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UIView * searchView = [UIView new];
    searchView.frame = CGRectMake(backBtn.right , backBtn.top + 10, SCREEN_WIDTH - backBtn.right - 20, 30);
    [navView addSubview:searchView];
    [searchView addSubview:[self searchTextfieldView]];
    
}

-(void)initContentTableView
{
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.frame = CGRectMake(kContentTableMarginLeft, kContentTableMarginTop, kContentTableWidth, kContentTableHeight);
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _contentTableView.mj_header = header;
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _contentTableView.mj_footer = footer;
}

-(void)refreshTableView
{
    [_contentTableView.mj_header endRefreshing];
}

-(UIView *)searchTextfieldView
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 90, 30)];
    searchTFView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5 ];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 18)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon"];
    [searchTFView addSubview:searchTFImg];
    
    _questionSearchTF =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 95, 30)];
    [searchTFView addSubview:_questionSearchTF];
    _questionSearchTF.placeholder = @"关键词筛选";
    [_questionSearchTF setReturnKeyType:UIReturnKeySearch];
    _questionSearchTF.font = [UIFont systemFontOfSize:14];
    _questionSearchTF.leftViewMode = UITextFieldViewModeAlways;
    _questionSearchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    _questionSearchTF.delegate=self;
    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = 30 / 2;
    
    return searchTFView;
}

#pragma mark - Public Method

-(void)reloadContentViewWithArr:(NSArray *)arr{
    
    [self.datasArr addObjectsFromArray:arr];
    
    [_contentTableView.mj_header endRefreshing];
    [_contentTableView.mj_footer endRefreshing];
    [_contentTableView reloadData];
    
    if (_datasArr.count % MAX_PAGE_COUNT == 0 && _datasArr.count > 0 ) {
        
    }else{
        [_contentTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)canLoadMoreData
{
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _contentTableView.mj_footer = footer;
}
-(void)reloadFirstView:(NSArray *)array
{
    self.datasArr = [NSMutableArray array];
    [self reloadContentViewWithArr:array];
}
-(void)loadNewData
{
    if([self.delegate respondsToSelector:@selector(loadNewData)]){
        [self.delegate loadNewData];
    }
}

-(void)loadMoreData{
    if([self.delegate respondsToSelector:@selector(loadMoreData)]){
        [self.delegate loadMoreData];
    }
}
/**
 *  停止刷新
 */
-(void)headerEndRefreshing
{
    [_contentTableView.mj_header endRefreshing];
}

-(void)loadNoMoreData
{
    [_contentTableView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZEDistrictManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZEDistrictManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    [cell initUIWithDic:self.datasArr[indexPath.row]];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.datasArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic =  self.datasArr[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(goCourseDetail:)]) {
        [self.delegate goCourseDetail:dic ];
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
    if ([self.delegate respondsToSelector:@selector(goSearch:)]) {
        [self.delegate goSearch:textField.text];
    }
    return YES;
}

-(void)goBack
{
    if([self.delegate respondsToSelector:@selector(goBack)]){
        [self.delegate goBack];
    }
}


@end
