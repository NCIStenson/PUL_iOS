//
//  ZEUserCenterView.m
//  NewCentury
//
//  Created by Stenson on 16/4/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#define kUserTableMarginLeft    0.0f
#define kUserTableMarginTop     0.0f
#define kUserTableWidth   SCREEN_WIDTH
#define kUserTableHeight  SCREEN_HEIGHT - 49.0f

#import "UIImageView+WebCache.h"
#import "ZEUserCenterView.h"
#import "ZEButton.h"

@interface ZEUserCenterView ()
{
    UITableView * userCenterTable;
    UIButton * userHEAD;
    
    UILabel * pointLabel;
    UILabel * levelLab;
    UILabel * usernameLabel;
}

@end

@implementation ZEUserCenterView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserCenterView];
    }
    return self;
}

-(void)initUserCenterView
{
    userCenterTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    userCenterTable.delegate = self;
    userCenterTable.dataSource = self;
    userCenterTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:userCenterTable];
    userCenterTable.showsVerticalScrollIndicator = NO;
    [userCenterTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kUserTableMarginLeft);
        make.top.mas_equalTo(kUserTableMarginLeft);
        make.size.mas_equalTo(CGSizeMake(kUserTableWidth, kUserTableHeight));
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSuccess) name:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTI_CHANGEPERSONALMSG_SUCCESS object:nil];
}

-(void)changeSuccess
{
    [userCenterTable reloadData];
}

