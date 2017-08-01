//
//  ZEProCirDynamicVC.m
//  PUL_iOS
//
//  Created by Stenson on 16/10/13.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kDynamicsHeight  80.0f

#import "ZEProCirDynamicVC.h"

@interface ZEProCirDynamicVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * contentView;
}

@property(nonatomic,strong) NSMutableArray * datasArr;
@end

@implementation ZEProCirDynamicVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"圈子动态";
    
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self sendRequest];
}
-(void)sendRequest
{
    NSDictionary * parametersDic = @{@"limit":@"10",
                                     @"MASTERTABLE":KLB_DYNAMIC_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":[NSString stringWithFormat:@"PROCIRCLECODE = '%@'",_PROCIRCLECODE],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_DYNAMIC_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];


    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {

                                 self.datasArr = [NSMutableArray arrayWithArray:[ZEUtil getServerData:data withTabelName:KLB_DYNAMIC_INFO]];
                                 [contentView reloadData];
                             } fail:^(NSError *errorCode) {

                             }];
}

#pragma mark - initView

-(void)initView{
    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView.delegate = self;
    contentView.dataSource = self;
    [self.view addSubview:contentView];
}
#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3 * kDynamicsHeight;
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
    if (indexPath.row == 0) {
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        [cell.contentView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    }
    
    [self initNewestCircleDynamics:cell.contentView indexPath:indexPath];
    return cell;
}

-(void)initNewestCircleDynamics:(UIView *)superView indexPath:(NSIndexPath *)indexpath
{
    NSDictionary * dataDic = self.datasArr[indexpath.row];
    
    CALayer * sumLineLayer = [CALayer layer];
    sumLineLayer.frame = CGRectMake(0,kDynamicsHeight, SCREEN_WIDTH, 1);
    [superView.layer addSublayer:sumLineLayer];
    sumLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    CALayer * vLineLayer = [CALayer layer];
    vLineLayer.frame = CGRectMake(80, 0, 1, kDynamicsHeight);
    [superView.layer addSublayer:vLineLayer];
    vLineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    
    UILabel * timeTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 80, kDynamicsHeight)];
    timeTitleLab.text = [ZEUtil compareCurrentTime:[NSString stringWithFormat:@"%@.0",[dataDic objectForKey:@"SYSUPDATORID"]]] ;
    timeTitleLab.textAlignment = NSTextAlignmentCenter;
    timeTitleLab.font = [UIFont systemFontOfSize:14];
    [superView addSubview:timeTitleLab];
    
    NSInteger type = [[dataDic objectForKey:@"DYNAMICTYPE"] integerValue];
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 0 , SCREEN_WIDTH - 100, 25)];
    contentLab.text = [ZEUtil compareCurrentTime:[NSString stringWithFormat:@"%@.0",[dataDic objectForKey:@"SYSUPDATORID"]]] ;
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.font = [UIFont systemFontOfSize:14];
    [superView addSubview:contentLab];
    
    UILabel * questionContentLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 25 , SCREEN_WIDTH - 100, 25)];
    questionContentLab.text = [NSString stringWithFormat:@"问题：%@",[dataDic objectForKey:@"QUESTIONEXPLAIN"]];
    questionContentLab.textAlignment = NSTextAlignmentLeft;
    questionContentLab.font = [UIFont systemFontOfSize:14];
    [superView addSubview:questionContentLab];

    UILabel * answerContentLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 50 , SCREEN_WIDTH - 100, 25)];
    answerContentLab.text = [NSString stringWithFormat:@"回答：%@",[dataDic objectForKey:@"ANSWEREXPLAIN"]] ;
    answerContentLab.textAlignment = NSTextAlignmentLeft;
    answerContentLab.font = [UIFont systemFontOfSize:14];
    [superView addSubview:answerContentLab];

    if (type == 0) {
        contentLab.text = [NSString stringWithFormat:@"%@回答了问题",[dataDic objectForKey:@"USERNAME"]] ;
    } else if (type == 2){
        contentLab.text = [NSString stringWithFormat:@"%@的回答被采纳",[dataDic objectForKey:@"USERNAME"]] ;
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
