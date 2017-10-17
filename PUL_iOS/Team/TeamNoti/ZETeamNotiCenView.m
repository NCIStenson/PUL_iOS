//
//  ZETeamNotiCenView.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/4.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kCellTopMargin 5.0f
#define kCellBottomMargin 5.0f

#import "ZETeamNotiCenView.h"
#import "ZETeamNotiLayout.h"
#import "ZEWithoutDataTipsView.h"

@implementation ZETeamNotiCenTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    _contentLab = [UILabel new];
    _contentLab.top = kCellTopMargin;
    _contentLab.left = 10.0f;
    _contentLab.numberOfLines = 0;
    [self.contentView addSubview:_contentLab];
    _contentLab.size = CGSizeMake(SCREEN_WIDTH - 20, 20);
    _contentLab.textColor = kTextColor;
    
    _disUsername = [UILabel new];
    _disUsername.top = _contentLab.bottom + 5.0f;
    _disUsername.left = _contentLab.left;
    [self.contentView addSubview:_disUsername];
    _disUsername.size = CGSizeMake(100, 20);
    _disUsername.textAlignment = NSTextAlignmentLeft;
    _disUsername.textColor = [UIColor lightGrayColor];
    _disUsername.font = [UIFont systemFontOfSize:kTiltlFontSize];
    
    _dateLab = [UILabel new];
    _dateLab.top = _disUsername.top;
    _dateLab.right = SCREEN_WIDTH - 105;
    [self.contentView addSubview:_dateLab];
    _dateLab.size = CGSizeMake(100, 20);
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.textColor = [UIColor lightGrayColor];
    _dateLab.font = [UIFont systemFontOfSize:kTiltlFontSize];

    _receiptCount = [UILabel new];
    _receiptCount.top = _disUsername.top;
    _receiptCount.left = _disUsername.right + 5.0f;
    [self.contentView addSubview:_receiptCount];
    _receiptCount.size = CGSizeMake(SCREEN_WIDTH - _disUsername.width - 30 - _dateLab.width , 21.0f);
    _receiptCount.textAlignment = NSTextAlignmentCenter;
    _receiptCount.text = @"回执数量：12/23";
    _receiptCount.textColor = [UIColor lightGrayColor];
    _receiptCount.font = [UIFont systemFontOfSize:kTiltlFontSize];

    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _lineView.backgroundColor = MAIN_LINE_COLOR;
    [self.contentView addSubview:_lineView];

    
}

-(void)setLayout:(ZETeamNotiLayout *)layout
{
    float contentHeight = [ZEUtil heightForString:layout.teamNotiModel.MESSAGE font:_contentLab.font andWidth:SCREEN_WIDTH - _contentLab.left * 2];
    
    _contentLab.text = layout.teamNotiModel.MESSAGE;
    _disUsername.text = [NSString stringWithFormat:@"发布人：%@",layout.teamNotiModel.USERNAME];

    float disUsernameWidth = [ZEUtil widthForString:_disUsername.text font:_disUsername.font maxSize:CGSizeMake(200, 20)];
    _dateLab.text = [ZEUtil formatDate:layout.teamNotiModel.SYSCREATEDATE];

    _receiptCount.size = CGSizeMake(SCREEN_WIDTH - _disUsername.width - 30 - _dateLab.width , 21.0f);
//    if(layout.teamNotiModel.RECEIPTCOUNT.length > 0){
        _receiptCount.text = [NSString stringWithFormat:@"回执数量：%@",layout.teamNotiModel.RECEIPTCOUNT];
//    }else{
//        _receiptCount.text = [NSString stringWithFormat:@"回执数量：%@/23",@"0"];
//    }
    
    _contentLab.height = contentHeight;
    _disUsername.top = _contentLab.bottom + 5;
    _disUsername.width = disUsernameWidth;
    _dateLab.top = _disUsername.top;
    _receiptCount.top = _disUsername.top;
    _lineView.top = layout.height - 1;

    
    if (![layout.teamNotiModel.ISRECEIPT boolValue]) {
        _receiptCount.hidden = YES;
    }
}

@end


@interface ZETeamNotiCenView()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _notiCenTableView;
    ZEWithoutDataTipsView * _withoutTipsView;
}
@property (nonatomic,strong) NSMutableArray * layouts;

