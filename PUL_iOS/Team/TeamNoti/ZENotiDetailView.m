//
//  ZENotiDetailView.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/5.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENotiDetailView.h"
@implementation ZENotiDetailHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    UILabel * notiLab = [UILabel new];
    notiLab.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 30);
    [self addSubview:notiLab];
    notiLab.text = @"通知：";
    notiLab.textColor = kTextColor;
    
    _notiTextLab = [[UILabel alloc]init];
    _notiTextLab.numberOfLines = 0;
    _notiTextLab.frame = CGRectMake(10, notiLab.bottom + 5, SCREEN_WIDTH - 20, 50);
    _notiTextLab.font = [UIFont systemFontOfSize:14];
    _notiTextLab.textColor = kTextColor;
    [self addSubview:_notiTextLab];
    
    _lineLayer = [CALayer layer];
    _lineLayer.frame = CGRectMake(0, _notiTextLab.bottom + 5, SCREEN_WIDTH, 1.0f);
    [self.layer addSublayer:_lineLayer];
    _lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    _notiDetailLab = [UILabel new];
    _notiDetailLab.frame = CGRectMake(10, _notiTextLab.bottom + 10, SCREEN_WIDTH - 20, 30);
    [self addSubview:_notiDetailLab];
    _notiDetailLab.text = @"补充说明：";
    _notiDetailLab.textColor = [UIColor lightGrayColor];

    _notiDetailTextLab = [[UILabel alloc]init];
    _notiDetailTextLab.frame = CGRectMake(10, _notiDetailLab.bottom + 5, SCREEN_WIDTH - 20, 90);
    _notiDetailTextLab.font = [UIFont systemFontOfSize:14];
    _notiDetailTextLab.textColor = kTextColor;
    [self addSubview:_notiDetailTextLab];
    _notiDetailTextLab.numberOfLines = 0;
    
    _detailLineLayer = [CALayer layer];
    _detailLineLayer.frame = CGRectMake(0, _notiTextLab.bottom + 5, SCREEN_WIDTH, 1.0f);
    [self.layer addSublayer:_detailLineLayer];
    _detailLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    _disUsername = [UILabel new];
    _disUsername.top = _detailLineLayer.bottom + 5.0f;
    _disUsername.left = _notiDetailTextLab.left;
    [self addSubview:_disUsername];
    _disUsername.size = CGSizeMake(120, 20);
    _disUsername.textAlignment = NSTextAlignmentLeft;
    _disUsername.textColor = [UIColor lightGrayColor];
    _disUsername.font = [UIFont systemFontOfSize:kTiltlFontSize];
    
    _dateLab = [UILabel new];
    _dateLab.top = _disUsername.top;
    _dateLab.left = 10;
    [self addSubview:_dateLab];
    _dateLab.size = CGSizeMake(SCREEN_WIDTH - 20, 20);
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.textColor = [UIColor lightGrayColor];
    _dateLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"未回执",@"已回执",nil];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(20,_dateLab.bottom + 10, SCREEN_WIDTH - 40,35);
    // 设置默认选择项索引
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = MAIN_NAV_COLOR;
    [self addSubview:_segmentedControl];
    [_segmentedControl addTarget:self action:@selector(selectDiffertReceipt:) forControlEvents:UIControlEventValueChanged];
    
    _receiptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _receiptBtn.backgroundColor = [UIColor lightGrayColor];
    _receiptBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _receiptBtn.size = CGSizeMake(SCREEN_WIDTH - 40, 40);
    [self addSubview:_receiptBtn];
    [_receiptBtn setTitle:@"点击回执" forState:UIControlStateNormal];
    _receiptBtn.userInteractionEnabled = NO;
    _receiptBtn.clipsToBounds = YES;
    _receiptBtn.layer.cornerRadius = 5;
    _receiptBtn.top = _dateLab.bottom + 20;
    _receiptBtn.left = (SCREEN_WIDTH - _receiptBtn.width)/ 2;
    [_receiptBtn addTarget:self action:@selector(receiptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setViewFrames:(ZETeamNotiCenModel *)notiModel withEnterTeamNotiType:(ENTER_TEAMNOTI_TYPE)type
{
    _notiTextLab.text = notiModel.MESSAGE;
    _notiDetailTextLab.text = notiModel.REMARK;
    _disUsername.text = [NSString stringWithFormat:@"发布人：%@",notiModel.USERNAME];;
    _dateLab.text =[NSString stringWithFormat:@"发布时间：%@",[ZEUtil formatContainTime:notiModel.SYSCREATEDATE]];
    if ((type == ENTER_TEAMNOTI_TYPE_RECEIPT_N || type == ENTER_TEAMNOTI_TYPE_RECEIPT_Y ) && notiModel.QUESTIONEXPLAIN.length > 0) {
        _notiTextLab.text = notiModel.QUESTIONEXPLAIN;
        _notiTextLab.height = [ZEUtil heightForString:notiModel.QUESTIONEXPLAIN font:_notiTextLab.font andWidth:SCREEN_WIDTH - _notiTextLab.left * 2];
        _disUsername.text = [NSString stringWithFormat:@"发布人：%@",notiModel.CREATORNAME];;
        _lineLayer.frame = CGRectMake(0, _notiTextLab.bottom + 5, SCREEN_WIDTH, 1.0f);
    }
    if(type == ENTER_TEAMNOTI_TYPE_DEFAULT || type == ENTER_TEAMNOTI_TYPE_RECEIPT_N){
        _receiptBtn.hidden = YES;
    }

    if (notiModel.MESSAGE.length > 0) {
        _notiTextLab.height = [ZEUtil heightForString:notiModel.MESSAGE font:_notiTextLab.font andWidth:SCREEN_WIDTH - _notiTextLab.left * 2];
        _lineLayer.frame = CGRectMake(0, _notiTextLab.bottom + 5, SCREEN_WIDTH, 1.0f);
    }
    _notiDetailLab.top = _notiTextLab.bottom + 10;
    
    if (notiModel.REMARK.length > 0) {
        _notiDetailTextLab.height = [ZEUtil heightForString:notiModel.REMARK font:_notiDetailTextLab.font andWidth:SCREEN_WIDTH - _notiDetailTextLab.left * 2];
        _notiDetailTextLab.top = _notiDetailLab.bottom + 5;
        _detailLineLayer.top = _notiDetailTextLab.bottom + 5;
        _disUsername.top = _detailLineLayer.bottom + 5;
        _dateLab.top = _disUsername.top;

    }else{
        _notiDetailLab.hidden = YES;
        _notiDetailTextLab.hidden =YES;
        _detailLineLayer.hidden = YES;
        
        _disUsername.top = _lineLayer.bottom + 5;
        _dateLab.top = _disUsername.top;
    }
    
    _segmentedControl.top = _dateLab.bottom + 5;

    _totalHeight = _segmentedControl.bottom + 5.0f;
    if (type == ENTER_TEAMNOTI_TYPE_RECEIPT_N || type == ENTER_TEAMNOTI_TYPE_RECEIPT_Y) {
        _receiptBtn.top = _dateLab.bottom + 20;
        _totalHeight = _receiptBtn.bottom + 5.0f;
    }
}

-(void)selectDiffertReceipt:(UISegmentedControl *)seg
{
    if(seg.selectedSegmentIndex == 0){
        [_detailView reloadViewWithISReceipt:NO];
    }else{
        [_detailView reloadViewWithISReceipt:YES];
    }
}

-(void)setReceiptSelectIndex:(BOOL)isReceipt
{
    if (isReceipt) {
        _segmentedControl.selectedSegmentIndex = 1;
    }else{
        _segmentedControl.selectedSegmentIndex = 0;
    }

}

-(void)receiptBtnClick:(UIButton*)btn
{
    if ([self.detailView.delegate respondsToSelector:@selector(confirmTeamReceipt)]) {
        [self.detailView.delegate confirmTeamReceipt];
    }
}

@end

@interface ZENotiDetailView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * notiDetailTableView;
    
    ENTER_TEAMNOTI_TYPE _enterTeamNotiDetailType;
}
@property (nonatomic,strong) ZETeamNotiCenModel * notiCenModel;


@end

@implementation ZENotiDetailView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView
{
    notiDetailTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)  style:UITableViewStylePlain];
    notiDetailTableView.delegate = self;
    notiDetailTableView.dataSource = self;
    [self addSubview:notiDetailTableView];
    notiDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Public Method

