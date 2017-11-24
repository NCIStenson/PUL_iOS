//
//  ZEExpertDetailVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/3/29.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEExpertDetailVC.h"
#import "ZEButton.h"
#import "ZEExpertChatVC.h"
#import "ZEShowQuestionVC.h"
#import "ZEExpertChatListVC.h"

@interface ZEExpertDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZEExpertDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"专家信息";
    [self initView];
}

-(void)initView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    for (int i = 0; i < 2; i ++) {
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        optionBtn.frame = CGRectMake(0 + SCREEN_WIDTH / 2 * i, SCREEN_HEIGHT - 40, SCREEN_WIDTH / 2, 40);
        [self.view addSubview:optionBtn];
        optionBtn.backgroundColor = MAIN_NAV_COLOR;
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = 100 + i;
        
        switch (i) {
            case 0:
                [optionBtn setTitle:@"专家历史解答" forState:UIControlStateNormal];
                break;
            case 1:
                [optionBtn setTitle:@"专家在线解答" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
    }
    
    UIView * lineLayer1 = [UIView new];
    lineLayer1.frame = CGRectMake(SCREEN_WIDTH / 2,SCREEN_HEIGHT - 40, 1.0f, 100);
    [self.view addSubview:lineLayer1];
    lineLayer1.backgroundColor = MAIN_LINE_COLOR;
    
}

-(void)didSelectMyOption:(UIButton *)btn
{    
    if (btn.tag == 101) {
        if ([_expertModel.USERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
            NSLog(@"是专家！！！");
            ZEExpertChatListVC * chatListVC = [[ZEExpertChatListVC alloc]init];
            [self.navigationController pushViewController:chatListVC animated:YES];
        }else{
            JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:_expertModel.USERCODE];
            if (conversation == nil) {
                [self showTips:@"获取会话" afterDelay:1.5];
                NSLog(@" ===  %@",_expertModel.USERCODE);
                [JMSGConversation createSingleConversationWithUsername:_expertModel.USERCODE completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if (error) {
                        NSLog(@"创建会话失败");
                        return ;
                    }
                    self.navigationController.navigationBar.hidden = NO;
                    ZEExpertChatVC *conversationVC = [ZEExpertChatVC new];
                    conversationVC.expertModel = _expertModel;
                    conversationVC.conversation = (JMSGConversation *)resultObject;
                    [self.navigationController pushViewController:conversationVC animated:YES];
                    
                }];
            } else {
                self.navigationController.navigationBar.hidden = NO;
                ZEExpertChatVC *conversationVC = [ZEExpertChatVC new];
                conversationVC.conversation = conversation;
                conversationVC.expertModel = _expertModel;
                [self.navigationController pushViewController:conversationVC animated:YES];
            }
        }
    }else if (btn.tag == 100){
        ZEShowQuestionVC * showQuesVC = [[ZEShowQuestionVC alloc]init];
        showQuesVC.showQuestionListType = QUESTION_LIST_EXPERT;
        showQuesVC.expertModel = _expertModel;
        [self.navigationController pushViewController:showQuesVC animated:YES];
    }
}



