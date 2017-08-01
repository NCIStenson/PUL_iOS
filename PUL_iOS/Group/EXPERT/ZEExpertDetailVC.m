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

@interface ZEExpertDetailVC ()

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
    UIImageView * expertPhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, NAV_HEIGHT + 20, SCREEN_WIDTH *.4, SCREEN_WIDTH * .4 * 1.4)];
    [self.view addSubview:expertPhotoImageView];
    [expertPhotoImageView sd_setImageWithURL:ZENITH_IMAGEURL(_expertModel.FILEURL) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    expertPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    expertPhotoImageView.clipsToBounds = YES;
    
    UILabel * expertIntroduce = [[UILabel alloc]initWithFrame:CGRectMake(expertPhotoImageView.right + 10, expertPhotoImageView.top, SCREEN_WIDTH - expertPhotoImageView.width - 30, expertPhotoImageView.height + 60)];
    expertIntroduce.text = _expertModel.DESCRIBE;
    expertIntroduce.numberOfLines = 0;
    expertIntroduce.textColor = kTextColor;
    [self.view addSubview:expertIntroduce];
    expertIntroduce.adjustsFontSizeToFitWidth = YES;
    
    // 专家名字
    UILabel * expertName = [[UILabel alloc]initWithFrame:CGRectMake(expertPhotoImageView.left, expertPhotoImageView.bottom + 20, expertPhotoImageView.width, 40)];
    expertName.text = _expertModel.USERNAME;
    expertName.textAlignment = NSTextAlignmentCenter;
    expertName.numberOfLines = 0;
    expertName.textColor = kTextColor;
    [self.view addSubview:expertName];
    
    // 所属专业
    UILabel * expertSpec = [[UILabel alloc]initWithFrame:CGRectMake(expertPhotoImageView.left, expertName.bottom + 20, SCREEN_WIDTH -  expertPhotoImageView.left * 2, 40)];
    if([ZEUtil isStrNotEmpty:_expertModel.PROFESSIONAL]){
        expertSpec.text = [NSString stringWithFormat:@"所属专业：%@",_expertModel.PROFESSIONAL];
    }
    expertSpec.numberOfLines = 0;
    expertSpec.textColor = kTextColor;
    [self.view addSubview:expertSpec];
    expertSpec.adjustsFontSizeToFitWidth = YES;
    
    UILabel * expertGoodField = [[UILabel alloc]initWithFrame:CGRectMake(expertSpec.left, expertSpec.bottom + 10, SCREEN_WIDTH -  expertSpec.left * 2, 40)];
    if([ZEUtil isStrNotEmpty:_expertModel.GOODFIELD]){
        expertGoodField.text = [NSString stringWithFormat:@"擅长领域：%@",_expertModel.GOODFIELD];
    }
    expertGoodField.numberOfLines = 0;
    expertGoodField.textColor = kTextColor;
    [self.view addSubview:expertGoodField];
    expertGoodField.adjustsFontSizeToFitWidth = YES;
    
    
    for (int i = 0; i < 2; i ++) {
        ZEButton * optionBtn = [ZEButton buttonWithType:UIButtonTypeCustom];
        [optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        optionBtn.frame = CGRectMake(0 + SCREEN_WIDTH / 2 * i, SCREEN_HEIGHT - 100, SCREEN_WIDTH / 2, 100);
        [self.view addSubview:optionBtn];
        optionBtn.backgroundColor = [UIColor whiteColor];
        optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
        [optionBtn addTarget:self action:@selector(didSelectMyOption:) forControlEvents:UIControlEventTouchUpInside];
        optionBtn.tag = 100 + i;
        
        switch (i) {
            case 0:
                [optionBtn setImage:[UIImage imageNamed:@"icon_expert_history" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
                [optionBtn setTitle:@"专家历史解答" forState:UIControlStateNormal];
                break;
            case 1:
                [optionBtn setImage:[UIImage imageNamed:@"icon_expert_chat" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
                [optionBtn setTitle:@"专家在线解答" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
    }
    UIView * lineLayer = [UIView new];
    lineLayer.frame = CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 1.0f);
    [self.view addSubview:lineLayer];
    lineLayer.backgroundColor = MAIN_LINE_COLOR;
    
    UIView * lineLayer1 = [UIView new];
    lineLayer1.frame = CGRectMake(SCREEN_WIDTH / 2,SCREEN_HEIGHT - 100, 1.0f, 100);
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
                
                [JMSGConversation createSingleConversationWithUsername:_expertModel.USERCODE completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if (error) {
                        NSLog(@"创建会话失败");
                        return ;
                    }
                    ZEExpertChatVC *conversationVC = [ZEExpertChatVC new];
                    conversationVC.expertModel = _expertModel;
                    conversationVC.conversation = (JMSGConversation *)resultObject;
                    [self.navigationController pushViewController:conversationVC animated:YES];
                    
                }];
            } else {
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
