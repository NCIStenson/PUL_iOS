//
//  ZEExpertListView.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/28.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kNavViewMarginLeft 0.0f
#define kNavViewMarginTop NAV_HEIGHT
#define kNavViewWidth SCREEN_WIDTH
#define kNavViewHeight 85.0f

#define kContentTableViewMarginLeft 0.0f
#define kContentTableViewMarginTop  (NAV_HEIGHT + kNavViewHeight)
#define kContentTableViewWidth      SCREEN_WIDTH
#define kContentTableViewHeight     SCREEN_HEIGHT - (kNavViewHeight + NAV_HEIGHT)


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

- (void)reloadCellView:(ZEExpertModel *)expertModel withIndexPath:(NSIndexPath *)indexPath;
{
    _expertModel = expertModel;
    UIImageView * detailView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_WIDTH / 3)];
    detailView.contentMode=UIViewContentModeScaleAspectFill;
    detailView.clipsToBounds=YES;
    [self.contentView addSubview:detailView];
    
    UIImageView * detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
    [detailView addSubview:detailImageView];
    [detailImageView sd_setImageWithURL:ZENITH_IMAGEURL([expertModel.FILEURL stringByReplacingOccurrencesOfString:@"," withString:@""]) placeholderImage:[UIImage imageNamed:@"icon_expert_headimage"]];
    detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    detailImageView.backgroundColor = MAIN_LINE_COLOR;
    detailImageView.clipsToBounds = YES;
    detailImageView.layer.cornerRadius = detailImageView.height / 2;
    
    float praiseNumWidth = [ZEUtil widthForString:[NSString stringWithFormat:@"%.1f",[expertModel.SCORE floatValue]] font:[UIFont boldSystemFontOfSize:kTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    UILabel * commentLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,detailImageView.top + 10,praiseNumWidth,15.0f)];
    commentLab.text  = [NSString stringWithFormat:@"%.1f",[expertModel.SCORE floatValue]];
    commentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    commentLab.textColor = RGBA(226, 138, 55, 1);
    [self.contentView addSubview:commentLab];
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 40.0f, commentLab.top , 15, 15)];
    commentImg.image = [UIImage imageNamed:@"icon_expert_star.png"];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:commentImg];
    
    UILabel * caseNameLab = [[UILabel alloc]initWithFrame:CGRectMake(detailImageView.right + 15, 15, 50, 30)];
    caseNameLab.text = expertModel.USERNAME;
    if([ZEUtil isStrNotEmpty:expertModel.GOODFIELD]){
        caseNameLab.text = expertModel.USERNAME;
    }
    [caseNameLab setTextColor:MAIN_NAV_COLOR];
    caseNameLab.font = [UIFont systemFontOfSize:20];
    [detailView addSubview:caseNameLab];
    [caseNameLab sizeToFit];
    
    UILabel * levelLab = [[UILabel alloc]initWithFrame:CGRectMake(caseNameLab.right + 5,caseNameLab.top , commentImg.left - caseNameLab.right - 10, caseNameLab.height)];
    levelLab.text = expertModel.GRADENAME;
    [levelLab setTextColor:kTextColor];
    levelLab.textAlignment = NSTextAlignmentCenter;
    levelLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [detailView addSubview:levelLab];
    
    UILabel * questionNumsLab = [[UILabel alloc]initWithFrame:CGRectMake(caseNameLab.left, caseNameLab.bottom + 10, SCREEN_WIDTH - 100, 25)];
//    if([ZEUtil isStrNotEmpty:expertModel.GOODFIELD]){
    questionNumsLab.text = [NSString stringWithFormat:@"解疑数：%@",expertModel.CLICKCOUNT];
