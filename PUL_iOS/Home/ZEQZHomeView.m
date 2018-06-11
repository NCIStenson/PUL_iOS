//
//  ZEQZHomeView.m
//  PUL_iOS
//
//  Created by Stenson on 2018/5/24.
//  Copyright © 2018年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kCellHeight 100 * kCURRENTASPECT

#import "ZEQZHomeView.h"
#import "ZEPULHomeModel.h"

@interface ZEQZHomeView ()
{
    UICollectionView * mainCollectionView;
}

@end

@implementation ZEQZHomeView

-(id)init
{
    self = [super init];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(self.frame.size.width, 100);
    //该方法也可以设置itemSize
//    layout.itemSize =CGSizeMake(110, 150);
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40.0f);  //设置headerView大小

    //2.初始化collectionView
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) collectionViewLayout:layout];
    [self addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor clearColor];
    [mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置

    //3.注册collectionViewCell
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
}

-(void)setDataDic:(NSMutableDictionary *)dataDic{
    _dataDic = dataDic;
    
    [mainCollectionView reloadData];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataDic.allKeys.count;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataDic.allKeys.count > 0) {
        NSString * keyStr = _dataDic.allKeys[section];
        NSArray * arr = [_dataDic objectForKey:keyStr];
        return arr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    NSString * keyStr = _dataDic.allKeys[indexPath.section];
    NSArray * arr = [_dataDic objectForKey:keyStr];
    NSDictionary * dic = arr[indexPath.row];

    UIImageView * iconImageView = [UIImageView new];
    iconImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2 * .2, kCellHeight * .5);
    iconImageView.centerX = cell.contentView.bounds.size.width / 2 ;
    iconImageView.centerY = kCellHeight / 2 - 10;
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:iconImageView];
//    [iconImageView setImageURL:[NSURL URLWithString:@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1965096719,332911728&fm=27&gp=0.jpg"]];
    
    UILabel * iconNameLab = [UILabel new];
    iconNameLab.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2 * .8, 20);
    iconNameLab.centerX = iconImageView.centerX;
    iconNameLab.top = iconImageView.bottom + 10;
    [cell.contentView addSubview:iconNameLab];
    iconNameLab.textAlignment = NSTextAlignmentCenter;
    iconNameLab.font = [UIFont systemFontOfSize:kTableRowTitleSize];
    
    NSString * fileURL = [dic objectForKey:@"FUNCTIONURL"];
    
    [iconImageView sd_setImageWithURL:ZENITH_IMAGEURL([[fileURL stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"\\"]) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    iconNameLab.text = [dic objectForKey:@"ABILITYTYPE"];

    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH / 2 - 5, 100 );
}
//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    while (headerView.subviews.lastObject) {
        [headerView.subviews.lastObject removeFromSuperview];
    }
    headerView.backgroundColor = MAIN_LINE_COLOR;
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 5, 3, headerView.bounds.size.height  - 10);
    lineView.backgroundColor = MAIN_NAV_COLOR;
    [headerView addSubview:lineView];
    
    NSString * keyStr = _dataDic.allKeys[indexPath.section];

    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0, headerView.bounds.size.width - 30, headerView.bounds.size.height)];
    titleLabel.text = keyStr;
    titleLabel.textColor = MAIN_TITLEBLACK_COLOR;
    [headerView addSubview:titleLabel];
    
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = nil;
    if (_dataDic.allKeys.count > 0) {
        NSString * keyStr = _dataDic.allKeys[indexPath.section];
        NSArray * arr = [_dataDic objectForKey:keyStr];
        dic = arr[indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(goDetail:)]) {
        [self.delegate goDetail:dic];
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