@end

@implementation ZETeamNotiCenView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - Public Method

-(void)reloadCellWithArr:(NSArray *)arr
{
    @weakify(self);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weak_self.layouts = [NSMutableArray array];
        
        for (int i = 0; i < arr.count ; i ++) {
            ZETeamNotiCenModel * teamNotiCenModel = [ZETeamNotiCenModel getDetailWithDic:arr[i]];
            ZETeamNotiLayout * layout = [[ZETeamNotiLayout alloc]initWithContent:teamNotiCenModel];
            [_layouts addObject:layout];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [_notiCenTableView reloadData];
        });
    });
}
-(void)showTipsView
{
    if (!_withoutTipsView) {
        _withoutTipsView = [[ZEWithoutDataTipsView alloc]initWithFrame:self.frame];
        _withoutTipsView.type = SHOW_TIPS_TYPE_SENDNOTICENTER;
        [self addSubview:_withoutTipsView];
        [self bringSubviewToFront:_withoutTipsView];
    }
}

-(void)hiddenTipsView{
    [_withoutTipsView removeFromSuperview];
    _withoutTipsView = nil;
}

-(void)initView
{
    _notiCenTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    _notiCenTableView.delegate = self;
    _notiCenTableView.dataSource = self;
    _notiCenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_notiCenTableView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _notiCenTableView.mj_header = header;
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _notiCenTableView.mj_footer = footer;
    
}

#pragma mark - Public Method
-(void)reloadContentViewWithArr:(NSArray *)arr{
    
    for (int i = 0; i < arr.count ; i ++) {
        ZETeamNotiCenModel * teamNotiCenModel = [ZETeamNotiCenModel getDetailWithDic:arr[i]];
        ZETeamNotiLayout * layout = [[ZETeamNotiLayout alloc]initWithContent:teamNotiCenModel];
        [self.layouts addObject:layout];
    }
    
    [_notiCenTableView.mj_header endRefreshing];
    
    if (arr.count < MAX_PAGE_COUNT) {
        [_notiCenTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_notiCenTableView.mj_footer endRefreshing];
    }
    
    [_notiCenTableView reloadData];
    
    if (arr.count == 0) {
        [self showTipsView];
    }else{
        [self hiddenTipsView];
    }
}

-(void)canLoadMoreData
{
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _notiCenTableView.mj_footer = footer;
}
-(void)reloadFirstView:(NSArray *)array
{
    self.layouts = [NSMutableArray array];
    [self reloadContentViewWithArr:array];
}
-(void)loadNewData
{
    if([self.delegate respondsToSelector:@selector(loadNewData)]){
        [self.delegate loadNewData];
    }
}

-(void)loadMoreData{
    if([self.delegate respondsToSelector:@selector(loadMoreData)]){
        [self.delegate loadMoreData];
    }
}
/**
 *  停止刷新
 */
-(void)headerEndRefreshing
{
    [_notiCenTableView.mj_header endRefreshing];
}

-(void)loadNoMoreData
{
    [_notiCenTableView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZETeamNotiLayout * layout = self.layouts[indexPath.row];
    return layout.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layouts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZETeamNotiCenTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZETeamNotiCenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell setLayout:self.layouts[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//滑动删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_notiCenTableView.isEditing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


//左滑点击事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除事件
        
        if([self.delegate respondsToSelector:@selector(didSelectDeleteBtn:)]){
            ZETeamNotiLayout * layout = self.layouts[indexPath.row];
            ZETeamNotiCenModel * MODEL = layout.teamNotiModel;
            [self.delegate didSelectDeleteBtn:MODEL];
        }
        
        [self.layouts removeObjectAtIndex:indexPath.row];//tableview数据源
        if (![self.layouts count]) { //删除此行后数据源为空
            [_notiCenTableView reloadData];
            [self showTipsView];
//            [_notiCenTableView deleteSections: [NSIndexSet indexSetWithIndex: indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
        } else {
            [_notiCenTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectNoti:)]) {
        ZETeamNotiLayout * layout =self.layouts[indexPath.row];
        [self.delegate didSelectNoti:layout.teamNotiModel];
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