-(void)reloadHeaderB
{
    [userHEAD sd_setImageWithURL:ZENITH_IMAGEURL([ZESettingLocalData getUSERHHEADURL]) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
}

-(void)setPointNum:(NSString *)pointNum
{
    _pointNum = pointNum;
    pointLabel.text = [NSString stringWithFormat:@"%@积分",pointNum];
}

-(void)setLevelTitle:(NSString *)levelTitle
{
    _levelTitle = levelTitle;
    levelLab.text = _levelTitle;
    levelLab.width = [ZEUtil widthForString:_levelTitle font:levelLab.font maxSize:CGSizeMake(100, 20)];
    levelLab.left = usernameLabel.right + 10;

}

#pragma mark - 新消息提醒图标

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [self initCellContentViewWithIndexPath:indexPath withCell:cell];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)initCellContentViewWithIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    [cell.contentView addSubview:logoImageView];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.0f, 0.0f, SCREEN_WIDTH - 80.0f, 60.0f)];
    [cell.contentView addSubview:contentLabel];
    contentLabel.userInteractionEnabled = YES;
    contentLabel.textColor = kTextColor;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(45, 59.5f, SCREEN_WIDTH - 45.0f, 0.5f);
    [cell.contentView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    if (indexPath.row == 0) {
        logoImageView.image = [UIImage imageNamed:@"icon_setting_personal data" ];
        contentLabel.text = @"个人资料";
    }else if (indexPath.row == 1) {
        logoImageView.image = [UIImage imageNamed:@"icon_setting_question" ];
        contentLabel.text = @"我的提问";
    }else if(indexPath.row == 2){
        logoImageView.image = [UIImage imageNamed:@"icon_setting_answer" ];
        contentLabel.text = @"我的回答";
    }else if (indexPath.row == 3){
        logoImageView.image = [UIImage imageNamed:@"icon_setting_resume" ];
        contentLabel.text = @"我的履历";
    }else if (indexPath.row == 4){
        logoImageView.image = [UIImage imageNamed:@"icon_setting_Train" ];
        contentLabel.text = @"我的培训";
    }else if (indexPath.row == 5){
        logoImageView.image = [UIImage imageNamed:@"icon_setting_integration" ];
        contentLabel.text = @"我的发展积分";
    }else if (indexPath.row == 6){
        logoImageView.image = [UIImage imageNamed:@"icon_setting_honor" ];
        contentLabel.text = @"我的获奖及荣誉";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10.0f;
    }
    return 240;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH + 2, 20)];
    grayView.backgroundColor = MAIN_LINE_COLOR ;
    if (section == 1) {
        return grayView;
    }
    
    _userMessage = [[UIView alloc]init];
    _userMessage.frame = CGRectMake(0, 0, SCREEN_WIDTH, 240);
    [ZEUtil addGradientLayer:_userMessage];

    [ZEUtil addLineLayer:_userMessage];
    
    userHEAD = [UIButton buttonWithType:UIButtonTypeCustom];
    userHEAD.frame =CGRectMake(0, 0, 100, 100);
    userHEAD.center = CGPointMake(SCREEN_WIDTH / 2, 110.0f);
    [userHEAD sd_setImageWithURL:ZENITH_IMAGEURL([ZESettingLocalData getUSERHHEADURL]) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [_userMessage addSubview:userHEAD];
    [userHEAD addTarget:self action:@selector(goChooseImage) forControlEvents:UIControlEventTouchUpInside];
    _userMessage.contentMode = UIViewContentModeScaleAspectFit;
    userHEAD.clipsToBounds = YES;
    userHEAD.layer.cornerRadius = userHEAD.frame.size.height / 2;
    userHEAD.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.2] CGColor];
    userHEAD.layer.borderWidth = 8;
    
    NSString * username = [ZESettingLocalData getNICKNAME];
    if (![ZEUtil isStrNotEmpty:username]) {
        username = [ZESettingLocalData getNAME];
    }
    float usernameWidth = [ZEUtil widthForString:username font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH - 60, 20)];
    
    usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - usernameWidth ) / 2, 60, usernameWidth, 20.0f)];
    usernameLabel.text = username;
    usernameLabel.font = [UIFont boldSystemFontOfSize:18];
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.top = userHEAD.bottom + 10;
    [_userMessage addSubview:usernameLabel];
    
    levelLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - usernameWidth ) / 2, 60, usernameWidth, 20.0f)];
    levelLab.text = @"";
    levelLab.font = [UIFont systemFontOfSize:12];
    levelLab.textColor = [UIColor orangeColor];
    levelLab.textAlignment = NSTextAlignmentCenter;
    [_userMessage addSubview:levelLab];
    levelLab.top = usernameLabel.top;

    pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH - 40, 20.0f)];
    pointLabel.text = @"";
    pointLabel.font = [UIFont systemFontOfSize:14];
    pointLabel.textColor = [UIColor whiteColor];
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.top = usernameLabel.bottom + 10;
    [_userMessage addSubview:pointLabel];

    UIImageView * sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    sexImage.center = CGPointMake(usernameLabel.center.x + usernameWidth / 2 + 10.0f, usernameLabel.center.y );
    sexImage.image = [UIImage imageNamed:@"boy"];
    [_userMessage addSubview:sexImage];
    
    UIButton * signinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signinBtn.frame = CGRectMake(SCREEN_WIDTH - 50 , 27.0f , 40, 40);
    [_userMessage addSubview:signinBtn];
    [signinBtn setImage:[UIImage imageNamed:@"icon_signin" color:[UIColor whiteColor]] forState:UIControlStateNormal];
    signinBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [signinBtn addTarget:self action:@selector(goSinginVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(15, 27, 40,40);
    [_userMessage addSubview:setBtn];
    [setBtn setImage:[UIImage imageNamed:@"icon_setting_up" color:[UIColor whiteColor]] forState:UIControlStateNormal];
    setBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [setBtn addTarget:self action:@selector(goSettingVC) forControlEvents:UIControlEventTouchUpInside];

    return _userMessage;
}

-(void)didSelectMyOption:(UIButton *)btn
{
    switch (btn.tag - 100) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(goMyQuestionList)]) {
                [self.delegate goMyQuestionList];
            }
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(goMyAnswerList)]) {
                [self.delegate goMyAnswerList];
            }
            break;
        case 2:
            if ([self.delegate respondsToSelector:@selector(goSchollVC:)]) {
                [self.delegate goSchollVC:ENTER_WEBVC_MY_PRACTICE];
            }
            break;
        case 3:
            if ([self.delegate respondsToSelector:@selector(goMyCollect)]) {
                [self.delegate goMyCollect];
            }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if ([self.delegate respondsToSelector:@selector(goSettingVC:)]) {
                [self.delegate goSettingVC:ENTER_SETTING_TYPE_SETTING];
            }
        }
            break;
            
        case 1:
        {
            if ([self.delegate respondsToSelector:@selector(goMyQuestionList)]) {
                [self.delegate goMyQuestionList];
            }
        }
            break;
        case 2:
        {
            if ([self.delegate respondsToSelector:@selector(goMyAnswerList)]) {
                [self.delegate goMyAnswerList];
            }
        }
            break;
        case 3:
        {
            if ([self.delegate respondsToSelector:@selector(goWebVCWithType:)]) {
                [self.delegate goWebVCWithType:ENTER_QUESTIONBANK_TYPE_MYRECORD];
            }
        }
            break;
        case 4:
        {
            if ([self.delegate respondsToSelector:@selector(goWebVCWithType:)]) {
                [self.delegate goWebVCWithType:ENTER_QUESTIONBANK_TYPE_MYTRAIN];
            }
        }
            break;

        case 5:
        {
            if ([self.delegate respondsToSelector:@selector(goWebVCWithType:)]) {
                [self.delegate goWebVCWithType:ENTER_QUESTIONBANK_TYPE_DEVPOINT];
            }
        }
            break;

        case 6:
        {
            if ([self.delegate respondsToSelector:@selector(goWebVCWithType:)]) {
                [self.delegate goWebVCWithType:ENTER_QUESTIONBANK_TYPE_MYAWARDS];
            }
        }
            break;

            
        default:
            break;
    }
}


-(void)goSinginVC
{
    if ([self.delegate respondsToSelector:@selector(goSinginVC)]) {
        [self.delegate goSinginVC];
    }
}

-(void)goNotiVC
{
    if ([self.delegate respondsToSelector:@selector(goNotiVC)]) {
        [self.delegate goNotiVC];
    }
}

-(void)goPersonalVC
{
    if ([self.delegate respondsToSelector:@selector(goSettingVC:)]) {
        [self.delegate goSettingVC:ENTER_SETTING_TYPE_PERSONAL];
    }
}

-(void)goSettingVC
{
    if ([self.delegate respondsToSelector:@selector(goSettingVC:)]) {
        [self.delegate goSettingVC:ENTER_SETTING_TYPE_SETTING];
    }
}

-(void)goChooseImage{
    if ([self.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
        [self.delegate takePhotosOrChoosePictures];
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
