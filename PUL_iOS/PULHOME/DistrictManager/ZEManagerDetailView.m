//
//  ZEManagerDetailView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kTabbarHeight 70.0
#define kCellHeight 70

#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      (SCREEN_HEIGHT - NAV_HEIGHT - kTabbarHeight)

#define kInputViewMarginLeft  0.0f
#define kInputViewMarginTop   SCREEN_HEIGHT - kInputViewHeight
#define kInputViewWidth       SCREEN_WIDTH
#define kInputViewHeight      40.0f

#import "ZEManagerDetailView.h"
#import "ZEKLB_CLASSICCASE_INFOModel.h"
#import "ZEButton.h"
#import "ZEDistrictManagerCell.h"

@implementation ZEManagerDetailView

-(id)initWithFrame:(CGRect)frame withData:(ZEDistrictManagerModel *)managerModel
{
    self = [super initWithFrame:frame];
    if (self) {
        detailManagerModel = managerModel;
        _currentDetailType = MANAGERDETAIL_TYPE_INTR;
        [self initView];
        [self initTabbarView];
    }
    return self;
}
#pragma mark - Public Method

-(void)reloadAboutCourseData:(NSArray *)arr
{
    self.aboutArr = [NSMutableArray arrayWithArray:arr];
    if(_currentDetailType == MANAGERDETAIL_TYPE_CASE){
        [_contentView reloadData];
    }
}

-(void)reloadSectionView:(NSDictionary *)detailDic
{
    managerDetailDic = detailDic;
    [_contentView reloadData];
}

-(void)reloadFirstView:(NSArray *)arrData
{
    self.commentArr = [NSMutableArray array];
    [self reloadMoreDataView:arrData];
}

-(void)reloadMoreDataView:(NSArray *)arrData
{
    [self.commentArr addObjectsFromArray:arrData];
    [_contentView.mj_header endRefreshing];
    if (arrData.count % MAX_PAGE_COUNT != 0) {
        [_contentView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_contentView.mj_footer endRefreshing];
    }
    [_contentView reloadData];
}

/**
 *  停止刷新
 */
-(void)headerEndRefreshing
{
    [_contentView.mj_header endRefreshing];
}

-(void)loadNoMoreData
{
    [_contentView.mj_footer endRefreshingWithNoMoreData];
}

-(void)publishCommentSuccess
{
    inputField.text = @"";
    inputField.placeholder = @"我也来说一句";
}

-(void)initTabbarView
{
    tabbarView = [UIView new];
    tabbarView.frame = CGRectMake(0, SCREEN_HEIGHT - kTabbarHeight, SCREEN_WIDTH , kTabbarHeight);
    [self addSubview:tabbarView];
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:1 superView:tabbarView];
    
    for (int i = 0; i < 3; i ++) {
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(SCREEN_WIDTH /3  * i , 5 , SCREEN_WIDTH / 3 , 40);
        [tabbarView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor clearColor];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [optionBtn addTarget:self action:@selector(goManagerCourse:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 105;
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
        optionBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        
        UILabel * nameLab = [UILabel new];
        nameLab.frame = CGRectMake(SCREEN_WIDTH / 3 * i , 50 , SCREEN_WIDTH / 3 , 15);
        [tabbarView addSubview:nameLab];
        nameLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        nameLab.textColor = kTextColor;
        nameLab.textAlignment = NSTextAlignmentCenter;
        
        switch (i) {
            case 0:
                [optionBtn setImage:[UIImage imageNamed:@"icon_manager_coll"] forState:UIControlStateNormal];
                //                [optionBtn setTitle:@"我的错题" forState:UIControlStateNormal];
                nameLab.text = @"我的收藏";
                break;
            case 1:
                if ([detailManagerModel.ISTHEORY integerValue] == 1) {
                    [optionBtn setImage:[UIImage imageNamed:@"icon_manager_tabbar_practice" ] forState:UIControlStateNormal];
                    //                [optionBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
                    nameLab.text = @"题库练习";
                }else if ([detailManagerModel.ISTHEORY integerValue] == 2){
                    [optionBtn setImage:[UIImage imageNamed:@"icon_manager_tabbar_stand" ] forState:UIControlStateNormal];
                    //                [optionBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
                    nameLab.text = @"实操规范";
                    optionBtn.tag = 108;
                }
                
                break;
            case 2:
                [optionBtn setImage:[UIImage imageNamed:@"icon_manager_tabbar_study" ] forState:UIControlStateNormal];
                //                [optionBtn setTitle:@"学习讨论区" forState:UIControlStateNormal];
                nameLab.text = @"学习讨论区";
                break;
                
            default:
                break;
        }
    }
}

-(void)initView
{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight) style:UITableViewStyleGrouped];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self addSubview:_contentView];
    
    //    MJRefreshHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    //    _contentView.mj_header = header;
    
    [_contentView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    navSegmentControlView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 50.0f)];
    navSegmentControlView.backgroundColor = [UIColor whiteColor];
    [self addSubview:navSegmentControlView];
    navSegmentControlView.hidden = YES;
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc]initWithItems:@[@"课件简介",@"相关课件",@"评论"]];
    [segControl addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventValueChanged];
    segControl.frame = CGRectMake(10, 10, SCREEN_WIDTH  - 20, 30);
    segControl.selectedSegmentIndex = _currentDetailType;
    segControl.tintColor = MAIN_NAV_COLOR;
    [navSegmentControlView addSubview:segControl];
    
    [self initInputView];
}

