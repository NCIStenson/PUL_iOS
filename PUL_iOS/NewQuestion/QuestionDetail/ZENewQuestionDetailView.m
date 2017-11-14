//
//  ZENewQuestionDetailView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZENewQuestionDetailView.h"

#import "ZENewQuestionListCell.h"

@implementation ZENewQuestionDetailView

-(id)initWithFrame:(CGRect)frame
  withQuestionInfo:(ZEQuestionInfoModel *)questionInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        _questionInfoModel = questionInfo;
        self.answerInfoArr = [NSMutableArray array];
        [self initView];
    }
    return self;
}

-(void)initView{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    [self addSubview:contentTableView];
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 35);
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentTableView registerClass:[ZENewQuestionDetailCell class] forCellReuseIdentifier:@"cell"];
    
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewNewestData:)];
//    contentTableView.mj_header = header;
    
    if ([_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        contentTableView.height = SCREEN_HEIGHT - NAV_HEIGHT;
        return;
    }
    
    
    for (int i = 0; i < 2; i ++) {
        UIButton * answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        answerBtn.frame = CGRectMake(SCREEN_WIDTH / 2 * i, contentTableView.bottom, SCREEN_WIDTH / 2, 35);
        [answerBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
        [answerBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
        answerBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [self addSubview:answerBtn];
        answerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        answerBtn.backgroundColor = MAIN_LINE_COLOR;
        
        if (i == 0) {
            [answerBtn setTitle:@" 回答" forState:UIControlStateNormal];
            [answerBtn setImage:[UIImage imageNamed:@"center_name_logo.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
            [answerBtn addTarget:self action:@selector(answerQuestion) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [answerBtn setTitle:@" 赞" forState:UIControlStateNormal];
            [answerBtn setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png"] forState:UIControlStateNormal];
            [answerBtn addTarget:self action:@selector(giveQuestionPraise:) forControlEvents:UIControlEventTouchUpInside];
            _praiseBtn = answerBtn;
            
            if ([_questionInfoModel.GOODNUMS integerValue] == 0) {
                [_praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
            }else{
                [_praiseBtn setTitle:[NSString stringWithFormat:@" %@",_questionInfoModel.GOODNUMS] forState:UIControlStateNormal];
            }
            
            if (_questionInfoModel.ISGOOD) {
                _praiseBtn.enabled = NO;
                [_praiseBtn setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
            }

        }
    }
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, contentTableView.bottom, SCREEN_WIDTH, 1);
    [self addSubview:lineView];
    lineView.backgroundColor =RGBA(217, 217, 217, 1);

    UIView * lineView1 = [UIView new];
    lineView1.frame = CGRectMake(SCREEN_WIDTH / 2 - 2, contentTableView.bottom + 6, 2, 25);
    [self addSubview:lineView1];
    lineView1.backgroundColor =RGBA(217, 217, 217, 1);
}




#pragma mark - Public Method

-(void)reloadViewWithData:(NSArray *)arr
{
//    _answerInfoArr = arr;
    ZE_weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZE_strongify(weakSelf);

        _answerInfoArr = [NSMutableArray array];
        for (int i = 0; i < arr.count ; i ++) {
            ZEAnswerInfoModel * answerInfoM = [ZEAnswerInfoModel getDetailWithDic:arr[i]];
            ZENewDetailLayout * layout = [[ZENewDetailLayout alloc]initWithModel:answerInfoM withQuestionModel:_questionInfoModel];
            [_answerInfoArr addObject:layout];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count == 0 ) {
                contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                return;
            }else{
                contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                [tipsView removeAllSubviews];
                [tipsView removeFromSuperview];
                tipsView = nil;
            }
            [contentTableView reloadData];
        });
        
    });
    
}


#pragma mark - UITableViewDataSource


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZENewQuetionLayout * layout = [[ZENewQuetionLayout alloc] initWithModel:_questionInfoModel ishiddenMode:NO];

    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, layout.height + 50)];
//    headerView.backgroundColor = [UIColor cyanColor];
    
    ZENewQuestionListCell * cellView = [[ZENewQuestionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cellView setLayout:layout];
    [headerView addSubview:cellView];

    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, layout.height + 10, SCREEN_WIDTH, 5)];
    [headerView addSubview:lineView];
    lineView.backgroundColor = MAIN_LINE_COLOR;
    
    UILabel * commentLab = [UILabel new];
    commentLab.frame = CGRectMake(20, lineView.bottom, SCREEN_WIDTH - 40, 40);
    [headerView addSubview:commentLab];
    commentLab.text = @"评论 66666";
    commentLab.textColor = kTextColor;
    commentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    float width = [ZEUtil widthForString:commentLab.text font:commentLab.font maxSize:CGSizeMake(SCREEN_WIDTH, 30)];
    commentLab.width  =width;
    
    UIView * underlineView = [UIView new];
    underlineView.backgroundColor = MAIN_NAV_COLOR;
    underlineView.frame = CGRectMake(0, 0, 40, 4);
    underlineView.center = CGPointMake(width / 2 + 20, commentLab.bottom - 2);
    [headerView addSubview:underlineView];
    
    UIButton * orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(SCREEN_WIDTH - 80, commentLab.top, 60, 40);
    [orderBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
    [orderBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [headerView addSubview:orderBtn];
    orderBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [orderBtn setTitle:@" 按热度" forState:UIControlStateNormal];
    [orderBtn setImage:[UIImage imageNamed:@"center_name_logo.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(answerQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ZENewQuetionLayout * layout = [[ZENewQuetionLayout alloc] initWithModel:_questionInfoModel ishiddenMode:NO];
    return layout.height + 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZENewQuestionDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZENewQuestionDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (_answerInfoArr.count == 0 && [_questionInfoModel.ANSWERSUM integerValue] == 0) {
        tipsView = [[ZEWithoutDataTipsView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 300)];
        tipsView.type = SHOW_TIPS_TYPE_QUESTIONDETAIL;
        tipsView.imageType = SHOW_TIPS_IMAGETYPE_CRY;
        [cell.contentView addSubview:tipsView];
    }else{
        cell.delegate = self;
        cell.detailLayout = _answerInfoArr[indexPath.row];
//        [self initCellContentView:cell.contentView withIndexPath:indexPath];
    }

    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_answerInfoArr.count == 0 && [_questionInfoModel.ANSWERSUM integerValue] == 0){
        return 1;
    }
    return  _answerInfoArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_answerInfoArr.count == 0 && [_questionInfoModel.ANSWERSUM integerValue] == 0) {
        return 300;
    }
    
    ZENewDetailLayout * detailLayout = _answerInfoArr[indexPath.row];
    return detailLayout.height;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_answerInfoArr.count == 0 && [_questionInfoModel.ANSWERSUM integerValue] == 0) {
        return;
    }
    ZENewDetailLayout * detailLayout = _answerInfoArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(enterAnswerDetailView:)]) {
        [self.delegate enterAnswerDetailView:detailLayout.answerInfo];
    }
}

#pragma mark - ZENewQuestionDetailViewDelegate

-(void)answerQuestion{
    if ([self.delegate respondsToSelector:@selector(answerQuestion)]) {
        [self.delegate answerQuestion];
    }
}

-(void)giveQuestionPraise:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(giveQuestionPraise)]){
        [self.delegate giveQuestionPraise];
    }
}

-(void)giveAnswerPraise:(ZEAnswerInfoModel *)answerInfo
{
    if ([self.delegate respondsToSelector:@selector(giveAnswerPraise:)]) {
        [self.delegate giveAnswerPraise:answerInfo];
    }
}

-(void)acceptAnswer:(ZEAnswerInfoModel *)answerInfo
{
    if([self.delegate respondsToSelector:@selector(acceptBestAnswer:)]){
        [self.delegate acceptBestAnswer:answerInfo];
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
