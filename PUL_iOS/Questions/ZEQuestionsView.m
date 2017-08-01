//
//  ZEQuestionsView.m
//  PUL_iOS
//
//  Created by Stenson on 16/7/29.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kQuestionTitleFontSize      kTiltlFontSize
#define kQuestionSubTitleFontSize   kSubTiltlFontSize

#define kContentTableMarginLeft  0.0f
#define kContentTableMarginTop   50.0f
#define kContentTableWidth       SCREEN_WIDTH
#define kContentTableHeight      SCREEN_HEIGHT - 49.0f - NAV_HEIGHT - kContentTableMarginTop

#import "ZEQuestionsView.h"
#import "ZEQuestionInfoModel.h"


@interface ZEQuestionsView()

{
    UITextField * _questionSearchTF;
    NSString * _questionStr;
    UITableView * _contentTableView;
}

@property (nonatomic,strong) NSArray * datasArr;

@end

@implementation ZEQuestionsView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView];
    }
    return self;
}

-(void)initContentView
{
    UIView * searchBackView = [[UIView alloc]initWithFrame:CGRectMake(0, -1, SCREEN_WIDTH, 50)];
    searchBackView.backgroundColor = MAIN_NAV_COLOR;
    
    UIView * searchTF = [self searchTextfieldView];
    searchTF.frame = CGRectMake(25, 10, SCREEN_WIDTH - 50, 30);
    [searchBackView addSubview:searchTF];
    [self addSubview:searchBackView];
    
    [self initContentTableView];
}

-(void)initContentTableView
{
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self addSubview:_contentTableView];
    
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableMarginLeft);
        make.top.mas_equalTo(kContentTableMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableWidth, kContentTableHeight));
    }];
    
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
    _questionSearchTF.placeholder = @"搜索你想知道的问题";
    [_questionSearchTF setReturnKeyType:UIReturnKeySearch];
    _questionSearchTF.font = [UIFont systemFontOfSize:14];
    _questionSearchTF.leftViewMode = UITextFieldViewModeAlways;
    _questionSearchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    _questionSearchTF.delegate=self;
    
    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = 2.0f;
    
    return searchTFView;
}

#pragma mark - Public Method

-(void)reloadContentViewWithArr:(NSArray *)arr{
    self.datasArr = arr;
    [_contentTableView reloadData];
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
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = _datasArr[indexPath.row];
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    NSString * QUESTIONEXPLAINStr = [datasDic objectForKey:@"QUESTIONEXPLAIN"];

    if (indexPath.section == QUESTION_SECTION_TYPE_RECOMMEND) {
        
        float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
        if( quesInfoM.FILEURLARR.count > 0 ){
            return questionHeight + kCellImgaeHeight + 60.0f;
        }
        
        return questionHeight + 50.0f;
        
    }else if (indexPath.section == QUESTION_SECTION_TYPE_NEWEST){
        

        float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
        if( quesInfoM.FILEURLARR.count > 0 ){
            return questionHeight + kCellImgaeHeight + 60.0f;
        }
        return questionHeight + 50.0f;
    }
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * sectionView = [[UIView alloc]init];
    
    UIView * sectionTitleV = [self createSectionTitleView:section];
    [sectionView addSubview:sectionTitleV];
    
    return sectionView;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    [cell.contentView addSubview:[self createAnswerView:indexPath]];
    
    return cell;
}


