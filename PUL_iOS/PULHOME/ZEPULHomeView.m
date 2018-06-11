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
#define kNavBarHeight       ((IPHONEX ? 63 : 43) + (IPHONE6_MORE ? 35 : 30))
// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 15.0f
#define kLeftButtonMarginTop 20.0f + 2.0f

#define kSearchTFMarginLeft   25.0f
#define kSearchTFMarginTop    (IPHONEX ? 47.0f : 27.0f)
#define kSearchTFWidth        SCREEN_WIDTH - 50.0f
#define kSearchTFHeight       (IPHONE6_MORE ? 35 : 30)


#define kServerBtnWidth (SCREEN_WIDTH - 10 ) / 4

#define kCustomBtnWidth (SCREEN_WIDTH - 10 ) / 4

#import "ZEPULHomeView.h"
#import "ZEButton.h"
#import "ZEPULHomeDynamicCell.h"

@interface ZEPULHomeView()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,ZEHomeOptionViewDelegate,UIGestureRecognizerDelegate>
{
    CGRect _PULHomeViewFrame;
    
    UITableView * _contentTableView;
    
    UITextField * searchTF;
    
    ZEPULHomeModel * _currentSelectHomeModel; // 当前选择的忽略动态
    
    BOOL _viewIsEditing;
    NSString * _clickFunctionCode;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

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
    lineLayer.frame = CGRectMake(0, searchView.bottom + 15.0f, SCREEN_WIDTH, 0.5);
    lineLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    [navView.layer addSublayer:lineLayer];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self downTheKeyboard];
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
#pragma mark - UITapGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件(只解除的是cell与手势间的冲突，cell以外仍然响应手势)
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        return NO;
    }
    
    // 若为UITableView（即点击了tableView任意区域），则不截获Touch事件(完全解除tableView与手势间的冲突，cell以外也不会再响应手势)
    if ([touch.view isKindOfClass:[UITableView class]]){
        return NO;
    }
    return YES;
}

-(void)keyboardWillShow:(NSNotification *)noti{
    _viewIsEditing = YES;
}

-(void)downTheKeyboard
{
    _viewIsEditing = NO;
    [self endEditing:YES];
}

#pragma mark - 导航栏搜索界面