//    }
    questionNumsLab.numberOfLines = 0;
    [questionNumsLab setTextColor:kTextColor];
    questionNumsLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [detailView addSubview:questionNumsLab];

    
    UILabel * goodFieldLab = [[UILabel alloc]initWithFrame:CGRectMake(caseNameLab.left, questionNumsLab.bottom + 5, questionNumsLab.width, 20)];
    if([ZEUtil isStrNotEmpty:expertModel.GOODFIELD]){
        goodFieldLab.text = [NSString stringWithFormat:@"擅长领域：%@",expertModel.GOODFIELD];
    }
    [goodFieldLab setTextColor:kTextColor];
    goodFieldLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [detailView addSubview:goodFieldLab];
    
    if (![expertModel.ISONLINE boolValue]) {
        UIView * whiteAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, goodFieldLab.bottom + 10)];
        whiteAlphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [detailView addSubview:whiteAlphaView];
        
        UILabel * isOnlineLab = [UILabel new];
        isOnlineLab.frame = CGRectMake(0, 0, 100, 20);
        isOnlineLab.text = @"[离线请留言]";
        isOnlineLab.textColor = kSubTitleColor;
        isOnlineLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [detailView addSubview:isOnlineLab];
        [isOnlineLab sizeToFit];
        isOnlineLab.center = CGPointMake(detailImageView.center.x, detailImageView.bottom + 15);        
    }

    
    for (int i = 0; i < 2; i ++) {
        UIButton * expertMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [expertMessageBtn setTitleColor:kSubTitleColor forState:UIControlStateNormal];
        [expertMessageBtn setFrame:CGRectMake(0 + SCREEN_WIDTH / 2 * i, goodFieldLab.bottom + 10, SCREEN_WIDTH / 2, 35)];
        expertMessageBtn.backgroundColor = MAIN_NAV_COLOR_A(0.2);
        expertMessageBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [self.contentView addSubview:expertMessageBtn];
        if (i == 0) {
            [expertMessageBtn setTitle:@"专家在线解答" forState:UIControlStateNormal];
            [expertMessageBtn addTarget:self action:@selector(goExpertOnlineAnswer) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [expertMessageBtn setTitle:@"专家历史解答" forState:UIControlStateNormal];
            [expertMessageBtn addTarget:self action:@selector(goExpertHistoryAnswer) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [ZEUtil addLineLayerMarginLeft:SCREEN_WIDTH/2 - 1 marginTop:goodFieldLab.bottom + 10 width:2 height:35 superView:self.contentView];
}

-(void)goExpertHistoryAnswer
{
    if ([_expertListView.delegate respondsToSelector:@selector(goExpertHistoryAnswer:)]) {
        [_expertListView.delegate goExpertHistoryAnswer:_expertModel];
    }
}

-(void)goExpertOnlineAnswer{
    if ([_expertListView.delegate respondsToSelector:@selector(goExpertOnlineAnswer:)]) {
        [_expertListView.delegate goExpertOnlineAnswer:_expertModel];
    }
}

@end

@implementation ZEExpertListView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.teamsDataArr = [NSMutableArray array];
        [self initNavView];
        [self initView];
    }
    return self;
}

-(void)initNavView
{
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(kNavViewMarginLeft, kNavViewMarginTop, kNavViewWidth, kNavViewHeight)];
    navView.top = 0;
    [self addSubview:navView];
    [ZEUtil addGradientLayer:navView];
    navView.top = NAV_HEIGHT;
    
    UIView * searchView = [UIView new];
    searchView.frame = CGRectMake(30 , 5, SCREEN_WIDTH - 60, 35);
    [navView addSubview:searchView];
    [searchView addSubview:[self searchTextfieldView]];
    
    UIView * orederView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, kNavViewHeight - 45)];
    orederView.backgroundColor = [UIColor whiteColor];
    [navView addSubview:orederView];
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:5 superView:orederView];
    
    levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [levelBtn setTitle:@"评级" forState:UIControlStateNormal];
    [levelBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    [levelBtn setFrame:CGRectMake(20, 5, 80, orederView.height - 5)];
    levelBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [levelBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [orederView addSubview:levelBtn];
    //    [newestBtn setImage:[UIImage imageNamed:@"icon_case_order"] forState:UIControlStateNormal];
    //    [newestBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    //    [newestBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
    questionNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [questionNumBtn setTitle:@"解疑数" forState:UIControlStateNormal];
    [questionNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [questionNumBtn setFrame:CGRectMake(120, 5, 80, orederView.height - 5)];
    questionNumBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [questionNumBtn addTarget:self action:@selector(sortCondition:) forControlEvents:UIControlEventTouchUpInside];
    [orederView addSubview:questionNumBtn];
    //    [hotestBtn setImage:[UIImage imageNamed:@"icon_case_order"] forState:UIControlStateNormal];
    //    [hotestBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    //    [hotestBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:orederView.height - 1 width:SCREEN_WIDTH height:1 superView:orederView];

}

-(UIView *)searchTextfieldView
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
    searchTFView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5 ];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 18)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon"];
    [searchTFView addSubview:searchTFImg];
    
    _questionSearchTF =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 30)];
    [searchTFView addSubview:_questionSearchTF];
    _questionSearchTF.placeholder = @"关键词筛选";
    [_questionSearchTF setReturnKeyType:UIReturnKeySearch];
    _questionSearchTF.font = [UIFont systemFontOfSize:14];
    _questionSearchTF.leftViewMode = UITextFieldViewModeAlways;
    _questionSearchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    _questionSearchTF.delegate=self;
    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = 5;
    
    return searchTFView;
}

