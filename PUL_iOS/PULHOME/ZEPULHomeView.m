//
//  ZEPULHomeView.m
//  PUL_iOS
//
//  Created by Stenson on 17/7/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kNavBarMarginLeft   0.0f
#define kNavBarMarginTop    0.0f
#define kNavBarWidth        SCREEN_WIDTH
#define kNavBarHeight       (43 + (IPHONE6_MORE ? 35 : 30))
// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 15.0f
#define kLeftButtonMarginTop 20.0f + 2.0f

#define kSearchTFMarginLeft   25.0f
#define kSearchTFMarginTop    27.0f
#define kSearchTFWidth        SCREEN_WIDTH - 50.0f
#define kSearchTFHeight       (IPHONE6_MORE ? 35 : 30)


#define kServerBtnWidth (SCREEN_WIDTH - 40 ) / 4

#define kCustomBtnWidth (SCREEN_WIDTH - 40 ) / 4

#import "ZEPULHomeView.h"
#import "ZEButton.h"
#import "ZEPULHomeDynamicCell.h"

@interface ZEPULHomeView()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    CGRect _PULHomeViewFrame;
    
    UITableView * _contentTableView;
    
    UITextField * searchTF;
}

@property (nonatomic,retain) NSMutableArray * PULHomeRequestionData;
@property (nonatomic,retain) NSMutableArray * commandStudyDataArr;

@property (nonatomic,retain) NSMutableArray * homeBtnArr;

@end

@implementation ZEPULHomeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _PULHomeViewFrame = frame;
        [self initNavBar];
        
        self.homeBtnArr = [NSMutableArray array];
                
        [self initPULHomeView];
    }
    return self;
}

-(void)initNavBar
{
    UIView * navView = [[UIView alloc] initWithFrame:CGRectZero];
    //    navView.backgroundColor = MAIN_NAV_COLOR;
    [self addSubview:navView];
    navView.frame = CGRectMake(kNavBarMarginLeft, kNavBarMarginTop, kNavBarWidth, kNavBarHeight);
    
    //  添加渐变色
    [ZEUtil addGradientLayer:navView];
    
    UIView * searchView = [self searchTextfieldView:kSearchTFHeight];
    [navView addSubview:searchView];
    searchView.frame = CGRectMake(kSearchTFMarginLeft, kSearchTFMarginTop, kSearchTFWidth, kSearchTFHeight);
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, searchView.bottom + 15.0f, SCREEN_WIDTH, 1);
    lineLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    [navView.layer addSublayer:lineLayer];
    
    
}

#pragma mark - 导航栏搜索界面

-(UIView *)searchTextfieldView:(float)height
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, height)];
    searchTFView.backgroundColor = [UIColor whiteColor];
    searchTFView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
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
    searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, height * 0.6 + 20, height)];
    searchTF.delegate=self;
    
    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = 2;
    
    return searchTFView;
}


-(void)initPULHomeView
{
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, _PULHomeViewFrame.size.height - kNavBarHeight) style:UITableViewStyleGrouped];
    _contentTableView.delegate =self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    _contentTableView.backgroundColor = [UIColor whiteColor];
    [_contentTableView registerClass:[ZEPULHomeDynamicCell class] forCellReuseIdentifier:@"cell"];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    _contentTableView.mj_header = header;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - Public Method

/**
 刷新第一页面最新数据
 
 @param dataArr 数据内容
 */
-(void)reloadFirstView:(NSArray *)dataArr;
{
    self.PULHomeRequestionData = [NSMutableArray arrayWithArray:dataArr];
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    _contentTableView.mj_footer = footer;
    
    [_contentTableView.mj_header endRefreshingWithCompletionBlock:nil];
    [_contentTableView reloadData];
}
/**
 刷新其他页面最新数据
 
 @param dataArr 数据内容
 */

