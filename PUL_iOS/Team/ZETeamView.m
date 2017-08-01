//
//  ZETeamView.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/7.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kContentTableHeight (SCREEN_HEIGHT - NAV_HEIGHT - TAB_BAR_HEIGHT)

#import "ZETeamView.h"

#import "ZETeamCircleModel.h"

@implementation ZETeamViewHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

#pragma mark - Public Method

-(void)reloadCollectionView:(NSArray *)arr
{
    _joinTeam = [NSMutableArray arrayWithArray:arr];
    [_collectionView reloadData];
    if (_joinTeam.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

-(void)initView
{
    MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3);
    flow.minimumLineSpacing = 30;
    flow.minimumInteritemSpacing = 30;
    flow.needAlpha = YES;
    flow.delegate = self;
    CGFloat oneX =SCREEN_WIDTH / 4;
    flow.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);

    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:lineView];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH , (SCREEN_WIDTH / 3 + (IPHONE5 ? 30 : IPHONE6 ? 40 : 50))) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = MAIN_LINE_COLOR;
    
    UILabel * headerLab = [[UILabel alloc]init];
    headerLab.left = 20;
    headerLab.top = _collectionView.frame.size.height + 30;
    headerLab.size = CGSizeMake(SCREEN_WIDTH, 20);
    [self addSubview:headerLab];
    headerLab.text = @"团队动态";
    headerLab.textColor = kTextColor;
    headerLab.font = [UIFont boldSystemFontOfSize:18];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_TEAM_QUESTION object:@""];
}

#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _joinTeam.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row > 0 && indexPath.row < _joinTeam.count + 1) {
        
        UIView * bacgroundView = [[UIView alloc]init];
        bacgroundView.backgroundColor = MAIN_NAV_COLOR;
        bacgroundView.frame = CGRectMake(15, 0, SCREEN_WIDTH / 3 - 30 ,SCREEN_WIDTH / 3 + (IPHONE5 ? 40 : IPHONE6 ? 50 : 60));
        [cell.contentView addSubview:bacgroundView];
        bacgroundView.clipsToBounds = YES;
        bacgroundView.layer.cornerRadius = 5.0f;
        ZETeamCircleModel * teaminfo = [ZETeamCircleModel getDetailWithDic:_joinTeam[indexPath.row - 1]];
        
        UIImageView * heroImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 6, SCREEN_WIDTH / 6)];
        [bacgroundView addSubview:heroImageVIew];
        [heroImageVIew sd_setImageWithURL:ZENITH_IMAGEURL(teaminfo.FILEURL) placeholderImage:ZENITH_PLACEHODLER_TEAM_IMAGE];
        heroImageVIew.center = CGPointMake( (SCREEN_WIDTH / 3 - 30 ) / 2 , SCREEN_WIDTH / 8);
        heroImageVIew.layer.cornerRadius = SCREEN_WIDTH / 12;
        heroImageVIew.layer.masksToBounds = YES;
        
        UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH / 4 - 10, SCREEN_WIDTH / 3 - 30, 30)];
        nameLab.text = teaminfo.TEAMCIRCLENAME;
        nameLab.numberOfLines = 0;
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [bacgroundView addSubview:nameLab];
        nameLab.textColor = kTextColor;

    }else{
        
        UIImageView * heroImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH / 3 - 30, SCREEN_WIDTH / 3 )];
        [cell.contentView addSubview:heroImageVIew];
        heroImageVIew.contentMode = UIViewContentModeScaleAspectFit;
        heroImageVIew.layer.cornerRadius = 5.0f;
        heroImageVIew.layer.masksToBounds = YES;
        
        if(indexPath.row == 0){
            heroImageVIew.image = [UIImage imageNamed:@"icon_addTeam_1"];
        }else{
            heroImageVIew.image = [UIImage imageNamed:@"icon_addTeam_2"];
        }
    }
    
    return cell;
}

