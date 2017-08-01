//
//  ZETypicalCaseDetailView.m
//  PUL_iOS
//
//  Created by Stenson on 16/11/1.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//


#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   NAV_HEIGHT
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT )

#define kInputViewMarginLeft  0.0f
#define kInputViewMarginTop   SCREEN_HEIGHT - kInputViewHeight
#define kInputViewWidth       SCREEN_WIDTH
#define kInputViewHeight      40.0f

#import "ZETypicalCaseDetailView.h"
#import "ZEKLB_CLASSICCASE_INFOModel.h"

@interface ZETypicalCaseDetailView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView * _contentView;

    BOOL _isComment;
    
    UIView * navSegmentControlView;
    UIView * inputView;
    
    UITextField * inputField;
    
    UITapGestureRecognizer * tap;
    
    NSDictionary * typicalCaseDetailDic;
}

@property (nonatomic,strong) NSMutableArray * commentArr;
@end

@implementation ZETypicalCaseDetailView

-(id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dataDic
{
    self = [super initWithFrame:frame];
    if (self) {
        typicalCaseDetailDic = dataDic;

        [self initView];
    }
    return self;
}
#pragma mark - Public Method

-(void)reloadSectionView:(NSDictionary *)detailDic
{
    typicalCaseDetailDic = detailDic;
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
-(void)initView
{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight) style:UITableViewStyleGrouped];
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

    UISegmentedControl *segControl = [[UISegmentedControl alloc]initWithItems:@[@"详情",@"评论"]];
    [segControl addTarget:self action:@selector(changeContent) forControlEvents:UIControlEventValueChanged];
    segControl.frame = CGRectMake(10, 10, SCREEN_WIDTH  - 20, 30);
    segControl.selectedSegmentIndex = 0;
    if (_isComment) {
        segControl.selectedSegmentIndex = 1;
    }
    segControl.tintColor = RGBA(120, 120, 120, 1);
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
    if(_isComment){
        return self.commentArr.count;
    }else{
        ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:typicalCaseDetailDic];
        
        NSArray * H5ARR = [infoM.H5URL componentsSeparatedByString:@","];
        if (H5ARR.count > 0) {
            if([H5ARR[0] length] == 0)
            {
                return [infoM.COURSEFILENAMEARR count];
            }
            return [infoM.COURSEFILENAMEARR count] + [H5ARR count];
        }
        
        if ([infoM.COURSEFILENAMEARR count] > 0) {
            return [infoM.COURSEFILENAMEARR count];
        }
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isComment) {
        NSDictionary * dataDic = self.commentArr[indexPath.row];
        float contentHeight = [ZEUtil heightForString:[dataDic objectForKey:@"COMMENTEXPLAIN"] font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH - 100.0f];

        return contentHeight + 55.0f;
    }
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_isComment){
        return 160;
    }
    
    ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:typicalCaseDetailDic];

    float contentHeight = [ZEUtil heightForString:infoM.CASEEXPLAIN font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH - 20.0f];

    return 200 + contentHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView = [UIView new];
    
    [self initCommonView:bgView];
    
    if(_isComment){
        
    }else{
        [self initDetailView:bgView];
    }
    
    return bgView;
}
-(void)initCommonView:(UIView *)superView
{
    UIView * commonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    [superView addSubview:commonView];
    
    UIImageView * detailView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    detailView.contentMode=UIViewContentModeScaleAspectFill;
    detailView.clipsToBounds=YES;
    [commonView addSubview:detailView];
    
    ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:typicalCaseDetailDic];
    
    UIImageView * detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH / 3, 90.0f)];
    [detailView addSubview:detailImageView];
    detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    detailImageView.clipsToBounds = YES;
    detailImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    detailImageView.layer.borderWidth = 1.5;
    
    if ([ZEUtil isStrNotEmpty:infoM.FILEURL] ) {
        NSURL * fileURL =[NSURL URLWithString:ZENITH_IMAGE_FILESTR(infoM.FILEURL)] ;
        [detailImageView sd_setImageWithURL:fileURL placeholderImage:ZENITH_PLACEHODLER_IMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            detailView.image=[ZEUtil boxblurImage:detailImageView.image withBlurNumber:0.4];
        }];
    }
    
    UILabel * caseNameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 + 15, 15, SCREEN_WIDTH - SCREEN_WIDTH / 3 - 25, 20)];
    caseNameLab.text = infoM.CASENAME;
    [caseNameLab setTextColor:[UIColor whiteColor]];
    caseNameLab.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:caseNameLab];

    for (int i = 0; i < 5; i ++ ) {
        UIImageView * starImageView = [[UIImageView alloc]initWithFrame:CGRectMake(caseNameLab.frame.origin.x + 20 * i, 35, 15, 15)];
        [detailView addSubview:starImageView];
        starImageView.contentMode = UIViewContentModeScaleAspectFit;
    
        if ([[ZEUtil notRounding:[infoM.CASESCORE floatValue] afterPoint:0] floatValue] <= i) {
            [starImageView setImage:[UIImage imageNamed:@"course_score_number"]];
        }else{
            [starImageView setImage:[UIImage imageNamed:@"course_score_number_selectd"]];
        }
        
    }
    
    UILabel * scoreLab = [[UILabel alloc]initWithFrame:CGRectMake(caseNameLab.frame.origin.x + 100, 37, 30, 15)];
    scoreLab.text = [NSString stringWithFormat:@"%@分",infoM.CASESCORE];
    [scoreLab setTextColor:[UIColor lightGrayColor]];
    scoreLab.font = [UIFont systemFontOfSize:10];
    [detailView addSubview:scoreLab];
    
    UILabel * caseAuthorLab = [[UILabel alloc]initWithFrame:CGRectMake(caseNameLab.frame.origin.x, 50, SCREEN_WIDTH - SCREEN_WIDTH / 3 - 25, 20)];
    if ([ZEUtil isNotNull:infoM.CASEAUTHOR] && [infoM.CASEAUTHOR length] > 0) {
        caseAuthorLab.text = [NSString stringWithFormat:@"制作人：%@",infoM.CASEAUTHOR];
    }
    [caseAuthorLab setTextColor:[UIColor lightGrayColor]];
    caseAuthorLab.font = [UIFont systemFontOfSize:10];
    [detailView addSubview:caseAuthorLab];
    
    UISegmentedControl * segControl = [[UISegmentedControl alloc]initWithItems:@[@"详情",@"评论"]];
    [segControl addTarget:self action:@selector(changeContent) forControlEvents:UIControlEventValueChanged];
    segControl.frame = CGRectMake(10, 125, SCREEN_WIDTH  - 20, 30);
    segControl.selectedSegmentIndex = 0;
    if (_isComment) {
        segControl.selectedSegmentIndex = 1;
    }
    segControl.tintColor = RGBA(120, 120, 120, 1);
    [commonView addSubview:segControl];    
}

