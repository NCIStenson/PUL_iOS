//
//  ZESkillDetailView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/18.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kCellHeight 70

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT )

#import "ZESkillDetailView.h"
#import "ZEDistrictManagerCell.h"

@implementation ZESkillDetailView

-(id)initWithFrame:(CGRect)frame withData:(ZESkillListModel *)listM
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr=  [NSMutableArray array];
        _skillListModel = listM;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight) style:UITableViewStyleGrouped];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self addSubview:_contentView];

}

-(void)reloadContentWithData:(NSArray *)arr
{
    _dataArr = [NSMutableArray arrayWithArray:arr];

    [_contentView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float specHeight = [ZEUtil heightForString:_skillListModel.ABILITY_LEVEL_DESC font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];

    return 160 + specHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLab = [UILabel new];
    titleLab.backgroundColor = MAIN_LINE_COLOR;
    titleLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
    titleLab.text = @"     技能详情";
    titleLab.textColor = kTextColor;
    [headerView addSubview:titleLab];
    
    UIView * lineView=  [UIView new];
    lineView.frame = CGRectMake(0, 3, 3, 29);
    [headerView addSubview:lineView];
    lineView.backgroundColor = MAIN_NAV_COLOR;
    
    UILabel * levelLab = [UILabel new];
    [headerView addSubview:levelLab];
    levelLab.textColor = kTextColor;
    levelLab.frame = CGRectMake(20, titleLab.bottom + 5, SCREEN_WIDTH - 40, 35);
    levelLab.text = [NSString stringWithFormat:@"能力项等级要求：%@",_skillListModel.ABILITY_LEVEL];
    
    UILabel * specTitleLab = [UILabel new];
    [headerView addSubview:specTitleLab];
    specTitleLab.textColor = kTextColor;
    specTitleLab.frame = CGRectMake(20, levelLab.bottom , SCREEN_WIDTH - 40, 35);
    specTitleLab.text = @"能力项等级说明：";

    float specHeight = [ZEUtil heightForString:_skillListModel.ABILITY_LEVEL_DESC font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    UILabel * specLab = [UILabel new];
    [headerView addSubview:specLab];
    specLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    specLab.textColor = kSubTitleColor;
    specLab.frame = CGRectMake(20, specTitleLab.bottom + 5, SCREEN_WIDTH - 40, specHeight);
    specLab.text = _skillListModel.ABILITY_LEVEL_DESC;

    UILabel * titleLab1 = [UILabel new];
    titleLab1.frame = CGRectMake(0, specLab.bottom + 10, SCREEN_WIDTH , 35);
    titleLab1.backgroundColor = MAIN_LINE_COLOR;
    titleLab1.text = @"     学习推荐";
    titleLab1.textColor = kTextColor;
    [headerView addSubview:titleLab1];

    UIView * lineView1=  [UIView new];
    lineView1.frame = CGRectMake(0, titleLab1.top + 3, 3, 29);
    [headerView addSubview:lineView1];
    lineView1.backgroundColor = MAIN_NAV_COLOR;

    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [UIView new];
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
        
    [cell initUIWithDic:_dataArr[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * resultdic = _dataArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(goCourseDetail:)]) {
        [self.delegate goCourseDetail:resultdic];
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