#pragma mark - initInputView

-(void)initInputView
{
    inputView = [[UIView alloc]initWithFrame:CGRectMake(kInputViewMarginLeft, kInputViewMarginTop, kInputViewWidth, kInputViewHeight)];
    inputView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:inputView];
    inputView.hidden = YES;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    lineView.backgroundColor = MAIN_NAV_COLOR;
    [inputView addSubview:lineView];
    
    inputField = [[UITextField alloc]initWithFrame:CGRectMake(20, 5.0f, SCREEN_WIDTH - 100.0f, 30.0f)];
    inputField.placeholder = @"我也来说一句";
    inputField.delegate = self;
    inputField.font = [UIFont systemFontOfSize:12];
    [inputView addSubview:inputField];
    inputField.layer.borderColor = [MAIN_NAV_COLOR CGColor];
    inputField.layer.borderWidth = 0.5f;
    inputField.layer.cornerRadius = 5.0f;
    inputField.leftViewMode = UITextFieldViewModeAlways;
    inputField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 5.0f, 60, 30);
    [inputView addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sendBtn.clipsToBounds = YES;
    sendBtn.layer.cornerRadius =10;
    sendBtn.layer.borderColor = [MAIN_NAV_COLOR_A(0.5) CGColor];
    sendBtn.layer.borderWidth = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
        [self addGestureRecognizer:tap];
    }
    
    //获取键盘的高度
    CGRect begin = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    CGRect end = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if(begin.size.height > 0 && (end.size.height - begin.size.height > 0)){
        [UIView animateWithDuration:0.29 animations:^{
            inputView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - end.size.height - kInputViewHeight, kContentViewWidth, kInputViewHeight);
        }];
        
    }else{
        [UIView animateWithDuration:0.29 animations:^{
            inputView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - begin.size.height - kInputViewHeight, kContentViewWidth, kInputViewHeight);
        }];
        
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self removeGestureRecognizer:tap];
    tap = nil;
    
    [UIView animateWithDuration:0.29 animations:^{
        inputView.frame = CGRectMake(kInputViewMarginLeft, kInputViewMarginTop, kInputViewWidth, kInputViewHeight);
    }];
}

