//
//  ZEQuestionBasicCell.m
//  PUL_iOS
//
//  Created by Stenson on 17/7/6.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kQuestionTitleFontSize      kTiltlFontSize
#define kQuestionSubTitleFontSize   kSubTiltlFontSize

#import "ZEQuestionBasicCell.h"

@implementation ZEQuestionBasicCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

-(void)reloadCellView:(NSDictionary *)dataDic
{
    ZEQuestionInfoModel * quesInfoM = [ZEQuestionInfoModel getDetailWithDic:dataDic];
        
    NSString * QUESTIONEXPLAINStr = quesInfoM.QUESTIONEXPLAIN;
    
    if ([quesInfoM.BONUSPOINTS integerValue] > 0) {
        if (quesInfoM.BONUSPOINTS.length == 1) {
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"          %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 2){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"            %@",QUESTIONEXPLAINStr];
        }else if (quesInfoM.BONUSPOINTS.length == 3){
            QUESTIONEXPLAINStr = [NSString stringWithFormat:@"              %@",QUESTIONEXPLAINStr];
        }
        
        UIImageView * bonusImage = [[UIImageView alloc]init];
        [bonusImage setImage:[UIImage imageNamed:@"high_score_icon.png"]];
        [self.contentView addSubview:bonusImage];
        bonusImage.left = 20.0f;
        bonusImage.top = 8.0f;
        bonusImage.width = 20.0f;
        bonusImage.height = 20.0f;
        
        UILabel * bonusPointLab = [[UILabel alloc]init];
        bonusPointLab.text = quesInfoM.BONUSPOINTS;
        [bonusPointLab setTextColor:MAIN_GREEN_COLOR];
        [self.contentView addSubview:bonusPointLab];
        bonusPointLab.left = 43.0f;
        bonusPointLab.top = bonusImage.top;
        bonusPointLab.width = 27.0f;
        bonusPointLab.font = [UIFont boldSystemFontOfSize:kTiltlFontSize];
        bonusPointLab.height = 20.0f;
    }
    
    float questionHeight =[ZEUtil heightForString:QUESTIONEXPLAINStr font:[UIFont boldSystemFontOfSize:kQuestionTitleFontSize] andWidth:SCREEN_WIDTH - 40];
    
    UILabel * QUESTIONEXPLAIN = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, questionHeight)];
    QUESTIONEXPLAIN.numberOfLines = 0;
    QUESTIONEXPLAIN.text = QUESTIONEXPLAINStr;
    QUESTIONEXPLAIN.font = [UIFont boldSystemFontOfSize:kQuestionTitleFontSize];
    [self.contentView addSubview:QUESTIONEXPLAIN];
    //  问题文字与用户信息之间间隔
    float userY = questionHeight + 20.0f;
    
    NSMutableArray * urlsArr = [NSMutableArray array];
    for (NSString * str in quesInfoM.FILEURLARR) {
        [urlsArr addObject:[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,str]];
    }
    
    if (quesInfoM.FILEURLARR.count > 0) {
        PYPhotosView *linePhotosView = [PYPhotosView photosViewWithThumbnailUrls:urlsArr originalUrls:urlsArr layoutType:PYPhotosViewLayoutTypeLine];
        // 设置Frame
        linePhotosView.py_y = userY;
        linePhotosView.py_x = PYMargin;
        linePhotosView.py_width = SCREEN_WIDTH - 40;
        
        // 3. 添加到指定视图中
        [self.contentView addSubview:linePhotosView];
        
        userY += kCellImgaeHeight + 10.0f;
    }
    
    
    NSArray * typeCodeArr = [quesInfoM.QUESTIONTYPECODE componentsSeparatedByString:@","];
    
    NSString * typeNameContent = @"";
    
    for (NSDictionary * dic in [[ZEQuestionTypeCache instance] getQuestionTypeCaches]) {
        ZEQuestionTypeModel * questionTypeM = nil;
        ZEQuestionTypeModel * typeM = [ZEQuestionTypeModel getDetailWithDic:dic];
        for (int i = 0; i < typeCodeArr.count; i ++) {
            if ([typeM.CODE isEqualToString:typeCodeArr[i]]) {
                questionTypeM = typeM;
                if (![ZEUtil isStrNotEmpty:typeNameContent]) {
                    typeNameContent = questionTypeM.NAME;
                }else{
                    typeNameContent = [NSString stringWithFormat:@"%@,%@",typeNameContent,questionTypeM.NAME];
                }
                break;
            }
        }
    }
    
    //     圈组分类最右边
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, userY, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"answer_tag"];
    [self.contentView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,userY,SCREEN_WIDTH - 70,15.0f)];
    circleLab.text = typeNameContent;
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [self.contentView addSubview:circleLab];
    circleLab.numberOfLines = 0;
    [circleLab sizeToFit];    
    
    
    if (circleLab.height == 0) {
        circleLab.height = 15.0f;
    }
    
    userY += circleLab.height + 5.0f;
    
    UIView * messageLineView = [[UIView alloc]initWithFrame:CGRectMake(0, userY, SCREEN_WIDTH, 0.5)];
    messageLineView.backgroundColor = MAIN_LINE_COLOR;
    [self.contentView addSubview:messageLineView];
    
    userY += 5.0f;
    
    UIImageView * userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, userY, 20, 20)];
    if(!quesInfoM.ISANONYMITY){
        [userImg sd_setImageWithURL:ZENITH_IMAGEURL(quesInfoM.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    }
    [self.contentView addSubview:userImg];
    userImg.clipsToBounds = YES;
    userImg.layer.cornerRadius = 10;
    
    UILabel * QUESTIONUSERNAME = [[UILabel alloc]initWithFrame:CGRectMake(45,userY,100.0f,20.0f)];
    QUESTIONUSERNAME.text = quesInfoM.NICKNAME;
    if(quesInfoM.ISANONYMITY){
        [userImg setImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        QUESTIONUSERNAME.text = @"匿名提问";
    }
    
    [QUESTIONUSERNAME sizeToFit];
    QUESTIONUSERNAME.textColor = MAIN_SUBTITLE_COLOR;
    QUESTIONUSERNAME.font = [UIFont systemFontOfSize:kQuestionTitleFontSize];
    [self.contentView addSubview:QUESTIONUSERNAME];
    
    
    UILabel * SYSCREATEDATE = [[UILabel alloc]initWithFrame:CGRectMake(QUESTIONUSERNAME.frame.origin.x + QUESTIONUSERNAME.frame.size.width + 5.0f,userY,100.0f,20.0f)];
    SYSCREATEDATE.text = [ZEUtil compareCurrentTime:quesInfoM.SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = NO;
    SYSCREATEDATE.textColor = MAIN_SUBTITLE_COLOR;
    SYSCREATEDATE.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:SYSCREATEDATE];
    SYSCREATEDATE.userInteractionEnabled = YES;
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld 回答",(long)[quesInfoM.ANSWERSUM integerValue]];
    
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 70,userY,praiseNumWidth,20.0f)];
    praiseNumLab.text  = praiseNumLabText;
    praiseNumLab.font = [UIFont boldSystemFontOfSize:kSubTiltlFontSize];
    praiseNumLab.textColor = MAIN_SUBTITLE_COLOR;
    [self.contentView addSubview:praiseNumLab];
    
    // 10 回答 | （图标）回答  分割线
    
    UIView * answerLineView = [[UIView alloc]initWithFrame:CGRectMake( praiseNumLab.frame.origin.x + praiseNumLab.frame.size.width + 5.0f , userY, 1.0f, 20.0f)];
    answerLineView.backgroundColor = MAIN_LINE_COLOR;
    [self.contentView addSubview:answerLineView];
    
    
    self.answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _answerBtn.frame = CGRectMake(SCREEN_WIDTH - 60 , userY - 20, 50, 40);
    [_answerBtn setImage:[UIImage imageNamed:@"center_name_logo.png" color:MAIN_NAV_COLOR] forState:UIControlStateNormal];
    [_answerBtn setTitleColor:MAIN_SUBTITLE_COLOR forState:UIControlStateNormal];
    [_answerBtn setTitle:@" 回答" forState:UIControlStateNormal];
    [_answerBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [_answerBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [_answerBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    _answerBtn.titleLabel.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [self.contentView addSubview:_answerBtn];
//    _answerBtn.tag = indexpath.row;
    _answerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, userY + 25.0f, SCREEN_WIDTH, 5.0f)];
    grayView.backgroundColor = MAIN_LINE_COLOR;
    [self.contentView addSubview:grayView];
    
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, userY + 30.0f);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
