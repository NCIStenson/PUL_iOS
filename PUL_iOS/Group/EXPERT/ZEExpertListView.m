//
//  ZEExpertListView.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/28.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kContentTableViewMarginLeft 0.0f
#define kContentTableViewMarginTop  NAV_HEIGHT
#define kContentTableViewWidth      SCREEN_WIDTH
#define kContentTableViewHeight     SCREEN_HEIGHT - NAV_HEIGHT


#import "ZEExpertListView.h"

@implementation ZEExpertListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     withData:(NSDictionary *)dataDic;
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)reloadCellView:(NSDictionary *)dic withIndexPath:(NSIndexPath *)indexPath;
{
    ZEExpertModel * expertModel = [ZEExpertModel getDetailWithDic:dic];
    dataDic = dic;
    UIImageView * detailView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_WIDTH / 3)];
    detailView.contentMode=UIViewContentModeScaleAspectFill;
    detailView.clipsToBounds=YES;
    [self.contentView addSubview:detailView];
    
    UIImageView * detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH / 3, SCREEN_WIDTH / 3)];
    [detailView addSubview:detailImageView];
    [detailImageView sd_setImageWithURL:ZENITH_IMAGEURL(expertModel.FILEURL) placeholderImage:ZENITH_PLACEHODLER_TEAM_IMAGE];
    detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    detailImageView.clipsToBounds = YES;
    
    UILabel * caseNameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 + 15, 15, SCREEN_WIDTH - SCREEN_WIDTH / 3 - 25, 30)];
    caseNameLab.text = expertModel.USERNAME;
    if([ZEUtil isStrNotEmpty:expertModel.GOODFIELD]){
        caseNameLab.text = expertModel.USERNAME;
    }
    [caseNameLab setTextColor:kTextColor];
    caseNameLab.font = [UIFont boldSystemFontOfSize:21];
    [detailView addSubview:caseNameLab];
    
    
    UILabel * goodFieldLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 + 15, 50, SCREEN_WIDTH - SCREEN_WIDTH / 3 - 25, 50)];
    if([ZEUtil isStrNotEmpty:expertModel.GOODFIELD]){
        goodFieldLab.text = [NSString stringWithFormat:@"擅长领域：%@",expertModel.GOODFIELD];
    }
    goodFieldLab.numberOfLines = 0;
    [goodFieldLab setTextColor:kTextColor];
    goodFieldLab.font = [UIFont boldSystemFontOfSize:19];
    [detailView addSubview:goodFieldLab];
    goodFieldLab.adjustsFontSizeToFitWidth = YES;
}

@end

@implementation ZEExpertListView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.teamsDataArr = [NSMutableArray array];
        [self initView];
    }
    return self;
}

-(void)initView{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    contentTableView.left  = kContentTableViewMarginLeft;
    contentTableView.top  = kContentTableViewMarginTop;
    contentTableView.size  = CGSizeMake(kContentTableViewWidth, kContentTableViewHeight);
}
#pragma mark - Public Method

-(void)reloadExpertListViw:(NSArray *)dataArr;
{
    self.teamsDataArr = [NSMutableArray array];
    [self.teamsDataArr addObjectsFromArray:dataArr];
    [contentTableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teamsDataArr.count;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH / 3 + 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZEExpertListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZEExpertListViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellID];
    }
    
    while (cell.contentView.subviews.lastObject) {
        UIView * lastView = cell.contentView.subviews.lastObject;
        [lastView removeFromSuperview];
    }
    cell.expertListView = self;
    [cell reloadCellView:self.teamsDataArr[indexPath.row] withIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - ZEFindTeamViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(goExpertVCDetail:)]){
        ZEExpertModel * expertModel = [ZEExpertModel getDetailWithDic:self.teamsDataArr[indexPath.row]];
        [self.delegate goExpertVCDetail:expertModel];
    }
}

@end