-(UIView *)searchTextfieldView:(float)height
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, height)];
    searchTFView.backgroundColor = [UIColor whiteColor];
    searchTFView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, ( height - height * 0.6 ) / 2, height * 0.6, height * 0.6)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon" color:[UIColor whiteColor]];
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
    searchTF.textColor = [UIColor whiteColor];
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
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
//    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
//    _contentTableView.mj_footer = footer;
    
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
    [cell reloadCellView:[ZEPULHomeModel getDetailWithDic:self.PULHomeRequestionData[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.optionBtn.tag = indexPath.row + 100;
    [cell.optionBtn addTarget:self action:@selector(showOptionView:) forControlEvents:UIControlEventTouchUpInside];

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
        optionBtn.frame = CGRectMake(5 + kServerBtnWidth * i, 0, kServerBtnWidth, kServerBtnWidth);
        [superView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor clearColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 200;
        [optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
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
        optionBtn.frame = CGRectMake(5 + kCustomBtnWidth * (i % 4),  kCustomBtnWidth * (i / 4), kCustomBtnWidth, kCustomBtnWidth );
        [superView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
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
            NSString * titleStr =[dic objectForKey:@"FUNCTIONNAME"];
            [optionBtn setTitle:titleStr forState:UIControlStateNormal];
            optionBtn.tag = 100 + i;
            [optionBtn sd_setImageWithURL:ZENITH_IMAGEURL([[dic objectForKey:@"FUNCTIONURL"] stringByReplacingOccurrencesOfString:@"," withString:@""]) forState:UIControlStateNormal];
            [self addBtnSelector:[dic objectForKey:@"FUNCTIONCODE"] withButton:optionBtn];
            if (IPHONE5 && titleStr.length > 5) {
                optionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            }
            if([[dic objectForKey:@"IS_SPREAD"] boolValue]){
                UIImageView * newImageView = [[UIImageView alloc]init];
                newImageView.frame = CGRectMake(0, 0, 25, 25);
                [optionBtn addSubview:newImageView];
                newImageView.userInteractionEnabled = YES;
                [newImageView setImage:[UIImage imageNamed:@"home_icon_new"]];
                newImageView.left = (optionBtn.right - 30) * kCURRENTASPECT;
                newImageView.top = 5 * kCURRENTASPECT;
                if(IPHONE6_MORE){
                    newImageView.frame = CGRectMake(0, 0, 30, 30);
                    newImageView.left = (optionBtn.right - 40) * kCURRENTASPECT;
                    newImageView.top = 5;
                }
            }
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
    }else if ([functionCode isEqualToString:@"ZJJD"]){
        /**
         专家在线 专业圈
         */
        [button addTarget:self action:@selector(goZJJD) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"HYGF"]){
        /**
         专家在线 专业圈
         */
        [button addTarget:self action:@selector(goHYGF) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"DXAL"]){
        /**
         专家在线 专业圈
         */
        [button addTarget:self action:@selector(goDXAL) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"xxkj"]){
        /**
         职业性格测评
         */
        [button addTarget:self action:@selector(goXXKJ) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"lxtk"]){
        /**
         职业性格测评
         */
        [button addTarget:self action:@selector(goLXTK) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"jnqd"]){
        /**
         职业性格测评
         */
        [button addTarget:self action:@selector(goJNQD) forControlEvents:UIControlEventTouchUpInside];
    }else if ([functionCode isEqualToString:@"jnxx"]){
        /**
         职业性格测评
         */
        [button addTarget:self action:@selector(goJNXX) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [button addTarget:self action:@selector(goWebVC:) forControlEvents:UIControlEventTouchUpInside];
    }
//    else if ([functionCode isEqualToString:@"gwtx"]){
//        /**
//         岗位体系
//         */
//        [button addTarget:self action:@selector(goGWTX) forControlEvents:UIControlEventTouchUpInside];
//    }else if ([functionCode isEqualToString:@"gwcp"]){
//        /**
//         岗位测评
//         */
//        [button addTarget:self action:@selector(goGWCP) forControlEvents:UIControlEventTouchUpInside];
//    }else if ([functionCode isEqualToString:@"xwgf"]){
//        /**
//         行为规范
//         */
//        [button addTarget:self action:@selector(goXWGF) forControlEvents:UIControlEventTouchUpInside];
//    }else if ([functionCode isEqualToString:@"zxcs"]){
//        /**
//         在线测试
//         */
//        [button addTarget:self action:@selector(goZXCS) forControlEvents:UIControlEventTouchUpInside];
//    }else if ([functionCode isEqualToString:@"jnqd"]){
//        /**
//         在线测试
//         */
//        [button addTarget:self action:@selector(goJNQD) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        
//        [button addTarget:self action:@selector(goWebVC:) forControlEvents:UIControlEventTouchUpInside];
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }

    ZEPULHomeModel * model = [ZEPULHomeModel getDetailWithDic:self.PULHomeRequestionData[indexPath.row]];
    if ([model.MES_TYPE integerValue] == 4) {
        [self goSinginView];
    }else if ([model.MES_TYPE integerValue] == 2){
        [self goTeamView];
    }else if ([model.MES_TYPE integerValue] == 1){
        [self goQuestionView:model.FORKEY];
    }else if ([model.MES_TYPE integerValue] == 3){
        if ([self.delegate respondsToSelector:@selector(didSelectWebViewWithIndex:)]) {
            [self.delegate didSelectWebViewWithIndex:model.URLPATH];
        }
    }else if ([model.MES_TYPE integerValue] == 8){
        if ([self.delegate respondsToSelector:@selector(goDistrictManagerHome)]) {
            [self.delegate goDistrictManagerHome];
        }
    }else if ([model.MES_TYPE integerValue] >= 5){
        if ([self.delegate respondsToSelector:@selector(didSelectWebViewWithIndex:)]) {
            [self.delegate didSelectWebViewWithIndex:model.URLPATH];
        }
    }
}

-(void)showOptionView:(UIButton *)btn{
    
    _currentSelectHomeModel = [ZEPULHomeModel getDetailWithDic:self.PULHomeRequestionData[btn.tag - 100]];
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[btn convertRect: btn.bounds toView:window];
    
    ZEHomeOptionView * homeOptionView = [[ZEHomeOptionView alloc]initWithFrame:CGRectZero];
    homeOptionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    homeOptionView.delegate =self;
    homeOptionView.rect = rect;
    [window addSubview:homeOptionView];
    
}

-(void)ignoreDynamic{
    if ([self.delegate respondsToSelector:@selector(ignoreHomeDynamic:)]) {
        [self.delegate ignoreHomeDynamic:_currentSelectHomeModel];
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
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if([self.delegate respondsToSelector:@selector(serverBtnClick:)]){
        [self.delegate serverBtnClick:btn.tag - 200];
    }
}

-(void)loadNewData:(MJRefreshHeader *)header
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }

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
-(void)goJNXX
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goJNXX)]) {
        [self.delegate goJNXX];
    }
}

