//
//  ZEProCirDeatilView.m
//  PUL_iOS
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kDynamicsHeight  80.0f
#define kMemberHeight  30.0f

#define kExpertViewMarginLeft  0.0f
#define kExpertViewMarginTop   0
#define kExpertViewWidth       SCREEN_WIDTH
#define kExpertViewHeight      ((SCREEN_WIDTH - 20.0f ) / 3 / 0.85 + 70.0f)

#define kTypicalViewMarginLeft  0.0f
#define kTypicalViewMarginTop   (kExpertViewHeight + kExpertViewMarginTop)
#define kTypicalViewWidth       SCREEN_WIDTH
#define kTypicalViewHeight      ((SCREEN_WIDTH - 20) / 3 - 10) * 1.4

#define kWorkStandardRowHeight 40

#define kCircleMessageMarginTop (kTypicalViewMarginTop + kTypicalViewHeight)
#define kCircleMessageHeight 140.0f

#import "ZEProCirDeatilView.h"
#import "ZEKLB_CLASSICCASE_INFOModel.h"

@interface ZEProCirDeatilView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * contentView;
    
    NSMutableArray * _caseQuestionArr;
    
    UIView * circleMessageView;
}
@property (nonatomic,strong) NSDictionary * scoreDic;
@property (nonatomic,strong) NSArray * memberArr;
@property (nonatomic,strong) NSMutableArray * caseQuestionArr;
@property (nonatomic,strong) NSMutableArray * expertListArr;
@property (nonatomic,strong) NSMutableArray * workStandardArr;
@end

@implementation ZEProCirDeatilView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


-(void)initView{
    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT , SCREEN_WIDTH, (SCREEN_HEIGHT - NAV_HEIGHT)) style:UITableViewStyleGrouped];
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.delegate = self;
    contentView.dataSource = self;
    [self addSubview:contentView];
}

