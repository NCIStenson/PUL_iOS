//
//  ZEHomeView.m
//  PUL_iOS
//
//  Created by Stenson on 16/7/22.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. . All rights reserved.
//

#define kQuestionTitleFontSize      kTiltlFontSize
#define kQuestionSubTitleFontSize   kSubTiltlFontSize

#define kHomeMarkFontSize       16.0f
#define kHomeTitleFontSize      kTiltlFontSize
#define kHomeSubTitleFontSize   kSubTiltlFontSize

#define kNavBarMarginLeft   0.0f
#define kNavBarMarginTop    0.0f
#define kNavBarWidth        SCREEN_WIDTH
#define kNavBarHeight       SCREEN_HEIGHT * 0.11

// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 10.0f
#define kLeftButtonMarginTop (IPHONEX ? 40.0f : 20.0f + 2.0f)

#define kNavTitleLabelWidth (SCREEN_WIDTH - 110.0f)
#define kNavTitleLabelHeight 44.0f
#define kNavTitleLabelMarginLeft (kNavBarWidth - kNavTitleLabelWidth) / 2.0f
#define kNavTitleLabelMarginTop ( IPHONEX ? 40.0f : 20.0f)

#define kSearchTFMarginLeft   70.0f
#define kSearchTFMarginTop    27.0f
#define kSearchTFWidth        SCREEN_WIDTH - 120.0f
#define kSearchTFHeight       30.0f

#define kTypicalViewMarginLeft  0.0f
#define kTypicalViewMarginTop   0.0f
#define kTypicalViewWidth       SCREEN_WIDTH
#define kTypicalViewHeight      135.0f

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   ( kNavBarHeight + 35.0f )
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - kContentTableMarginTop

#import "ZEHomeView.h"
#import "PYPhotoBrowser.h"
#import "ZEKLB_CLASSICCASE_INFOModel.h"

@interface ZEHomeView ()
{
    UITextField * searchTF;
    UILabel * signinLab;
    UILabel * subSigninLab;
    UILabel * goSignInLab;
    
    UIScrollView * _labelScrollView;  // 展示出的分类名称
    UIScrollView * _contentScrollView; // 展示出的问题内容
    
    UIImageView * _lineImageView;
    
    NSArray * _allTypeArr;
    
    BOOL isSignin;
    
    NSInteger _currentHomeContentPage; // 当前显示的页面 0 最新 1 推荐 2 高悬赏
}

@property (nonatomic,strong) NSMutableArray * newestQuestionArr;
@property (nonatomic,strong) NSMutableArray * recommandQuestionArr;
@property (nonatomic,strong) NSMutableArray * bonusQuestionArr;

@end

@implementation ZEHomeView


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
    _allTypeArr = @[@"最新",@"推荐",@"悬赏"];

    _currentHomeContentPage = HOME_CONTENT_NEWEST;
    
    [self initNavBar];
    [self initContentView];
    [self addSubview:[self createTypicalCaseView]];
//    [self initSignInView:self];
}

-(void)initNavBar
{
    UIView * navView = [[UIView alloc] initWithFrame:CGRectZero];
    navView.backgroundColor = MAIN_NAV_COLOR;
    [self addSubview:navView];
    navView.frame = CGRectMake(kNavBarMarginLeft, kNavBarMarginTop, kNavBarWidth, kNavBarHeight);

    [ZEUtil addGradientLayer:navView];
    
    UIButton * _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, kLeftButtonWidth, kLeftButtonHeight);
    if(IPHONE6_MORE){
        _typeBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, 50, 50);
    }
    _typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0, 0.0f, 0.0f);
    _typeBtn.contentMode = UIViewContentModeScaleAspectFill;
    _typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_typeBtn setImage:[UIImage imageNamed:@"icon_back" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_typeBtn];
    
    UILabel * _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNavTitleLabelMarginLeft, kNavTitleLabelMarginTop, kNavTitleLabelWidth, kNavTitleLabelHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:22.0f];
    _titleLabel.text = @"知道问答";
    _titleLabel.numberOfLines = 0;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [navView addSubview:_titleLabel];
    
    for (int i = 1; i < 4; i ++) {
        UIButton * _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeBtn.frame = CGRectMake(SCREEN_WIDTH - 140 + 33 * i, (IPHONEX ? 47 : 27.0f), 30.0, 30.0);
        _typeBtn.contentMode = UIViewContentModeScaleAspectFit;
        _typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [navView addSubview:_typeBtn];
        _typeBtn.tag = i + 100;
        if (i == 1){
            [_typeBtn setImage:[UIImage imageNamed:@"yy_nav_search" ] forState:UIControlStateNormal];
            [_typeBtn addTarget:self action:@selector(goSearchView) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 2){
            [_typeBtn setImage:[UIImage imageNamed:@"type" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [_typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 3){
            [_typeBtn setImage:[UIImage imageNamed:@"yy_nav_why" ] forState:UIControlStateNormal];
            [_typeBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
#pragma mark - 导航栏搜索界面

-(UIView *)searchTextfieldView:(float)height
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, height)];
    searchTFView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, ( height - height * 0.6 ) / 2, height * 0.6, height * 0.6)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon"];
    [searchTFView addSubview:searchTFImg];
    searchTFImg.contentMode = UIViewContentModeScaleAspectFill;
    
    searchTF =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, height)];
    [searchTFView addSubview:searchTF];
    searchTF.placeholder = @"搜索你想知道的问题";
    [searchTF setReturnKeyType:UIReturnKeySearch];
    searchTF.font = [UIFont systemFontOfSize:IPHONE6P ? 16 : 14];
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, height * 0.6 + 7, height)];
    searchTF.delegate=self;

    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = height / 2;
    
    return searchTFView;
}

