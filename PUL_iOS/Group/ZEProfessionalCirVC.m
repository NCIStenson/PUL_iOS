//
//  ZEProfessionalCirVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/9/26.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define PROCIRCLECODE(dic) [dic objectForKey:@"PROCIRCLECODE"]
#define PROCIRCLENAME(dic) [dic objectForKey:@"PROCIRCLENAME"]
#define ICOPATH(dic) [dic objectForKey:@"ICOPATH"]
#define SEQKEY(dic) [dic objectForKey:@"SEQKEY"]

#define kTableViewCellHeight 44.0f

#import "ZEProfessionalCirVC.h"
#import "ZEQuestionTypeCache.h"
#import "ZEProCirDetailVC.h"

@interface ZEProfessionalCirVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView * profContentView;
    UITableView * contentView;
}

@property (nonnull,nonatomic,strong) NSMutableArray * datasArr;

@property (nonnull,nonatomic,strong) NSMutableArray * myCircleArr;

@end

@implementation ZEProfessionalCirVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.datasArr = [NSMutableArray array];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self sendRequest];
}

#pragma mark - Request

-(void)sendRequest
{
    NSString * WHERESQL = @"";
    NSString * ORDERSQL = @"";
    NSString * tableName = KLB_PROCIRCLE_POSITION;
    tableName = KLB_PROCIRCLE_POSITION;
    ORDERSQL = @"procirclepoints desc";
    NSArray * dataArr = [[ZEQuestionTypeCache instance]getProCircleCaches];
    if (dataArr.count > 0) {
        self.datasArr = [NSMutableArray arrayWithArray:dataArr];
        [self myCircleRequest];
        return;
    }
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":tableName,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":ORDERSQL,
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.procirclestatus.ProcirclePosition",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[tableName]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {

                                 NSArray * arr = [NSMutableArray arrayWithArray:[ZEUtil getServerData:data withTabelName:tableName]];
                                 self.datasArr = [NSMutableArray arrayWithArray:arr];
                                 
                                 //  整理数据 加入圈子排名字段
                                 NSMutableArray * rankingArr = [NSMutableArray array];
                                 long i = 1;
                                 for (NSDictionary * dic in arr) {
                                     NSMutableDictionary * rankingDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                                     [rankingDic setObject:[NSString stringWithFormat:@"%ld",i] forKey:@"PROCIRCLERANKING"];
                                     i ++;
                                     [rankingArr addObject:rankingDic];
                                 }
                                 self.datasArr = rankingArr;
                                 
                                 [self myCircleRequest];
                                 [[ZEQuestionTypeCache instance] setProCircleCaches:rankingArr];
                                 
                             } fail:^(NSError *errorCode) {
                                 NSLog(@">>>  %@",errorCode);
                             }];
}

-(void)myCircleRequest
{
    NSString * WHERESQL = @"";
    NSString * ORDERSQL = @"";
    NSString * tableName = KLB_PROCIRCLE_INFO;
    
    WHERESQL = [NSString stringWithFormat:@"USERCODE='%@'",[ZESettingLocalData getUSERCODE]];
    tableName = KLB_PROCIRCLE_REL_USER;
    ORDERSQL = @"SYSCREATEDATE desc";

    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":tableName,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":ORDERSQL,
                                     @"WHERESQL":WHERESQL,
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[tableName]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [NSMutableArray arrayWithArray:[ZEUtil getServerData:data withTabelName:tableName]];
                                 self.myCircleArr = [NSMutableArray arrayWithArray:arr];
                                 if (_enter_group_type == ENTER_GROUP_TYPE_SETTING) {
                                     [self reloadMyCircleView:self.myCircleArr];
                                 }
                                 if(arr.count == 0 ){
                                     MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                     hud3.mode = MBProgressHUDModeText;
                                     hud3.labelText = @"您还没有关注的专业圈。";
                                     [hud3 hide:YES afterDelay:1];
                                 }
                                 [contentView reloadData];
                             } fail:^(NSError *errorCode) {
                             }];
}


-(void)reloadMyCircleView:(NSArray *)arr
{
    self.datasArr = [NSMutableArray array];
    NSArray * cacheArr = [[ZEQuestionTypeCache instance] getProCircleCaches];
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary * dic = arr[i];
        for (int j = 0; j < cacheArr.count; j ++) {
            NSDictionary * cacheDic = cacheArr[j];
            if ([[dic objectForKey:@"PROCIRCLECODE"] isEqualToString:[cacheDic objectForKey:@"PROCIRCLECODE"]]) {
                [self.datasArr addObject:cacheDic];
                break;
            }
        }
    }
    [contentView reloadData];
}

