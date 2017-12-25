//
//  ZEDistrictManagerCell.m
//  PUL_iOS
//
//  Created by Stenson on 2017/12/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEDistrictManagerCell.h"
#import "ZEDistrictManagerModel.h"
@implementation ZEDistrictManagerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
}

-(void)initUIWithDic:(NSDictionary *)dic
{
    ZEDistrictManagerModel * managerModel  = [ZEDistrictManagerModel getDetailWithDic:dic];
    
    UIImageView * contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
    [self.contentView addSubview:contentImageView];
    [contentImageView setImage:[UIImage imageNamed:@"icon_circle_word.png"]];
    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    if([managerModel.FILETYPE isEqualToString:@".doc"] || [managerModel.FILETYPE isEqualToString:@".docx"]){
        [contentImageView setImage:[UIImage imageNamed:@"icon_circle_word.png"]];
    }else if ([managerModel.FILETYPE isEqualToString:@".pdf"] ){
        [contentImageView setImage:[UIImage imageNamed:@"icon_circle_pdf.png"]];
    }else if ([managerModel.FILETYPE isEqualToString:@".mp4"] ){
        [contentImageView setImage:[UIImage imageNamed:@"icon_manager_mp4"]];
    }
    
    if ([managerModel.ISCOLLECT boolValue]) {
        UIImageView * collectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 10, 15, 15)];
        [self.contentView addSubview:collectImageView];
        [collectImageView setImage:[UIImage imageNamed:@"icon_manager_collect.png"]];
        collectImageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(contentImageView.right + 10, 10, SCREEN_WIDTH - 120, 20.0f)];
    contentLab.text = managerModel.COURSENAME;
    contentLab.textColor = kTextColor;
    contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [self.contentView addSubview:contentLab];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(contentLab.left,contentLab.bottom + 15,contentLab.width,contentLab.height - 5)];
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    circleLab.text = managerModel.TYPENAME;
    [self.contentView addSubview:circleLab];
//    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    if (managerModel.TYPENAME.length > 0) {
//        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:managerModel.TYPENAME attributes:attribtDic];
//        circleLab.attributedText = attribtStr;
//    }
    [circleLab sizeToFit];
    
    NSString * commentLabText =[NSString stringWithFormat:@"%ld",(long)[managerModel.COMMENTCOUNT integerValue]];
    float commentWidth = [ZEUtil widthForString:commentLabText font:[UIFont boldSystemFontOfSize:10] maxSize:CGSizeMake(200, 20)];
    
    UILabel * commentLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - commentWidth - 20,circleLab.top,commentWidth,20.0f)];
    commentLab.text  = commentLabText;
    commentLab.font = [UIFont boldSystemFontOfSize:10];
    commentLab.textColor = MAIN_SUBTITLE_COLOR;
    [self.contentView addSubview:commentLab];
    [commentLab sizeToFit];
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(commentLab.left - 20.0f, circleLab.top + 1, 15, 10)];
    commentImg.image = [UIImage imageNamed:@"icon_comment_count.png"];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:commentImg];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld",(long)[managerModel.CLICKCOUNT integerValue]];
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:10] maxSize:CGSizeMake(200, 20)];
    
    UILabel * praiseLab = [[UILabel alloc]initWithFrame:CGRectMake(commentImg.left - praiseNumWidth - 10,circleLab.top,praiseNumWidth,20.0f)];
    praiseLab.text  = praiseNumLabText;
    praiseLab.font = [UIFont boldSystemFontOfSize:10];
    praiseLab.textColor = MAIN_SUBTITLE_COLOR;
    [self.contentView addSubview:praiseLab];
    [praiseLab sizeToFit];
    
    UIImageView * praiseImg = [[UIImageView alloc]initWithFrame:CGRectMake(praiseLab.left - 20.0f, circleLab.top + 1, 15, 10)];
    praiseImg.image = [UIImage imageNamed:@"discuss_pv.png"];
    praiseImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:praiseImg];
    
    NSString * pageText = [NSString stringWithFormat:@"%@",managerModel.CONTENTLEN];
    float pageWidth = [ZEUtil widthForString:pageText font:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(200, 20)];

    UILabel * pageLab = [[UILabel alloc]initWithFrame: CGRectMake(praiseImg.left - pageWidth - 10, circleLab.top, pageWidth, circleLab.height)];
    pageLab.text = pageText;
    pageLab.font = [UIFont systemFontOfSize:10];
    pageLab.textColor = MAIN_SUBTITLE_COLOR;
    [self.contentView addSubview:pageLab];
    [pageLab sizeToFit];
    
    self.lineLayer = [UIView new];
    _lineLayer.frame = CGRectMake(20, 69, SCREEN_WIDTH - 40 , 1);
    _lineLayer.backgroundColor = MAIN_LINE_COLOR;
    [self.contentView addSubview:_lineLayer];

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