#pragma warning -   
// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.collectionView.collectionViewLayout isKindOfClass:[MKJCollectionViewFlowLayout class]]) {
        CGPoint pInUnderView = [self convertPoint:collectionView.center toView:collectionView];
        
        // 获取中间的indexpath
        NSIndexPath *indexpathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
        
        if (indexPath.row == indexpathNew.row)
        {
            if (indexPath.row == 0 || indexPath.row == _joinTeam.count +1) {
                if ([self.teamView.delegate respondsToSelector:@selector(goFindTeamVC)]) {
                    [self.teamView.delegate goFindTeamVC];
                }
            }else{
                if ([self.teamView.delegate respondsToSelector:@selector(goTeamQuestionVC:)]) {
                    [self.teamView.delegate goTeamQuestionVC:indexPath.row - 1];
                }
            }
            return;
        }else{
//            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}

#pragma mark - 滑动结束后 获取当前cell的indexpath
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint pInView = [self convertPoint:_collectionView.center toView:_collectionView];

    NSIndexPath * indexpath = [_collectionView indexPathForItemAtPoint:pInView];
    
    if(_joinTeam.count > 0 && indexpath.row > 0 && indexpath.row < _joinTeam.count + 1){
        ZETeamCircleModel * teaminfo = [ZETeamCircleModel getDetailWithDic:_joinTeam[indexpath.row - 1]];

        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_TEAM_QUESTION object:teaminfo];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTI_ASK_TEAM_QUESTION object:nil];
    }
    
}



@end


@implementation ZETeamView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _headerView =[[ZETeamViewHeaderView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH,  (SCREEN_WIDTH / 3 + (IPHONE5 ? 30 : IPHONE6 ? 40 : 50)) + 60)];
    _headerView.teamView = self;
    [self addSubview:_headerView];
    
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.frame = CGRectMake(0, _headerView.height + NAV_HEIGHT, SCREEN_WIDTH,  SCREEN_HEIGHT - _headerView.height - NAV_HEIGHT - TAB_BAR_HEIGHT);
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Public Method

-(void)reloadHeaderView:(NSArray *)arr
{
    [_headerView reloadCollectionView:arr];
}

-(void)reloadContentView:(NSArray  *)datasArr
{
    self.dynamicDatasArr = [NSMutableArray arrayWithArray:datasArr];
    [contentTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dynamicDatasArr.count ;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary * dynamicDic = self.dynamicDatasArr[indexPath.row];
    NSString * fileUrl = [[[dynamicDic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];

    UIImageView * headeImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    [headeImage setImage:ZENITH_PLACEHODLER_TEAM_IMAGE];
    [headeImage sd_setImageWithURL:ZENITH_IMAGEURL(fileUrl) placeholderImage:ZENITH_PLACEHODLER_TEAM_IMAGE];
    [cell.contentView addSubview:headeImage];
    [headeImage setContentMode:UIViewContentModeScaleAspectFit];
    
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 120, 40)];
    nameLab.text = @"市区二站";
    nameLab.text = [dynamicDic objectForKey:@"TEAMCIRCLENAME"];
    nameLab.numberOfLines = 0;
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:nameLab];
    nameLab.textColor = kTextColor;
    
    UILabel * dynamiLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, SCREEN_WIDTH - 120, 40)];
    dynamiLab.numberOfLines = 0;
    dynamiLab.textAlignment = NSTextAlignmentLeft;
    dynamiLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:dynamiLab];
    dynamiLab.textColor = kTextColor;
    
    if ([[dynamicDic objectForKey:@"DYNAMICTYPE"]  integerValue] == 1) {
        dynamiLab.text = @"你的小伙伴又有新的问题需要你的帮助，快来帮助他吧！";
    }else if ([[dynamicDic objectForKey:@"DYNAMICTYPE"]  integerValue] == 2){
        dynamiLab.text = @"有人回答了你的问题，快去看看吧！";
    }else if ([[dynamicDic objectForKey:@"DYNAMICTYPE"]  integerValue] == 3){
        dynamiLab.text = @"有人对你提问了，快去挑战吧！";
    }else if ([[dynamicDic objectForKey:@"DYNAMICTYPE"]  integerValue] == 4){
        dynamiLab.text = @"您的回答被采纳了，快去看看吧！";
    }

    
    UILabel * SYSCREATEDATE = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90,10,70,20.0f)];
    SYSCREATEDATE.text = [ZEUtil compareCurrentTime:[NSString stringWithFormat:@"%@.0", [dynamicDic objectForKey:@"SYSCREATEDATE"]]];
    SYSCREATEDATE.userInteractionEnabled = NO;
    SYSCREATEDATE.textAlignment = NSTextAlignmentRight;
    SYSCREATEDATE.textColor = MAIN_SUBTITLE_COLOR;
    SYSCREATEDATE.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = YES;

    if (indexPath.row == 0) {
        UIView * lineView = [UIView new];
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = MAIN_LINE_COLOR;
        [cell.contentView addSubview:lineView];
    }
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 99.5f, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark -UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cellClikcGoTeamQuestionVC:)]) {
        [self.delegate cellClikcGoTeamQuestionVC:indexPath.row];
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