#pragma mark - 专家列表
-(UIView *)createExpertView
{
    UIView * expertAnswerView = [[UIView alloc]initWithFrame:CGRectMake(kExpertViewMarginLeft, kExpertViewMarginTop, kExpertViewWidth,kExpertViewHeight)];
    expertAnswerView.backgroundColor = [UIColor whiteColor];
    expertAnswerView.tag = 100;
    
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, 2.0f, 20)];
    maskView.backgroundColor = MAIN_NAV_COLOR;
    [expertAnswerView addSubview:maskView];
    maskView.clipsToBounds = YES;
    maskView.layer.cornerRadius = 1.0f;
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 50)];
    rowTitleLab.text = @"专家解答";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.font = [UIFont systemFontOfSize:18];
    [expertAnswerView addSubview:rowTitleLab];
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_SUBBTN_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 50);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [expertAnswerView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(moreExpertBtnClck) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(15, 50, SCREEN_WIDTH - 30.0f, 1);
    [expertAnswerView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UIScrollView * typicalScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, lineLayer.bottom + 5.0f, SCREEN_WIDTH - 20.0f, (SCREEN_WIDTH - 40.0f ) / 3 / 0.85)];
    typicalScrollView.showsHorizontalScrollIndicator = NO;
    [expertAnswerView addSubview:typicalScrollView];
    typicalScrollView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0 ; i < self.expertListArr.count; i ++ ) {
        ZEExpertModel * classicalCaseM = [ZEExpertModel getDetailWithDic:self.expertListArr[i]];
        
        UIButton * typicalImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typicalImageBtn.frame = CGRectMake( (SCREEN_WIDTH - 20.0f ) / 3 * i , 0, (SCREEN_WIDTH - 20) / 3,(SCREEN_WIDTH - 20.0f ) / 3/0.85);
        typicalImageBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
        [typicalScrollView addSubview:typicalImageBtn];
        [typicalImageBtn addTarget:self action:@selector(goExpertDetail:) forControlEvents:UIControlEventTouchUpInside];
        typicalImageBtn.tag = i;
        typicalImageBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [typicalImageBtn setBackgroundImage:[UIImage imageNamed:@"jdbh_zjjd_bg"] forState:UIControlStateNormal];
        if (i > 2) {
            typicalScrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 20) / 3 * (i + 1) - 10, kTypicalViewHeight - 75);
        }
        
        UIImageView * expertHeadImage = [[UIImageView alloc]init];
        [typicalImageBtn addSubview:expertHeadImage];
        expertHeadImage.width = 70;
        expertHeadImage.height = 70;
        expertHeadImage.center = CGPointMake(typicalImageBtn.width / 2 , typicalImageBtn.center.y - 25);

        if(IPHONE6P){
        }else if (IPHONE6){
            expertHeadImage.center = CGPointMake(typicalImageBtn.width / 2  , typicalImageBtn.center.y - 25);
        }else if (IPHONE5){
            expertHeadImage.width = 60;
            expertHeadImage.height = 60;
            expertHeadImage.center = CGPointMake(typicalImageBtn.width / 2 , typicalImageBtn.center.y - 25);
        }
        expertHeadImage.clipsToBounds = YES;
        expertHeadImage.layer.cornerRadius = expertHeadImage.height / 2;
        NSURL * fileURL =[NSURL URLWithString:ZENITH_IMAGE_FILESTR(classicalCaseM.FILEURL)] ;
        [expertHeadImage sd_setImageWithURL:fileURL placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];

        UILabel * typicalLab = [[UILabel alloc]initWithFrame:CGRectZero];
        typicalLab.size = CGSizeMake(typicalImageBtn.width, 20);
        typicalLab.center = CGPointMake(typicalImageBtn.width / 2, typicalImageBtn.center.y + 35);
        typicalLab.font = [UIFont systemFontOfSize:15];
        typicalLab.textColor = kTextColor;
        typicalLab.text = classicalCaseM.USERNAME;
        typicalLab.numberOfLines = 0;
        typicalLab.textAlignment = NSTextAlignmentCenter;
        [typicalImageBtn addSubview:typicalLab];
    }
    
    if (self.expertListArr.count == 0) {
        expertAnswerView.height = 60.0f;
    }else{
        expertAnswerView.height = (SCREEN_WIDTH - 20.0f ) / 3 / 0.85 + 70.0f;
    }
    
    CALayer * grayLine = [CALayer layer];
    grayLine.frame = CGRectMake(0, expertAnswerView.height - 10.0f, SCREEN_WIDTH, 10.0f);
    [expertAnswerView.layer addSublayer:grayLine];
    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    return  expertAnswerView;
}

#pragma mark - 经典案例

