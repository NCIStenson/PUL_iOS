//
//  ZETypicalCaseView.m
//  PUL_iOS
//
//  Created by Stenson on 16/10/31.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kNavViewMarginLeft 0.0f
#define kNavViewMarginTop NAV_HEIGHT
#define kNavViewWidth SCREEN_WIDTH
#define kNavViewHeight 30.0f

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT + kNavViewHeight
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT + kNavViewHeight )


#import "ZETypicalCaseView.h"

#import "ZEKLB_CLASSICCASE_INFOModel.h"
@interface ZETypicalCaseView ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * optionBtn;
    UIButton * newestBtn;
    UIButton * hotestBtn;
    
    UIView * _optionView;
    
    UIButton * _currentBtn;
    
    UITableView * _contentView;
        
    BOOL _isShowOptionView;
    
    ENTER_CASE_TYPE _enterCaseType;
}

@property (nonatomic,strong) NSMutableArray * classicalCaseArr;

@end

@implementation ZETypicalCaseView


-(id)initWithFrame:(CGRect)frame withEnterType:(ENTER_CASE_TYPE)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _enterCaseType = type;
        [self initNavView];
        
        [self initContentView];
    }
    return self;
}

-(void)initNavView
{
    if (_enterCaseType == ENTER_CASE_TYPE_SETTING) {
        return;
    }
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
    if (_enterCaseType == ENTER_CASE_TYPE_SETTING) {
        _contentView.frame = CGRectMake(kContentViewMarginLeft, NAV_HEIGHT, kContentViewWidth, SCREEN_HEIGHT - NAV_HEIGHT);
    }
    MJRefreshHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    _contentView.mj_header = header;
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _contentView.mj_footer = footer;
}

-(void)showDecOptions
{    
    if (_isShowOptionView) {
        [self hiddenOptionView];
        optionBtn.enabled = YES;
    }else{
        
        optionBtn.enabled = NO;
        [optionBtn setImage:[UIImage imageNamed:@"icon_down.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
        
        _optionView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + kNavViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _optionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:_optionView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenOptionView)];
        [_optionView addGestureRecognizer:tap];
        
        
        UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kNavViewWidth, kNavViewHeight)];
        navView.backgroundColor = [UIColor whiteColor];
        [_optionView addSubview:navView];
        
        NSArray * typeArr = @[@"类型",@"全部",@"视频",@"图片",@"文档",@"其他"];
        
        for (int i = 0; i < typeArr.count; i++ ) {
            UIButton *  typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [typeBtn setTitle:typeArr[i] forState:UIControlStateNormal];
            [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [typeBtn setFrame:CGRectMake(10 + 45 * i, 0, 40, kNavViewHeight)];
            typeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            typeBtn.tag = i;
            if (i == 0) {
                typeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            }else if ([typeArr[i] isEqualToString:optionBtn.titleLabel.text]){
                [typeBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
            }
            [typeBtn addTarget:self action:@selector(chooseDifferentOption:) forControlEvents:UIControlEventTouchUpInside];
            [navView addSubview:typeBtn];
        }
        
    }
    _isShowOptionView = !_isShowOptionView;
}

-(void)chooseDifferentOption:(UIButton *)btn
{
    optionBtn.enabled = YES;

    if(btn.tag == 0){
        [self hiddenOptionView];
        return;
    }
    NSArray * typeArr = @[@"类型",@"全部",@"视频",@"图片",@"文档",@"其他"];

    [optionBtn setTitle:typeArr[btn.tag] forState:UIControlStateNormal];
    
    [self hiddenOptionView];
    
    if ([self.delegate respondsToSelector:@selector(screenFileType:)]) {
        [self.delegate screenFileType:typeArr[btn.tag]];
    }
}

-(void)hiddenOptionView{
    _isShowOptionView = NO;
    optionBtn.enabled = YES;

    [optionBtn setImage:[UIImage imageNamed:@"icon_up.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    [_optionView removeFromSuperview];
    _optionView = nil;
}


-(void)sortCondition:(UIButton *)btn
{
    [self hiddenOptionView];
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

-(void)reloadFirstView:(NSArray *)arrData
{
    self.classicalCaseArr = [NSMutableArray array];
    [self reloadMoreDataView:arrData];
}

-(void)reloadMoreDataView:(NSArray *)arrData
{
    [self.classicalCaseArr addObjectsFromArray:arrData];
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
    return self.classicalCaseArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    while ([cell.contentView subviews].lastObject) {
        [[[cell.contentView subviews] lastObject] removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initCellView:cell.contentView withIndexpath:indexPath];
    
    return cell;
}

-(void)initCellView:(UIView *)cellView withIndexpath:(NSIndexPath *)indexPath
{
    ZEKLB_CLASSICCASE_INFOModel * infoModel = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:self.classicalCaseArr[indexPath.row]];
    
    UIImageView * contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 100, 70)];
    [cellView addSubview:contentImageView];
    if ([ZEUtil isStrNotEmpty:infoModel.FILEURL]) {
        [contentImageView sd_setImageWithURL:ZENITH_IMAGEURL(infoModel.FILEURL) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    }
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(115, 5, SCREEN_WIDTH - 120, 40.0f)];
    contentLab.text = infoModel.CASENAME;
    contentLab.numberOfLines = 2;
    contentLab.font = [UIFont systemFontOfSize:12];
    [cellView addSubview:contentLab];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld",(long)[infoModel.CLICKCOUNT integerValue]];
    
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:10] maxSize:CGSizeMake(200, 20)];

    UILabel * commentLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,60,praiseNumWidth,20.0f)];
    commentLab.text  = praiseNumLabText;
    commentLab.font = [UIFont boldSystemFontOfSize:10];
    commentLab.textColor = MAIN_SUBTITLE_COLOR;
    [cellView addSubview:commentLab];
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 45.0f, 60.0f, 20, 15)];
    commentImg.image = [UIImage imageNamed:@"discuss_pv.png"];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    [cellView addSubview:commentImg];

    // 圈组分类最右边
    float circleTypeR = SCREEN_WIDTH - praiseNumWidth - 30;
    
    float circleWidth = [ZEUtil widthForString:infoModel.CASESCORE font:[UIFont systemFontOfSize:10.0f] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(circleTypeR - circleWidth - 50.0f, 60.0f, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"coursecell_list_score.png"];
    [cellView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,58.0f,circleWidth,20.0f)];
    circleLab.text = infoModel.CASESCORE;
    circleLab.font = [UIFont systemFontOfSize:10.0f];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [cellView addSubview:circleLab];
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(goTypicalCaseDetailVC:)]) {
        [self.delegate goTypicalCaseDetailVC:self.classicalCaseArr[indexPath.row]];
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
-(void)showOptions
{
    if ([self.delegate respondsToSelector:@selector(showType)]) {
        [self.delegate showType];
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