-(void)hiddenKeyboard{
    [self endEditing:YES];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_currentDetailType == MANAGERDETAIL_TYPE_COMMENT){
        return self.commentArr.count;
    }else if (_currentDetailType == MANAGERDETAIL_TYPE_CASE){
        return self.aboutArr.count;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentDetailType == MANAGERDETAIL_TYPE_COMMENT) {
        NSDictionary * dataDic = self.commentArr[indexPath.row];
        float contentHeight = [ZEUtil heightForString:[dataDic objectForKey:@"CONTENTEXPLAIN"] font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH - 100.0f];
        return contentHeight + 55.0f;
    }else if (_currentDetailType == MANAGERDETAIL_TYPE_CASE){
        return kCellHeight;
    }
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_currentDetailType == MANAGERDETAIL_TYPE_COMMENT){
        return SCREEN_WIDTH / 2  + 80 ;
    }else if (_currentDetailType == MANAGERDETAIL_TYPE_CASE){
        return SCREEN_WIDTH / 2  + 40 ;
    }
    
    ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:managerDetailDic];
    float contentHeight = [ZEUtil heightForString:infoM.CASEEXPLAIN font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH - 20.0f];
    
    return SCREEN_WIDTH / 2  + 40 + contentHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView = [UIView new];
    
    [self initCommonView:bgView];
    
    if(_currentDetailType == MANAGERDETAIL_TYPE_INTR){
        [self initDetailView:bgView];
    }
    
    return bgView;
}
-(void)initCommonView:(UIView *)superView
{
    UIView * commonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 2 + 40)];
    [superView addSubview:commonView];
    
    UIButton * detailBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    detailBtn.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 2 );
    detailBtn.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [commonView addSubview:detailBtn];
    [detailBtn addTarget:self action:@selector(courseClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (detailManagerModel.FORMATPHOTOURL.length > 0) {
        [detailBtn sd_setImageWithURL:ZENITH_IMAGEURL(detailManagerModel.FORMATPHOTOURL) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    }
    
    for (int i = 0; i < 3; i ++) {
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(SCREEN_WIDTH / 3 * i , SCREEN_WIDTH / 2 , SCREEN_WIDTH / 3 , 40);
        [commonView addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = i + 100;

        switch (i) {
            case 0:
                [optionBtn setTitle:@"课件简介" forState:UIControlStateNormal];
                break;
            case 1:
                [optionBtn setTitle:@"相关课件" forState:UIControlStateNormal];
                break;
            case 2:
                [optionBtn setTitle:@"评论" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        if (i == _currentDetailType) {
            UIView * underBtnLineView = [UIView new];
            underBtnLineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/6, 2);
            underBtnLineView.backgroundColor = MAIN_NAV_COLOR;
            [commonView addSubview:underBtnLineView];
            [optionBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
            underBtnLineView.centerX = optionBtn.centerX;
            underBtnLineView.centerY = optionBtn.bottom - 1;
        }
    }
    
    if (_currentDetailType == MANAGERDETAIL_TYPE_COMMENT) {
        commonView.height = SCREEN_WIDTH/2 + 80;
        commonView.backgroundColor = [UIColor whiteColor];
        
        UILabel * commentCountLab = [UILabel new];
        commentCountLab.text =[NSString stringWithFormat:@"评论 %@",detailManagerModel.COMMENTCOUNT];
        commentCountLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        commentCountLab.frame = CGRectMake(20, SCREEN_WIDTH / 2 + 40, SCREEN_WIDTH - 40, 40);
        commentCountLab.textColor = kTextColor;
        [commonView addSubview:commentCountLab];
        
        [ZEUtil addLineLayerMarginLeft:0 marginTop:commentCountLab.top width:SCREEN_WIDTH height:2 superView:commonView];
        [ZEUtil addLineLayerMarginLeft:0 marginTop:commentCountLab.bottom - 1 width:SCREEN_WIDTH height:1 superView:commonView];
    }
}

-(void)initDetailView:(UIView *)superView
{
    UIView * detailView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH / 2 + 40, SCREEN_WIDTH, 160)];
    [superView addSubview:detailView];
    
    float contentHeight = [ZEUtil heightForString:detailManagerModel.COURSEXPLAIN font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40.0f];
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 40.0f, contentHeight)];
    contentLab.text = detailManagerModel.COURSEXPLAIN;
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [detailView addSubview:contentLab];
    
    detailView.frame = CGRectMake(0, SCREEN_WIDTH / 2 + 40, SCREEN_WIDTH, 15 + contentHeight);
}

#pragma mark - changeDetailOrComment

-(void)changeContent:(UIButton *)btn
{
    _currentDetailType = btn.tag - 100;
    
    UISegmentedControl * segCont = navSegmentControlView.subviews[0];
    segCont.selectedSegmentIndex = _currentDetailType;
    
    if (_currentDetailType == MANAGERDETAIL_TYPE_COMMENT) {
        _contentView.frame = CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight + 30.f);
        inputView.hidden = NO;
        tabbarView.hidden = YES;
        _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _contentView.mj_footer = footer;
        
        if ([self.delegate respondsToSelector:@selector(showCommentView)]) {
            [self.delegate showCommentView];
        }
        
    }else{
        _contentView.frame = CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight);
        inputView.hidden = YES;
        tabbarView.hidden = NO;
        _contentView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_contentView.mj_footer removeFromSuperview];
