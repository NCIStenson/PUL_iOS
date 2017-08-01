//
//  ZEPULHomeView.m
//  PUL_iOS
//
//  Created by Stenson on 17/7/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kServerBtnWidth (SCREEN_WIDTH - 40 ) / 4

#import "ZEPULHomeView.h"
#import "ZEButton.h"
#import "ZEQuestionBasicCell.h"

@interface ZEPULHomeView()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    CGRect _PULHomeViewFrame;
    
    UIPageControl * _pageControl;
    UITableView * _contentTableView;
    UIScrollView * bannerScrollView;
    
    UIScrollView * commandStudyScrollView;
}

@property (nonatomic,retain) NSMutableArray * PULHomeRequestionData;
@property (nonatomic,retain) NSMutableArray * commandStudyDataArr;

@end

@implementation ZEPULHomeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _PULHomeViewFrame = frame;
        [self initPULHomeView];
    }
    return self;
}

-(void)initPULHomeView
{
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _PULHomeViewFrame.size.height) style:UITableViewStyleGrouped];
    _contentTableView.delegate =self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    _contentTableView.backgroundColor = [UIColor whiteColor];
    [_contentTableView registerClass:[ZEQuestionBasicCell class] forCellReuseIdentifier:@"cell"];
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

-(void)reloadCommandStudy:(NSArray *)arr
{
    self.commandStudyDataArr = [NSMutableArray arrayWithArray:arr];
    [_contentTableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.PULHomeRequestionData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = self.PULHomeRequestionData[indexPath.row];
        
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
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    
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
    
    ZEQuestionBasicCell * cell  = [[ZEQuestionBasicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    cell.answerBtn.tag = indexPath.row;
    [cell.answerBtn addTarget:self action:@selector(answerQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [cell reloadCellView:self.PULHomeRequestionData[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCURRENTASPECT * 120 + kServerBtnWidth + 30 + kCURRENTASPECT * 150 + 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    
    bannerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCURRENTASPECT * 120)];
    [headerView addSubview:bannerScrollView];
    bannerScrollView.pagingEnabled = YES;
    bannerScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, bannerScrollView.height);
    bannerScrollView.showsVerticalScrollIndicator = NO;
    bannerScrollView.showsHorizontalScrollIndicator = NO;
    bannerScrollView.delegate = self;
    
    for (int i = 0; i < 3; i ++) {
        UIButton * bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bannerBtn.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH , bannerScrollView.height);
        [bannerScrollView addSubview:bannerBtn];
        [bannerBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"banner%d.jpg",i+1]] forState:UIControlStateNormal];
        if (i == 2) {
            [bannerBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"banner1.jpg"]] forState:UIControlStateNormal];
        }
    }
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = 2;
    [headerView addSubview:_pageControl];
    _pageControl.currentPage = 0;
    _pageControl.frame = CGRectMake(0, bannerScrollView.height - 20, SCREEN_WIDTH, 20);
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.bannerTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.bannerTimer, start, interval, 0);
    
    __block int count = 0;
    // 设置回调
    dispatch_source_set_event_handler(self.bannerTimer, ^{
        
        count ++;

        if (count % 4 == 3) {
            bannerScrollView.contentOffset = CGPointMake(0,0);
            count = 0;
        }else{
            [bannerScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * (count%4), 0, SCREEN_WIDTH, bannerScrollView.height) animated:YES];
        }
        _pageControl.currentPage = count;
//         取消定时器
//        dispatch_cancel(self.bannerTimer);
//        self.bannerTimer = nil;
        
    });
    
    // 启动定时器
    dispatch_resume(self.bannerTimer);
    
    UIView * iconView = [UIView new];
    iconView.frame = CGRectMake(0, bannerScrollView.height, SCREEN_WIDTH, kServerBtnWidth + 30);
    [headerView addSubview:iconView];
    [self initIconView:iconView];
    
    UIView * commandStudyView = [UIView new];
    commandStudyView.frame = CGRectMake(0, iconView.bottom, SCREEN_WIDTH, kCURRENTASPECT * 150);
    [headerView addSubview:commandStudyView];
    [self initCommandStudyView:commandStudyView];
    
    
    UILabel * hotRequestLab = [UILabel new];
    hotRequestLab.frame = CGRectMake(0, commandStudyView.bottom, SCREEN_WIDTH, 30);
    hotRequestLab.text = @"   热门问题";
    hotRequestLab.textColor = kTextColor;
    [headerView addSubview:hotRequestLab];
    hotRequestLab.backgroundColor = MAIN_LINE_COLOR;
    
    headerView.height = hotRequestLab.bottom;
    
    return headerView;
}
-(void)initIconView:(UIView *)superView
{
    UILabel * serverLab = [UILabel new];
    serverLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    serverLab.text = @"   快捷服务";
    serverLab.textColor = kTextColor;
    [superView addSubview:serverLab];
    serverLab.backgroundColor = MAIN_LINE_COLOR;
    
    for (int i = 0 ; i < 4; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(20 + kServerBtnWidth * i, 30, kServerBtnWidth, kServerBtnWidth);
        if (i >= 4 ) {
            optionBtn.frame = CGRectMake(20 + kServerBtnWidth* (i - 4), 30 + kServerBtnWidth, kServerBtnWidth, kServerBtnWidth);
        }
        [superView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 200;
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        [optionBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateSelected];
        
        switch (i) {
            case 0:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_wyw"] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_wyw-_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"能力地图" forState:UIControlStateNormal];
                break;
            case 1:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_lyl" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_lyl_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"每日一练" forState:UIControlStateNormal];
                break;
            case 2:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_byb" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_byb_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"必修课" forState:UIControlStateNormal];
                break;
            case 3:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_nn" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_nn1_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"我的问答" forState:UIControlStateNormal];
                break;
            case 4:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_wyw"] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_wyw-_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"问一问" forState:UIControlStateNormal];
                break;
            case 5:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_lyl" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_lyl_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"练一练" forState:UIControlStateNormal];
                break;
            case 6:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_byb" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_byb_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"比一比" forState:UIControlStateNormal];
                break;
            case 7:
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_nn" ] forState:UIControlStateNormal];
                [optionBtn setImage:[UIImage imageNamed:@"yy_head_nn1_click"] forState:UIControlStateSelected];
                [optionBtn setTitle:@"聊一聊" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        if (i == 0) {
            [optionBtn setSelected:YES];
        }
    }
}

-(void)initCommandStudyView:( UIView *)superView
{
    UILabel * commandStudyLab = [UILabel new];
    commandStudyLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    commandStudyLab.text = @"   推荐学习";
    commandStudyLab.textColor = kTextColor;
    [superView addSubview:commandStudyLab];
    commandStudyLab.backgroundColor = MAIN_LINE_COLOR;
    
    commandStudyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, superView.height - 30)];
    [superView addSubview:commandStudyScrollView];
    commandStudyScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, bannerScrollView.height);
    commandStudyScrollView.showsVerticalScrollIndicator = NO;
    commandStudyScrollView.showsHorizontalScrollIndicator = NO;
    commandStudyScrollView.delegate = self;
    
    for (int i = 0; i < self.commandStudyDataArr.count; i ++) {
        
        NSDictionary * dic = self.commandStudyDataArr[i];
        NSString * NAME = [dic objectForKey:@"NAME"];
        NSString * IMAGE_URL = [[dic objectForKey:@"IMAGE_URL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIButton * studyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        studyBtn.frame = CGRectMake(10 + (SCREEN_WIDTH / 3 + 20) * i , 0, SCREEN_WIDTH / 3, commandStudyScrollView.height - 30 );
        [studyBtn sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL] forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        [commandStudyScrollView addSubview:studyBtn];
        
        UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(studyBtn.left, studyBtn.bottom, studyBtn.width, 30)];
        nameLab.numberOfLines = 2;
        [nameLab setTextColor:kTextColor];
        nameLab.textAlignment = NSTextAlignmentCenter;
        [commandStudyScrollView addSubview:nameLab];
        nameLab.text = NAME;
        nameLab.font = [UIFont systemFontOfSize:12];
    }
    
    [commandStudyScrollView setContentSize:CGSizeMake(20 + (SCREEN_WIDTH / 3 + 20) * self.commandStudyDataArr.count, commandStudyScrollView.height)];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.commandStudyTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 1, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.01 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.commandStudyTimer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.commandStudyTimer, ^{
        __block  float offsetX = commandStudyScrollView.contentOffset.x;
        if (offsetX >= commandStudyScrollView.contentSize.width - SCREEN_WIDTH / 2) {
            commandStudyScrollView.contentOffset = CGPointMake(0, 0);
        }else{
            commandStudyScrollView.contentOffset  = CGPointMake(offsetX += 0.5, 0);
        }
    });
    
    // 启动定时器
    dispatch_resume(self.commandStudyTimer);
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

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:bannerScrollView]) {
        _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH > 2 ? 2 : scrollView.contentOffset.x / SCREEN_WIDTH;
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