-(void)reloadViewWithArr:(NSArray *)arr withNotiModel:(ZETeamNotiCenModel *)notiModel withIsReceipt:(BOOL)isReceipt
{
    _isReceipt = isReceipt;
    if (isReceipt) {
        self.notiYesReceiptArr = [NSMutableArray arrayWithArray:arr];
    }else{
        self.notiNoReceiptArr = [NSMutableArray arrayWithArray:arr];
    }
    _notiCenModel = notiModel;
    [notiDetailTableView reloadData];
    
    ZENotiDetailHeaderView * headerView =  [[ZENotiDetailHeaderView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)];
    [headerView setViewFrames:_notiCenModel  withEnterTeamNotiType:ENTER_TEAMNOTI_TYPE_DEFAULT];
    headerView.height = headerView.totalHeight;
    headerView.detailView = self;
    [headerView setReceiptSelectIndex:isReceipt];
    
    [headerView.segmentedControl setTitle:[NSString stringWithFormat:@"已回执（%ld）",(long)self.notiYesReceiptArr.count] forSegmentAtIndex:1];
    [headerView.segmentedControl setTitle:[NSString stringWithFormat:@"未回执（%ld）",(long)self.notiNoReceiptArr.count] forSegmentAtIndex:0];
    
    [notiDetailTableView beginUpdates];
    [notiDetailTableView setTableHeaderView:headerView];// 关键是这句话
    [notiDetailTableView endUpdates];

}