//        if ([self.delegate respondsToSelector:@selector(showCourseView)]) {
//            [self.delegate showCourseView];
//        }
        
    }
    [self endEditing:YES];
    [_contentView reloadData];
    _contentView.contentOffset = CGPointMake(0, 0);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZEDistrictManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZEDistrictManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_currentDetailType == MANAGERDETAIL_TYPE_COMMENT) {
        [self initCommentCellView:cell.contentView withIndexpath:indexPath];
    }else if (_currentDetailType == MANAGERDETAIL_TYPE_CASE){
        NSDictionary * dic = self.aboutArr[indexPath.row];
        [cell initUIWithDic:dic];
    }else{
        [self initCellView:cell.contentView withIndexpath:indexPath];
    }
    
    return cell;
}
-(void)initCommentCellView:(UIView *)cellView withIndexpath:(NSIndexPath *)indexPath
{
    NSDictionary * dataDic = self.commentArr[indexPath.row];
    
    UIImageView * userHeaderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f,10.0f, 55.0f, 55.0f)];
    
    [userHeaderImgView sd_setImageWithURL:ZENITH_IMAGEURL([[[dataDic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [cellView addSubview:userHeaderImgView];
    userHeaderImgView.contentMode = UIViewContentModeScaleAspectFill;
    userHeaderImgView.clipsToBounds = YES;
    userHeaderImgView.layer.cornerRadius = 27.5f;
    
    UILabel * usernameLab = [[UILabel alloc]initWithFrame:CGRectMake(85.0f, 10.0f, SCREEN_WIDTH - 100.0f, 20.0f)];
    usernameLab.text = [NSString stringWithFormat:@"%@：",[dataDic objectForKey:@"USERNAME"]];
    usernameLab.numberOfLines = 0;
    usernameLab.textColor = [UIColor blueColor];
    usernameLab.font = [UIFont systemFontOfSize:12];
    [cellView addSubview:usernameLab];
    
    float contentHeight = [ZEUtil heightForString:[dataDic objectForKey:@"CONTENTEXPLAIN"] font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH - 100.0f];
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(85.0f, 30.0f, SCREEN_WIDTH - 100.0f, contentHeight)];
    contentLab.text = [dataDic objectForKey:@"CONTENTEXPLAIN"];
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont systemFontOfSize:12];
    [cellView addSubview:contentLab];
    
    UILabel * timeLab = [[UILabel alloc]initWithFrame:CGRectMake(85.0f, 30.0f + contentHeight, SCREEN_WIDTH - 100.0f, 20.0f)];
    timeLab.text = [ZEUtil compareCurrentTime:[dataDic objectForKey:@"SYSCREATEDATE"]];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.numberOfLines = 0;
    timeLab.font = [UIFont systemFontOfSize:10];
    [cellView addSubview:timeLab];
    
    //    UIButton * replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    replyBtn.frame = CGRectMake(SCREEN_WIDTH - 50,timeLab.frame.origin.y , 40, 20);
    //    [cellView addSubview:replyBtn];
    //    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    //    [replyBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    //    replyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    //    replyBtn.clipsToBounds = YES;
    //    replyBtn.layer.cornerRadius =10;
    //    replyBtn.layer.borderColor = [MAIN_NAV_COLOR_A(0.5) CGColor];
    //    replyBtn.layer.borderWidth = 1;
    //    [replyBtn addTarget:self action:@selector(replyCurrentPeople:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * replyLineView = [[UIView alloc]initWithFrame:CGRectMake(85.0f, timeLab.frame.origin.y + 25.0f, SCREEN_WIDTH - 85.0f, 1.0f)];
    replyLineView.backgroundColor = MAIN_LINE_COLOR;
    [cellView addSubview:replyLineView];
    
}
-(void)initCellView:(UIView *)cellView withIndexpath:(NSIndexPath *)indexPath
{
    ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:managerDetailDic];
    
    UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f,10.0f, 30.0f, 30.0f)];
    [iconImageView setImage:[UIImage imageNamed:@"ic_vedio_play" color:MAIN_ARM_COLOR]];
    [cellView addSubview:iconImageView];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = 15.0f;
    
    UILabel * courseLab = [[UILabel alloc]initWithFrame:CGRectMake(50.0f, 7.0f, SCREEN_WIDTH - 100.0f, 36.0f)];
    courseLab.numberOfLines = 0;
    courseLab.font = [UIFont systemFontOfSize:12];
    [cellView addSubview:courseLab];
    if (indexPath.row < infoM.COURSEFILENAMEARR.count ) {
        NSLog(@">>>.  %@",infoM.COURSEFILENAMEARR);
        courseLab.text = infoM.COURSEFILENAMEARR[indexPath.row];
    }else{
        //  h5连接根据','分割
        NSArray * H5URLNAMEarr = [infoM.H5URLNAME componentsSeparatedByString:@","];
        
        courseLab.text = H5URLNAMEarr[indexPath.row - infoM.COURSEFILENAMEARR.count];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentDetailType == MANAGERDETAIL_TYPE_CASE){
        if ([self.delegate respondsToSelector:@selector(goNextCourseDetail:)]) {
            [self.delegate goNextCourseDetail:self.aboutArr[indexPath.row]];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]){
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (offset.y > 150.0f) {
            navSegmentControlView.hidden = NO;
        }else{
            navSegmentControlView.hidden = YES;
        }
    }
}

