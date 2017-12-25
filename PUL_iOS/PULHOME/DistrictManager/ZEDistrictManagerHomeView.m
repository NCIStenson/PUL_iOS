//
//  ZEDistrictManagerHomeView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kManagerTabbarHeight 70

#define kNavViewMarginLeft 0.0f
#define kNavViewMarginTop NAV_HEIGHT
#define kNavViewWidth SCREEN_WIDTH
#define kNavViewHeight 85.0f

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT + kNavViewHeight
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT + kNavViewHeight + kManagerTabbarHeight )

#define kCellHeight 70
#define kHeaderViewHeight 35

#import "ZEDistrictManagerHomeView.h"
#import "ZEDistrictManagerModel.h"
#import "ZEButton.h"

@implementation ZEDistrictManagerHomeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentSortType = SORT_ALL;
        allDataArr = [NSMutableArray array];
        allDetailDataArr = [NSMutableArray array];
        allRecommondDataArr = [NSMutableArray array];
        allTotalCountArr= [NSMutableArray array];
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
    
    UIView * orederView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 45)];
    orederView.backgroundColor = [UIColor whiteColor];
    [navView addSubview:orederView];
    
    allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [allBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    [allBtn setFrame:CGRectMake(20, 0, 50, orederView.height)];
    [allBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [orederView addSubview:allBtn];

    btnUnderlineView=  [UIView new];
    btnUnderlineView.frame = CGRectMake(0, 0, allBtn.width, 2);
    btnUnderlineView.center = CGPointMake(allBtn.centerX, allBtn.height );
    btnUnderlineView.backgroundColor = MAIN_NAV_COLOR;
    [orederView addSubview:btnUnderlineView];
    
    hotestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotestBtn setTitle:@"推荐" forState:UIControlStateNormal];
    [hotestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hotestBtn setFrame:CGRectMake(80, 0, 50, orederView.height)];
    [hotestBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [orederView addSubview:hotestBtn];

    _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 70, orederView.height);
    [_orderBtn setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
    _orderBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [orederView addSubview:_orderBtn];
    _orderBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    if (_currentSelectOrder == 2) {
//        [_orderBtn setTitle:@" 按热度" forState:UIControlStateNormal];
//    }else{
        [_orderBtn setTitle:@" 按时间" forState:UIControlStateNormal];
//    }
    [_orderBtn setImage:[UIImage imageNamed:@"icon_manager_order" color:MAIN_BLUE_COLOR] forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(showOptionView:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)sortCondition:(UIButton *)btn
{
    btnUnderlineView.centerX = btn.centerX;
    if ([btn isEqual:allBtn]) {
        if (_currentSortType == SORT_ALL) {
            return;
        }
        [_contentView.mj_footer endRefreshing];
        [_contentView.mj_footer removeFromSuperview];
        
        [_orderBtn setTitle:@" 按时间" forState:UIControlStateNormal];
        _currentSortType = SORT_ALL;
        [allBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
        [hotestBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    }else if ([btn isEqual:hotestBtn]){
        if (_currentSortType == SORT_RECOMMAND) {
            return;
        }
        _contentView.mj_footer.hidden = NO;

        MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecommondData)];
        _contentView.mj_footer = footer;

        [_orderBtn setTitle:@" 按时间" forState:UIControlStateNormal];
        _currentSortType = SORT_RECOMMAND;
        [hotestBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
        [allBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        
        allRecommondDataArr = [NSMutableArray array];
        if ([self.delegate respondsToSelector:@selector(goRecommondViewRequest)]) {
            [self.delegate goRecommondViewRequest];
        }
    }
    [_contentView reloadData];
}

-(void)showOptionView:(UIButton *)btn
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[btn convertRect: btn.bounds toView:window];
    
    ZEShowOptionView * homeOptionView = [[ZEShowOptionView alloc]initWithFrame:CGRectZero];
    homeOptionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    homeOptionView.delegate =self;
    homeOptionView.rect = rect;
    [window addSubview:homeOptionView];
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
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight) style:UITableViewStyleGrouped];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self addSubview:_contentView];
    
    MJRefreshHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    _contentView.mj_header = header;
    
    tabbarView = [UIView new];
    tabbarView.frame = CGRectMake(0, SCREEN_HEIGHT - kManagerTabbarHeight, SCREEN_WIDTH , kManagerTabbarHeight);
    [self addSubview:tabbarView];
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:1 superView:tabbarView];

    for (int i = 0; i < 3; i ++) {
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(SCREEN_WIDTH /3  * i , 5 , SCREEN_WIDTH / 3 , 40);
        [tabbarView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor clearColor];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [optionBtn addTarget:self action:@selector(goManagerCourse:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 105;
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
        optionBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

        UILabel * nameLab = [UILabel new];
        nameLab.frame = CGRectMake(SCREEN_WIDTH / 3 * i , 50 , SCREEN_WIDTH / 3 , 15);
        [tabbarView addSubview:nameLab];
        nameLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        nameLab.textColor = kTextColor;
        nameLab.textAlignment = NSTextAlignmentCenter;
        
        switch (i) {
            case 0:
                [optionBtn setImage:[UIImage imageNamed:@"icon_manager_coll"] forState:UIControlStateNormal];
//                [optionBtn setTitle:@"我的错题" forState:UIControlStateNormal];
                nameLab.text = @"我的收藏";
                break;
            case 1:
                [optionBtn setImage:[UIImage imageNamed:@"icon_manager_tabbar_practice" ] forState:UIControlStateNormal];
//                [optionBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
                nameLab.text = @"题库练习";

                break;
            case 2:
                [optionBtn setImage:[UIImage imageNamed:@"icon_manager_tabbar_study" ] forState:UIControlStateNormal];
//                [optionBtn setTitle:@"学习讨论区" forState:UIControlStateNormal];
                nameLab.text = @"学习讨论区";
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - Public Method

-(void)reloadDataWithArr:(NSArray *)arr{
    allDataArr = [NSMutableArray array];
    [allDataArr addObjectsFromArray:arr];
    
    for (int i = 0; i < allDataArr.count; i ++) {
        ZEDistrictManagerModel * managerM = [ZEDistrictManagerModel getDetailWithDic:allDataArr[i]];
        NSDictionary * detailDic = [ZEUtil dictionaryWithJsonString:managerM.DATALIST];
        NSArray * detailArr = [detailDic objectForKey:@"datas"];
        if(detailArr.count > 0){
            [allTotalCountArr addObject:[detailDic objectForKey:@"totalCount"]];
            [allDetailDataArr addObject:detailArr];
        }
    }
    
    if (_currentSortType == SORT_ALL) {
        [_contentView.mj_header endRefreshing];
        [_contentView reloadData];
    }
}

-(void)reloadFirstRecommandDataWithArr:(NSArray *)arr
{
    allRecommondDataArr = [NSMutableArray arrayWithArray:arr];
    if (_currentSortType == SORT_RECOMMAND) {
        [_contentView.mj_header endRefreshing];
        [_contentView reloadData];
        [_contentView.mj_footer endRefreshing];
    }
}

-(void)reloadRecommandDataWithArr:(NSArray *)arr
{
    [allRecommondDataArr addObjectsFromArray:arr];
    if (_currentSortType == SORT_RECOMMAND) {
        [_contentView.mj_header endRefreshing];
        [_contentView reloadData];
        [_contentView.mj_footer endRefreshing];
    }
}

-(void)endFooterRefreshingWithNoMoreData
{
    [_contentView.mj_footer endRefreshingWithNoMoreData];
}

-(void)reloadSectionWithIndex:(NSInteger)index withArr:(NSArray *)arr
{
    NSMutableArray * orArr = [NSMutableArray arrayWithArray:allDetailDataArr[index]];
    [orArr addObjectsFromArray:arr];
    [allDetailDataArr replaceObjectAtIndex:index withObject:orArr];
    
    NSInteger totalCount = [allTotalCountArr[index] integerValue];
    NSArray * currentCountArr = allDetailDataArr[index];
    if ( currentCountArr.count == totalCount ) {
        [_contentView reloadData];
    }else{
        [_contentView reloadSection:index withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_currentSortType == SORT_RECOMMAND){
        return 1;
    }
    return allDetailDataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_currentSortType == SORT_RECOMMAND){
        return allRecommondDataArr.count;
    }
//    ZEDistrictManagerModel * managerM = [ZEDistrictManagerModel getDetailWithDic:allDataArr[section]];
//    NSDictionary * detailDic = [ZEUtil dictionaryWithJsonString:managerM.DATALIST];
//    NSArray * detailArr = [detailDic objectForKey:@"datas"];
    NSArray * arr = allDetailDataArr[section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_currentSortType == SORT_RECOMMAND){
        return 0.1;
    }
    return kHeaderViewHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(_currentSortType == SORT_RECOMMAND){
        return 0.1;
    }
    NSInteger totalCount = [allTotalCountArr[section] integerValue];
    NSArray * arr = allDetailDataArr[section];
    if ( arr.count == totalCount ) {
        return 0.1;
    }

    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [UIView new];
    if (_currentSortType == SORT_RECOMMAND) {
        return headerView;
    }
    headerView.backgroundColor = MAIN_LINE_COLOR;
    
    UIView * lineView=  [UIView new];
    lineView.frame = CGRectMake(0, 3, 3, kHeaderViewHeight - 6);
    [headerView addSubview:lineView];
    lineView.backgroundColor = MAIN_NAV_COLOR;
    
    if (section >= allDataArr.count) {
        return headerView;
    }
    
    ZEDistrictManagerModel * managerModel = [ZEDistrictManagerModel getDetailWithDic:allDataArr[section]];
    
    UILabel * titleLab = [UILabel new];
    titleLab.frame = CGRectMake(20, 0, SCREEN_WIDTH - 90, kHeaderViewHeight);
    titleLab.text = managerModel.TYPENAME;
    titleLab.textColor = kTextColor;
    titleLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [headerView addSubview:titleLab];
    
    UIButton * goPracticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goPracticeBtn setFrame:CGRectMake(SCREEN_WIDTH- kHeaderViewHeight - 20, 0, kHeaderViewHeight, kHeaderViewHeight)];
    [goPracticeBtn addTarget:self action:@selector(goChapterPractice:) forControlEvents:UIControlEventTouchUpInside];
    [goPracticeBtn setImage:[UIImage imageNamed:@"icon_manager_goPrac"] forState:UIControlStateNormal];
    goPracticeBtn.tag = 200 + section;
    [headerView addSubview:goPracticeBtn];

    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [UIView new];
    if (_currentSortType == SORT_RECOMMAND) {
        return footerView;
    }
    
    NSInteger totalCount = [allTotalCountArr[section] integerValue];
    NSArray * arr = allDetailDataArr[section];
    if ( arr.count == totalCount ) {
        return footerView;
    }

    footerView.backgroundColor = [UIColor whiteColor];
    UIButton* titleLab = [UIButton buttonWithType:UIButtonTypeCustom];
    titleLab.frame = CGRectMake(0, 0, SCREEN_WIDTH , 25);
    [titleLab setTitle:@"加载更多" forState:UIControlStateNormal];
    [titleLab setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
    [titleLab setImage:[UIImage imageNamed:@"icon_manager_showall"] forState:UIControlStateNormal];
    titleLab.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [footerView addSubview:titleLab];
    CGFloat imgWidth = titleLab.imageView.bounds.size.width;
    CGFloat labWidth = titleLab.titleLabel.bounds.size.width;
    [titleLab setImageEdgeInsets:UIEdgeInsetsMake(0, labWidth + 10, 0, -labWidth)];
    [titleLab setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, 0, imgWidth)];
    titleLab.tag = 100 + section;
    [titleLab addTarget:self action:@selector(loadMoreCurrentTypeData:) forControlEvents:UIControlEventTouchUpInside];

    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
     ZEDistrictManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZEDistrictManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    if(_currentSortType == SORT_ALL){
//        ZEDistrictManagerModel * managerM = [ZEDistrictManagerModel getDetailWithDic:allDataArr[indexPath.section]];
//        NSDictionary * detailDic = [ZEUtil dictionaryWithJsonString:managerM.DATALIST];
//        NSArray * detailArr = [detailDic objectForKey:@"datas"];
        if (allDetailDataArr.count > 0) {
            [cell initUIWithDic:allDetailDataArr[indexPath.section][indexPath.row]];
        }
    }else if (_currentSortType == SORT_RECOMMAND){
        if (indexPath.row == 0) {
            UIView * lineLayer = [UIView new];
            lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 3);
            lineLayer.backgroundColor = MAIN_LINE_COLOR;
            [cell.contentView addSubview:lineLayer];
        }
        if (allRecommondDataArr.count > 0) {
            [cell initUIWithDic:allRecommondDataArr[indexPath.row]];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * resultdic = nil;
    if(_currentSortType == SORT_ALL){
       resultdic = allDetailDataArr[indexPath.section][indexPath.row];
    }else if (_currentSortType == SORT_RECOMMAND){
        resultdic = allRecommondDataArr[indexPath.row];
    }

    if ([self.delegate respondsToSelector:@selector(goManagerDetail:)]) {
        [self.delegate goManagerDetail:resultdic];
    }
}


#pragma mark - ZEDistrictManagerHomeViewDelegate
-(void)didSelectOptionWithIndex:(NSInteger)index
{
    allDataArr = [NSMutableArray array];
    allDetailDataArr = [NSMutableArray array];
    allRecommondDataArr = [NSMutableArray array];

    if(index == 0){
        _currentSelectOrder = ORDER_BY_CLICKCOUNT;
        [_orderBtn setTitle:@" 按热度" forState:UIControlStateNormal];
        if([self.delegate respondsToSelector:@selector(sendRequestWithOrder:)]){
            [self.delegate sendRequestWithOrder:ORDER_BY_CLICKCOUNT];
        }
    }else{
        _currentSelectOrder = ORDER_BY_DATE;
        [_orderBtn setTitle:@" 按时间" forState:UIControlStateNormal];
        if([self.delegate respondsToSelector:@selector(sendRequestWithOrder:)]){
            [self.delegate sendRequestWithOrder:ORDER_BY_DATE];
        }
    }
    
}

-(void)goManagerCourse:(UIButton *)btn
{
    if (btn.tag == 105) {
        if ([self.delegate respondsToSelector:@selector(goMyCollectCourse)]) {
            [self.delegate goMyCollectCourse];
        }
    }else if (btn.tag == 106){
        if ([self.delegate respondsToSelector:@selector(goManagerPractice)]) {
            [self.delegate goManagerPractice];
        }
    }else if (btn.tag == 107){
        if ([self.delegate respondsToSelector:@selector(goNewQuestionListVC)]) {
            [self.delegate goNewQuestionListVC];
        }
    }
}

-(void)goChapterPractice:(UIButton *)button
{
    NSDictionary * dic = allDataArr[button.tag - 200];
    if ([self.delegate respondsToSelector:@selector(goChapterPractice:)]) {
        [self.delegate goChapterPractice:dic];
    }
    
}

-(void)refreshView
{
    allRecommondDataArr = [NSMutableArray array];
    allDataArr = [NSMutableArray array];
    allDetailDataArr = [NSMutableArray array];
    [_orderBtn setTitle:@" 按时间" forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(reloadRequest)]) {
        [self.delegate reloadRequest];
    }
}

-(void)loadMoreRecommondData
{
    if ([self.delegate respondsToSelector:@selector(loadMoreRecommondRequest:)]) {
        [self.delegate loadMoreRecommondRequest:_currentSelectOrder];
    }
}

-(void)loadMoreCurrentTypeData:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(loadMoreDataWithSection:withTypeDic:)]) {
        [self.delegate loadMoreDataWithSection:btn.tag - 100 withTypeDic:allDataArr[btn.tag - 100]];
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(goCourseSearchView)]) {
        [self.delegate goCourseSearchView];
    }
    [self endEditing:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
