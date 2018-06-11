//
//  ZEWorkStandardHomeView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/17.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETypicalCaseHomeView.h"

@implementation ZETypicalCaseHomeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.recommandClassicalCaseArr = [NSMutableArray array];
        self.topClassicalCaseArr = [NSMutableArray array];
        self.hotClassicalCaseArr = [NSMutableArray array];
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    
}

#pragma mark - PublicMethod

-(void)reloadBannerView:(NSArray *)dataArr
{
    self.topClassicalCaseArr = [NSMutableArray arrayWithArray:dataArr];
    [_contentTableView  reloadData];
}

-(void)reloadRecommandView:(NSArray *)dataArr
{
    self.recommandClassicalCaseArr = [NSMutableArray arrayWithArray:dataArr];
    
//    [_contentTableView reloadData];
     [_contentTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)reloadNewestView:(NSArray *)dataArr{
    self.hotClassicalCaseArr = [NSMutableArray arrayWithArray:dataArr];
    
    //    [_contentTableView reloadData];
    [_contentTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:bannerScrollView]) {
        pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    }
}


#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return  self.recommandClassicalCaseArr.count;
    }else if (section == 1){
        return  self.hotClassicalCaseArr.count;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return SCREEN_WIDTH / 2 + 50;
    }else{
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UIScrollView * scrollView =[self createScrollView:view];
        [view addSubview:scrollView];
        
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0 , SCREEN_WIDTH / 2 - 50, view.width, 50)];
        pageControl.numberOfPages = self.topClassicalCaseArr.count;
        pageControl.currentPage = 0;
//        pageControl.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_WIDTH / 2 - 20);
//        pageControl.backgroundColor = [UIColor redColor];
        [view addSubview:pageControl];

        
        [ZEUtil addLineLayerMarginLeft:0 marginTop:scrollView.height width:SCREEN_WIDTH height:5 superView:view];
        
        UIView * moreView = [self createMoreViewWithTitle:@"最新推荐"];
        moreView.frame = CGRectMake(0, scrollView.height + 5, SCREEN_WIDTH, 45);
        [view addSubview:moreView];

        return view;
    }
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:5 superView:view];
    UIView * moreView = [self createMoreViewWithTitle:@"最热推荐"];
    moreView.frame = CGRectMake(0, 5, SCREEN_WIDTH, 45);
    [view addSubview:moreView];

    return view;
}

-(UIView *)createMoreViewWithTitle:(NSString *)title{
    UIView * moreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    moreView.backgroundColor = [UIColor whiteColor];
    
    UILabel * moreTitleLab = [UILabel new];
    moreTitleLab.frame = CGRectMake(0, 5, 100, 35);
    moreTitleLab.font = [UIFont systemFontOfSize:kTiltlFontSize ];
    moreTitleLab.textAlignment = NSTextAlignmentCenter;
    moreTitleLab.backgroundColor = MAIN_NAV_COLOR;
    moreTitleLab.text = title;
    moreTitleLab.textColor = [UIColor whiteColor];
    [moreView addSubview:moreTitleLab];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:moreTitleLab.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = moreTitleLab.bounds;
    maskLayer.path = maskPath.CGPath;
    moreTitleLab.layer.mask = maskLayer;
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_SUBBTN_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 5, 50, 35);
    [sectionSubTitleBtn setTitle:@"更多" forState:UIControlStateNormal];
    [sectionSubTitleBtn setTitleColor:kSubTitleColor forState:UIControlStateNormal];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    sectionSubTitleBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize ];
    [moreView addSubview:sectionSubTitleBtn];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:sectionSubTitleBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = sectionSubTitleBtn.bounds;
    maskLayer1.path = maskPath.CGPath;
    sectionSubTitleBtn.layer.mask = maskLayer1;

    if ([title isEqualToString:@"最新推荐"]) {
        [sectionSubTitleBtn addTarget:self action:@selector(goMoreNewestRecommend) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [sectionSubTitleBtn addTarget:self action:@selector(goMoreHotRecommend) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return moreView;
}

-(UIScrollView *)createScrollView:(UIView *)superView{
    bannerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 2)];
    bannerScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.topClassicalCaseArr.count, bannerScrollView.height);
    bannerScrollView.pagingEnabled = YES;
    bannerScrollView.delegate =self;
    [superView addSubview:bannerScrollView];
    
    for (int i = 0; i < self.topClassicalCaseArr.count; i ++) {
        ZEKLB_CLASSICCASE_INFOModel * infoModel = nil;
        infoModel = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:self.topClassicalCaseArr[i]];
        UIButton * bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bannerBtn.tag = 100 + i;
        bannerBtn.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, bannerScrollView.height);
        bannerBtn.contentMode = UIViewContentModeScaleAspectFit;
        bannerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [bannerScrollView addSubview:bannerBtn];
        NSLog(@" =====  %@",infoModel.FILEURL);