-(void)initView{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    contentTableView.left  = kContentTableViewMarginLeft;
    contentTableView.top  = kContentTableViewMarginTop;
    contentTableView.size  = CGSizeMake(kContentTableViewWidth, kContentTableViewHeight);
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    contentTableView.mj_header = header;
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    contentTableView.mj_footer = footer;

}
#pragma mark - Public Method

-(void)reloadExpertListViw:(NSArray *)dataArr;
{
    [self.teamsDataArr addObjectsFromArray:dataArr];
    [contentTableView.mj_header endRefreshing];
    if (dataArr.count % MAX_PAGE_COUNT != 0) {
        [contentTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [contentTableView.mj_footer endRefreshing];
    }
    [contentTableView reloadData];
}

-(void)loadNewData:(id)obj{
    self.teamsDataArr = [NSMutableArray array];
    if ([self.delegate respondsToSelector:@selector(loadNewData)]) {
        [self.delegate loadNewData];
    }
}

-(void)loadMoreData{
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
    }
}
/**
 没有更多最新问题数据
 */
-(void)loadNoMoreData
{
    [contentTableView.mj_footer endRefreshingWithNoMoreData];
}

/**
 最新问题数据停止刷新
 */
-(void)headerEndRefreshing
{
    [contentTableView.mj_header endRefreshing];
}

-(void)endRefreshing
{
    [contentTableView.mj_footer endRefreshing];
    [contentTableView.mj_header endRefreshing];
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
    return 144;
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
    ZEExpertModel * expertM = [ZEExpertModel getDetailWithDic:self.teamsDataArr[indexPath.row]];
    [cell reloadCellView:expertM withIndexPath:indexPath];
    
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

-(void)sortCondition:(UIButton *)btn
{
    if ([_currentBtn isEqual:btn]) {
        return;
    }
    self.teamsDataArr = [NSMutableArray array];
    _currentBtn = btn;
    NSString *  sortOrderSQL = @"1";
    if ([btn isEqual:levelBtn]) {
        [levelBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
        [questionNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if ([btn isEqual:questionNumBtn]){
        sortOrderSQL = @"2";
        [levelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [questionNumBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    }
    if([self.delegate respondsToSelector:@selector(sortConditon:)]){
        [self.delegate sortConditon:sortOrderSQL];
    }
}

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_questionSearchTF resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.text.length > 0){
        if([self.delegate respondsToSelector:@selector(goSearchWithSearchStr:)]){
            [self.delegate goSearchWithSearchStr:textField.text];
        }
    }
    
    return YES;
}



@end
