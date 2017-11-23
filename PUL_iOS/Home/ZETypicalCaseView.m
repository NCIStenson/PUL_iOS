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
#define kNavViewHeight 85.0f

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT + kNavViewHeight
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT + kNavViewHeight )


#import "ZETypicalCaseView.h"

#import "ZEKLB_CLASSICCASE_INFOModel.h"
@interface ZETypicalCaseView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
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
    
    newestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newestBtn setTitle:@"按最新" forState:UIControlStateNormal];
    [newestBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    [newestBtn setFrame:CGRectMake(20, 45, 80, orederView.height)];
    newestBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [newestBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:newestBtn];
    
    hotestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotestBtn setTitle:@"按最热" forState:UIControlStateNormal];
    [hotestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hotestBtn setFrame:CGRectMake(120, 45, 80, orederView.height)];
    hotestBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [hotestBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:hotestBtn];
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
        [ZEUtil addGradientLayer:navView];
        
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
    NSString *  sortOrderSQL = @"1";
    if ([btn isEqual:newestBtn]) {
        [newestBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
        [hotestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if ([btn isEqual:hotestBtn]){
        sortOrderSQL = @"2";
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
    return 100.0f;
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
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:5 superView:cellView];
    
    UIImageView * contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 70)];
    [cellView addSubview:contentImageView];
    if ([ZEUtil isStrNotEmpty:infoModel.FILEURL]) {
        [contentImageView sd_setImageWithURL:ZENITH_IMAGEURL(infoModel.FILEURL) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    }
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(115, contentImageView.top, SCREEN_WIDTH - 180, 40.0f)];
    contentLab.text = infoModel.CASENAME;
    contentLab.textColor = kTextColor;
    contentLab.numberOfLines = 2;
    contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cellView addSubview:contentLab];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld",(long)[infoModel.CLICKCOUNT integerValue]];
    
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:10] maxSize:CGSizeMake(200, 20)];

    UILabel * commentLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,contentImageView.top + 5,praiseNumWidth,20.0f)];
    commentLab.text  = praiseNumLabText;
    commentLab.font = [UIFont boldSystemFontOfSize:10];
    commentLab.textColor = MAIN_SUBTITLE_COLOR;
    [cellView addSubview:commentLab];
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 45.0f, commentLab.top + 1, 20, 15)];
    commentImg.image = [UIImage imageNamed:@"discuss_pv.png"];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    [cellView addSubview:commentImg];

    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(115,80,SCREEN_WIDTH - 120,20)];
    circleLab.text = [NSString stringWithFormat:@"简介：%@",infoModel.CASEEXPLAIN];
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [cellView addSubview:circleLab];
    
    UIImageView * typeImg = [[UIImageView alloc]initWithFrame:CGRectMake(115, 60, 15, 15)];
    typeImg.image = [UIImage imageNamed:@"answer_tag"];
    [cellView addSubview:typeImg];
    
    UILabel * _typeContentLab = [[UILabel alloc]initWithFrame:CGRectMake(typeImg.right + 10,58,SCREEN_WIDTH - 160,20)];
    _typeContentLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    _typeContentLab.text = infoModel.QUESTIONTYPENAME;
    _typeContentLab.textColor = MAIN_SUBTITLE_COLOR;
    _typeContentLab.numberOfLines = 0;
    [cellView addSubview:_typeContentLab];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(goTypicalCaseDetailVC:)]) {
        [self.delegate goTypicalCaseDetailVC:self.classicalCaseArr[indexPath.row]];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_questionSearchTF resignFirstResponder];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