//        bannerBtn.backgroundColor = MAIN_ARM_COLOR;
        [bannerBtn addTarget:self action:@selector(bannerBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([ZEUtil isStrNotEmpty:infoModel.FILEURL]) {
            [bannerBtn sd_setBackgroundImageWithURL:ZENITH_IMAGEURL(infoModel.FILEURL)   forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        }
    }

    return bannerScrollView;
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
    
    [self initCellView:cell.contentView withIndexpath:indexPath];
    
    return cell;
}

-(void)initCellView:(UIView *)cellView withIndexpath:(NSIndexPath *)indexPath
{
    ZEKLB_CLASSICCASE_INFOModel * infoModel = nil;
    if (indexPath.section == 0) {
        infoModel = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:self.recommandClassicalCaseArr[indexPath.row]];
    }else{
        infoModel = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:self.hotClassicalCaseArr[indexPath.row]];
    }
    
    UIImageView * contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 100, 70)];
    [cellView addSubview:contentImageView];
    if ([ZEUtil isStrNotEmpty:infoModel.FILEURL]) {
        [contentImageView sd_setImageWithURL:ZENITH_IMAGEURL(infoModel.FILEURL) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    }
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(115, 5, SCREEN_WIDTH - 180, 40.0f)];
    contentLab.text = infoModel.CASENAME;
    contentLab.numberOfLines = 2;
    contentLab.font = [UIFont systemFontOfSize:12];
    [cellView addSubview:contentLab];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld",(long)[infoModel.CLICKCOUNT integerValue]];
    
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:10] maxSize:CGSizeMake(200, 20)];
    
    UILabel * commentLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,10,praiseNumWidth,20.0f)];
    commentLab.text  = praiseNumLabText;
    commentLab.font = [UIFont boldSystemFontOfSize:10];
    commentLab.textColor = MAIN_SUBTITLE_COLOR;
    [cellView addSubview:commentLab];
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 45.0f, commentLab.top + 1, 20, 15)];
    commentImg.image = [UIImage imageNamed:@"discuss_pv.png"];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    [cellView addSubview:commentImg];
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = nil;
    
    if (indexPath.section == 0) {
        dic = self.recommandClassicalCaseArr[indexPath.row];
    }else{
        dic = self.hotClassicalCaseArr[indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(goTypicalCaseDetailVC:)]) {
        [self.delegate goTypicalCaseDetailVC:dic];
    }
}

-(void)bannerBtnDidClick:(UIButton *)btn{
    NSDictionary * dic =  self.topClassicalCaseArr[btn.tag - 100];
    
    if ([self.delegate respondsToSelector:@selector(goTypicalCaseDetailVC:)]) {
        [self.delegate goTypicalCaseDetailVC:dic];
    }

    

}

#pragma mark - Delegate

-(void)goMoreNewestRecommend{
    if ([self.delegate respondsToSelector:@selector(goMoreView:)]) {
        [self.delegate goMoreView:ENTER_CASE_TYPE_RECOMMAND];
    }
}

-(void)goMoreHotRecommend{
    if ([self.delegate respondsToSelector:@selector(goMoreView:)]) {
        [self.delegate goMoreView:ENTER_CASE_TYPE_NEWEST];
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
