//
//  ZEQuestionsDetailView.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/4.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kCellImgaeHeight    (SCREEN_WIDTH - 60)/3

#define kDetailTitleFontSize      kTiltlFontSize
#define kDetailSubTitleFontSize   kSubTiltlFontSize

#define kContentTableViewMarginLeft 0.0f
#define kContentTableViewMarginTop  NAV_HEIGHT
#define kContentTableViewWidth      SCREEN_WIDTH
#define kContentTableViewHeight     SCREEN_HEIGHT - NAV_HEIGHT 

#import "ZEQuestionsDetailView.h"
#import "ZEAnswerInfoModel.h"

#import "ZEWithoutDataTipsView.h"

@interface ZEQuestionsDetailView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * contentTableView;
    
    ZEWithoutDataTipsView * tipsView;
}

@property (nonatomic,strong) ZEQuestionInfoModel * questionInfoModel;
@property (nonatomic,assign) BOOL isTeam;
@property (nonatomic,strong) NSArray * answerInfoArr;

@end

@implementation ZEQuestionsDetailView

-(id)initWithFrame:(CGRect)frame
  withQuestionInfo:(ZEQuestionInfoModel *)infoModel
        withIsTeam:(BOOL)isTeam
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _questionInfoModel = infoModel;
        _isTeam = isTeam;
        [self initView];
    }
    return self;
}

-(void)initView
{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentTableView];
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableViewMarginLeft);
        make.top.mas_equalTo(kContentTableViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableViewWidth, kContentTableViewHeight));
    }];
    
}
#pragma mark - Public Method

-(void)reloadData:(NSArray *)arr
{
    if (arr.count == 0 ) {
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tipsView removeAllSubviews];
        [tipsView removeFromSuperview];
        tipsView = nil;
    }
    _answerInfoArr = arr;
    [contentTableView reloadData];
}

