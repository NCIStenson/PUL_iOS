//
//  ZENewQuestionListView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/8.
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
#define kContentTableMarginTop   ( kNavBarHeight )
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - kContentTableMarginTop

#import "ZENewQuestionListView.h"
#import "ZENewQuetionLayout.h"
#import "ZENewQuestionListCell.h"

@interface ZENewQuestionListView()<UITableViewDelegate,UITableViewDataSource,ZENewQuestionListCellDelegate>
{
    UIScrollView * _contentScrollView; // 展示出的问题内容
    NSInteger _currentHomeContent;
}

@property (nonatomic,strong) NSMutableArray * newestQuestionArr;
@property (nonatomic,strong) NSMutableArray * recommandQuestionArr;
@property (nonatomic,strong) NSMutableArray * bonusQuestionArr;

@end

@implementation ZENewQuestionListView

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
    [self initNavBar];
    [self initContentView];
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
    
    UIButton * _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeBtn.frame = CGRectMake(SCREEN_WIDTH - kLeftButtonWidth - 10, kLeftButtonMarginTop, kLeftButtonWidth, kLeftButtonHeight);
    if(IPHONE6_MORE){
        _typeBtn.frame = CGRectMake(SCREEN_WIDTH - 60, kLeftButtonMarginTop, 50, 50);
    }
    _typeBtn.contentMode = UIViewContentModeScaleAspectFill;
    _typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_typeBtn setImage:[UIImage imageNamed:@"home_icon_search" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_typeBtn];
    
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"推荐", @"悬赏"]];
    self.segmentedControl.frame = CGRectMake(0, 0, 200, 30);
    self.segmentedControl.center = CGPointMake(SCREEN_WIDTH / 2, 42);
    // 设置整体的色调
    self.segmentedControl.tintColor = [UIColor whiteColor];
    
    // 设置初始选中项
    self.segmentedControl.selectedSegmentIndex = 0;
    
    [self.segmentedControl addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
    [self addSubview:self.segmentedControl];
}