-(void)reloadViewWithISReceipt:(BOOL)isReceipt
{
    if (isReceipt) {
        [self reloadViewWithArr:self.notiYesReceiptArr withNotiModel:_notiCenModel withIsReceipt:isReceipt];
    }else{
        [self reloadViewWithArr:self.notiNoReceiptArr withNotiModel:_notiCenModel withIsReceipt:isReceipt];
    }
}

/**
 不需要回执页面
 */
-(void)reloadPersonalNoReceiptView:(ZETeamNotiCenModel *)notiM;
{
    _enterTeamNotiDetailType = ENTER_TEAMNOTI_TYPE_RECEIPT_N;
    
    _notiCenModel = notiM;

    ZENotiDetailHeaderView * headerView =  [[ZENotiDetailHeaderView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)];
    [headerView setViewFrames:_notiCenModel withEnterTeamNotiType:_enterTeamNotiDetailType];
    headerView.height = headerView.totalHeight;
    headerView.detailView = self;
    
    [headerView.segmentedControl setHidden:YES];
    
    [notiDetailTableView beginUpdates];
    [notiDetailTableView setTableHeaderView:headerView];// 关键是这句话
    [notiDetailTableView endUpdates];
}

/**
 需要回执页面
 */
-(void)reloadPersonalYesReceiptView:(ZETeamNotiCenModel *)notiM isReceipt:(BOOL)isReceipt
{
    _enterTeamNotiDetailType = ENTER_TEAMNOTI_TYPE_RECEIPT_Y;
    
    _notiCenModel = notiM;

    ZENotiDetailHeaderView * headerView =  [[ZENotiDetailHeaderView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)];
    [headerView setViewFrames:_notiCenModel withEnterTeamNotiType:_enterTeamNotiDetailType];
    headerView.height = headerView.totalHeight;
    headerView.detailView = self;
    
    if (isReceipt) {
        [headerView.receiptBtn setTitle:@"已回执" forState:UIControlStateNormal];
        [headerView.receiptBtn setBackgroundColor:[UIColor lightGrayColor]];
        headerView.receiptBtn.userInteractionEnabled = NO;
    }else{
        [headerView.receiptBtn setTitle:@"点击回执" forState:UIControlStateNormal];
        [headerView.receiptBtn setBackgroundColor:MAIN_NAV_COLOR];
        headerView.receiptBtn.userInteractionEnabled = YES;
    }
    
    [headerView.segmentedControl setHidden:YES];
    
    [notiDetailTableView beginUpdates];
    [notiDetailTableView setTableHeaderView:headerView];// 关键是这句话
    [notiDetailTableView endUpdates];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isReceipt) {
        return self.notiYesReceiptArr.count;
    }else{
        return self.notiNoReceiptArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID  = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    [self cellForTeamMemberListView:indexPath cellView:cell.contentView];
    
    return cell;
}


-(void)cellForTeamMemberListView:(NSIndexPath *)indexPath cellView:(UIView *)cellView
{
    NSDictionary * dic;
    
    if (_isReceipt) {
        dic = self.notiYesReceiptArr[indexPath.row];
    }else{
        dic = self.notiNoReceiptArr[indexPath.row];
    }
    
    NSString * USERNAME = [dic objectForKey:@"USERNAME"];
    NSString * HEADIMAGEURL = [[[dic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@"//"];
    
        UILabel * rankingLab = [UILabel new];
        [cellView addSubview:rankingLab];
        rankingLab.frame = CGRectMake(10, 15, 30, 30);
        rankingLab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
        rankingLab.textAlignment = NSTextAlignmentCenter;
        rankingLab.textColor = kTextColor;
    
    if(HEADIMAGEURL.length > 0){
        UIImageView * headimage = [UIImageView new];
        headimage.frame = CGRectMake(50, 5, 50, 50);
        [cellView addSubview:headimage];
        headimage.clipsToBounds = YES;
        headimage.layer.cornerRadius = headimage.height/ 2;
        [headimage sd_setImageWithURL:ZENITH_IMAGEURL(HEADIMAGEURL) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    }else{
        UILabel * lastName = [UILabel new];
        [cellView addSubview:lastName];
        lastName.frame = CGRectMake(50, 5, 50, 50);
        lastName.backgroundColor = MAIN_ARM_COLOR;
        lastName.clipsToBounds = YES;
        lastName.layer.cornerRadius = lastName.height / 2;
        if(USERNAME.length > 0){
            lastName.text = [USERNAME substringToIndex:1];
        }
        lastName.textAlignment = NSTextAlignmentCenter;
        lastName.textColor = [UIColor whiteColor];
    }
    
    UILabel * usernameLab = [UILabel new];
    [cellView addSubview:usernameLab];
    usernameLab.frame = CGRectMake(110, 5, 150, 50);
    usernameLab.text = USERNAME;
    usernameLab.textAlignment = NSTextAlignmentLeft;
    usernameLab.textColor = kTextColor;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [cellView addSubview:lineView];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