#pragma mark - UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10.0f;
    }
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * _userMessage = [[UIView alloc]init];
    _userMessage.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    [ZEUtil addGradientLayer:_userMessage];
    
    [ZEUtil addLineLayer:_userMessage];
    
    UIButton *  userHEAD = [UIButton buttonWithType:UIButtonTypeCustom];
    userHEAD.frame =CGRectMake(0, 0, 100, 100);
    userHEAD.center = CGPointMake(SCREEN_WIDTH / 2, 70.0f);
    [userHEAD sd_setImageWithURL:ZENITH_IMAGEURL(_expertModel.FILEURL) forState:UIControlStateNormal placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    [_userMessage addSubview:userHEAD];
    _userMessage.contentMode = UIViewContentModeScaleAspectFit;
    userHEAD.clipsToBounds = YES;
    userHEAD.layer.cornerRadius = userHEAD.frame.size.height / 2;
    userHEAD.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.5] CGColor];
    userHEAD.layer.borderWidth = 5;
    
    NSString * username = [ZESettingLocalData getNICKNAME];
    username = _expertModel.USERNAME;
    float usernameWidth = [ZEUtil widthForString:username font:[UIFont boldSystemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH - 60, 20)];
    
    UILabel* usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - usernameWidth ) / 2, 60, usernameWidth, 20.0f)];
    usernameLabel.text = username;
    usernameLabel.font = [UIFont boldSystemFontOfSize:18];
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.top = userHEAD.bottom + 10;
    [_userMessage addSubview:usernameLabel];
    
    float praiseNumWidth = [ZEUtil widthForString:[NSString stringWithFormat:@"%.1f",[_expertModel.SCORE floatValue]] font:[UIFont boldSystemFontOfSize:kTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(usernameLabel.right + 35.0f, usernameLabel.top + 3 , 15, 15)];
    commentImg.image = [UIImage imageNamed:@"icon_expert_star.png"];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    [_userMessage addSubview:commentImg];
    
    UILabel * commentLab = [[UILabel alloc]initWithFrame:CGRectMake(commentImg.right + 5,commentImg.top ,praiseNumWidth,15.0f)];
    commentLab.text  = [NSString stringWithFormat:@"%.1f",[_expertModel.SCORE floatValue]];
    commentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    commentLab.textColor = RGBA(226, 138, 55, 1);
    [_userMessage addSubview:commentLab];

    UILabel *pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH - 40, 20.0f)];
    pointLabel.text = _expertModel.GRADENAME;
    pointLabel.font = [UIFont systemFontOfSize:14];
    pointLabel.textColor = [UIColor whiteColor];
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.top = usernameLabel.bottom + 10;
    [_userMessage addSubview:pointLabel];
    [pointLabel sizeToFit];
    pointLabel.centerX = SCREEN_WIDTH / 2;
    
    if (![_expertModel.ISONLINE boolValue]) {
        UILabel * isOnlineLab = [UILabel new];
        isOnlineLab.frame = CGRectMake(0, 0, 100, 20);
        isOnlineLab.text = @"[离线请留言]";
        isOnlineLab.textColor = MAIN_DEEPLINE_COLOR;
        isOnlineLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [_userMessage addSubview:isOnlineLab];
        [isOnlineLab sizeToFit];

        isOnlineLab.center = CGPointMake(pointLabel.right + isOnlineLab.width / 2 + 5, pointLabel.centerY);
        
        userHEAD.enabled = NO;
    }
    
    
    return _userMessage;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellID];
    }
    
    while (cell.contentView.subviews.lastObject) {
        UIView * lastView = cell.contentView.subviews.lastObject;
        [lastView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initCellView:cell.contentView withIndexpath:indexPath];
    
    return cell;
}

-(void)initCellView:(UIView *)cellView withIndexpath:(NSIndexPath *)indexpath{
    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:1 superView:cellView];
    
    UILabel * _contentLab = [UILabel new];
    _contentLab.frame = CGRectMake(20, 10, SCREEN_WIDTH - 40, 20);
    [cellView addSubview:_contentLab];
    _contentLab.font = [UIFont systemFontOfSize:16];
    _contentLab.textColor = kTextColor;
    
    UILabel * _subContentLab = [UILabel new];
    _subContentLab.text = _expertModel.GOODFIELD;
    _subContentLab.numberOfLines = 0;
    _subContentLab.frame = CGRectMake(_contentLab.left, _contentLab.bottom + 5, _contentLab.width, 20);
    [cellView addSubview:_subContentLab];
    _subContentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    _subContentLab.textColor = kSubTitleColor;
    
    switch (indexpath.row) {
        case 0:{
            _contentLab.text = @"擅长领域";
            _subContentLab.text = _expertModel.GOODFIELD;
            float goodFiledHeight =  [ZEUtil heightForString:_expertModel.GOODFIELD font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
            _subContentLab.height = goodFiledHeight;
        }
            break;
        case 1:{
            _contentLab.text = @"所属专业";
            _subContentLab.text =_expertModel.PROFESSIONAL;
            float goodFiledHeight =  [ZEUtil heightForString:_expertModel.PROFESSIONAL font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
            _subContentLab.height = goodFiledHeight;
        }
            break;
        case 2:{
            _contentLab.text = @"描述";
            _subContentLab.text = _expertModel.DESCRIBE;
            float goodFiledHeight =  [ZEUtil heightForString:_expertModel.DESCRIBE font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
            _subContentLab.height = goodFiledHeight;
        }
            break;
            
            
        default:
            break;
    }
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            float goodFiledHeight =  [ZEUtil heightForString:_expertModel.GOODFIELD font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
            
            return goodFiledHeight + 45;
        }
            break;
        case 1:
        {
            float goodFiledHeight =  [ZEUtil heightForString:_expertModel.PROFESSIONAL font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
            
            return goodFiledHeight + 45;
        }            break;
        case 2:
        {
            float goodFiledHeight =  [ZEUtil heightForString:_expertModel.DESCRIBE font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
            
            return goodFiledHeight + 45;
        }            break;
            
        default:
            break;
    }
    return 0;
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
