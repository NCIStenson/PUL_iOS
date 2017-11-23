//
//  ZEWorkStandardListCell.m
//  PUL_iOS
//
//  Created by Stenson on 17/4/25.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kWorkStandardCellHeight 60

#import "ZEWorkStandardListCell.h"

@implementation ZEWorkStandardListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
    }
    return self;
}

-(void)initCellViewWithDic:(NSDictionary *)dic
{
    NSString * PHOTOURL = [[dic objectForKey:@"PHOTOURL"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString * STANDARDNAME = [dic objectForKey:@"STANDARDNAME"];
    NSString * CLICKCOUNT = [dic objectForKey:@"CLICKCOUNT"];

    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:5 superView:self.contentView];
    
    UIImageView * contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 70)];
    [self.contentView addSubview:contentImageView];
    if ([ZEUtil isStrNotEmpty:PHOTOURL]) {
        [contentImageView sd_setImageWithURL:ZENITH_IMAGEURL(PHOTOURL) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    }
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(115, contentImageView.top, SCREEN_WIDTH - 180, 40.0f)];
    contentLab.text = STANDARDNAME;
    contentLab.textColor = kTextColor;
    contentLab.numberOfLines = 2;
    contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [self.contentView addSubview:contentLab];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld",(long)[CLICKCOUNT integerValue]];
    
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:10] maxSize:CGSizeMake(200, 20)];
    
    UILabel * commentLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,contentImageView.top + 5,praiseNumWidth,20.0f)];
    commentLab.text  = praiseNumLabText;
    commentLab.font = [UIFont boldSystemFontOfSize:10];
    commentLab.textColor = MAIN_SUBTITLE_COLOR;
    [self.contentView addSubview:commentLab];
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 45.0f, commentLab.top + 1, 20, 15)];
    commentImg.image = [UIImage imageNamed:@"discuss_pv.png"];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:commentImg];
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(contentLab.left, contentLab.bottom + 5, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"answer_tag"];
    [self.contentView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,contentLab.bottom + 5,contentLab.width,contentLab.height - 5)];
    circleLab.text = [dic objectForKey:@"QUESTIONTYPENAME"];
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [self.contentView addSubview:circleLab];
    circleLab.numberOfLines = 0;
    [circleLab sizeToFit];

//    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(115,80,SCREEN_WIDTH - 120,20)];
//    circleLab.text = [NSString stringWithFormat:@"简介：%@",infoModel.CASEEXPLAIN];
//    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
//    circleLab.textColor = MAIN_SUBTITLE_COLOR;
//    [cellView addSubview:circleLab];
//    UIImageView * typeImageView = [UIImageView new];
//    typeImageView.frame = CGRectMake(10, 10, 40, 40);
//    typeImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:typeImageView];
//    if ([[dic objectForKey:@"FILETYPE"] isEqualToString:@".pdf"]) {
//        [typeImageView setImage:[UIImage imageNamed:@"icon_circle_pdf"] ];
//    }else{
//        [typeImageView setImage:[UIImage imageNamed:@"icon_circle_word"] ];
//    }
//
//    UILabel * workStandardName = [UILabel new];
//    workStandardName.frame = CGRectMake(55, 0, SCREEN_WIDTH - 140, 30);
//    [self.contentView addSubview:workStandardName];
//    [workStandardName setText:[dic objectForKey:@"STANDARDEXPLAIN"]];
//    workStandardName.font = [UIFont systemFontOfSize:14];
//    workStandardName.textColor = kTextColor;
//
//
//
//    UIButton * browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    browseBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 80, kWorkStandardCellHeight);
//    browseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [browseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    if ([[dic objectForKey:@"CLICKCOUNT"] integerValue] == 0) {
//        [browseBtn setTitle:@" 0" forState:UIControlStateNormal];
//        browseBtn.width = 30;
//        browseBtn.right = SCREEN_WIDTH - 10;
//    }else{
//        NSString * clickCount = [NSString stringWithFormat:@" %@",[dic objectForKey:@"CLICKCOUNT"]];
//        [browseBtn setTitle:clickCount forState:UIControlStateNormal];
//        float btnWidth = [ZEUtil widthForString:clickCount font:browseBtn.titleLabel.font maxSize:CGSizeMake(100, kWorkStandardCellHeight)];
//        browseBtn.width = btnWidth + 20;
//        browseBtn.right = SCREEN_WIDTH - 10;
//    }
//    [browseBtn setImage:[UIImage imageNamed:@"discuss_pv.png" color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
//    [self.contentView addSubview:browseBtn];
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
