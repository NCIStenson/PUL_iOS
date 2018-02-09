//
//  ZEDistrictManagerHomeView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT )

#define kCellHeight 80
#define kHeaderViewHeight 45

#import "ZESkillListView.h"
#import "ZESkillListModel.h"

@implementation ZESkillListView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        yesArr = [NSMutableArray array];
        noArr = [NSMutableArray array];
        [self initContentView];
    }
    return self;
}

-(void)initContentView
{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight) style:UITableViewStyleGrouped];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self addSubview:_contentView];
    
    //    MJRefreshHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    //    _contentView.mj_header = header;
    //
    //    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //    _contentView.mj_footer = footer;
}

#pragma mark - Public Method

-(void)reloadDataWithData:(NSArray *)arr withIndex:(NSInteger)index
{
    if(index == 0){
        [noArr addObjectsFromArray:arr];
        [_contentView reloadSection:index withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (index == 1){
        [yesArr addObjectsFromArray:arr];
        [_contentView reloadSection:index withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return noArr.count;
    }else if (section == 1){
        return yesArr.count;
    }
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (yesArr.count == 0 && section == 1) {
        return 0.1;
    }else if (noArr.count == 0 && section ==0){
        return 0.1;
    }
    
    return kHeaderViewHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [UIView new];
    headerView.backgroundColor = MAIN_LINE_COLOR;
    
    if (yesArr.count == 0 && section == 1) {
        return headerView;
    }else if (noArr.count == 0 && section == 0) {
        return headerView;
    }

    
    UIView * moreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    moreView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:moreView];
    
    UILabel * moreTitleLab = [UILabel new];
    moreTitleLab.frame = CGRectMake(0, 5, 150, 35);
    moreTitleLab.font = [UIFont systemFontOfSize:kTiltlFontSize ];
    moreTitleLab.textAlignment = NSTextAlignmentCenter;
    moreTitleLab.backgroundColor = MAIN_NAV_COLOR;
    moreTitleLab.textColor = [UIColor whiteColor];
    [moreView addSubview:moreTitleLab];
    if (section == 0) {
        moreTitleLab.backgroundColor = RGBA(226, 136, 53, 1);
        moreTitleLab.text = @"未通过考试技能";
    }else if (section == 1){
        moreTitleLab.text = @"已通过考试技能";
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:moreTitleLab.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = moreTitleLab.bounds;
    maskLayer.path = maskPath.CGPath;
    moreTitleLab.layer.mask = maskLayer;

    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];    
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initCellView:cell.contentView withIndexpath:indexPath];
    
    return cell;
}

-(void)initCellView:(UIView *)cellView withIndexpath:(NSIndexPath *)indexpath
{
    ZESkillListModel * listModel ;
    if (indexpath.section == 0) {
       listModel = [ZESkillListModel getDetailWithDic:noArr[indexpath.row]];
    }else if (indexpath.section == 1){
       listModel = [ZESkillListModel getDetailWithDic:yesArr[indexpath.row]];
    }
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 80, 35.0f)];
    contentLab.text = listModel.ABILITYNAME;
    contentLab.textColor = kTextColor;
    contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cellView addSubview:contentLab];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(contentLab.left,contentLab.bottom,contentLab.width,contentLab.height - 5)];
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = kSubTitleColor;
    [cellView addSubview:circleLab];
    circleLab.text = listModel.ABILITYTYPE;
    
    UIImageView * levelImage = [[UIImageView alloc]initWithFrame:CGRectMake(contentLab.right,contentLab.top + 5, 35, 35)];
    [cellView addSubview:levelImage];
    
    if ([listModel.ABILITY_LEVEL isEqualToString:@"I"]) {
        levelImage.image = [UIImage imageNamed:@"icon_skill_level1"];
    }else if ([listModel.ABILITY_LEVEL isEqualToString:@"II"]){
        levelImage.image = [UIImage imageNamed:@"icon_skill_level2"];
    }else if([listModel.ABILITY_LEVEL isEqualToString:@"III"]){
        levelImage.image = [UIImage imageNamed:@"icon_skill_level3"];
    }
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:79 width:SCREEN_WIDTH height:1 superView:cellView];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * skillDic = nil;
    if (indexPath.section == 0) {
        skillDic = noArr[indexPath.row];
    }else if (indexPath.section == 1){
        skillDic = yesArr[indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(goSkillDetailWithObject:)]) {
        [self.delegate goSkillDetailWithObject:skillDic];
    }
}

@end

