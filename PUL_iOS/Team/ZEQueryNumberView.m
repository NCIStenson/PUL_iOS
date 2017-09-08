//
//  ZEQueryNumberView.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kNavBarMarginLeft   0.0f
#define kNavBarMarginTop    0.0f
#define kNavBarWidth        SCREEN_WIDTH
#define kNavBarHeight       SCREEN_HEIGHT * 0.11

// 导航栏内左侧按钮
#define kLeftButtonWidth 40.0f
#define kLeftButtonHeight 40.0f
#define kLeftButtonMarginLeft SCREEN_WIDTH - 60
#define kLeftButtonMarginTop 20.0f + 4.0f

#define kSearchTFMarginLeft   20.0f
#define kSearchTFMarginTop    27.0f
#define kSearchTFWidth        SCREEN_WIDTH - 90.0f
#define kSearchTFHeight       30.0f

#import "ZEQueryNumberView.h"

@implementation ZEQueryNumberView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.alreadyInviteNumbersArr = [NSMutableArray array];
        self.searchNumbersArr = [NSMutableArray array];
        [self initNavBar];
    }
    return self;
}

-(void)initNavBar
{
    UIView * navView = [[UIView alloc] initWithFrame:CGRectZero];
    navView.backgroundColor = MAIN_NAV_COLOR;
    [self addSubview:navView];
    navView.frame = CGRectMake(kNavBarMarginLeft, kNavBarMarginTop, kNavBarWidth, kNavBarHeight);
    [ZEUtil addGradientLayer:navView];
    
    UIButton * _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(kLeftButtonMarginLeft, kLeftButtonMarginTop, kLeftButtonWidth, kLeftButtonHeight);
    _leftBtn.backgroundColor = [UIColor clearColor];
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 16.0f, 0.0f, 0.0f);
    _leftBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(goBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_leftBtn];
    
    
    UIView * searchView = [self searchTextfieldView:IPHONE6_MORE ? 35 : 30];
    
    [navView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSearchTFMarginTop);
        make.left.mas_equalTo(kSearchTFMarginLeft);
        if(IPHONE6_MORE){
            make.size.mas_equalTo(CGSizeMake(kSearchTFWidth, 35));
        }else{
            make.size.mas_equalTo(CGSizeMake(kSearchTFWidth, kSearchTFHeight));
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    contentView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight) style:UITableViewStylePlain];
    contentView.delegate = self;
    contentView.dataSource = self;
    [self addSubview:contentView];
    contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - 导航栏搜索界面

-(UIView *)searchTextfieldView:(float)height
{
    UIView * searchTFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, height)];
    searchTFView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * searchTFImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, ( height - height * 0.6 ) / 2, height * 0.6, height * 0.6)];
    searchTFImg.image = [UIImage imageNamed:@"search_icon"];
    [searchTFView addSubview:searchTFImg];
    searchTFImg.contentMode = UIViewContentModeScaleAspectFill;
    
    searchTF =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, height)];
    [searchTFView addSubview:searchTF];
    searchTF.placeholder = @"请输入工号添加团队成员";
    [searchTF setReturnKeyType:UIReturnKeySearch];
    searchTF.font = [UIFont systemFontOfSize:IPHONE6P ? 16 : 14];
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    searchTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, height * 0.6 + 7, height)];
    searchTF.delegate=self;
    [searchTF becomeFirstResponder];
    [searchTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];

    searchTFView.clipsToBounds = YES;
    searchTFView.layer.cornerRadius = height / 2;
    
    return searchTFView;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    CGRect end = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if(end.size.height > 0 ){
        [UIView animateWithDuration:0.29 animations:^{
            contentView.frame = CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - end.size.height);
        }];
    }
}

#pragma mark - 表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchNumbersArr.count;
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
    ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.searchNumbersArr[indexPath.row]];

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

    UIButton * stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stateBtn.frame = CGRectMake(SCREEN_WIDTH - 100 , 10 , 80, 40);
    [stateBtn  setTitle:@"邀请加入" forState:UIControlStateNormal];
    [cell.contentView addSubview:stateBtn];
    stateBtn.backgroundColor = MAIN_NAV_COLOR_A(0.9);
    [stateBtn addTarget:self action:@selector(inviteNumber:) forControlEvents:UIControlEventTouchUpInside];
    stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    stateBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    stateBtn.titleLabel.numberOfLines = 0;
    stateBtn.clipsToBounds = YES;
    stateBtn.layer.cornerRadius = 5;
    stateBtn.tag = indexPath.row;
    
    for (NSDictionary * dic in self.alreadyInviteNumbersArr) {
        ZEUSER_BASE_INFOM * invitedUserinfo = [ZEUSER_BASE_INFOM getDetailWithDic:dic];
        if ([invitedUserinfo.USERCODE isEqualToString:userinfo.USERCODE]) {
            stateBtn.backgroundColor = [UIColor lightGrayColor];
            [stateBtn setTitleColor:kTextColor forState:UIControlStateNormal];
            [stateBtn setTitle:@"已邀请" forState:UIControlStateNormal];
            [stateBtn removeTarget:self action:@selector(inviteNumber:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.5f)];
    [cell.contentView addSubview:lineView];
    lineView.backgroundColor = MAIN_LINE_COLOR;
    
    return cell;
}

-(void)inviteNumber:(UIButton *)btn
{
    btn.enabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitleColor:kTextColor forState:UIControlStateNormal];
    [btn setTitle:@"已邀请" forState:UIControlStateNormal];
    [self.alreadyInviteNumbersArr addObject:self.searchNumbersArr[btn.tag]];
}


#pragma mark - Public Method

-(void)showSearchNumberResult:(NSArray *)dataArr
{
    self.searchNumbersArr = [NSMutableArray array];
    [self.searchNumbersArr addObjectsFromArray:dataArr];
    [contentView reloadData];
}

#pragma mark - delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(goSearch:)]) {
        [self.delegate goSearch:textField.text];
    }
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(goSearch:)]) {
        [self.delegate goSearch:textField.text];
    }
}

-(void)goBackBtnClick
{
    if (self.alreadyInviteNumbersArr.count > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTI_FINISH_INVITE_TEAMCIRCLENUMBERS object:self.alreadyInviteNumbersArr] ;
    }
    if ([self.delegate respondsToSelector:@selector(goBack)]) {
        [self.delegate goBack];
    }
}

@end