-(void)disableSelect
{
    _questionInfoModel.ISSOLVE = @"1";
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_answerInfoArr.count == 0) {
        return 1;
    }
    
    return _answerInfoArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [headerView addSubview:[self createQuestionDetailView]];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)createQuestionDetailView
{
    UIView *  questionsView = [[UIView alloc]init];

    float questionHeight =[ZEUtil heightForString:_questionInfoModel.QUESTIONEXPLAIN font:[UIFont boldSystemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 40];

    UITextView * questionsLab = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    questionsLab.text = _questionInfoModel.QUESTIONEXPLAIN;
    questionsLab.editable = NO;
//    questionsLab.scrollEnabled = NO;
    questionsLab.font = [UIFont boldSystemFontOfSize:kDetailTitleFontSize];
    [questionsView addSubview:questionsLab];
    [questionsLab setContentInset:UIEdgeInsetsMake(-8, 0, 0, 0)];//设置UITextView的内边距

    
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    NSMutableArray * urlsArr = [NSMutableArray array];
    for (NSString * str in _questionInfoModel.FILEURLARR) {
        [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
    }
    if (_questionInfoModel.FILEURLARR.count > 0) {
        PYPhotosView *linePhotosView = [PYPhotosView photosViewWithThumbnailUrls:urlsArr originalUrls:urlsArr layoutType:PYPhotosViewLayoutTypeLine];
        // 设置Frame
        linePhotosView.py_y = userY;
        linePhotosView.py_x = PYMargin;
        if (urlsArr.count == 1) {
            linePhotosView.py_width =  ( SCREEN_WIDTH - 40 ) / 3 + 20;
        }else if (urlsArr.count == 2){
            linePhotosView.py_width =  ( SCREEN_WIDTH - 40 ) / 3  * 2;
        }else{
            linePhotosView.py_width = SCREEN_WIDTH - 40;
        }
        // 3. 添加到指定视图中
        [questionsView addSubview:linePhotosView];
        
        userY += kCellImgaeHeight + 10.0f;
    }
    NSArray * typeCodeArr = [_questionInfoModel.QUESTIONTYPECODE componentsSeparatedByString:@","];
    
    NSString * typeNameContent = @"";
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * questionTypeM = nil;
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        for (int i = 0; i < typeCodeArr.count; i ++) {
            if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                questionTypeM = typeM;
                if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                    typeNameContent = questionTypeM.NAME;
                }else{
                    typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                }
                break;
            }
        }
    }
    
    //     圈组分类最右边
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, userY, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"answer_tag"];
    [questionsView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,SCREEN_WIDTH - 70,15.0f)];
    circleLab.text = typeNameContent;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:circleLab];
    circleLab.numberOfLines = 0;
    [circleLab sizeToFit];
    
    if (circleLab.height == 0) {
        circleLab.height = 15.0f;
    }
    userY += circleLab.height + 5.0f;

    if (_questionInfoModel.TARGETUSERNAME.length > 0) {

        NSString * targetUsernameStr = [NSString stringWithFormat:@"指定人员回答 ：%@",_questionInfoModel.TARGETUSERNAME];
        
        float targetUsernameHeight = [ZEUtil heightForString:targetUsernameStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
        
        UILabel * TARGETUSERNAMELab = [[UILabel alloc]initWithFrame:CGRectMake(20,userY,SCREEN_WIDTH - 40,targetUsernameHeight)];
        TARGETUSERNAMELab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        TARGETUSERNAMELab.text = targetUsernameStr;
        TARGETUSERNAMELab.textColor = MAIN_SUBTITLE_COLOR;
        [questionsView addSubview:TARGETUSERNAMELab];
        TARGETUSERNAMELab.numberOfLines = 0;
        
        userY += targetUsernameHeight + 5.0f;
    }
    
    UIView * messageLineView = [[UIView alloc]initWithFrame:CGRectMake(0, userY, SCREEN_WIDTH, 0.5)];
    messageLineView.backgroundColor = MAIN_LINE_COLOR;
    [questionsView addSubview:messageLineView];
    
    userY += 5.0f;
    
    UILabel * usernameLab = [[UILabel alloc]initWithFrame:CGRectMake(20,userY,200.0f,20.0f)];
    usernameLab.text = [ZEUtil compareCurrentTime:_questionInfoModel.SYSCREATEDATE];
    usernameLab.textColor = MAIN_SUBTITLE_COLOR;
    usernameLab.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [questionsView addSubview:usernameLab];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld 回答",(long)[_questionInfoModel.ANSWERSUM integerValue]];

    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text = praiseNumLabText;
    praiseNumLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:praiseNumLab];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, userY + 25.0f, SCREEN_WIDTH, 10.0f);
    [lineLayer setBackgroundColor:[MAIN_LINE_COLOR CGColor]];
    [questionsView.layer addSublayer:lineLayer];
    
    questionsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, userY + 20.0f);

    return questionsView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  [self calHeaderHeight];
}

