//
//  ZECreateTeamView.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZECreateTeamView.h"
#import "ZEButton.h"
#define textViewStr @"请输入团队宣言（不超过20字）"
#define textViewProfileStr @"请输入团队简介，建议不超过100字！"

#define kItemSizeWidth (SCREEN_WIDTH - 20) / (IPHONE6_MORE ? 6 : 5)
#define kItemSizeHeight (IPHONE6_MORE ? 95 : 80.0f)

@implementation ZECreateTeamManagerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    for (int i = 0; i < 3; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(0 + SCREEN_WIDTH / 3 * i, 0, SCREEN_WIDTH / 3, 100);
        [self addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = 100 + i;
        
        UIView * lineLayer = [UIView new];
        lineLayer.frame = CGRectMake( optionBtn.frame.size.width - 1, 0, 1.0f, 100.0f);
        [optionBtn addSubview:lineLayer];
        lineLayer.backgroundColor = MAIN_LINE_COLOR;
                
        switch (i) {
            case 0:
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_noti"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"团队通知" forState:UIControlStateNormal];
                break;
            case 1:
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_circle_practice"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"练习管理" forState:UIControlStateNormal];
                break;
            case 2:
                [optionBtn setImage:[UIImage imageNamed:@"icon_team_test"] forState:UIControlStateNormal];
                [optionBtn setTitle:@"考试管理" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
    
    UIView * lineLayer = [UIView new];
    lineLayer.frame = CGRectMake( 0, 99.0f, SCREEN_WIDTH, 1.0f);
    [self addSubview:lineLayer];
    lineLayer.backgroundColor = MAIN_LINE_COLOR;
}

-(void)didSelectMyOption:(UIButton *)btn
{
    switch (btn.tag - 100) {
        case 0:
            if ([_createTeamView.delegate respondsToSelector:@selector(goTeamNotiCenter)]) {
                [_createTeamView.delegate goTeamNotiCenter];
            }
            break;
        case 1:
            if ([_createTeamView.delegate respondsToSelector:@selector(goPracticeManager)]) {
                [_createTeamView.delegate goPracticeManager];
            }
            break;
        case 2:
            if ([_createTeamView.delegate respondsToSelector:@selector(goExamManager)]) {
                [_createTeamView.delegate goExamManager];
            }
            break;
        default:
            break;
    }
}

@end

@implementation ZECreateTeamMessageView

-(id)initWithFrame:(CGRect)frame withTeamCircleInfo:(ZETeamCircleModel *)teamCircleM;
{
    self = [super initWithFrame:frame];
    if (self) {
        teamCircleInfo = teamCircleM;
        self.backgroundColor = [UIColor whiteColor];
        [self initTeamMsgView];
        [self initTeamProfileView];
    }
    return self;
}

-(void)initTeamMsgView
{
    _teamHeadImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _teamHeadImgBtn.frame = CGRectMake(10 , 10 , 90, 90);
    [self addSubview:_teamHeadImgBtn];
    [_teamHeadImgBtn setImage:[UIImage imageNamed:@"icon_team_headimage2"] forState:UIControlStateNormal];
    [_teamHeadImgBtn addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    _teamHeadImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    for (int i = 0; i < 3;  i ++) {
        UILabel * caseNameLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 15 + 30 * i, 70, 30)];
        caseNameLab.text = @"团队名称:";
        [caseNameLab setTextColor:kTextColor];
        caseNameLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:caseNameLab];
        
        float marginLeft = 185;
        float marginTop = 15 + 30 * i;
        float maiginWidth = SCREEN_WIDTH - marginLeft - 20;
        
        if (i == 0) {
            _teamNameField = [[UITextField alloc]initWithFrame:CGRectMake(marginLeft + 5, marginTop, maiginWidth, 30)];
            _teamNameField.clipsToBounds = YES;
            _teamNameField.layer.cornerRadius = 5.0f;
//            _teamNameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
//            _teamNameField.leftViewMode = UITextFieldViewModeAlways;
            _teamNameField.placeholder = @"请输入不超过10字";
            _teamNameField.textColor = kTextColor;
            _teamNameField.delegate = self;
            [self addSubview:_teamNameField];
            [_teamNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [_teamNameField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        }else if (i == 1){
            caseNameLab.text = @"团队分类:";
            _teamTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _teamTypeBtn.frame = CGRectMake(marginLeft + 5.0f , marginTop , maiginWidth, 30);
            [_teamTypeBtn  setTitle:@"请选择团队所属专业" forState:UIControlStateNormal];
            [_teamTypeBtn addTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
            [_teamTypeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self addSubview:_teamTypeBtn];
            _teamTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _teamTypeBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        }else if (i == 2){
            caseNameLab.text = @"团队宣言:";
            _manifestoTextView = [[UITextView alloc]initWithFrame:CGRectMake(marginLeft, marginTop, maiginWidth , 40)];
            _manifestoTextView.text = textViewStr;
            _manifestoTextView.font = [UIFont systemFontOfSize:kTiltlFontSize];
            _manifestoTextView.textColor = [UIColor lightGrayColor];
            _manifestoTextView.delegate = self;
            [self addSubview:_manifestoTextView];
        }
    }
}

-(void)initTeamProfileView
{
    UIView * teamProfileView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 105)];
    [self addSubview:teamProfileView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [teamProfileView addSubview:lineView];
    
    UILabel * caseNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
    caseNameLab.text = @"团队简介:";
    [caseNameLab setTextColor:kTextColor];
    caseNameLab.font = [UIFont systemFontOfSize:16];
    [teamProfileView addSubview:caseNameLab];

    _profileTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30 , SCREEN_WIDTH - 20 , 70)];
    _profileTextView.text = textViewProfileStr;
    _profileTextView.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _profileTextView.textColor = [UIColor lightGrayColor];
    _profileTextView.delegate = self;
    [teamProfileView addSubview:_profileTextView];
    
    if ([ZEUtil isNotNull:teamCircleInfo] ) {
        // 不是团长 不允许编辑
        if (![teamCircleInfo.SYSCREATORID isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            [_teamHeadImgBtn removeTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
            _teamNameField.enabled = NO;
            _manifestoTextView.editable = NO;
            _profileTextView.editable = NO;
            [_teamTypeBtn removeTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_teamHeadImgBtn sd_setImageWithURL:ZENITH_IMAGEURL(teamCircleInfo.FILEURL) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_team_headimage2"]];
        
        _teamNameField.text = teamCircleInfo.TEAMCIRCLENAME;
        
        [_teamTypeBtn setTitle:teamCircleInfo.TEAMCIRCLECODENAME forState:UIControlStateNormal];
        [_teamTypeBtn setTitleColor:kTextColor forState:UIControlStateNormal];

        _manifestoTextView.text = teamCircleInfo.TEAMMANIFESTO;
        _manifestoTextView.textColor = kTextColor;

        _profileTextView.text  = teamCircleInfo.TEAMCIRCLEREMARK;
        _profileTextView.textColor = kTextColor;
        
        _TEAMCIRCLECODE = teamCircleInfo.TEAMCIRCLECODE;
        _TEAMCIRCLECODENAME = teamCircleInfo.TEAMCIRCLECODENAME;
    }
}

-(void)allowEdit
{
    [_teamHeadImgBtn addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    _teamNameField.enabled = YES;
    _manifestoTextView.editable = YES;
    _profileTextView.editable = YES;
    [_teamTypeBtn addTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView isEqual:_manifestoTextView] && [_inputManifestoStr isEqualToString:textViewStr]){
        _inputManifestoStr = textView.text;
    }else if([textView isEqual:_profileTextView] && [_inputManifestoStr isEqualToString:textViewProfileStr]){
        _inputProfileStr = textView.text;
    }
    
    if ([textView.text isEqualToString:textViewStr] || [textView.text isEqualToString:textViewProfileStr]) {
        textView.text = @"";
        textView.textColor = kTextColor;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewStr]&& [textView isEqual:_manifestoTextView]) {
        textView.text = textViewStr;
        textView.textColor = [UIColor lightGrayColor];
    }else if ([textView.text isEqualToString:textViewProfileStr] && [textView.text isEqualToString:textViewProfileStr]){
        textView.text = textViewStr;
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    BOOL flag=[ZEUtil isContainsTwoEmoji:textView.text];
    if ([textView isEqual:_manifestoTextView] ) {
        if (flag){
            _manifestoTextView.text = [textView.text substringToIndex:_inputManifestoStr.length];
        }else{
            _inputManifestoStr = _manifestoTextView.text;
        }
    }else if ([textView isEqual:_profileTextView]){
        if (flag){
            _profileTextView.text = [textView.text substringToIndex:_inputProfileStr.length];
        }else{
            _inputProfileStr = _profileTextView.text;
        }
    }

    if (textView.text.length > 20 && [textView isEqual:_manifestoTextView]) {
        textView.text = [textView.text substringToIndex:20];
    }else if (textView.text.length > 100 && [textView isEqual:_profileTextView]){
        textView.text = [textView.text substringToIndex:100];
    }
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_teamNameField]) {
        _teamNameStr = textField.text;
    }
}

-(void)valueChanged:(NSNotification *)noti
{
    UITextField *textField = (UITextField *)noti;

    BOOL flag=[ZEUtil isContainsTwoEmoji:textField.text];
    if (flag) {
        _teamNameField.text = [textField.text substringToIndex:_teamNameStr.length];
    }else{
        _teamNameStr = textField.text;
    }
    
    if (textField.text.length > 10) {
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.detailsLabelText = @"最多显示10个字";
        hud3.detailsLabelFont = [UIFont systemFontOfSize:14];
        [hud3 hide:YES afterDelay:1.0f];

        _teamNameField.text = [textField.text substringToIndex:10];
        _teamNameStr = textField.text;
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self downTheKeyBoard];
}

-(void)downTheKeyBoard
{
    [self endEditing:YES];
}
#pragma mark - Public Method

- (void)reloadTeamHeadImageView:(UIImage *)headImage
{
    [_teamHeadImgBtn setImage:headImage forState:UIControlStateNormal];
}

#pragma mark - 展示提问问题分类列表

-(void)showCamera
{
    [self endEditing:YES];
    if ([_createTeamView.delegate respondsToSelector:@selector(takePhotosOrChoosePictures)]) {
        [_createTeamView.delegate takePhotosOrChoosePictures];
    }
}

-(void)showQuestionTypeView
{
    [self endEditing:YES];
    
    NSArray * typeArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];
    if (typeArr.count > 0) {
        _teamTypeView = [[ZEAskQuestionTypeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _teamTypeView.delegate = self;
        [_createTeamView addSubview:_teamTypeView];

        [_teamTypeView reloadTypeData];
    }else{
        [ZEUtil cacheQuestionType];
    }
}

#pragma mark - 选择问题分类

-(void)didSelectType:(NSString *)typeName typeCode:(NSString *)typeCode fatherCode:(NSString *)fatherCode
{
    [_teamTypeBtn  setTitle:[NSString stringWithFormat:@"%@",typeName] forState:UIControlStateNormal];
    [_teamTypeBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    self.TEAMCIRCLECODE = typeCode;
    self.TEAMCIRCLECODENAME = typeName;
    for (UIView * view in _teamTypeView.subviews) {
        [view removeFromSuperview];
    }
    [_teamTypeView removeFromSuperview];
    _teamTypeView = nil;
}

@end


@implementation ZECreateTeamNumbersView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alreadyInviteNumbersArr = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [self addSubview:lineView];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH - 20, self.frame.size.height - 15) collectionViewLayout:flowLayout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册Cell，必须要有
    [self addSubview:_collectionView];
    
}
#pragma mark  - Public Method
-(void)reloadNumbersView:(NSArray *)numbersArr
           withEnterType:(ENTER_TEAM)type
{
    if (type == ENTER_TEAM_CREATE) {
        self.alreadyInviteNumbersArr = [NSMutableArray arrayWithArray:@[[ZESettingLocalData getUSERINFO]]];
    }else if (type == ENTER_TEAM_DETAIL){
        self.alreadyInviteNumbersArr = [NSMutableArray array];

    }
    _enterTeamType = type;
    [self.alreadyInviteNumbersArr addObjectsFromArray:numbersArr];
    
    [_collectionView reloadData];
    
    for (NSDictionary * dic in self.alreadyInviteNumbersArr) {
        ZEUSER_BASE_INFOM * USERINFO = [ZEUSER_BASE_INFOM getDetailWithDic:dic];
        if ([USERINFO.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]] && [USERINFO.USERTYPE integerValue] == 3 ) {
            [_createTeamView.messageView allowEdit];
        }
    }
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_enterTeamType == ENTER_TEAM_CREATE) {
        return self.alreadyInviteNumbersArr.count + 2 ;
    }
    if (self.alreadyInviteNumbersArr.count > 0) {
        for (NSDictionary * dic in self.alreadyInviteNumbersArr){
            ZEUSER_BASE_INFOM * USERINFO = [ZEUSER_BASE_INFOM getDetailWithDic:dic];

            if ([USERINFO.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]] && ([USERINFO.USERTYPE integerValue] == 4 || [USERINFO.USERTYPE integerValue] == 3 )) {
                return self.alreadyInviteNumbersArr.count + 2;
            }
        }
    }
    return self.alreadyInviteNumbersArr.count ;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for (id view  in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if(indexPath.row < self.alreadyInviteNumbersArr.count){
        ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.alreadyInviteNumbersArr[indexPath.row]];
        
        UIImageView * headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kItemSizeWidth, kItemSizeWidth)];
        [headImage sd_setImageWithURL:ZENITH_IMAGEURL(userinfo.FILEURL) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        [cell.contentView addSubview:headImage];
        headImage.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, kItemSizeWidth, kItemSizeWidth, kItemSizeHeight - kItemSizeWidth)];
        nameLab.text = userinfo.USERNAME;
        [nameLab setTextColor:[UIColor blackColor]];
        nameLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [cell.contentView addSubview:nameLab];
        //    nameLab.backgroundColor = [UIColor cyanColor];
        nameLab.textAlignment = NSTextAlignmentCenter;
        
        if ([userinfo.USERTYPE integerValue]== 2) {
            UILabel * leaderLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
            leaderLab.center = CGPointMake(kItemSizeWidth - 8, kItemSizeWidth -  (IPHONE6_MORE ? 5 : 10));
            leaderLab.text = @"审核中";
            leaderLab.textAlignment = NSTextAlignmentCenter;
            [leaderLab setTextColor:[UIColor whiteColor]];
            leaderLab.backgroundColor = RGBA(255, 100, 100, 1);
            leaderLab.font = [UIFont systemFontOfSize:11];
            [cell.contentView addSubview:leaderLab];
            leaderLab.clipsToBounds = YES;
            leaderLab.layer.cornerRadius = 5;
        }else if ([userinfo.USERTYPE integerValue]== 3) {
            UILabel * leaderLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
            leaderLab.center = CGPointMake(kItemSizeWidth - 8, kItemSizeWidth -  (IPHONE6_MORE ? 5 : 10));
            leaderLab.text = @"管理员";
            leaderLab.textAlignment = NSTextAlignmentCenter;
            [leaderLab setTextColor:[UIColor whiteColor]];
            leaderLab.backgroundColor = RGBA(22, 155, 213, 1);
            leaderLab.font = [UIFont systemFontOfSize:11];
            [cell.contentView addSubview:leaderLab];
            leaderLab.clipsToBounds = YES;
            leaderLab.layer.cornerRadius = 5;
        }

        if (indexPath.row == 0 && [userinfo.USERTYPE integerValue] == 4 &&  self.alreadyInviteNumbersArr.count > 0) {
            UILabel * leaderLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
            leaderLab.center = CGPointMake(kItemSizeWidth - 5, kItemSizeWidth -  (IPHONE6_MORE ? 5 : 10));
            leaderLab.text = @"团长";
            leaderLab.textAlignment = NSTextAlignmentCenter;
            [leaderLab setTextColor:[UIColor whiteColor]];
            leaderLab.backgroundColor = RGBA(22, 155, 213, 1);
            leaderLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
            [cell.contentView addSubview:leaderLab];
            leaderLab.clipsToBounds = YES;
            leaderLab.layer.cornerRadius = 5;
        }
    }
    
    else if (indexPath.row == self.alreadyInviteNumbersArr.count){
        UIImageView * addImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addimg"]];
        addImage.frame = CGRectMake(0,(kItemSizeHeight - kItemSizeWidth) / 2, kItemSizeWidth, kItemSizeWidth);
        [cell.contentView addSubview:addImage];
    }else if (indexPath.row == self.alreadyInviteNumbersArr.count + 1){
        UIImageView * addImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reduceimage"]];
        addImage.frame = CGRectMake(0,(kItemSizeHeight - kItemSizeWidth) / 2, kItemSizeWidth, kItemSizeWidth);
        [cell.contentView addSubview:addImage];
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kItemSizeWidth,kItemSizeHeight);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.alreadyInviteNumbersArr.count + 1){
        if([_createTeamView.delegate respondsToSelector:@selector(goRemoveNumberView)]){
            [_createTeamView.delegate goRemoveNumberView];
        }

    }else if(indexPath.row == self.alreadyInviteNumbersArr.count){
        if([_createTeamView.delegate respondsToSelector:@selector(goQueryNumberView)]){
            [_createTeamView.delegate goQueryNumberView];
        }
    }else{
        if (self.alreadyInviteNumbersArr.count > 0) {
            ZEUSER_BASE_INFOM * leaderUserinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.alreadyInviteNumbersArr[0]];
            ZEUSER_BASE_INFOM * userinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.alreadyInviteNumbersArr[indexPath.row]];
            
            BOOL isleader = NO;
            for (int i = 0; i < self.alreadyInviteNumbersArr.count; i ++) {
                ZEUSER_BASE_INFOM * isLeaderUserinfo = [ZEUSER_BASE_INFOM getDetailWithDic:self.alreadyInviteNumbersArr[i]];
                if ([isLeaderUserinfo.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]] && ( [isLeaderUserinfo.USERTYPE integerValue] == 3 || [isLeaderUserinfo.USERTYPE integerValue] == 4 )) {
                    isleader = YES;
                    break;
                }
            }

            if (isleader && [userinfo.USERTYPE integerValue] == 2) {
                if([_createTeamView.delegate respondsToSelector:@selector(whetherAgreeJoinTeam:)]){
                    [_createTeamView.delegate whetherAgreeJoinTeam:userinfo];
                }
            }else if ([[ZESettingLocalData getUSERCODE] isEqualToString:leaderUserinfo.USERCODE] && [userinfo.USERTYPE integerValue] == 0){
                if([_createTeamView.delegate respondsToSelector:@selector(designatedAdministrator:)]){
                    [_createTeamView.delegate designatedAdministrator:userinfo];
                }
            }else if ([[ZESettingLocalData getUSERCODE] isEqualToString:leaderUserinfo.USERCODE] && [userinfo.USERTYPE integerValue] == 3){
                if([_createTeamView.delegate respondsToSelector:@selector(revokeAdministrator:)]){
                    [_createTeamView.delegate revokeAdministrator:userinfo];
                }
            }
        }
    }
    
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end