-(void)loadMoreData
{
    if ([self.delegate respondsToSelector:@selector(loadMoreData)]) {
        [self.delegate loadMoreData];
    }
}

-(void)sendComment
{
    [self endEditing:YES];
    
    if([inputField.text length] == 0){
        return;
    }
    if ([self.delegate respondsToSelector:@selector(publishComment:)]) {
        [self.delegate publishComment:inputField.text];
    }
}

-(void)courseClick
{
    if([self.delegate respondsToSelector:@selector(goCourseDetail)]){
        [self.delegate goCourseDetail];
    }
}

-(void)goManagerCourse:(UIButton *)btn
{
    if (btn.tag == 105) {
        if ([self.delegate respondsToSelector:@selector(goMyCollectCourse)]) {
            [self.delegate goMyCollectCourse];
        }
    }else if (btn.tag == 106){
        if ([self.delegate respondsToSelector:@selector(goManagerPractice:)]) {
            [self.delegate goManagerPractice:detailManagerModel];
        }
    }else if (btn.tag == 107){
        if ([self.delegate respondsToSelector:@selector(goNewQuestionListVC:)]) {
            [self.delegate goNewQuestionListVC:detailManagerModel];
        }
    }else if (btn.tag == 108){
        if ([self.delegate respondsToSelector:@selector(goCoreseStandard)]) {
            [self.delegate goCoreseStandard];
        }
    }
}


#pragma mark - 回复

-(void)replyCurrentPeople:(UIButton *)btn
{
    [inputField becomeFirstResponder];
    inputField.placeholder = [NSString stringWithFormat:@"回复：%@",@"一二三"];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}
-(void)dealloc
{
    [_contentView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}

@end