-(UIView *)createTypicalCaseView
{
    UIView * typicalCaseView = [[UIView alloc]initWithFrame:CGRectMake(kTypicalViewMarginLeft, 0, kTypicalViewWidth, kTypicalViewHeight)];
    typicalCaseView.backgroundColor = [UIColor whiteColor];
    typicalCaseView.tag = 100;
    
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, 2.0f, 20)];
    maskView.backgroundColor = MAIN_NAV_COLOR;
    [typicalCaseView addSubview:maskView];
    maskView.clipsToBounds = YES;
    maskView.layer.cornerRadius = 1.0f;
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 50)];
    rowTitleLab.text = @"典型案例";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.font = [UIFont systemFontOfSize:18];
    [typicalCaseView addSubview:rowTitleLab];
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_SUBBTN_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 50);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [typicalCaseView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(moreCaseBtnClck) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(15, 50, SCREEN_WIDTH - 30.0f, 1);
    [typicalCaseView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    UIView * typicalContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, lineLayer.bottom, SCREEN_WIDTH - 30.0f, self.caseQuestionArr.count * 80)];
    [typicalCaseView addSubview:typicalContentView];
    
    for (int i = 0 ; i < self.caseQuestionArr.count; i ++ ) {
        
        UIButton * typicalDetaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typicalDetaiBtn.frame = CGRectMake(0, i * 80, SCREEN_WIDTH - 30.0f, 80);
        [typicalContentView addSubview:typicalDetaiBtn];
        [typicalDetaiBtn addTarget:self action:@selector(goTypicalCaseDetail:) forControlEvents:UIControlEventTouchUpInside];
        typicalDetaiBtn.tag = i;
        
        ZEKLB_CLASSICCASE_INFOModel * classicalCaseM = [ZEKLB_CLASSICCASE_INFOModel getDetailWithDic:self.caseQuestionArr[i]];

        UIImageView * typicalImageView = [[UIImageView alloc]init];
        [typicalDetaiBtn addSubview:typicalImageView];
        typicalImageView.width = 90;
        typicalImageView.height = 70;
        typicalImageView.left = 0;
        typicalImageView.top = 10;
        typicalImageView.clipsToBounds = YES;
        typicalImageView.layer.cornerRadius =  5;
//        typicalImageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([ZEUtil isStrNotEmpty:classicalCaseM.FILEURL]) {
            NSURL * fileURL =[NSURL URLWithString:ZENITH_IMAGE_FILESTR(classicalCaseM.FILEURL)] ;
            [typicalImageView sd_setImageWithURL:fileURL placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        }
        
        UIImageView * arrowImage = [[UIImageView alloc]init];
        arrowImage.frame = CGRectMake(typicalImageView.width + 10.0f, typicalImageView.top + 3, 10,14);
        [typicalDetaiBtn addSubview:arrowImage];
        [arrowImage setImage:[UIImage imageNamed:@"jdbh_title"]];
        
        UILabel * typicalDetailName = [[UILabel alloc]init];
        typicalDetailName.frame = CGRectMake(arrowImage.right + 5.0f , typicalImageView.top , typicalDetaiBtn.width - arrowImage.right , 20);
        [typicalDetaiBtn addSubview:typicalDetailName];
        typicalDetailName.textColor = kTextColor;
        typicalDetailName.text = classicalCaseM.CASENAME;
        
        UILabel * typicalSubDetailName = [[UILabel alloc]init];
        typicalSubDetailName.frame = CGRectMake(arrowImage.left , typicalDetailName.bottom + 5.0f , typicalDetaiBtn.width - arrowImage.left, typicalDetaiBtn.height - typicalDetailName.bottom - 5.0f);
        [typicalDetaiBtn addSubview:typicalSubDetailName];
        typicalSubDetailName.font = [UIFont systemFontOfSize:14];
        typicalSubDetailName.text = classicalCaseM.CASEEXPLAIN;
        typicalSubDetailName.numberOfLines = 2;
        typicalSubDetailName.textColor = MAIN_SUBBTN_COLOR;
    }
    
    CALayer * grayLine = [CALayer layer];
    grayLine.frame = CGRectMake(0, typicalContentView.bottom + 5.0f, SCREEN_WIDTH, 10.0f);
    [typicalCaseView.layer addSublayer:grayLine];
    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    typicalCaseView.height = typicalContentView.bottom + 10.0f;
    
    return  typicalCaseView;
}