-(void)reloadContentViewWithArr:(NSArray *)dataArr;
{
    
    [self.PULHomeRequestionData addObjectsFromArray:dataArr];
    
    [_contentTableView.mj_header endRefreshing];
    [_contentTableView.mj_footer endRefreshing];
    [_contentTableView reloadData];
}
-(void)reloadContentViewWithNoMoreData:(NSArray *)dataArr
{
    
}
/**
 没有更多最新问题数据
 */
-(void)loadNoMoreData;
{
    [_contentTableView.mj_footer endRefreshingWithNoMoreData];
}

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshing;
{
    [_contentTableView.mj_header endRefreshing];
}

-(void)endRefreshing;
{
    [_contentTableView.mj_footer endRefreshing];
    [_contentTableView.mj_header endRefreshing];
}

-(void)reloadHeaderView:(NSArray *)arr
{
    self.homeBtnArr = [NSMutableArray arrayWithArray:arr];
    [_contentTableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.PULHomeRequestionData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 135;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    
    ZEPULHomeDynamicCell * cell  = [[ZEPULHomeDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    [cell reloadCellView:[ZEQuestionInfoModel getDetailWithDic:self.PULHomeRequestionData[indexPath.row]]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((self.homeBtnArr.count + 1 ) % 4 == 0) {
        return ((self.homeBtnArr.count + 1) / 4 + 1) * kCustomBtnWidth ;
    }
    
    return ((self.homeBtnArr.count + 1) / 4 + 2) * kCustomBtnWidth;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    
    UIView * bigIconView = [UIView new];
    bigIconView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kServerBtnWidth);
    [headerView addSubview:bigIconView];
    [ZEUtil addGradientLayer:bigIconView];
    [self initBigIconView:bigIconView];
    
    UIView * customIconView = [UIView new];
    [headerView addSubview:customIconView];
    customIconView.frame = CGRectMake(0, bigIconView.bottom, SCREEN_WIDTH, kCustomBtnWidth);
    [self initCustomIconView:customIconView];
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:customIconView.bottom width:SCREEN_WIDTH height:5 superView:headerView];
    return headerView;
}

-(void)initBigIconView:(UIView *)superView
{
    for (int i = 0 ; i < 4; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(20 + kServerBtnWidth * i, 0, kServerBtnWidth, kServerBtnWidth);
        [superView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor clearColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 200;
        [optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        switch (i) {
                case 0:
                [optionBtn setImage:[UIImage imageNamed:@"home_btn_bank"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"能力题库" forState:UIControlStateNormal];
                break;
                case 1:
                [optionBtn setImage:[UIImage imageNamed:@"home_btn_ask" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"知道问答" forState:UIControlStateNormal];
                break;
                case 2:
                [optionBtn setImage:[UIImage imageNamed:@"home_btn_school_white" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"能力学堂" forState:UIControlStateNormal];
                break;
                case 3:
                [optionBtn setImage:[UIImage imageNamed:@"home_btn_dev" ] forState:UIControlStateNormal];
                [optionBtn setTitle:@"员工发展" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        if (i == 0) {
            [optionBtn setSelected:YES];
        }
    }
}

-(void)initCustomIconView:(UIView *)superView
{
    for (int i = 0 ; i < self.homeBtnArr.count + 1; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(20 + kCustomBtnWidth * (i % 4),  kCustomBtnWidth * (i / 4), kCustomBtnWidth, kCustomBtnWidth );
        [superView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor clearColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        optionBtn.tag = i + 200;
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        
        if (i == self.homeBtnArr.count) {
            [optionBtn setImage:[UIImage imageNamed:@"home_btn_more"] forState:UIControlStateNormal];
            [optionBtn setTitle:@"更多" forState:UIControlStateNormal];
            [optionBtn addTarget:self action:@selector(goMoreFunction) forControlEvents:UIControlEventTouchUpInside];
            superView.height = kCustomBtnWidth * (i / 4) + kCustomBtnWidth;
            return;
        }else{
            NSDictionary *dic = self.homeBtnArr[i];
            [optionBtn setTitle:[dic objectForKey:@"FUNCTIONNAME"] forState:UIControlStateNormal];
            [optionBtn sd_setImageWithURL:ZENITH_IMAGEURL([[dic objectForKey:@"FUNCTIONURL"] stringByReplacingOccurrencesOfString:@"," withString:@""]) forState:UIControlStateNormal];
            [self addBtnSelector:[dic objectForKey:@"FUNCTIONCODE"] withButton:optionBtn];
        }

    }
}

-(void)addBtnSelector:(NSString *)functionCode withButton:(UIButton *)button
{
    if ([functionCode isEqualToString:@"zjzx"]) {
        /**
         专家在线 专业圈
         */
        [button addTarget:self action:@selector(goZJZX) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"zyq"]){
        /**
         专家在线 专业圈
         */
        [button addTarget:self action:@selector(goZYQ) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"zyxgcp"]){
        /**
         职业性格测评
         */
        [button addTarget:self action:@selector(goZYXGCP) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"gwtx"]){
        /**
         岗位体系
         */
        [button addTarget:self action:@selector(goGWTX) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"gwcp"]){
        /**
         岗位测评
         */
        [button addTarget:self action:@selector(goGWCP) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"xwgf"]){
        /**
         行为规范
         */
        [button addTarget:self action:@selector(goXWGF) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"zxcs"]){
        /**
         在线测试
         */
        [button addTarget:self action:@selector(goZXCS) forControlEvents:UIControlEventTouchUpInside];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = nil;
    
    datasDic = self.PULHomeRequestionData[indexPath.row];
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:quesInfoM ];
    }
}

-(void)answerQuestion:(UIButton *)btn
{
    NSDictionary * datasDic = self.PULHomeRequestionData[btn.tag];
    ZEQuestionInfoModel * questionInfoModel = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    if ([self.delegate respondsToSelector:@selector(goAnswerQuestionVC:)]) {
        [self.delegate goAnswerQuestionVC:questionInfoModel];
    }
    
}

#pragma mark - ZEPULHomeViewDelegate

-(void)didSelectMyOption:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(serverBtnClick:)]){
        [self.delegate serverBtnClick:btn.tag - 200];
    }
}

-(void)loadNewData:(MJRefreshHeader *)header
{
    if([self.delegate respondsToSelector:@selector(loadNewData)]){
        [self.delegate loadNewData];
    }
}

-(void)loadMoreData:(MJRefreshFooter *)footer
{
    if([self.delegate respondsToSelector:@selector(loadMoreData)]){
        [self.delegate loadMoreData];
    }
}

#pragma mark - 自定义功能区页面跳转


/**
 跳转专业圈
 */
-(void)goZYQ
{
    if ([self.delegate respondsToSelector:@selector(goZYQ)]) {
        [self.delegate goZYQ];
    }
}
/**
 跳转专业圈
 */
-(void)goGWCP
{
    if ([self.delegate respondsToSelector:@selector(goGWCP)]) {
        [self.delegate goGWCP];
    }
}

/**
 职业性格测评
 */
-(void)goZYXGCP
{
    if ([self.delegate respondsToSelector:@selector(goZYXGCP)]) {
        [self.delegate goZYXGCP];
    }
}
/**
 岗位体系
 */
-(void)goGWTX
{
    if ([self.delegate respondsToSelector:@selector(goGWTX)]) {
        [self.delegate goGWTX];
    }
}

/**
 专家在线
 */
-(void)goZJZX{
    if ([self.delegate respondsToSelector:@selector(goZJZX)]) {
        [self.delegate goZJZX];
    }
}

/**
 行为规范
 */
-(void)goXWGF{
    if ([self.delegate respondsToSelector:@selector(goXWGF)]) {
        [self.delegate goXWGF];
    }
}


/**
 在线测试
 */
-(void)goZXCS{
    if ([self.delegate respondsToSelector:@selector(goZXCS)]) {
        [self.delegate goZXCS];
    }
}


/**
 更多功能
 */
-(void)goMoreFunction
{
    if ([self.delegate respondsToSelector:@selector(goMoreFunction)]) {
        [self.delegate goMoreFunction];
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
