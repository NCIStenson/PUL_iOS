//
//  ZENewSearchQuestionView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/15.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kNavBarMarginLeft   0.0f
#define kNavBarMarginTop    0.0f
#define kNavBarWidth        SCREEN_WIDTH
#define kNavBarHeight       NAV_HEIGHT

// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft 10.0f
#define kLeftButtonMarginTop (IPHONEX ? 40.0f : 18.0f)

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   kNavBarHeight
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - NAV_HEIGHT

#import "ZENewSearchQuestionView.h"

@interface ZENewSearchQuestionView()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ZENewQuestionListCellDelegate,ZEAskQuestionTypeViewDelegate>
{
    UITableView * _contentTableView;
    UITextField * _questionSearchTF;
    
    QUESTION_LIST _enterShowQuestionListType;
    
    ZEAskQuestionTypeView * _askTypeView;
}

@property (nonatomic,strong) NSMutableArray * datasArr;

@end

@implementation ZENewSearchQuestionView

-(id)initWithFrame:(CGRect)frame withEnterType:(QUESTION_LIST)enterType
{
    self = [super initWithFrame:frame];
    if (self) {
        _enterShowQuestionListType = enterType;
        self.datasArr = [NSMutableArray array];
        [self initNavBar];
        [self initContentTableView];
    }
    return self;
}
-(void)initNavBar
{
    UIView * navView = [[UIView alloc] initWithFrame:CGRectZero];
    navView.backgroundColor = MAIN_NAV_COLOR;
    [self addSubview:navView];
    navView.frame = CGRectMake(kNavBarMarginLeft, kNavBarMarginTop, kNavBarWidth, kNavBarHeight);
    
    [ZEUtil addGradientLayer:navView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, kLeftButtonWidth, kLeftButtonHeight);
    if(IPHONE6_MORE){
        backBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, 50, 50);
    }
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0, 0.0f, 0.0f);
    backBtn.contentMode = UIViewContentModeScaleAspectFill;
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [backBtn setImage:[UIImage imageNamed:@"icon_back" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UIButton * _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeBtn.frame = CGRectMake(SCREEN_WIDTH - kLeftButtonWidth - 10, kLeftButtonMarginTop, kLeftButtonWidth, kLeftButtonHeight);
    if(IPHONE6_MORE){
        _typeBtn.frame = CGRectMake(SCREEN_WIDTH - 60, kLeftButtonMarginTop, 50, 50);
    }
    _typeBtn.contentMode = UIViewContentModeScaleAspectFill;
    _typeBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_typeBtn setImage:[UIImage imageNamed:@"icon_question_searchType" tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(showTypeSearch) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_typeBtn];
    
    UIView * searchView = [UIView new];
    searchView.frame = CGRectMake(backBtn.right , backBtn.top + 10, SCREEN_WIDTH - 120, 30);
    [navView addSubview:searchView];
    [searchView addSubview:[self searchTextfieldView]];
        
}

-(void)initContentTableView
{
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.frame = CGRectMake(kContentTableMarginLeft, kContentTableMarginTop, kContentTableWidth, kContentTableHeight);

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
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 30)];
    searchTFView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5 ];
    
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

-(void)reloadContentViewWithArr:(NSArray *)arr{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < arr.count ; i ++) {
            ZEQuestionInfoModel * quesAnsDetail = [ZEQuestionInfoModel getDetailWithDic:arr[i]];
            ZENewQuetionLayout * layout = [[ZENewQuetionLayout alloc]initWithModel:quesAnsDetail];
            [self.datasArr addObject:layout];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_contentTableView.mj_header endRefreshing];
            [_contentTableView.mj_footer endRefreshing];
            [_contentTableView reloadData];
            
            if (_datasArr.count % MAX_PAGE_COUNT == 0 && _datasArr.count > 0 ) {
                
            }else{
                [_contentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        });
        
    });
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.datasArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZENewQuetionLayout * layout = nil;
    layout =  self.datasArr[indexPath.row];
    
    return  layout.height;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZENewQuetionLayout * layout = nil;
    layout =  self.datasArr[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:layout.questionInfo ];
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
    NSDictionary * datasDic = _datasArr[indexPath.row];
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(_askTypeView){
        for (UIView * view in _askTypeView.subviews) {
            [view removeFromSuperview];
        }
        [_askTypeView removeFromSuperview];
        _askTypeView = nil;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(goSearch:)]) {
        [self.delegate goSearch:textField.text];
    }
    return YES;
}

-(void)showTypeSearch
{
    [self endEditing:YES];
    
    if(_askTypeView){
        for (UIView * view in _askTypeView.subviews) {
            [view removeFromSuperview];
        }
        [_askTypeView removeFromSuperview];
        _askTypeView = nil;
        return;
    }
    if ([self.delegate respondsToSelector:@selector(hiddenWithoutTipsView)]) {
        [self.delegate hiddenWithoutTipsView];
    }
    
    _askTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)  withMarginTop:NAV_HEIGHT];
    _askTypeView.delegate = self;
    [self addSubview:_askTypeView];
    _askTypeView.backgroundColor = [UIColor clearColor];
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        [_askTypeView reloadTypeData];
    }

}

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode fatherCode:(NSString *)fatherCode
{
    for (UIView * view in _askTypeView.subviews) {
        [view removeFromSuperview];
    }
    [_askTypeView removeFromSuperview];
    _askTypeView = nil;

    if (typeName.length == 0  && typeCode.length == 0 &&  fatherCode.length == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goTypeSearchWithTypeCode:withParentCode:)]) {
        [self.delegate goTypeSearchWithTypeCode:typeCode withParentCode:fatherCode];
    }
    
}

#pragma mark - ZENewQuestionListCellDelegate

-(void)giveQuestionPraise:(ZEQuestionInfoModel *)questionInfo
{
    NSInteger i = 0 ;
    for (ZENewQuetionLayout * layout in self.datasArr) {
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



#pragma mark - ZENewSearchQuestionsViewDelegate

-(void)goBack
{
    if([self.delegate respondsToSelector:@selector(goBack)]){
        [self.delegate goBack];
    }
}

@end