#pragma mark - 回答问题
-(UIView *)createAnswerView:(NSIndexPath *)indexpath
{
    NSDictionary * datasDic = _datasArr[indexpath.row];
    
    UIView *  questionsView = [[UIView alloc]init];
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * QUESTIONEXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    QUESTIONEXPLAIN.numberOfLines = 0;
    QUESTIONEXPLAIN.text = QUESTIONEXPLAINStr;
    QUESTIONEXPLAIN.font = [UIFont boldSystemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONEXPLAIN];
    
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    
    NSMutableArray * urlsArr = [NSMutableArray array];
    for (NSString * str in quesInfoM.FILEURLARR) {
        [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
    }
    
    if (quesInfoM.FILEURLARR.count > 0) {
        PYPhotosView *linePhotosView = [PYPhotosView photosViewWithThumbnailUrls:urlsArr originalUrls:urlsArr layoutType:PYPhotosViewLayoutTypeLine];
        // 设置Frame
        linePhotosView.py_y = userY;
        linePhotosView.py_x = PYMargin;
        linePhotosView.py_width = SCREEN_WIDTH - 40;
        // 3. 添加到指定视图中
        [questionsView addSubview:linePhotosView];

        userY += kCellImgaeHeight + 10.0f;
    }
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
    [userImg sd_setImageWithURL:ZENITH_IMAGEURL(quesInfoM.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [questionsView addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * QUESTIONUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(45,userY,100.0f,20.0f)];
    QUESTIONUSERNAME.text = quesInfoM.NICKNAME;
    QUESTIONUSERNAME.textColor = MAIN_SUBTITLE_COLOR;
    QUESTIONUSERNAME.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
    [questionsView addSubview:QUESTIONUSERNAME];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld 回答",(long)[quesInfoM.ANSWERSUM integerValue]];
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text = praiseNumLabText;
    praiseNumLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:praiseNumLab];
    ZEQuestionTypeModel * questionTypeM = nil;

    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        if ([typeM.CODE isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
            questionTypeM = typeM;
        }
    }

    // 圈组分类最右边
    float circleTypeR = SCREEN_WIDTH - praiseNumWidth - 30;
    
    float circleWidth = [ZEUtil widthForString:questionTypeM.NAME font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(circleTypeR - circleWidth - 20.0f, userY + 2.0f, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"rateTa.png"];
    [questionsView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,circleWidth,20.0f)];
    circleLab.text = questionTypeM.NAME;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [questionsView addSubview:circleLab];
    
    questionsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, userY + 20.0f);
    
    return questionsView;
}

-(UIView *)creatCaseView
{
    UIView *  caseView = [[UIView alloc]init];
    
    UIImage * img = [UIImage imageNamed:@"banner.jpg"];
    float questionImgH =  ( ( SCREEN_WIDTH - 40) / 2 - 10.0f   ) / img.size.width * img.size.height;
    
    UIImageView * questionImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, (SCREEN_WIDTH - 40) / 2 , questionImgH)];
    questionImg.image = img;
    questionImg.contentMode = UIViewContentModeScaleAspectFit;
    [caseView addSubview:questionImg];
    
    float caseContH = [ZEUtil heightForString:_questionStr font:[UIFont systemFontOfSize:kSubTiltlFontSize] andWidth:(SCREEN_WIDTH - 40) / 2 ];
    
    UILabel * caseContentLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 40) / 2 + 20.0f ,10,(SCREEN_WIDTH - 40) / 2 ,caseContH)];
    caseContentLab.text = _questionStr;
    caseContentLab.numberOfLines = 0;
    caseContentLab.textColor = MAIN_SUBTITLE_COLOR;
    caseContentLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [caseView addSubview:caseContentLab];
    
    return caseView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * datasDic = _datasArr[indexPath.row];
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:datasDic];

    ZEQuestionTypeModel * questionTypeM = nil;
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        if ([typeM.SEQKEY isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
            questionTypeM = typeM;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(goQuestionDetailVCWithQuestionInfo:withQuestionType:)]) {
        [self.delegate goQuestionDetailVCWithQuestionInfo:quesInfoM withQuestionType:questionTypeM];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

#pragma mark -  区头文字

-(UIView * )createSectionTitleView:(QUESTION_SECTION_TYPE)sectionType
{
    UIButton * sectionTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionTitleBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    sectionTitleBtn.backgroundColor = [UIColor whiteColor];
    [sectionTitleBtn addTarget:self action:@selector(goMoreQuesVC:) forControlEvents:UIControlEventTouchUpInside];
    [sectionTitleBtn setTag:sectionType];
    
    UIImageView * sectionIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 18, 20)];
    sectionIcon.userInteractionEnabled = NO;
    [sectionTitleBtn addSubview:sectionIcon];
    
    UILabel * sectionTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 40)];
    sectionTitleLab.userInteractionEnabled = NO;
    switch (sectionType) {
        case QUESTION_SECTION_TYPE_RECOMMEND:
            sectionIcon.image = [UIImage imageNamed:@"forum_list_post.png"];
            sectionTitleLab.text = @"最新";
            break;
        case QUESTION_SECTION_TYPE_NEWEST:
            sectionIcon.image = [UIImage imageNamed:@"forum_list_post.png"];
            sectionTitleLab.text = @"推荐";
            break;
        default:
            break;
    }
    sectionTitleLab.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
    [sectionTitleBtn addSubview:sectionTitleLab];
    
    UILabel * sectionSubTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110 , 0, 90, 40)];
    sectionSubTitleLab.text = @"更多>>>";
    sectionSubTitleLab.userInteractionEnabled = NO;
    sectionSubTitleLab.textAlignment = NSTextAlignmentRight;
    sectionSubTitleLab.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
    [sectionTitleBtn addSubview:sectionSubTitleLab];
    
    return sectionTitleBtn;
}

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_questionSearchTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(goSearchWithStr:)]) {
        [self.delegate goSearchWithStr:textField.text];
    }
    
    return YES;
}

#pragma mark - ZEQuestionsViewDelegate

-(void)goMoreQuesVC:(UIButton *)button
{
    switch (button.tag) {
        case QUESTION_SECTION_TYPE_RECOMMEND:
        {
            if ([self.delegate respondsToSelector:@selector(goMoreRecommend)]) {
                [self.delegate goMoreRecommend];
            }
        }
            break;
            
        default:
            break;
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
