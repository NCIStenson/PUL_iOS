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
    UIImageView * typeImageView = [UIImageView new];
    typeImageView.frame = CGRectMake(10, 10, 40, 40);
    typeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:typeImageView];
    if ([[dic objectForKey:@"FILETYPE"] isEqualToString:@".pdf"]) {
        [typeImageView setImage:[UIImage imageNamed:@"icon_circle_pdf"] ];
    }else{
        [typeImageView setImage:[UIImage imageNamed:@"icon_circle_word"] ];
    }
    
    UILabel * workStandardName = [UILabel new];
    workStandardName.frame = CGRectMake(55, 0, SCREEN_WIDTH - 140, 30);
    [self.contentView addSubview:workStandardName];
    [workStandardName setText:[dic objectForKey:@"STANDARDEXPLAIN"]];
    workStandardName.font = [UIFont systemFontOfSize:14];
    workStandardName.textColor = kTextColor;
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(workStandardName.left, workStandardName.bottom, 15, 15)];
    circleImg.image = [UIImage imageNamed:@"answer_tag"];
    [self.contentView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,workStandardName.bottom,workStandardName.width,workStandardName.height)];
    circleLab.text = [dic objectForKey:@"QUESTIONTYPENAME"];
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [self.contentView addSubview:circleLab];
    circleLab.numberOfLines = 0;
    [circleLab sizeToFit];
    
    
    UIButton * browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    browseBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 80, kWorkStandardCellHeight);
    browseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [browseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if ([[dic objectForKey:@"CLICKCOUNT"] integerValue] == 0) {
        [browseBtn setTitle:@" 0" forState:UIControlStateNormal];
        browseBtn.width = 30;
        browseBtn.right = SCREEN_WIDTH - 10;
    }else{
        NSString * clickCount = [NSString stringWithFormat:@" %@",[dic objectForKey:@"CLICKCOUNT"]];
        [browseBtn setTitle:clickCount forState:UIControlStateNormal];
        float btnWidth = [ZEUtil widthForString:clickCount font:browseBtn.titleLabel.font maxSize:CGSizeMake(100, kWorkStandardCellHeight)];
        browseBtn.width = btnWidth + 20;
        browseBtn.right = SCREEN_WIDTH - 10;
    }
    [browseBtn setImage:[UIImage imageNamed:@"discuss_pv.png" color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [self.contentView addSubview:browseBtn];
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
