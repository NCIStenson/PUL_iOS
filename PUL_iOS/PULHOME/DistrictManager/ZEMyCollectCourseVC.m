//
//  ZEMyCollectCourseVC.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/14.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEMyCollectCourseVC.h"
#import "ZEDistrictManagerCell.h"
#import "ZEManagerDetailVC.h"
@interface ZEMyCollectCourseVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _contentView;
}

@property (nonatomic,strong) NSMutableArray * myCollectArr;

@end

@implementation ZEMyCollectCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
}
-(void)initView{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH , SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self.view addSubview:_contentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMyCollectCourseList];
}
-(void)getMyCollectCourseList
{
    NSDictionary * parametersDic = @{@"MASTERTABLE":V_KLB_COURSEWARE_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"limit":@"-1",
                                     @"METHOD":METHOD_SEARCH,
                                     @"DETAILTABLE":@"",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":DISTRICTMANAGER_CLASS,
                                     @"usercode":[ZESettingLocalData getUSERCODE],
                                     };
    
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[V_KLB_COURSEWARE_INFO]
                                                                           withFields:nil
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:@"coursecollect"];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr =[ZEUtil getServerData:data withTabelName:V_KLB_COURSEWARE_INFO];
                                 self.myCollectArr = [NSMutableArray arrayWithArray:arr];
                                 
                                 for (int i = 0; i < self.myCollectArr.count; i ++) {
                                     NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.myCollectArr[i]];
                                     [dic setObject:@"1" forKey:@"ISCOLLECT"];
                                     [self.myCollectArr replaceObjectAtIndex:i withObject:dic];
                                 }
                                 [_contentView reloadData];

                             } fail:^(NSError *errorCode) {
                                 
                             }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myCollectArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZEDistrictManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZEDistrictManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    while (cell.contentView.subviews.lastObject) {
        [cell.contentView.subviews.lastObject removeFromSuperview];
    }
    
    [cell initUIWithDic:self.myCollectArr[indexPath.row]];
    cell.lineLayer.hidden = YES;
    
    UILabel *_tipsLab = [UILabel new];
    _tipsLab.frame = CGRectMake(0, 70, SCREEN_WIDTH, 25);
    [cell.contentView addSubview:_tipsLab];
    _tipsLab.text = @"立即查看";
    _tipsLab.backgroundColor = RGBA(244, 248, 251, 1);
    _tipsLab.textColor = kSubTitleColor;
    _tipsLab.textAlignment = NSTextAlignmentCenter;
    _tipsLab.font = [UIFont systemFontOfSize:14];

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic =self.myCollectArr[indexPath.row];
    ZEManagerDetailVC * detailVC = [[ZEManagerDetailVC alloc]init];
    detailVC.detailManagerModel = [ZEDistrictManagerModel getDetailWithDic:dic];
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
