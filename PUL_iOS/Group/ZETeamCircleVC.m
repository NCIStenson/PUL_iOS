//
//  ZETeamCircleVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/9/26.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZETeamCircleVC.h"

@interface ZETeamCircleVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _contentView;
}
@property (nonnull,nonatomic,strong) NSArray * datasArr;
@end

@implementation ZETeamCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self sendRequest];
}

#pragma mark - Request

-(void)sendRequest
{
    NSString * WHERESQL = [NSString stringWithFormat:@"ISLOSE=0 and QUESTIONLEVEL = 1 and ISEXPERTANSWER = 0"];

    NSDictionary * parametersDic = @{@"limit":@"10",
                                     @"MASTERTABLE":V_KLB_QUESTION_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_QUESTION_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 self.datasArr = [ZEUtil getServerData:data withTabelName:V_KLB_QUESTION_INFO];
                                 [_contentView reloadData];
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)initView{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 40.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 89.0f) style:UITableViewStyleGrouped];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self.view addSubview:_contentView];
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:self.datasArr[indexPath.row]];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    if([ZEUtil isStrNotEmpty:quesInfoM.FILEURL]){
        return questionHeight + kCellImgaeHeight + 60.0f;
    }
    return questionHeight + 50.0f;
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
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    [self initCellView:cell.contentView indexPath:indexPath];
    
    return cell;
}
#pragma mark - CellView
-(void)initCellView:(UIView *)superView indexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        CALayer * lineLaye = [CALayer layer];
        [superView.layer addSublayer:lineLaye];
        lineLaye.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        lineLaye.backgroundColor = [MAIN_LINE_COLOR CGColor];
    }
    
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:self.datasArr[indexPath.row]];
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * QUESTIONEXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    QUESTIONEXPLAIN.numberOfLines = 0;
    QUESTIONEXPLAIN.text = QUESTIONEXPLAINStr;
    QUESTIONEXPLAIN.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [superView addSubview:QUESTIONEXPLAIN];
    
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    NSArray * imgFileUrlArr;
    
    if([ZEUtil isStrNotEmpty:quesInfoM.FILEURL]){
        imgFileUrlArr = [quesInfoM.FILEURL componentsSeparatedByString:@","];
    }
    
    for (int i = 0; i < imgFileUrlArr.count; i ++) {
        UIButton * questionImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        questionImageBtn.frame = CGRectMake(20 + (kCellImgaeHeight + 10) * i, userY, kCellImgaeHeight, kCellImgaeHeight);
        questionImageBtn.tag = i;
        questionImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [questionImageBtn  sd_setImageWithURL:ZENITH_IMAGEURL(imgFileUrlArr[i]) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        
        [superView addSubview:questionImageBtn];
        questionImageBtn.clipsToBounds = YES;
        
        if (i == imgFileUrlArr.count - 1) {
            userY += kCellImgaeHeight + 10.0f;
        }
    }
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
    userImg.image = [UIImage imageNamed:@"avatar_default.jpg"];
    [superView addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * QUESTIONUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(45,userY,100.0f,20.0f)];
    QUESTIONUSERNAME.text = quesInfoM.QUESTIONUSERNAME;
    QUESTIONUSERNAME.textColor = MAIN_SUBTITLE_COLOR;
    QUESTIONUSERNAME.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [superView addSubview:QUESTIONUSERNAME];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld 回答",(long)[quesInfoM.ANSWERSUM integerValue]];
    
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text  = praiseNumLabText;
    praiseNumLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [superView addSubview:praiseNumLab];
    ZEQuestionTypeModel * questionTypeM = nil;
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        if ([typeM.SEQKEY isEqualToString:quesInfoM.QUESTIONTYPECODE]) {
            questionTypeM = typeM;
        }
    }
    
    // 圈组分类最右边
    float circleTypeR = SCREEN_WIDTH - praiseNumWidth - 30;
    
    float circleWidth = [ZEUtil widthForString:questionTypeM.QUESTIONTYPENAME font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(circleTypeR - circleWidth - 20.0f, userY + 2.0f, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"rateTa.png"];
    [superView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,circleWidth,20.0f)];
    circleLab.text = questionTypeM.QUESTIONTYPENAME;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [superView addSubview:circleLab];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 165;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * superView = [[UIView alloc]init];
    superView.backgroundColor =[UIColor whiteColor];
    [self initHeaderView:superView];
    return superView;
}

-(void)initHeaderView:(UIView *)superView
{
    NSInteger count =4;
    
    UILabel * rowTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (count / 3 + 1) * 60 + 5, 120, 40)];
    rowTitleLab.text = @"班组圈动态";
    rowTitleLab.textAlignment = NSTextAlignmentCenter;
    rowTitleLab.backgroundColor = MAIN_NAV_COLOR_A(0.5);
    rowTitleLab.font = [UIFont systemFontOfSize:16];
    [superView addSubview:rowTitleLab];

    
    for (int i = 0 ; i < count / 3 + 1 ; i ++) {
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 5 + 60 * i, SCREEN_WIDTH, 1);
        [superView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        
        if (i == count/3 ) {
            CALayer * lastLineLayer = [CALayer layer];
            lastLineLayer.frame = CGRectMake(0, 5 + 60 * (i + 1), SCREEN_WIDTH, 1);
            [superView.layer addSublayer:lastLineLayer];
            lastLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
        }

        for (int j = 1; j < 4; j ++ ) {

            CALayer * lineLayer = [CALayer layer];
            lineLayer.frame = CGRectMake(SCREEN_WIDTH / 3 * j, 5 + 60 * i, 1, 60);
            [superView.layer addSublayer:lineLayer];
            lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];

            if (i * 3 + j > count) {
                return;
            }
        
            UIButton * professionalBtn =[UIButton buttonWithType:UIButtonTypeSystem];
            professionalBtn.frame = CGRectMake((SCREEN_WIDTH / 3 * (j - 1)), 5 + 60 * i, SCREEN_WIDTH / 3, 60.0f);
            professionalBtn.tag = i * 3 + j;
            professionalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [professionalBtn setTitle:@"变电运输一班" forState:UIControlStateNormal];
            [professionalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [superView addSubview:professionalBtn];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