#pragma mark - 签到界面

-(void)initSignInView:(UIView *)fView
{
    UIButton * singInView = [UIButton buttonWithType:UIButtonTypeCustom];
    singInView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
    singInView.backgroundColor = [UIColor whiteColor];
    [singInView addTarget:self action:@selector(goSingInView) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)MAIN_NAV_COLOR.CGColor, (__bridge id) MAIN_LINE_COLOR.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65.0f);
    [singInView.layer addSublayer:layer];
    
    signinLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 20)];
    signinLab.userInteractionEnabled = NO;
    signinLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    signinLab.text = @"本月已签到 0 天";
    [singInView addSubview:signinLab];
    
    subSigninLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 200, 20)];
    subSigninLab.userInteractionEnabled = NO;
    subSigninLab.font = [UIFont systemFontOfSize:kHomeTitleFontSize];
    subSigninLab.attributedText = [self getAttrText:@"您已帮助了 0 位员工"];
    [singInView addSubview:subSigninLab];
    
    goSignInLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 70, 50)];
    goSignInLab.text = @"去签到 >";
    goSignInLab.textColor = MAIN_NAV_COLOR;
    goSignInLab.userInteractionEnabled = NO;
    
    goSignInLab.textAlignment = NSTextAlignmentRight;
    goSignInLab.font = [UIFont systemFontOfSize:14];
    [singInView addSubview:goSignInLab];
    
    UIView * grayLine = [[UIView alloc]init];
    grayLine.frame = CGRectMake(0, 60, SCREEN_WIDTH, 5);
    [singInView addSubview:grayLine];
    grayLine.backgroundColor = MAIN_LINE_COLOR;
    
    [fView addSubview:singInView];
    
    if (isSignin) {
        signinLab.text = @"今日已签到";
        goSignInLab.text = @"去看看 >";
    }
}

#pragma mark - 经典案例

-(UIView *)createTypicalCaseView
{
    _labelScrollView = [[UIScrollView alloc]init];
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.left = 0.0f;
    _labelScrollView.top = kNavBarHeight;
    _labelScrollView.width = SCREEN_WIDTH;
    _labelScrollView.height = 35.0f;
    
    _lineImageView = [[UIImageView alloc]init];
    _lineImageView.frame = CGRectMake(0, 33.0f, SCREEN_WIDTH / 3, 2.0f);
    _lineImageView.backgroundColor = MAIN_GREEN_COLOR;
    [_labelScrollView addSubview:_lineImageView];
    
    float marginLeft = 0;
    
    for (int i = 0 ; i < _allTypeArr.count; i ++) {
        UIButton * labelContentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        labelContentBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [_labelScrollView addSubview:labelContentBtn];
        [labelContentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(i == 0){
            [labelContentBtn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
        }
        labelContentBtn.top = 0.0f;
        labelContentBtn.height = 33.0f;
        [labelContentBtn setTitle:_allTypeArr[i] forState:UIControlStateNormal];
        [labelContentBtn addTarget:self action:@selector(selectDifferentType:) forControlEvents:UIControlEventTouchUpInside];
        labelContentBtn.tag = 100 + i;
//        labelContentBtn.width = [ZEUtil widthForString:_allTypeArr[i] font:[UIFont systemFontOfSize:kTiltlFontSize] maxSize:CGSizeMake(SCREEN_WIDTH, 33.0f)] + 20.0f;
        labelContentBtn.width = SCREEN_WIDTH / 3;
        labelContentBtn.left = marginLeft;
        
        marginLeft += labelContentBtn.width;
    }
    
    
    return _labelScrollView;
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
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNewestData:)];
        contentTableView.mj_header = header;
    }
    
}
-(void)plusBtnDidClick{
    if ([self.delegate respondsToSelector:@selector(askQuestion)]) {
        [self.delegate askQuestion];
    }
}