-(void)initDetailView:(UIView *)superView
{
    
    ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:typicalCaseDetailDic];

    UIView * detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 160)];
    [superView addSubview:detailView];

    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    titleLab.text = @"简介";
    titleLab.font = [UIFont systemFontOfSize:14];
    [detailView addSubview:titleLab];

//    文件大小
//    float sizeWidth = [ZEUtil widthForString:@"300MB" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(200, 40)];
//    
//    UILabel * sizeLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - sizeWidth - 10, 0, sizeWidth, 30)];
//    sizeLab.text = @"300MB";
//    sizeLab.font = [UIFont systemFontOfSize:12];
//    [detailView addSubview:sizeLab];
//
//    UIImageView * imageSizeView = [[UIImageView alloc]initWithFrame:CGRectMake(sizeLab.frame.origin.x - 23.0f, 7, 15.0f, 15.0f)];
//    [imageSizeView setImage:[UIImage imageNamed:@"ic_square_small.png"]];
//    [detailView addSubview:imageSizeView];
//    imageSizeView.contentMode = UIViewContentModeScaleAspectFit;
//    imageSizeView.clipsToBounds = YES;
    
    float contentHeight = [ZEUtil heightForString:infoM.CASEEXPLAIN font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH - 20.0f];
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH - 20.0f, contentHeight)];
    contentLab.text = infoM.CASEEXPLAIN;
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:contentLab];
    
    detailView.frame = CGRectMake(0, 160, SCREEN_WIDTH, 30 + contentHeight);
}

#pragma mark - changeDetailOrComment

