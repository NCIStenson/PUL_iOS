//
//  ZEChooseNumberView.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChooseNumberView.h"

@implementation ZEChooseNumberView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alreadyInviteNumbersArr = [NSMutableArray array];
        [self initView];
    }
    return self;
}
-(void)initView
{
    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    contentView.delegate = self;
    contentView.dataSource = self;
    [self addSubview:contentView];
}

#pragma mark - Public Method

-(void)reloadViewWithAlreadyInviteNumbers:(NSArray *)arr
{
    [self.alreadyInviteNumbersArr addObjectsFromArray:arr];
    self.maskArr = [NSMutableArray array];
    for (int i = 0 ; i < self.alreadyInviteNumbersArr.count; i++) {
        [self.maskArr addObject:[NSString stringWithFormat:@"%@",@"0"]];
    }
    [contentView reloadData];
}

#pragma mark - 表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alreadyInviteNumbersArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * IDCell = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (!cell ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic: self.alreadyInviteNumbersArr[indexPath.row]];
    UIImageView * headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 45, 45)];
    [cell.contentView addSubview:headerImageView];
    [headerImageView sd_setImageWithURL:ZENITH_IMAGEURL(userinfo.FILEURL) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
    
    UILabel * numberName = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, SCREEN_WIDTH - 120, 20)];
    numberName.text = userinfo.USERNAME;
    [numberName setTextColor:kTextColor];
    numberName.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:numberName];
    
    UILabel * numberCode = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, SCREEN_WIDTH - 120, 20)];
    numberCode.text = userinfo.USERCODE;
    [numberCode setTextColor:kTextColor];
    numberCode.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:numberCode];
    
    if (_whetherMultiselect) {
        if ([self.maskArr[indexPath.row] boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        if([userinfo.USERCODE isEqualToString:_currentSelectUserinfo.USERCODE]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_whetherMultiselect) {
        if (indexPath.row == 0 && _TEAMCODE.length == 0) {
            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud3.mode = MBProgressHUDModeText;
            hud3.labelText = @"团长不能被移除";
            [hud3 hide:YES afterDelay:1];
            
            return;
        }
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.alreadyInviteNumbersArr[indexPath.row]];
        ZEUSER_BASE_INFOM * leaderUserinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.alreadyInviteNumbersArr[0]];
        if ([userinfo.USERTYPE integerValue] == 3 && _TEAMCODE.length == 0 && ![leaderUserinfo.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud3.mode = MBProgressHUDModeText;
            hud3.labelText = @"当前账号无移除管理员权限";
            [hud3 hide:YES afterDelay:1];
            
            return;
        }

        if (_TEAMCODE.length > 0 && [userinfo.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud3.mode = MBProgressHUDModeText;
            hud3.labelText = @"不能指定自己回答";
            [hud3 hide:YES afterDelay:1];
            return;
        }
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([self.maskArr[indexPath.row] boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.maskArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.maskArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }
    }else{
        if (indexPath.row == 0) {
            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud3.mode = MBProgressHUDModeText;
            hud3.labelText = @"您已经是团长了";
            [hud3 hide:YES afterDelay:1];
            
            return;
        }
        
        
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.alreadyInviteNumbersArr[indexPath.row]];
        _currentSelectUserinfo = userinfo;
        [contentView reloadData];
//        if (_TEAMCODE.length > 0 && [userinfo.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
//            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
//            hud3.mode = MBProgressHUDModeText;
//            hud3.labelText = @"不能指定自己回答";
//            [hud3 hide:YES afterDelay:1];
//            return;
//        }
//
//        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        if ([self.maskArr[indexPath.row] boolValue]) {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            [self.maskArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            [self.maskArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
//        }
    }
    
    
}


-(void)setWhetherMultiselect:(BOOL)whetherMultiselect{
    _whetherMultiselect = whetherMultiselect;
    
}


@end