-(float)calHeaderHeight{
    float questionHeight =[ZEUtil heightForString:_questionInfoModel.QUESTIONEXPLAIN font:[UIFont boldSystemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    NSArray * typeCodeArr = [_questionInfoModel.QUESTIONTYPECODE componentsSeparatedByString:@","];
    NSString * typeNameContent = @"";
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * questionTypeM = nil;
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        for (int i = 0; i < typeCodeArr.count; i ++) {
            if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                questionTypeM = typeM;
                if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                    typeNameContent = questionTypeM.NAME;
                }else{
                    typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                }
                break;
            }
        }
    }
    
    float tagHeight = [ZEUtil heightForString:typeNameContent font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 70];
    
    NSString * targetUsernameStr = [NSString stringWithFormat:@"指定人员回答 ：%@", _questionInfoModel.TARGETUSERNAME];
    float targetUsernameHeight = [ZEUtil heightForString:targetUsernameStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    
    if(_questionInfoModel.FILEURLARR.count > 0){
        if(_questionInfoModel.TARGETUSERNAME.length > 0){
            return questionHeight + kCellImgaeHeight + tagHeight + 75.0f + targetUsernameHeight;
        }
        return questionHeight + kCellImgaeHeight + tagHeight + 70.0f;
    }
    
    if (_questionInfoModel.TARGETUSERNAME.length > 0) {
        return questionHeight + tagHeight + 65.0f + targetUsernameHeight;
    }
    
    return questionHeight + tagHeight + 65.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    while (cell.contentView.subviews.lastObject) {
        UIView * lastView = cell.contentView.subviews.lastObject;
        [lastView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_answerInfoArr.count == 0) {
        tipsView = [[ZEWithoutDataTipsView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 300)];
        tipsView.type = SHOW_TIPS_TYPE_QUESTIONDETAIL;
        [cell.contentView addSubview:tipsView];
    }else{
        [self initCellContentView:cell.contentView withIndexPath:indexPath];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_answerInfoArr.count == 0) {
        return 300;
    }
    
    ZEAnswerInfoModel * answerInfoM = [ZEAnswerInfoModel getDetailWithDic:_answerInfoArr[indexPath.row]];

    float answerHeight =[ZEUtil heightForString:answerInfoM.ANSWEREXPLAIN font:[UIFont boldSystemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 65];
    if ([answerInfoM.ISPASS boolValue]) {
        if ([answerInfoM.FILEURLARR count] > 0) {
            return answerHeight + 95.0f + kCellImgaeHeight;
        }
        return answerHeight + 85.0f;
    }
    if ([answerInfoM.FILEURLARR count] > 0) {
        return answerHeight + 75.0f + kCellImgaeHeight;
    }
    return answerHeight + 65.0f;
}

-(void)initCellContentView:(UIView *)cellContentView withIndexPath:(NSIndexPath *)indexPath
{
    ZEAnswerInfoModel * answerInfoM = [ZEAnswerInfoModel getDetailWithDic:_answerInfoArr[indexPath.row]];
    
    UIButton * userImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userImageBtn.frame = CGRectMake(20, 5, 200, 30);
    userImageBtn.backgroundColor = [UIColor clearColor];
    [userImageBtn addTarget:self action:@selector(showUserMessage) forControlEvents:UIControlEventTouchUpInside];
    [cellContentView addSubview:userImageBtn];

    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    userImg.userInteractionEnabled = NO;
    [userImg sd_setImageWithURL:ZENITH_IMAGEURL(answerInfoM.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [userImageBtn addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 15;
    
    UILabel * ANSWERUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(35,0,100.0f,30.0f)];
    ANSWERUSERNAME.text = answerInfoM.NICKNAME;
    if(_isTeam){
        ANSWERUSERNAME.text = answerInfoM.ANSWERUSERNAME;
    }
    ANSWERUSERNAME.userInteractionEnabled = NO;
    ANSWERUSERNAME.textColor = MAIN_SUBTITLE_COLOR;
    [ANSWERUSERNAME sizeToFit];
    ANSWERUSERNAME.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [userImageBtn addSubview:ANSWERUSERNAME];
    
    float answerHeight =[ZEUtil heightForString:answerInfoM.ANSWEREXPLAIN font:[UIFont boldSystemFontOfSize:kDetailTitleFontSize] andWidth:SCREEN_WIDTH - 65];
    
    UILabel * ANSWEREXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(55, 35, SCREEN_WIDTH - 65, answerHeight)];
    ANSWEREXPLAIN.numberOfLines = 0;
    ANSWEREXPLAIN.userInteractionEnabled = NO;
    ANSWEREXPLAIN.text = answerInfoM.ANSWEREXPLAIN;
    ANSWEREXPLAIN.font = [UIFont boldSystemFontOfSize:kDetailTitleFontSize];
    [cellContentView addSubview:ANSWEREXPLAIN];
    
    float userY = answerHeight + 40.0f;
    
    NSMutableArray * urlsArr = [NSMutableArray array];
    for (NSString * str in answerInfoM.FILEURLARR) {
        [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
    }
    
    if (answerInfoM.FILEURLARR.count > 0) {
        PYPhotosView *linePhotosView = [PYPhotosView photosViewWithThumbnailUrls:urlsArr originalUrls:urlsArr layoutType:PYPhotosViewLayoutTypeLine];
        // 设置Frame
        
        linePhotosView.py_y = userY;
        linePhotosView.py_x = PYMargin;
        if (urlsArr.count == 1) {
            linePhotosView.py_width =  ( SCREEN_WIDTH - 40 ) / 3 + 20;
        }else if (urlsArr.count == 2){
            linePhotosView.py_width =  ( SCREEN_WIDTH - 40 ) / 3  * 2;
        }else{
            linePhotosView.py_width = SCREEN_WIDTH - 40;
        }
        // 3. 添加到指定视图中
        [cellContentView addSubview:linePhotosView];
        
        userY += kCellImgaeHeight + 10.0f;
    }

    
    UILabel * SYSCREATEDATE = [[UILabel alloc]initWithFrame:CGRectMake(55,userY,100.0f,20.0f)];
    SYSCREATEDATE.text = [ZEUtil compareCurrentTime:answerInfoM.SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = NO;
    SYSCREATEDATE.textColor = MAIN_SUBTITLE_COLOR;
    SYSCREATEDATE.font = [UIFont systemFontOfSize:kDetailTitleFontSize];
    [cellContentView addSubview:SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = YES;

    if([ZEUtil isStrNotEmpty:answerInfoM.FILEURL]){
        SYSCREATEDATE.frame = CGRectMake(20,userY,100.0f,20.0f);
    }
    
    float praiseNumWidth = [ZEUtil widthForString:[NSString stringWithFormat:@"  %@",answerInfoM.GOODNUMS] font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];

    UIButton * praiseNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    praiseNumBtn.frame = CGRectMake(SCREEN_WIDTH - praiseNumWidth - 30.0f,userY - 5,praiseNumWidth + 20,30.0f);
    [praiseNumBtn setTitle:[NSString stringWithFormat:@"  %@",answerInfoM.GOODNUMS] forState:UIControlStateNormal];
    praiseNumBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [praiseNumBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
    [cellContentView addSubview:praiseNumBtn];
    praiseNumBtn.tag = indexPath.row;
    if([answerInfoM.ISGOOD boolValue]){
        [praiseNumBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [praiseNumBtn setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png" color:[UIColor redColor]] forState:UIControlStateNormal];
        [praiseNumBtn addTarget:self action:@selector(havenGiveLikes) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [praiseNumBtn setImage:[UIImage imageNamed:@"qb_praiseBtn_hand.png"] forState:UIControlStateNormal];
        [praiseNumBtn addTarget:self action:@selector(giveLikes:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel * que_ans_lab = nil;
    if ([answerInfoM.QACOUNT integerValue] > 0) {
        que_ans_lab = [[UILabel alloc]init];
        que_ans_lab.frame = CGRectMake(SCREEN_WIDTH - 100, 10, 90, 20);
        que_ans_lab.text = [NSString stringWithFormat:@"%@追问追答",answerInfoM.QACOUNT];
        que_ans_lab.userInteractionEnabled = NO;
        que_ans_lab.textAlignment = NSTextAlignmentRight;
        que_ans_lab.textColor = MAIN_SUBTITLE_COLOR;
        que_ans_lab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [cellContentView addSubview:que_ans_lab];
        que_ans_lab.userInteractionEnabled = YES;
    }
    
    if ([answerInfoM.ISPASS boolValue]) {
        UIImageView * iconAccept = [[UIImageView alloc]init];
        [cellContentView addSubview:iconAccept];
        iconAccept.frame = CGRectMake(SCREEN_WIDTH - 35, 0, 35, 35);
        [iconAccept setImage:[UIImage imageNamed:@"ic_best_answer"]];
        
        que_ans_lab.frame = CGRectMake(SCREEN_WIDTH - 135, 10, 90, 20);
        
        UILabel * otherAnswers = [[UILabel alloc]initWithFrame:CGRectMake(0, userY + 25.0f, SCREEN_WIDTH, 20.0f)];
        otherAnswers.numberOfLines = 0;
        otherAnswers.font = [UIFont systemFontOfSize:12];
        otherAnswers.backgroundColor = MAIN_LINE_COLOR;
        otherAnswers.textColor = MAIN_NAV_COLOR;
        otherAnswers.text = @"      其他回答";
        [cellContentView addSubview:otherAnswers];
    }
    
    if (([answerInfoM.ANSWERCOUNT integerValue] > 0 && [_questionInfoModel.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) ) {
        UILabel * badgeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20.0f)];
        badgeLab.backgroundColor = [UIColor redColor];
        badgeLab.tag = 100;
        badgeLab.center = CGPointMake(SCREEN_WIDTH - 20, (userY + 20.0f) / 2);
        badgeLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        badgeLab.textColor = [UIColor whiteColor];
        badgeLab.textAlignment = NSTextAlignmentCenter;
        [cellContentView addSubview:badgeLab];
        badgeLab.clipsToBounds = YES;
        badgeLab.layer.cornerRadius = badgeLab.height / 2;
        badgeLab.text = answerInfoM.ANSWERCOUNT;
        if (badgeLab.text.length > 2){
            badgeLab.width = 30.0f;
            badgeLab.center = CGPointMake(SCREEN_WIDTH - 25, (userY + 20.0f) / 2);
        }
        if ([_questionInfoModel.INFOCOUNT integerValue] > 99) {
            badgeLab.text = @"99+";
        }
    }
    
    if (([answerInfoM.QUESTIONCOUNT integerValue] > 0 && [answerInfoM.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) ) {
        UILabel * badgeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20.0f)];
        badgeLab.backgroundColor = [UIColor redColor];
        badgeLab.tag = 100;
        badgeLab.center = CGPointMake(SCREEN_WIDTH - 20, (userY + 20.0f) / 2);
        badgeLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        badgeLab.textColor = [UIColor whiteColor];
        badgeLab.textAlignment = NSTextAlignmentCenter;
        [cellContentView addSubview:badgeLab];
        badgeLab.clipsToBounds = YES;
        badgeLab.layer.cornerRadius = badgeLab.height / 2;
        badgeLab.text = answerInfoM.QUESTIONCOUNT;
        if (badgeLab.text.length > 2){
            badgeLab.width = 30.0f;
            badgeLab.center = CGPointMake(SCREEN_WIDTH - 25, (userY + 20.0f) / 2);
        }
        if ([_questionInfoModel.INFOCOUNT integerValue] > 99) {
            badgeLab.text = @"99+";
        }
    }

    
    cellContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, userY + 20.0f);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_answerInfoArr.count == 0) {
        return;
    }
    
    ZEAnswerInfoModel * answerInfoM = [ZEAnswerInfoModel getDetailWithDic:_answerInfoArr[indexPath.row]];
    if ([self.delegate respondsToSelector:@selector(acceptTheAnswerWithQuestionInfo:withAnswerInfo:)]) {
        [self.delegate acceptTheAnswerWithQuestionInfo:_questionInfoModel withAnswerInfo:answerInfoM];
    }
}

-(void)giveLikes:(UIButton *)btn
{
    ZEAnswerInfoModel * answerInfoM = [ZEAnswerInfoModel getDetailWithDic:_answerInfoArr[btn.tag]];

    if([self.delegate respondsToSelector:@selector(giveLikes:)]){
        [self.delegate giveLikes:answerInfoM.SEQKEY];
    }
    
}

-(void)havenGiveLikes{
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud2.labelText = @"已经点赞过了";
    hud2.mode = MBProgressHUDModeText;
    [hud2 hide:YES afterDelay:1.0f];
}



#pragma mark - ZEQuestionsDetailViewDelegate

-(void)showUserMessage
{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