-(void)initView{
    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    contentView.delegate = self;
    contentView.dataSource = self;
    [self.view addSubview:contentView];
    contentView.showsVerticalScrollIndicator = NO;
    contentView.separatorStyle  = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_enter_group_type == ENTER_GROUP_TYPE_SETTING) {
        return self.datasArr.count;
    }
    if (section == 0) {
        if (self.datasArr.count < 3) {
            return self.datasArr.count;
        }
        return 3;
    }
    return self.datasArr.count - 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_enter_group_type == ENTER_GROUP_TYPE_SETTING) {
        return 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
    view.backgroundColor = MAIN_BACKGROUND_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 43.0f, SCREEN_WIDTH, 1.0f);
    [cell.contentView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_BACKGROUND_COLOR CGColor];
        
    [self initCellView:cell withIndexPath:indexPath];
    
    return cell;
}

-(void)initCellView:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UIImageView * contentImage = [[UIImageView alloc]init];
    contentImage.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:contentImage];
    contentImage.left = 10.0f;
    contentImage.size = CGSizeMake(16.0f, 16.0f);
    contentImage.top = (kTableViewCellHeight - contentImage.height) / 2 ;
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(30.0f,0,SCREEN_WIDTH - 100 ,kTableViewCellHeight - 2.0f)];
    contentLab.textColor = kTextColor;
    contentLab.userInteractionEnabled = NO;
    contentLab.textColor = MAIN_SUBTITLE_COLOR;
    [cell.contentView addSubview:contentLab];
    contentLab.font = [UIFont systemFontOfSize:15.0f];
    contentLab.numberOfLines = 0;

    if(indexPath.section == 0){
        [contentImage sd_setImageWithURL:ZENITH_ICON_IMAGEURL(ICOPATH(self.datasArr[indexPath.row])) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        [contentLab setText:PROCIRCLENAME(self.datasArr[indexPath.row])];

        UIImageView * rankingImageView;
        rankingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 7, 30, 30.0f)];
        [cell.contentView addSubview:rankingImageView];
        rankingImageView.contentMode = UIViewContentModeScaleAspectFit;

        switch (indexPath.row) {
            case 0:
                rankingImageView.image = [UIImage imageNamed:@"icon_circle_first"];
                break;
            case 1:
                rankingImageView.image = [UIImage imageNamed:@"icon_circle_second"];
                break;
            case 2:
                rankingImageView.image = [UIImage imageNamed:@"icon_circle_third"];
                break;
                
            default:
                break;
        }
        if (_enter_group_type == ENTER_GROUP_TYPE_SETTING) {
            rankingImageView.hidden = YES;
        }
        for (int k = 0; k < self.myCircleArr.count ; k ++) {
            NSDictionary * myCircleDic = self.myCircleArr[k];
            if ([PROCIRCLECODE(myCircleDic) isEqualToString:PROCIRCLECODE(self.datasArr[indexPath.row])]) {
                UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 0, 20, 20)];
                iconImage.image = [UIImage imageNamed:@"hornView" color:MAIN_NAV_COLOR];
                [cell.contentView addSubview:iconImage];
            }
        }        
    }else{
        [contentLab setText:PROCIRCLENAME(self.datasArr[indexPath.row + 3])];
        [contentImage sd_setImageWithURL:ZENITH_ICON_IMAGEURL(ICOPATH(self.datasArr[indexPath.row + 3])) placeholderImage:ZENITH_PLACEHODLER_IMAGE];

        for (int k = 0; k < self.myCircleArr.count ; k ++) {
            NSDictionary * myCircleDic = self.myCircleArr[k];
            if ([PROCIRCLECODE(myCircleDic) isEqualToString:PROCIRCLECODE(self.datasArr[indexPath.row + 3])]) {
                UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 0, 20, 20)];
                iconImage.image = [UIImage imageNamed:@"hornView" color:MAIN_NAV_COLOR];
                [cell.contentView addSubview:iconImage];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZEProCirDetailVC * detailVC = [[ZEProCirDetailVC alloc]init];
    detailVC.enter_group_type = self.enter_group_type;

    if (indexPath.section == 0) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.datasArr[indexPath.row]];
        detailVC.PROCIRCLEDataDic = dic;
        detailVC.PROCIRCLECODE = [self.datasArr[indexPath.row] objectForKey:@"PROCIRCLECODE"];
        detailVC.PROCIRCLENAME = [self.datasArr[indexPath.row] objectForKey:@"PROCIRCLENAME"];
    }else{
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.datasArr[indexPath.row + 3]];
        detailVC.PROCIRCLEDataDic = dic;
        detailVC.PROCIRCLECODE = [self.datasArr[indexPath.row + 3] objectForKey:@"PROCIRCLECODE"];
        detailVC.PROCIRCLENAME = [self.datasArr[indexPath.row + 3] objectForKey:@"PROCIRCLENAME"];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
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