#pragma mark - 行业规范
-(UIView *)createWorkStandard
{
    UIView * workStandardView = [UIView new];
    
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, 2.0f, 20)];
    maskView.backgroundColor = MAIN_NAV_COLOR;
    [workStandardView addSubview:maskView];
    maskView.clipsToBounds = YES;
    maskView.layer.cornerRadius = 1.0f;
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 50)];
    rowTitleLab.text = @"行业规范";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.font = [UIFont systemFontOfSize:18];
    [workStandardView addSubview:rowTitleLab];
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_SUBBTN_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 50);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [workStandardView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(moreWorkStandard) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(15, 50, SCREEN_WIDTH - 30.0f, 1);
    [workStandardView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    for (int i = 0; i < self.workStandardArr.count; i ++) {
        NSDictionary * dic = self.workStandardArr[i];
        
        UIImageView * pointImageView = [UIImageView new];
        [workStandardView addSubview:pointImageView];
        pointImageView.size = CGSizeMake(10, 10);
        pointImageView.backgroundColor = [ZEUtil colorWithHexString:@"#f26168"];
        pointImageView.center = CGPointMake(25, 70 + kWorkStandardRowHeight * i);
        pointImageView.clipsToBounds = YES;
        pointImageView.layer.cornerRadius = pointImageView.height / 2;

        UIButton * standardTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [standardTitle setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
        standardTitle.frame = CGRectMake(30 , 50 + kWorkStandardRowHeight * i, SCREEN_WIDTH - 90, kWorkStandardRowHeight);
        standardTitle.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [standardTitle setTitle:[dic objectForKey:@"STANDARDNAME"] forState:UIControlStateNormal];
        [standardTitle setTitleColor:kTextColor forState:UIControlStateNormal];
        standardTitle.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        [workStandardView addSubview:standardTitle];
        [standardTitle addTarget:self action:@selector(goWorkStandardDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        standardTitle.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [standardTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0) ];
        standardTitle.tag = 100 + i;
        
        UIButton * browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        browseBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 80, kWorkStandardRowHeight);
        browseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [browseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        if ([[dic objectForKey:@"CLICKCOUNT"] integerValue] == 0) {
//            [browseBtn setTitle:@" 0" forState:UIControlStateNormal];
//        }else{
//            [browseBtn setTitle:[NSString stringWithFormat:@" %@",[dic objectForKey:@"CLICKCOUNT"]] forState:UIControlStateNormal];
//        }
        [browseBtn setImage:[UIImage imageNamed:@"jdbh_hot.png" ] forState:UIControlStateNormal];
        [standardTitle addSubview:browseBtn];
    }
    
    CALayer * grayLine = [CALayer layer];
    if (self.workStandardArr.count > 0) {
        grayLine.frame = CGRectMake(0, 50 + self.workStandardArr.count * kWorkStandardRowHeight + 5.0f, SCREEN_WIDTH, 10.0f);
    }else{
        grayLine.frame = CGRectMake(0, 50, SCREEN_WIDTH, 10.0f);
    }
    [workStandardView.layer addSublayer:grayLine];
    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];


    workStandardView.left = 0;
    workStandardView.width = SCREEN_WIDTH;
    workStandardView.height = grayLine.bottom;
    
    return workStandardView;
}


#pragma mark - Publick Method

-(void)reloadSection:(NSInteger)section
            scoreDic:(NSDictionary *)dic
          memberData:(id)data
{
    if([ZEUtil isNotNull:dic]){
        self.scoreDic = dic;
    }
    if ([ZEUtil isNotNull:data]) {
        self.memberArr = data;
    }
    
    [contentView reloadData];
}

-(void)reloadCaseView:(NSArray *)arr
{
    self.caseQuestionArr = [NSMutableArray arrayWithArray:arr];
    if(self.caseQuestionArr.count > 0){
        [contentView reloadData];
    }
}

-(void)reloadExpertView:(NSArray *)arr
{
    self.expertListArr = [NSMutableArray arrayWithArray:arr];
    
    if(self.expertListArr.count > 0){
        [contentView reloadData];
    }
}

-(void)reloadWorkStandardView:(NSArray *)arr{
    self.workStandardArr = [NSMutableArray arrayWithArray:arr];
    if(self.workStandardArr.count > 0){
        [contentView reloadData];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.expertListArr.count >0){
        return kExpertViewHeight + 60 + self.caseQuestionArr.count * 80 + 60 + self.workStandardArr.count * kWorkStandardRowHeight + kCircleMessageHeight;
    }
    
    return 60 + 60 + self.caseQuestionArr.count * 80 + 60 + self.workStandardArr.count * kWorkStandardRowHeight + kCircleMessageHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView * expertView = [self createExpertView];
    [headerView addSubview:expertView];
    
    UIView * typicalView = [self createTypicalCaseView];
    typicalView.top = expertView.height;
    [headerView addSubview:typicalView];

    UIView * workStandardView = [self createWorkStandard];
    workStandardView.top = typicalView.top + typicalView.height;
    [headerView addSubview:workStandardView];

    circleMessageView =  [UIView new];
    circleMessageView.frame = CGRectMake(0, workStandardView.top + workStandardView.height, SCREEN_WIDTH, kCircleMessageHeight);
    [self initCircleMessage:circleMessageView];
    [headerView addSubview:circleMessageView];

    return headerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
    return self.memberArr.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMemberHeight ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    while (cell.contentView.subviews.lastObject) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    [self initCellView:cell.contentView indexPath:indexPath];
    return cell;
}


-(void)initCellView:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
//    if (indexpath.row == 0) {
//        [self initCircleMessage:superView];
//    }else if (indexpath.row == 1){
        [self initMember:superView indexPath:indexpath];
//    }/
}

-(void)initCircleMessage:(UIView *)superView
{
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, 2.0f, 20)];
    maskView.backgroundColor = MAIN_NAV_COLOR;
    [superView addSubview:maskView];
    maskView.clipsToBounds = YES;
    maskView.layer.cornerRadius = 1.0f;
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 50)];
    rowTitleLab.text = @"排行榜";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.font = [UIFont systemFontOfSize:18];
    [superView addSubview:rowTitleLab];
    
    UIButton * sectionSubTitleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sectionSubTitleBtn setTitleColor:MAIN_SUBBTN_COLOR forState:UIControlStateNormal];
    sectionSubTitleBtn.frame = CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 50);
    [sectionSubTitleBtn setTitle:@"更多  >" forState:UIControlStateNormal];
    sectionSubTitleBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [superView addSubview:sectionSubTitleBtn];
    [sectionSubTitleBtn addTarget:self action:@selector(goMoreRankingMessage) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(15, 50, SCREEN_WIDTH - 30.0f, 1);
    [superView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

    for (int i = 0 ; i < 4; i ++) {
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 * i, 50, SCREEN_WIDTH / 2, 40)];
        titleLab.text = @"本月排行";
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:16];
        [superView addSubview:titleLab];
        
        UILabel * subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 * i, titleLab.bottom, SCREEN_WIDTH / 2, 40)];
        subTitleLab.text = [NSString stringWithFormat:@"第%@名",[self.scoreDic objectForKey:@"PROCIRCLERANKING"]];
        subTitleLab.textAlignment = NSTextAlignmentCenter;
        subTitleLab.font = [UIFont systemFontOfSize:22];
        subTitleLab.textColor = [ZEUtil colorWithHexString:@"#ff6678"];
        [superView addSubview:subTitleLab];
        
        if(i == 1){
            titleLab.text = @"圈子活跃度";
            [titleLab adjustsFontSizeToFitWidth];
            if ([[self.scoreDic objectForKey:@"ACTIVELEVEL"] length] > 0) {
                subTitleLab.text = [self.scoreDic objectForKey:@"ACTIVELEVEL"];
            }else{
                subTitleLab.text = @"0";
            }
        }
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake( SCREEN_WIDTH / 2 * i - 1 , 50 , 1, 80);
        [superView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    }
    
    CALayer * grayLine = [CALayer layer];
    grayLine.frame = CGRectMake(0, 130, SCREEN_WIDTH, 10.0f);
    [superView.layer addSublayer:grayLine];
    grayLine.backgroundColor = [MAIN_LINE_COLOR CGColor];

}

