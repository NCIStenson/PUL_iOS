//
//  ZEQuestionsView.m
//  PUL_iOS
//
//  Created by Stenson on 16/7/29.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kQuestionMarkFontSize       16.0f
#define kQuestionTitleFontSize      kTiltlFontSize
#define kQuestionSubTitleFontSize   kSubTiltlFontSize

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   0.0f
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - NAV_HEIGHT

#import "ZEShowQuestionView.h"

@interface ZEShowQuestionView()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _contentTableView;
    UITextField * _questionSearchTF;
    
    QUESTION_LIST _enterShowQuestionListType;
}

@property (nonatomic,strong) NSMutableArray * datasArr;

@end

@implementation ZEShowQuestionView

-(id)initWithFrame:(CGRect)frame withEnterType:(QUESTION_LIST)enterType
{
    self = [super initWithFrame:frame];
    if (self) {
        _enterShowQuestionListType = enterType;
        self.datasArr = [NSMutableArray array];
        [self initContentTableView];
    }
    return self;
}

-(void)initContentTableView
{
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableMarginLeft);
        make.top.mas_equalTo(kContentTableMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableWidth, kContentTableHeight));
    }];

    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _contentTableView.mj_header = header;
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _contentTableView.mj_footer = footer;

}

-(void)refreshTableView
{
    [_contentTableView.mj_header endRefreshing];
}

-(UIView *)searchTextfieldView
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 30)];
    searchTFView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 18)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon"];
    [searchTFView addSubview:searchTFImg];
    
    _questionSearchTF =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 30)];
    [searchTFView addSubview:_questionSearchTF];
    _questionSearchTF.placeholder = @"关键词筛选";
    if(_enterShowQuestionListType == QUESTION_LIST_EXPERT){
        _questionSearchTF.placeholder = @"搜索问题";
    }
    [_questionSearchTF setReturnKeyType:UIReturnKeySearch];
    _questionSearchTF.font = [UIFont systemFontOfSize:14];
    _questionSearchTF.leftViewMode = UITextFieldViewModeAlways;
    _questionSearchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    _questionSearchTF.delegate=self;
    if([ZEUtil isStrNotEmpty:_searchStr]){
        _questionSearchTF.text = _searchStr;
    }
    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = 30 / 2;
    
    return searchTFView;
}
#pragma mark - Public Method

-(void)reloadContentViewWithArr:(NSArray *)dataArr{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count ; i ++) {
        ZEQuestionInfoModel * quesAnsDetail = [ZEQuestionInfoModel getDetailWithDic:dataArr[i]];
        ZENewQuetionLayout * layout = [[ZENewQuetionLayout alloc]initWithModel:quesAnsDetail];
        [arr addObject:layout];
    }
    [self.datasArr addObjectsFromArray:arr];
    [_contentTableView.mj_header endRefreshing];
    [_contentTableView.mj_footer endRefreshing];
    [_contentTableView reloadData];
    
    if (dataArr.count % MAX_PAGE_COUNT == 0 && dataArr.count > 0 ) {
        
    }else{
        [_contentTableView.mj_footer endRefreshingWithNoMoreData];
    }
}


-(void)canLoadMoreData
{
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _contentTableView.mj_footer = footer;
}
-(void)reloadFirstView:(NSArray *)array
{
    self.datasArr = [NSMutableArray array];
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
    [_contentTableView.mj_header endRefreshing];
}

-(void)loadNoMoreData
{
    [_contentTableView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc]init];
    sectionView.backgroundColor = MAIN_LINE_COLOR;
    
    UIView * textfieldView = [self searchTextfieldView];
    textfieldView.center = CGPointMake(SCREEN_WIDTH / 2, 25.0f);
    [sectionView addSubview:textfieldView];
    
    return sectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZENewQuestionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZENewQuestionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    [cell setLayout:self.datasArr[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZENewQuetionLayout * layout = nil;
    layout =  self.datasArr [indexPath.row];
    return  layout.height;
    
}

#pragma mark - 开始滑动时 下滑键盘

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_questionSearchTF resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZENewQuetionLayout * layout = _datasArr[indexPath.row];
    ZEQuestionInfoModel * quesInfoM = layout.questionInfo;
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:layout.questionInfo];
    }
}

#pragma mark - 删除功能
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_enterShowQuestionListType == QUESTION_LIST_MY_QUESTION){
        return YES;
    }else if (_enterShowQuestionListType == QUESTION_LIST_MY_ANSWER){
        return YES;
    }
    return NO;
}
//设置编辑风格EditingStyle
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当表视图处于没有未编辑状态时选择左滑删除
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZENewQuetionLayout * layout = _datasArr[indexPath.row];
    ZEQuestionInfoModel * quesInfoM = layout.questionInfo;

    if(_enterShowQuestionListType == QUESTION_LIST_MY_QUESTION){
        if([self.delegate respondsToSelector:@selector(deleteMyQuestion:)]){
            [self.delegate deleteMyQuestion:quesInfoM.SEQKEY];
        }
    }else if (_enterShowQuestionListType == QUESTION_LIST_MY_ANSWER){
        if([self.delegate respondsToSelector:@selector(deleteMyAnswer:)]){
            [self.delegate deleteMyAnswer:quesInfoM.SEQKEY];
        }
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
    if ([self.delegate respondsToSelector:@selector(goSearch:)]) {
        [self.delegate goSearch:textField.text];
    }
    return YES;
}

#pragma mark - 展示图片


#pragma mark - ZEQuestionsViewDelegate
-(void)showWebVC:(NSString *)urlStr
{
    if ([self.delegate respondsToSelector:@selector(presentWebVCWithUrl:)]) {
        [self.delegate presentWebVCWithUrl:urlStr];
    }
}

-(void)goDetailVCWithQuestionInfo:(ZEQuestionInfoModel *)infoModel
{
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:infoModel];
    }
}

-(void)giveQuestionPraise:(ZEQuestionInfoModel *)questionInfo
{
    NSInteger i = 0 ;
    
    NSMutableArray * arr = [NSMutableArray array];
    arr = self.datasArr;
    
    for (ZENewQuetionLayout * layout in arr) {
        if ([questionInfo isEqual:layout.questionInfo]) {
            ZENewQuetionLayout * newLayout = layout;
            newLayout.questionInfo.ISGOOD = YES;
            newLayout.questionInfo.GOODNUMS = [NSString stringWithFormat:@"%ld",(long) [newLayout.questionInfo.GOODNUMS integerValue] + 1 ];
            [self.datasArr replaceObjectAtIndex:i withObject:newLayout];
            break;
        }else{
            i ++;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(giveQuestionPraise:)]){
        [self.delegate giveQuestionPraise:questionInfo];
    }
}

-(void)answerQuestion:(ZEQuestionInfoModel *)questionInfo{
    if([self.delegate respondsToSelector:@selector(answerQuestion:)]){
        [self.delegate answerQuestion:questionInfo];
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