#pragma mark - 选择上方分类

-(void)selectDifferentType:(UIButton *)btn
{
    _currentHomeContentPage = btn.tag - 100;

    UITableView * contentView = (UITableView *)[_contentScrollView viewWithTag:btn.tag];
    [contentView reloadData];
    
    float marginLeft = 0;
    
    for (int i = 0 ; i < _allTypeArr.count; i ++) {
        
        UIButton * button = [btn.superview viewWithTag:100 + i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

//        float btnWidth = [ZEUtil widthForString:_allTypeArr[i] font:[UIFont systemFontOfSize:kTiltlFontSize] maxSize:CGSizeMake(SCREEN_WIDTH, 33.0f)] + 20.0f;
        float btnWidth = SCREEN_WIDTH / 3;
        if (btn.tag - 100 == i) {
            [UIView animateWithDuration:0.35 animations:^{
                _lineImageView.frame = CGRectMake(marginLeft, 33.0f, btnWidth, 2.0f);
                _contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * i, 0);
            }];
        }
        marginLeft += btnWidth;
    }
    [btn setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
    
    if([self.delegate respondsToSelector:@selector(loadNewData:)]){
        [self.delegate loadNewData:_currentHomeContentPage];
    }
}


#pragma mark - Public Method

-(void)reloadSigninedViewDay:(NSString *)dayStr numbers:(NSString *)number
{
    isSignin = YES;
    signinLab.text = [NSString stringWithFormat:@"本月已签到%@天",dayStr];
    if ([dayStr integerValue] > 0){
        signinLab.attributedText = [self getAttrText:[NSString stringWithFormat:@"本月已签到 %@ 天",dayStr]];
    }
    if ([number integerValue] > 0){
        subSigninLab.attributedText = [self getAttrText:[NSString stringWithFormat:@"您已帮助了 %@ 位员工",number]];
    }
    goSignInLab.text = @"去看看 >";
}
-(void)hiddenSinginView
{
    UITableView * contentTableView = (UITableView *)[_contentScrollView viewWithTag:100];
    
    contentTableView.frame = CGRectMake(kContentTableMarginLeft, kContentTableMarginTop - 60.0, kContentTableWidth, kContentTableHeight + 60.0f);
    
    [signinLab.superview removeFromSuperview];
}

#pragma mark - 最新页面

/**
 刷新第一页面最新数据

 @param dataArr 数据内容
 */
-(void)reloadFirstView:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;
{
    UITableView * contentTableView;
    
    switch (content_page) {
        case HOME_CONTENT_RECOMMAND:
            self.recommandQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        case HOME_CONTENT_NEWEST:
            self.newestQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        case HOME_CONTENT_BOUNS:
            self.bonusQuestionArr = [NSMutableArray arrayWithArray:dataArr];
            break;
        default:
            break;
    }
    contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    contentTableView.mj_footer = footer;

    [contentTableView.mj_header endRefreshingWithCompletionBlock:nil];
    [contentTableView reloadData];
}
/**
 刷新其他页面最新数据
 
 @param dataArr 数据内容
 */

-(void)reloadContentViewWithArr:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page;
{
    UITableView * contentTableView;
    
    switch (content_page) {
        case HOME_CONTENT_RECOMMAND:
            [self.recommandQuestionArr addObjectsFromArray:dataArr];
            break;
        case HOME_CONTENT_NEWEST:
            [self.newestQuestionArr addObjectsFromArray:dataArr];
            break;
        case HOME_CONTENT_BOUNS:
            [self.bonusQuestionArr addObjectsFromArray:dataArr];
            break;
        default:
            break;
    }
    contentTableView = (UITableView *)[_contentScrollView viewWithTag:100 + content_page];

    [contentTableView.mj_header endRefreshing];
    [contentTableView.mj_footer endRefreshing];
    [contentTableView reloadData];
}
-(void)reloadContentViewWithNoMoreData:(NSArray *)dataArr withHomeContent:(HOME_CONTENT)content_page
{

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

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_currentHomeContentPage) {
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case HOME_CONTENT_RECOMMAND:
            datasDic = self.recommandQuestionArr[indexPath.row];
            break;
            
        case HOME_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexPath.row];
            break;
            
        case HOME_CONTENT_BOUNS:
            datasDic = self.bonusQuestionArr[indexPath.row];
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
    
    if(quesInfoM.FILEURLARR.count > 0){
        return questionHeight + kCellImgaeHeight + tagHeight + 70.0f;

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
    [self createAnswerViewWithIndexpath:indexPath withView:cell.contentView] ;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case HOME_CONTENT_RECOMMAND:
            datasDic = self.recommandQuestionArr[indexPath.row];
            break;
            
        case HOME_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexPath.row];
            break;
            
        case HOME_CONTENT_BOUNS:
            datasDic = self.bonusQuestionArr[indexPath.row];
            break;
            
        default:
            break;
    }

    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