-(void)initMember:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
//    UIView * lineLayer = [UIView new];
//    lineLayer.frame = CGRectMake(0, 30, SCREEN_WIDTH, 1);
//    [superView addSubview:lineLayer];
//    lineLayer.backgroundColor = MAIN_LINE_COLOR ;
    
//    if(indexpath.row == 0){
        UIView * fLineLayer = [UIView new];
        fLineLayer.frame = CGRectMake(40, 0, 1, kMemberHeight * (self.memberArr.count + 1));
        [superView addSubview:fLineLayer];
        fLineLayer.backgroundColor = MAIN_LINE_COLOR;
//    }
    
        UIView * sumLineLayer = [UIView new];
        sumLineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        [superView addSubview:sumLineLayer];
        sumLineLayer.backgroundColor = MAIN_LINE_COLOR;
        
        UILabel * timeTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 40, kMemberHeight)];
        timeTitleLab.text = [NSString stringWithFormat:@"%ldth",(long)indexpath.row];
        timeTitleLab.textAlignment = NSTextAlignmentCenter;
        timeTitleLab.font = [UIFont systemFontOfSize:14];
        [superView addSubview:timeTitleLab];
        
        if (indexpath.row == 0) {
            timeTitleLab.text = @"排名";
        }else if (indexpath.row == 1){
            timeTitleLab.text = @"1st";
        }else if (indexpath.row == 2){
            timeTitleLab.text = @"2nd";
        }else if (indexpath.row == 3){
            timeTitleLab.text = @"3rd";
        }
        
        for (int j = 0; j < 5; j ++ ) {
            UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(40 + (SCREEN_WIDTH - 40) / 5 * j, 0, (SCREEN_WIDTH - 40) / 5, kMemberHeight)];
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.font = [UIFont systemFontOfSize:14];
            [superView addSubview:contentLab];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(contentLab.frame.origin.x + contentLab.frame.size.width - 1, contentLab.frame.origin.y, 1, kMemberHeight)];
            lineView.backgroundColor = MAIN_LINE_COLOR;
            [superView addSubview:lineView];

            
            if(indexpath.row == 0){
                switch (j) {
                    case 0:
                        contentLab.text = @"昵称";
                        break;
                    case 1:
                        contentLab.text = @"提问数";
                        break;
                    case 2:
                        contentLab.text = @"回答数";
                        break;
                    case 3:
                        contentLab.text = @"采纳数";
                        break;
                    case 4:
                        contentLab.text = @"贡献值";
                        break;

                    default:
                        break;
                }
            }else{
                NSDictionary * dic = self.memberArr[indexpath.row - 1];
                
                switch (j) {
                    case 0:
                    {
                        if ([[dic objectForKey:@"NICKNAME"] length] > 0) {
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"NICKNAME"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@""];
                        }
                        contentLab.font = [UIFont systemFontOfSize:10];
                        contentLab.numberOfLines = 0;
                        contentLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
                    }
                        break;
                    case 1:
                        if([[dic objectForKey:@"QUESTIONSUM"] integerValue] > 0 ){
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"QUESTIONSUM"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@"0"];
                        }
                        break;
                    case 2:
                        if([[dic objectForKey:@"ANSWERSUM"] integerValue] > 0 ){
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ANSWERSUM"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@"0"];
                        }
                        break;
                    case 3:
                        if([[dic objectForKey:@"ANSWERTAKESUM"] integerValue] > 0 ){
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ANSWERTAKESUM"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@"0"];
                        }
                        break;

                    case 4:
                        if([[dic objectForKey:@"SUMPOINTS"] integerValue] > 0 ){
                            contentLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SUMPOINTS"]];
                        }else{
                            contentLab.text = [NSString stringWithFormat:@"0"];
                        }
                        break;

                    default:
                        break;
                }
            }
        }
        
    
}