-(void)initContentView
{
    _contentScrollView = [[UIScrollView alloc]init];
    [self addSubview:_contentScrollView];
    _contentScrollView.left = kContentTableMarginLeft;
    _contentScrollView.top = kContentTableMarginTop;
    _contentScrollView.size = CGSizeMake(kContentTableWidth, kContentTableHeight);
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, kContentTableHeight);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    
    for (int i = 0; i < 3; i ++) {
        UITableView * contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        contentTableView.delegate = self;
        contentTableView.dataSource = self;
        [_contentScrollView addSubview:contentTableView];
        contentTableView.showsVerticalScrollIndicator = NO;
        contentTableView.frame = CGRectMake(kContentTableMarginLeft + SCREEN_WIDTH * i, 0, kContentTableWidth, kContentTableHeight);
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.tag = 100 + i;
        [contentTableView registerClass:[ZENewQuestionListCell class] forCellReuseIdentifier:@"cell"];
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNewestData:)];
        contentTableView.mj_header = header;
    }
    
    UIButton * _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeBtn.frame = CGRectMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT - 70, 50, 50);
    _typeBtn.contentMode = UIViewContentModeScaleAspectFit;
    _typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_typeBtn];
    [_typeBtn setImage:[UIImage imageNamed:@"icon_ask"] forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark - 最新页面

/**
 刷新第一页面最新数据
 
 @param dataArr 数据内容
 */
-(void)reloadFirstView:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;
{
    switch (content_page) {
        case HOME_CONTENT_RECOMMAND:
            self.recommandQuestionArr = [NSMutableArray array];
            break;
        case HOME_CONTENT_NEWEST:
            self.newestQuestionArr = [NSMutableArray array];
            break;
        case HOME_CONTENT_BOUNS:
            self.bonusQuestionArr = [NSMutableArray array];
            break;
        default:
            break;
    }
    
//    ZE_weakify(self);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        ZE_strongify(weakSelf);
        NSMutableArray * arr = [NSMutableArray array];
        for (int i = 0; i < dataArr.count ; i ++) {
//            ZEQuestionInfoModel * quesAnsDetail = [ZEQuestionInfoModel new];
//            [quesAnsDetail setValuesForKeysWithDictionary:dataArr[i]];
            ZEQuestionInfoModel * quesAnsDetail = [ZEQuestionInfoModel getDetailWithDic:dataArr[i]];
            ZENewQuetionLayout * layout = [[ZENewQuetionLayout alloc]initWithModel:quesAnsDetail];
            [arr addObject:layout];
        }
        switch (content_page) {
            case HOME_CONTENT_RECOMMAND:
                [self.recommandQuestionArr addObjectsFromArray:arr];
                break;
            case HOME_CONTENT_NEWEST:
                [self.newestQuestionArr addObjectsFromArray:arr];
                break;
            case HOME_CONTENT_BOUNS:
                [self.bonusQuestionArr addObjectsFromArray:arr];
                break;
            default:
                break;
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
    
//            _currentHomeContent = content_page;
            
            UITableView * contentTableView;
            contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
            
            MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
            contentTableView.mj_footer = footer;
            
            [contentTableView.mj_header endRefreshingWithCompletionBlock:nil];
            [contentTableView reloadData];
//        });
//
//    });

}
/**
 刷新其他页面最新数据
 
 @param dataArr 数据内容
 */

-(void)reloadContentViewWithArr:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray * arr = [NSMutableArray array];
        for (int i = 0; i < dataArr.count ; i ++) {
            ZEQuestionInfoModel * quesAnsDetail = [ZEQuestionInfoModel getDetailWithDic:dataArr[i]];
            ZENewQuetionLayout * layout = [[ZENewQuetionLayout alloc]initWithModel:quesAnsDetail];
            [arr addObject:layout];
        }
        switch (content_page) {
            case HOME_CONTENT_RECOMMAND:
                [self.recommandQuestionArr addObjectsFromArray:arr];
                break;
            case HOME_CONTENT_NEWEST:
                [self.newestQuestionArr addObjectsFromArray:arr];
                break;
            case HOME_CONTENT_BOUNS:
                [self.bonusQuestionArr addObjectsFromArray:arr];
                break;
            default:
                break;
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
    
            _currentHomeContent = content_page;
            
            UITableView * contentTableView;
            contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
            
            [contentTableView.mj_header endRefreshing];
            [contentTableView.mj_footer endRefreshing];
            [contentTableView reloadData];
            
            if (dataArr.count % MAX_PAGE_COUNT == 0 && dataArr.count > 0 ) {
                
            }else{
                UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
                [contentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
//        });
//
//    });

    
}
/**
 没有更多最新问题数据
 */
-(void)loadNoMoreDataWithHomeContent:(HOME_CONTENT)content_page;
{
    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_footer endRefreshingWithNoMoreData];
}

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshingWithHomeContent:(HOME_CONTENT)content_page;
{
    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_header endRefreshing];
}

-(void)endRefreshingWithHomeContent:(HOME_CONTENT)content_page;
{
    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    [contentTableView.mj_footer endRefreshing];
    [contentTableView.mj_header endRefreshing];
}

-(void)selectItem:(UISegmentedControl*)segControl
{
    _contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * segControl.selectedSegmentIndex, 0);
    
    _currentHomeContent = segControl.selectedSegmentIndex;
    UITableView * contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentHomeContent];
    [contentView reloadData];
        
    if([self.delegate respondsToSelector:@selector(loadNewData:)]){
        [self.delegate loadNewData:_currentHomeContent];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_contentScrollView]) {
        
        NSInteger currentIndex = 0;
        currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        _currentHomeContent = currentIndex;
        UITableView * contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentHomeContent];
        [contentView reloadData];
        
        self.segmentedControl.selectedSegmentIndex = _currentHomeContent;

        if([self.delegate respondsToSelector:@selector(loadNewData:)]){
            [self.delegate loadNewData:_currentHomeContent];
        }
    }
}
#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZENewQuestionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZENewQuestionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    
    switch (_currentHomeContent) {
        case HOME_CONTENT_RECOMMAND:
            [cell setLayout:self.recommandQuestionArr[indexPath.row]];
            break;
        case HOME_CONTENT_NEWEST:
            [cell setLayout:self.newestQuestionArr[indexPath.row]];
            break;
        case HOME_CONTENT_BOUNS:
            [cell setLayout:self.bonusQuestionArr[indexPath.row]];
            break;
        default:
            break;
    }

    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_currentHomeContent) {
        case HOME_CONTENT_RECOMMAND:
            return self.recommandQuestionArr.count;
            break;
            
        case HOME_CONTENT_NEWEST:
            return self.newestQuestionArr.count;
            break;
            
        case HOME_CONTENT_BOUNS:
            return self.bonusQuestionArr.count;
            break;
            
        default:
            break;
    }
    
    return  0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZENewQuetionLayout * layout = nil;
    switch (_currentHomeContent) {
        case HOME_CONTENT_RECOMMAND:
            layout =  self.recommandQuestionArr[indexPath.row];
            break;
            
        case HOME_CONTENT_NEWEST:
            layout =  self.newestQuestionArr[indexPath.row];
            break;
            
        case HOME_CONTENT_BOUNS:
            layout =  self.bonusQuestionArr[indexPath.row];
            break;
            
        default:
            break;
    }
    
    return  layout.height;

}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZENewQuetionLayout * layout = nil;
    
    switch (_currentHomeContent) {
        case HOME_CONTENT_RECOMMAND:
            layout = self.recommandQuestionArr[indexPath.row];
            break;
            
        case HOME_CONTENT_NEWEST:
            layout = self.newestQuestionArr[indexPath.row];
            break;
            
        case HOME_CONTENT_BOUNS:
            layout = self.bonusQuestionArr[indexPath.row];
            break;
            
        default:
            break;
    }
        
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:layout.questionInfo ];
    }
}

