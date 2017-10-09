//
//  ZESetPersonalMessageView.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/11.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZESetPersonalMessageView.h"

@interface ZESetPersonalMessageView ()
{
    UITableView * contentTable;
    ENTER_SETTING_TYPE _enterType;
    NSString * sumpoints;
}
@property (nonatomic,strong) NSDictionary * userInfoDic;
@end

@implementation ZESetPersonalMessageView

-(id)initWithFrame:(CGRect)frame withEnterType:(ENTER_SETTING_TYPE)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _enterType = type;
        [self initView];
    }
    return self;
}

-(void)initView
{
    contentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    contentTable.backgroundColor = MAIN_LINE_COLOR;
    contentTable.delegate = self;
    contentTable.dataSource = self;
    [self addSubview:contentTable];
    contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSuccess) name:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
}

-(void)reloadDataWithDic:(NSDictionary *)dic
{
    self.userInfoDic = dic;
    
    [contentTable reloadData];
}

-(void)reloadPersonalScore:(NSString *)points
{
    sumpoints = points;
    [contentTable reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
}

-(void)changeSuccess
{
    [contentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_enterType == ENTER_SETTING_TYPE_SETTING && section == 0){
        return 0.0f;
    }
    return 10.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = MAIN_LINE_COLOR;
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [cell.contentView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"用户名";
                    cell.detailTextLabel.text = [ZESettingLocalData getUSERNAME];
                    break;
                case 1:
                    cell.textLabel.text = @"用户昵称";
                    cell.detailTextLabel.text = [ZESettingLocalData getNICKNAME];
                    break;
                case 2:
                    cell.textLabel.text = @"个人积分";
                    if ([sumpoints  integerValue ] == 0) {
                        cell.detailTextLabel.text = @"0";
                    }else{
                        cell.detailTextLabel.text = sumpoints;
                    }
                    break;
                case 3:
                    cell.textLabel.text = @"当前等级";
                    if([[self.userInfoDic objectForKey:@"LEVELNAME"] length] > 0){
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[self.userInfoDic objectForKey:@"LEVELNAME"],[self.userInfoDic objectForKey:@"LEVELCODE"]];
                    }
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"清除缓存";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f M",[self cacheFilePath] + [self downloadFilePath]];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                    break;
                    
                case 1:
                    cell.textLabel.text = @"意见反馈";
                    break;
                case 2:
                    cell.textLabel.text = @"修改密码";
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
            cell.textLabel.text = @"退出登录";
            break;
            
        default:
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 1:{
                    if ([self.delegate respondsToSelector:@selector(changePersonalMsg:)]) {
                        [self.delegate changePersonalMsg:CHANGE_PERSONALMSG_NICKNAME];
                    }
                }
                    break;
                    
                case 2:{
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    [self clearFile];
                }
                    break;

                case 1:{
                    if ([self.delegate respondsToSelector:@selector(changePersonalMsg:)]) {
                        [self.delegate changePersonalMsg:CHANGE_PERSONALMSG_ADVICE];
                    }
                }
                    break;

                case 2:{
                    if ([self.delegate respondsToSelector:@selector(changePassword)]) {
                        [self.delegate changePassword];
                    }
                }
                    break;

                default:
                    break;
            }
        }
            break;

        case 2:
            if ([self.delegate respondsToSelector:@selector(logout)]) {
                [self.delegate logout];
            }
            break;

            
        default:
            break;
    }
    
}
// 下载文件大小
-( float )downloadFilePath{
    NSString * cachPath = [NSString stringWithFormat:@"%@/Documents/Downloads",NSHomeDirectory()];
    
    return [ self folderSizeAtPath :cachPath];
}

// 显示缓存大小
-( float )cacheFilePath
{
    NSLog(@"%@" , NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) );
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1000.0 * 1000.0 );
    
}




// 清理缓存

- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
-(void)clearCachSuccess
{
    NSLog ( @" 清理成功 " );
    [MBProgressHUD hideAllHUDsForView:self animated:YES];

    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:1];//刷新
    [contentTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