@implementation ZECreateTeamView

-(id)initWithFrame:(CGRect)frame withTeamCircleInfo:(ZETeamCircleModel *)teamCircleM
{
    self = [super initWithFrame:frame];
    if (self) {
        teamCircleInfo = teamCircleM;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    [self addSubview:scrollView];
    
    _managerView = [[ZECreateTeamManagerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _managerView.createTeamView = self;
    [scrollView addSubview:_managerView];
    _managerView.backgroundColor = [UIColor cyanColor];
    _managerView.hidden = YES;
    
    _messageView = [[ZECreateTeamMessageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225) withTeamCircleInfo:teamCircleInfo];
    _messageView.createTeamView = self;
    [scrollView addSubview:_messageView];
    
    _numbersView = [[ZECreateTeamNumbersView alloc]initWithFrame:CGRectMake(0, _messageView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT -NAV_HEIGHT - 265)];
    _numbersView.createTeamView = self;
    [scrollView addSubview:_numbersView];
    
    UIView * leaderJuridiction = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAV_HEIGHT - 40, SCREEN_WIDTH, 40)];
    [scrollView addSubview:leaderJuridiction];
    leaderJuridiction.backgroundColor = MAIN_BACKGROUND_COLOR;

    for (int i = 0 ; i < 2; i ++) {
        UIButton * juridictionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        juridictionBtn.frame = CGRectMake(0 + SCREEN_WIDTH / 2 * i, 0 , SCREEN_WIDTH / 2 , 40);
        [leaderJuridiction addSubview:juridictionBtn];
        juridictionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [juridictionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        juridictionBtn.backgroundColor = [UIColor clearColor];
        if(i == 0){
            [juridictionBtn setImage:[UIImage imageNamed:@"icon_team_transfer.png"] forState:UIControlStateNormal];
            [juridictionBtn setTitle:@"转移团队" forState:UIControlStateNormal];
            [juridictionBtn addTarget:self action:@selector(goTransferTeam) forControlEvents:UIControlEventTouchUpInside];

        }else{
            [juridictionBtn setImage:[UIImage imageNamed:@"icon_team_delete.png"] forState:UIControlStateNormal];
            [juridictionBtn setTitle:@"解散团队" forState:UIControlStateNormal];
            [juridictionBtn addTarget:self action:@selector(goDeleteTeam) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView1.backgroundColor = kTextColor;
    [leaderJuridiction addSubview:lineView1];

    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 0.5, 3, .5, 34)];
    lineView.backgroundColor = kTextColor;
    [leaderJuridiction addSubview:lineView];
    
    if([teamCircleInfo.SYSCREATORID isEqualToString:[ZESettingLocalData getUSERCODE]]){
        leaderJuridiction.hidden = NO;
        _managerView.hidden = NO;
        _managerView.top = 0;
        _messageView.top = _managerView.bottom;
        _numbersView.top = _messageView.bottom;
        _numbersView.height =  SCREEN_HEIGHT - NAV_HEIGHT - _messageView.bottom - 40;
        _numbersView.collectionView.height = _numbersView.height - 15;
    }else{
        leaderJuridiction.hidden = YES;
        _numbersView.height =  SCREEN_HEIGHT -NAV_HEIGHT - _messageView.bottom - 20 ;
        _numbersView.collectionView.height = _numbersView.height - 15;
    }
}

-(void)reloadManagertView:(BOOL)isManager
{
    if (isManager) {
        _managerView.hidden = NO;
        _managerView.top = 0;
        _messageView.top = _managerView.bottom;
        _numbersView.top = _messageView.bottom;
        _numbersView.height = SCREEN_HEIGHT - _messageView.bottom -NAV_HEIGHT;
        _numbersView.collectionView.height = _numbersView.height - 15;
    }else{
        _managerView.hidden = YES;
        _messageView.top = 0;
        _numbersView.top = _messageView.bottom;
        _numbersView.height = SCREEN_HEIGHT - _messageView.bottom -NAV_HEIGHT;
        _numbersView.collectionView.height = _numbersView.height - 15;
    }
    
    if([teamCircleInfo.SYSCREATORID isEqualToString:[ZESettingLocalData getUSERCODE]]){
        _numbersView.height =  SCREEN_HEIGHT -NAV_HEIGHT - _messageView.bottom - 40 ;
        _numbersView.collectionView.height = _numbersView.height - 15;
    }else{
        _numbersView.height =  SCREEN_HEIGHT -NAV_HEIGHT - _messageView.bottom ;
        _numbersView.collectionView.height = _numbersView.height - 15;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - ZECreateTeamViewDelegate

-(void)goTransferTeam{
    if ([self.delegate respondsToSelector:@selector(whetherTransferTeam:)]) {
        [self.delegate whetherTransferTeam:nil];
    }
}

-(void)goDeleteTeam
{
    if ([self.delegate respondsToSelector:@selector(whetherDeleteTeam)]) {
        [self.delegate whetherDeleteTeam];
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