#pragma mark - DELEGATE

-(void)goDynamic
{
    if ([self.delegate respondsToSelector:@selector(goDynamic)]) {
        [self.delegate goDynamic];
    }
}

-(void)moreCaseBtnClck
{
    if([self.delegate respondsToSelector:@selector(goMoreCaseVC)]){
        [self.delegate goMoreCaseVC];
    }
}

-(void)moreExpertBtnClck
{
    if([self.delegate respondsToSelector:@selector(goMoreExpertVC)]){
        [self.delegate goMoreExpertVC];
    }
}

-(void)moreWorkStandard
{
    if ([self.delegate respondsToSelector:@selector(goMoreWorkStandard)]) {
        [self.delegate goMoreWorkStandard];
    }
}

-(void)goWorkStandardDetailBtnClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(goWorkStandardDetail:)]){
        [self.delegate goWorkStandardDetail:self.workStandardArr[btn.tag - 100]];
    }
}

-(void)goTypicalCaseDetail:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(goTypicalDetail:)]){
        [self.delegate goTypicalDetail:self.caseQuestionArr[btn.tag]];
    }
}

-(void)goExpertDetail:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(goTypicalDetail:)]){
        ZEExpertModel * expertM = [ZEExpertModel getDetailWithDic:self.expertListArr[btn.tag]];
        [self.delegate goExpertDetail:expertM];
    }
}

-(void)goMoreRankingMessage
{
    if ([self.delegate respondsToSelector:@selector(moreRankingMessage)]) {
        [self.delegate moreRankingMessage];
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