/**
 跳转专业圈
 */
-(void)goZYQ
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goZYQ)]) {
        [self.delegate goZYQ];
    }
}
/**
 跳转专业圈
 */
-(void)goGWCP
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goGWCP)]) {
        [self.delegate goGWCP];
    }
}

/**
 职业性格测评
 */
-(void)goZYXGCP
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goZYXGCP)]) {
        [self.delegate goZYXGCP];
    }
}

-(void)goZJJD
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goZJJD)]) {
        [self.delegate goZJJD];
    }
}

-(void)goDXAL
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goDXAL)]) {
        [self.delegate goDXAL];
    }
}

-(void)goHYGF
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goHYGF)]) {
        [self.delegate goHYGF];
    }
}

-(void)goXXKJ
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goXXKJ)]) {
        [self.delegate goXXKJ];
    }
}
-(void)goLXTK
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goLXTK)]) {
        [self.delegate goLXTK];
    }
}

/**
 岗位体系
 */
-(void)goGWTX
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goGWTX)]) {
        [self.delegate goGWTX];
    }
}

/**
 专家在线
 */
-(void)goZJZX{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goZJZX)]) {
        [self.delegate goZJZX];
    }
}

/**
 行为规范
 */
-(void)goXWGF{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goXWGF)]) {
        [self.delegate goXWGF];
    }
}


/**
 在线测试
 */
-(void)goZXCS{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goZXCS)]) {
        [self.delegate goZXCS];
    }
}


/**
 技能清单
 */
-(void)goJNQD{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goJNQD)]) {
        [self.delegate goJNQD];
    }
}
-(void)goJNBG{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goJNBG)]) {
        [self.delegate goJNBG];
    }
}

-(void)goWebVC:(UIButton *)btn
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    NSDictionary * dic = self.homeBtnArr[btn.tag - 100];
    if ([self.delegate respondsToSelector:@selector(goWebVC:)]) {
        [self.delegate goWebVC:[dic objectForKey:@"FUNCTIONCODE"]];
    }
}

/**
 更多功能
 */
-(void)goMoreFunction
{
    if (_viewIsEditing) {
        [self downTheKeyboard];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goMoreFunction)]) {
        [self.delegate goMoreFunction];
    }

}

/**
 签到
 */
-(void)goSinginView{
    if ([self.delegate respondsToSelector:@selector(goSinginView)]) {
        [self.delegate goSinginView];
    }
}

/**
 团队动态
 */
-(void)goTeamView{
    if ([self.delegate respondsToSelector:@selector(goFindTeamView)]) {
        [self.delegate goFindTeamView];
    }
}