//    
//    ZEQuestionTypeModel * questionTypeM = nil;
//    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
//        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
//        if ([typeM.CODE isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
//            questionTypeM = typeM;
//        }
//    }
    
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:quesInfoM ];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_contentScrollView]) {
        
        NSInteger currentIndex = 0;
        
        currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;

        float marginLeft = 0;
        
        for (int i = 0 ; i < _allTypeArr.count; i ++) {
            
            UIButton * button = [_labelScrollView viewWithTag:100 + i];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            float btnWidth = SCREEN_WIDTH / 3;

            if (currentIndex == i) {
                [UIView animateWithDuration:0.35 animations:^{
                    _lineImageView.frame = CGRectMake(marginLeft, 33.0f, btnWidth, 2.0f);
                }];
                _currentHomeContentPage = i;
                UITableView * contentView = (UITableView *)[_contentScrollView viewWithTag:100 + _currentHomeContentPage];
                [contentView reloadData];

                [button setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
            }
            marginLeft += btnWidth;
        }
        if([self.delegate respondsToSelector:@selector(loadNewData:)]){
            [self.delegate loadNewData:_currentHomeContentPage];
        }
    }
}

#pragma mark - 回答问题

-(UIView *)createAnswerViewWithIndexpath:(NSIndexPath *)indexpath withView:(UIView *)questionsView
{
    NSDictionary * datasDic = nil;
    
    switch (_currentHomeContentPage) {
        case HOME_CONTENT_RECOMMAND:
            datasDic = self.recommandQuestionArr[indexpath.row];
            break;
            
        case HOME_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[indexpath.row];
            break;
            
        case HOME_CONTENT_BOUNS:
            datasDic = self.bonusQuestionArr[indexpath.row];
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
    
    UIView * messageLineView = [[UIView alloc]initWithFrame:CGRectMake(0, userY, SCREEN_WIDTH, 0.5)];
    messageLineView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:messageLineView];
    
    userY += 5.0f;
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
    if(!quesInfoM.ISANONYMITY){
        [userImg sd_setImageWithURL:ZENITH_IMAGEURL(quesInfoM.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    }
    [questionsView addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * QUESTIONUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(45,userY,100.0f,20.0f)];
    QUESTIONUSERNAME.text = quesInfoM.NICKNAME;
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
    
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, userY + 25.0f, SCREEN_WIDTH, 5.0f)];
    grayView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:grayView];
    
    questionsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, userY + 30.0f);

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

-(void)goSearchView
{
    if ([self.delegate respondsToSelector:@selector(goSearch:)]) {
        [self.delegate goSearch:@""];
    }
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

-(void)goNotiVC
{
    if([self.delegate respondsToSelector:@selector(goNotiVC)]){
        [self.delegate goNotiVC];
    }
}

-(void)goSingInView
{
    if ([self.delegate respondsToSelector:@selector(goSinginView)]) {
        [self.delegate goSinginView];
    }
}

-(void)goMoreQuesVC:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(goMoreQuestionsView)]){
        [self.delegate goMoreQuestionsView];
    }
}

//  分类图标点击

-(void)typeBtnClick
{
    if ([self.delegate respondsToSelector:@selector(goTypeQuestionVC)]) {
        [self.delegate goTypeQuestionVC];
    }
}


-(void)goBack
{
    if ([self.delegate respondsToSelector:@selector(goBack)]) {
        [self.delegate goBack];
    }
}


/**
 页面直接回答问题
 */
-(void)answerQuestion:(UIButton *)btn
{
    NSDictionary * datasDic = nil;
    switch (_currentHomeContentPage) {
        case HOME_CONTENT_RECOMMAND:
            datasDic = self.recommandQuestionArr[btn.tag];
            break;
            
        case HOME_CONTENT_NEWEST:
            datasDic = self.newestQuestionArr[btn.tag];
            break;
            
        case HOME_CONTENT_BOUNS:
            datasDic = self.bonusQuestionArr[btn.tag];
            break;
            
        default:
            break;
    }
    
    ZEQuestionInfoModel * questionInfoModel = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    if ([self.delegate respondsToSelector:@selector(goAnswerQuestionVC:)]) {
        [self.delegate goAnswerQuestionVC:questionInfoModel];
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