-(void)changeContent
{
    _isComment = !_isComment;
    UISegmentedControl * control = [navSegmentControlView subviews][0];
    if (_isComment) {
        _contentView.frame = CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight - 40.f);
        control.selectedSegmentIndex = 1;
        inputView.hidden = NO;
        _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _contentView.mj_footer = footer;
        
        if ([self.delegate respondsToSelector:@selector(showCommentView)]) {
            [self.delegate showCommentView];
        }
        
    }else{
        _contentView.frame = CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight);
        control.selectedSegmentIndex = 0;
        inputView.hidden = YES;
        _contentView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_contentView.mj_footer removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(showCourseView)]) {
            [self.delegate showCourseView];
        }
        
    }
    [self endEditing:YES];
    [_contentView reloadData];
    _contentView.contentOffset = CGPointMake(0, 0);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_isComment) {
        [self initCommentCellView:cell.contentView withIndexpath:indexPath];
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
    usernameLab.text = [NSString stringWithFormat:@"%@：",[dataDic objectForKey:@"NICKNAME"]];
    usernameLab.numberOfLines = 0;
    usernameLab.textColor = [UIColor blueColor];
    usernameLab.font = [UIFont systemFontOfSize:12];
    [cellView addSubview:usernameLab];
    
    float contentHeight = [ZEUtil heightForString:[dataDic objectForKey:@"COMMENTEXPLAIN"] font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH - 100.0f];
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(85.0f, 30.0f, SCREEN_WIDTH - 100.0f, contentHeight)];
    contentLab.text = [dataDic objectForKey:@"COMMENTEXPLAIN"];
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
//    
//    float yValue = contentHeight  + 30.0f;
//    float commentContentHeight = 0;
//    for (int i = 0; i < 2; i ++) {
//        yValue = commentContentHeight + yValue;
//        
//        commentContentHeight = [ZEUtil heightForString:[NSString stringWithFormat:@"%@:%@",@"5600000",contentStr] font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH - 100.0f];
//
//        UILabel * commentContentLab = [[UILabel alloc]initWithFrame:CGRectMake(85.0f, yValue, SCREEN_WIDTH - 100.0f, commentContentHeight)];
//        commentContentLab.text = [NSString stringWithFormat:@"%@:%@",@"5600000",contentStr];
//        commentContentLab.numberOfLines = 0;
//        commentContentLab.font = [UIFont systemFontOfSize:12];
//        [cellView addSubview:commentContentLab];
//    }
    
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(85.0f, 199.0f, SCREEN_WIDTH - 85.0f, 1.0f)];
//    lineView.backgroundColor = MAIN_LINE_COLOR;
//    [cellView addSubview:lineView];

//    if (indexPath.row == 0) {
//        userHeaderImgView.frame = CGRectMake(10, 30.0f, 60.0f, 60.0f);
//        usernameLab.frame = CGRectMake(85.0f, 40.0f, SCREEN_WIDTH - 100.0f, 20.0f);
//        contentLab.frame = CGRectMake(85.0f, 60.0f, SCREEN_WIDTH - 100.0f, contentHeight);
//        
//        UIView * newestComment = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 5.0f, 20.0f)];
//        newestComment.backgroundColor = [UIColor redColor];
//        [cellView addSubview:newestComment];
//        
//        UILabel * newestLab = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 0.0f, SCREEN_WIDTH - 100.0f, 20.0f)];
//        newestLab.text = @"最新评论";
//        newestLab.numberOfLines = 0;
//        newestLab.font = [UIFont systemFontOfSize:12];
//        [cellView addSubview:newestLab];
//    }
    
}
-(void)initCellView:(UIView *)cellView withIndexpath:(NSIndexPath *)indexPath
{
    ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:typicalCaseDetailDic];

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
    
//    UIView * lineLayer = [UIView new];
//    lineLayer.frame = CGRectMake(SCREEN_WIDTH - 45.0f, 10.0f, 1.0f, 30.0f);
//    [lineLayer setBackgroundColor:MAIN_LINE_COLOR];
//    [cellView addSubview:lineLayer];
//    
//    UIButton *  downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [downloadBtn setImage:[UIImage imageNamed:@"course_download"] forState:UIControlStateNormal];
//    [downloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [downloadBtn setFrame:CGRectMake(SCREEN_WIDTH - 40.0f, 10.0f, 30, 30)];
//    downloadBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    downloadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [cellView addSubview:downloadBtn];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isComment){
        
    }else{
        ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:typicalCaseDetailDic];

        if (indexPath.row < infoM.COURSEFILETYPEARR.count) {
            
            NSString * fileTypeStr = infoM.COURSEFILETYPEARR[indexPath.row];
            
            NSString * serverAdress = [NSString stringWithFormat:@"%@/file/%@",Zenith_Server,infoM.COURSEFILEURLARR[indexPath.row]];
            
            if ([fileTypeStr isEqualToString:@".mp4"]) {
                if ([self.delegate respondsToSelector:@selector(playCourswareVideo:)]) {
                    [self.delegate playCourswareVideo:serverAdress];
                }
            }else if([fileTypeStr isEqualToString:@".jpg"] | [fileTypeStr isEqualToString:@".png"]){
                if ([self.delegate respondsToSelector:@selector(playCourswareImagePath:)]) {
                    [self.delegate playCourswareImagePath:serverAdress];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(loadFile:)]) {
                    [self.delegate loadFile:serverAdress];
                }
            }
        }else{
            ZEKLB_CLASSICCASE_INFOModel * infoM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:typicalCaseDetailDic];

            NSArray * H5URLArr = [infoM.H5URL componentsSeparatedByString:@","];
            if ([self.delegate respondsToSelector:@selector(loadFile:)]) {
                [self.delegate loadFile:H5URLArr[indexPath.row - infoM.COURSEFILETYPEARR.count]];
            }

            
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