/**
 主页问题动态点击
 */
-(void)goQuestionView:(NSString *)QUESTIONID{
    if ([self.delegate respondsToSelector:@selector(goQuestionView:)]) {
        [self.delegate goQuestionView:QUESTIONID];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    if(textField.text.length > 0){
        if ([self.delegate respondsToSelector:@selector(goQuestionSearchView:)]) {
            [self.delegate goQuestionSearchView:textField.text];
            textField.text = @"";
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
#pragma mark - 忽略动态
@interface ZEHomeOptionView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView * contentTab;
    UIImageView * backImageView;
}
@end

@implementation ZEHomeOptionView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self initUIView];
    }
    return self;
}

-(void)initUIView{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    backImageView = [[UIImageView alloc]init];
    backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, 55);
    [self addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    
    contentTab = [[UITableView alloc]initWithFrame:CGRectMake(20, 10, backImageView.width - 20 , 44) style:UITableViewStylePlain];
    contentTab.delegate = self;
    contentTab.dataSource  = self;
    [backImageView addSubview:contentTab];
    contentTab.backgroundColor = [UIColor clearColor];
    contentTab.clipsToBounds = YES;
    contentTab.layer.cornerRadius = 5;
    contentTab.userInteractionEnabled = YES;
    contentTab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件(只解除的是cell与手势间的冲突，cell以外仍然响应手势)
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        return NO;
    }
    
    // 若为UITableView（即点击了tableView任意区域），则不截获Touch事件(完全解除tableView与手势间的冲突，cell以外也不会再响应手势)
    if ([touch.view isKindOfClass:[UITableView class]]){
        return NO;
    }
    return YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UIImageView * eyeImage = [[UIImageView alloc]init];
    [eyeImage setImage:[UIImage imageNamed:@"home_icon_ignoreEye.png"]];
    [cell.contentView addSubview:eyeImage];
    eyeImage.left = 10.0f;
    eyeImage.top = 11.0f;
    eyeImage.width = 30.0f;
    eyeImage.height = 20.0f;
    eyeImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel * textLab = [[UILabel alloc]initWithFrame:CGRectMake(eyeImage.right + 8.0f, 0 , SCREEN_WIDTH - 200, 44)];
    textLab.textColor = MAIN_SUBTITLE_COLOR;
    textLab.font = [UIFont systemFontOfSize:15];
    textLab.text = @"忽略此条动态";
    [cell.contentView addSubview:textLab];
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(ignoreDynamic)]) {
        [self.delegate ignoreDynamic];
    }
    
    [self removeAllSubviews];
    [self removeFromSuperview];
}

-(void)setRect:(CGRect)rect
{
    _rect = rect;
    backImageView.alpha = 0.5;
    if (rect.origin.y < SCREEN_HEIGHT / 2) {
        backImageView.frame = CGRectMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height , 0, 0);
    }else{
        backImageView.frame = CGRectMake(rect.origin.x, rect.origin.y , 0, 0);
    }
    [UIView animateWithDuration:.29 animations:^{
//        contentTab.alpha =1;
        backImageView.alpha = 1;
        if (rect.origin.y < SCREEN_HEIGHT / 2) {
            backImageView.frame = CGRectMake(20, rect.origin.y + rect.size.height - 10, SCREEN_WIDTH - 30, 57);
            contentTab.top = 10;
            UIImage *image = [UIImage imageNamed:@"question_bank_change_bottom"];
            UIImage *newImage = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            [backImageView setImage:newImage];
        }else{
            backImageView.frame = CGRectMake(20, rect.origin.y - 40, SCREEN_WIDTH - 30, 55);
            UIImage *image = [UIImage imageNamed:@"question_bank_change_top"];
            UIImage *newImage = [image stretchableImageWithLeftCapWidth:20 topCapHeight:10];
            [backImageView setImage:newImage];
            contentTab.top = 0;
        }
    }];
}

@end