-(void)goDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
{
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:infoModel];
    }
}

-(void)showWebVC:(NSString *)urlStr
{
    if ([self.delegate respondsToSelector:@selector(presentWebVCWithUrl:)]) {
        [self.delegate presentWebVCWithUrl:urlStr];
    }
}


#pragma mark - ZENewQuestionListCellDelegate

-(void)goSearch{
    if ([self.delegate respondsToSelector:@selector(goSearchView)]) {
        [self.delegate goSearchView];
    }
}

-(void)goBack
{
    if ([self.delegate respondsToSelector:@selector(goBack)]) {
        [self.delegate goBack];
    }
}

-(void)giveQuestionPraise:(ZEQuestionInfoModel *)questionInfo
{
    NSInteger i = 0 ;
    
    NSMutableArray * arr = [NSMutableArray array];
    switch (_currentHomeContent) {
        case HOME_CONTENT_RECOMMAND:
            arr = self.recommandQuestionArr;
            break;
            
        case HOME_CONTENT_NEWEST:
            arr = self.newestQuestionArr;
            break;
            
        case HOME_CONTENT_BOUNS:
            arr = self.bonusQuestionArr;
            break;
            
        default:
            break;
    }
        
    for (ZENewQuetionLayout * layout in arr) {
        if ([questionInfo isEqual:layout.questionInfo]) {
            ZENewQuetionLayout * newLayout = layout;
            newLayout.questionInfo.ISGOOD = YES;
            newLayout.questionInfo.GOODNUMS = [NSString stringWithFormat:@"%ld",(long) [newLayout.questionInfo.GOODNUMS integerValue] + 1 ];
            switch (_currentHomeContent) {
                case HOME_CONTENT_RECOMMAND:
                    [self.recommandQuestionArr replaceObjectAtIndex:i withObject:newLayout];
                    break;
                    
                case HOME_CONTENT_NEWEST:
                    [self.newestQuestionArr replaceObjectAtIndex:i withObject:newLayout];
                    break;
                    
                case HOME_CONTENT_BOUNS:
                    [self.bonusQuestionArr replaceObjectAtIndex:i withObject:newLayout];
                    break;
                    
                default:
                    break;
            }

            break;
        }else{
            i ++;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(giveQuestionPraise:)]){
        [self.delegate giveQuestionPraise:questionInfo];
    }
}

-(void)answerQuestion:(ZEQuestionInfoModel *)questionInfo{
    if([self.delegate respondsToSelector:@selector(answerQuestion:)]){
        [self.delegate answerQuestion:questionInfo];
    }
}

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


-(void)plusBtnDidClick{
    if ([self.delegate respondsToSelector:@selector(askQuestion)]) {
        [self.delegate askQuestion];
    }
}

//-(void)plusBtnDidClick{
//    if ([self.delegate respondsToSelector:@selector(askQuestion)]) {
//        [self.delegate askQuestion];
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
