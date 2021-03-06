//
//  ZEPULHomeDynamicCell.m
//  PUL_iOS
//
//  Created by Stenson on 17/8/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kSubTitleColor         [UIColor colorWithHexString:@"#828282"]
#define kTitleColor         [UIColor colorWithHexString:@"#333333"]

#import "ZEPULHomeDynamicCell.h"

@implementation ZEPULHomeDynamicCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return  self;
}

-(void)initUI
{
    self.dynamicImageView = [UIImageView new];
    self.dynamicImageView.frame = CGRectMake(25, 15, 35, 35);
    [self.contentView addSubview:self.dynamicImageView];
    
    self.textLab = [UILabel new];
//    _textLab.text = @"签到";
    _textLab.frame = CGRectMake(_dynamicImageView.right + 20, 15, 100, 15);
    [self.contentView addSubview:_textLab];
    self.textLab.font = [UIFont systemFontOfSize:14];
    self.textLab.textColor = kSubTitleColor;

    self.timeLab = [UILabel new];
//    _timeLab.text = @"10分钟前";
    _timeLab.frame = CGRectMake(self.textLab.left, self.textLab.bottom + 5 , 100, 15);
    [self.contentView addSubview:_timeLab];
    _timeLab.font = [UIFont systemFontOfSize:14];
    _timeLab.textColor = kSubTitleColor;

    self.contentLab = [UILabel new];
//    _contentLab.text = @"每日签到";
    _contentLab.frame = CGRectMake(self.textLab.left, self.timeLab.bottom, SCREEN_WIDTH - self.textLab.left - 20, 35);
    [self.contentView addSubview:_contentLab];
    _contentLab.font = [UIFont systemFontOfSize:18];
    _contentLab.textColor = kTitleColor;
    
    self.subContentLab = [UILabel new];
    _subContentLab.text = @"";
    _subContentLab.frame = CGRectMake(self.textLab.left, self.contentLab.bottom, self.contentLab.width, 17);
    [self.contentView addSubview:_subContentLab];
    _subContentLab.font = [UIFont systemFontOfSize:14];
    _subContentLab.textColor = kSubTitleColor;

    self.tipsLab = [UILabel new];
    _tipsLab.frame = CGRectMake(0, self.subContentLab.bottom + 5, SCREEN_WIDTH, 25);
    [self.contentView addSubview:_tipsLab];
    _tipsLab.text = @"立即查看";
    _tipsLab.backgroundColor = RGBA(244, 248, 251, 1);
    _tipsLab.textColor = kSubTitleColor;
    _tipsLab.textAlignment = NSTextAlignmentCenter;
    _tipsLab.font = [UIFont systemFontOfSize:14];
    
    _optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optionBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    _optionBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 40, 40);
    _optionBtn.backgroundColor = [UIColor clearColor];
//    optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [_optionBtn addTarget:self action:@selector(didSelectOptionBtn:) forControlEvents:UIControlEventTouchUpInside];
//    optionBtn.backgroundColor = MAIN_ARM_ COLOR;
    [_optionBtn setImage:[UIImage imageNamed:@"home_dynamic_more" color:kTextColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_optionBtn];
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:130 width:SCREEN_WIDTH height:5 superView:self.contentView];
}

-(void)reloadCellView:(ZEPULHomeModel *)model;
{
    [_dynamicImageView sd_setImageWithURL:ZENITH_IMAGEURL(model.FILEURL) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    _textLab.text = model.MES_NAME;

    if ([model.MES_TYPE integerValue] == 4) {
//        _textLab.text = @"签到";
        _timeLab.text = [ZEUtil compareCurrentTime:model.SYSCREATEDATE];
        _contentLab.text = @"每日签到，奖励多多";
        _contentLab.height = 45;
        _subContentLab.hidden = YES;
        _tipsLab.text = model.EXTRASPARAM;
    }else if ([model.MES_TYPE integerValue] == 2){
//        _textLab.text = @"团队";
        _timeLab.text = [ZEUtil compareCurrentTime:model.SYSCREATEDATE];
        _subContentLab.text = model.MSG_TITLE;
        _contentLab.text = model.MSG_CONTENT;
        _tipsLab.text = @"立即查看";
    }else if ([model.MES_TYPE integerValue] == 1){
//        _textLab.text = @"问答";
        _timeLab.text = [ZEUtil compareCurrentTime:model.SYSCREATEDATE];
        _subContentLab.text = model.MSG_TITLE;
        _contentLab.text = model.MSG_CONTENT;
        _tipsLab.text = model.EXTRASPARAM;
    }else if ([model.MES_TYPE integerValue] == 5){
//        _textLab.text = @"在线考试";
        _timeLab.text = [ZEUtil compareCurrentTime:model.SYSCREATEDATE];
        _contentLab.text = model.MSG_TITLE;
        _contentLab.height = 50;
        _contentLab.numberOfLines = 0;
//        _subContentLab.text = model.MSG_CONTENT;
        _tipsLab.text = model.EXTRASPARAM;
    }else if ([model.MES_TYPE integerValue] == 3){
//        _textLab.text = @"能力学堂";
        _timeLab.text = [ZEUtil compareCurrentTime:model.SYSCREATEDATE];
        _contentLab.text = model.MSG_TITLE;
        _contentLab.height = 50;
        _contentLab.numberOfLines = 0;
//        _subContentLab.text = model.MSG_CONTENT;
        _tipsLab.text = model.EXTRASPARAM;
    }else if ([model.MES_TYPE integerValue] == 8){
//        _textLab.text = @"学习课件";
        _timeLab.text = [ZEUtil compareCurrentTime:model.SYSCREATEDATE];
        _subContentLab.text = model.MSG_TITLE;
        _contentLab.text = model.MSG_CONTENT;
        _tipsLab.text = model.EXTRASPARAM;
    }else if ([model.MES_TYPE integerValue] == 9){
//        _textLab.text = @"技能列表";
        _timeLab.text = [ZEUtil compareCurrentTime:model.SYSCREATEDATE];
        _contentLab.text = model.MSG_TITLE;
        _contentLab.height = 50;
        _contentLab.numberOfLines = 0;
        // _subContentLab.text = model.MSG_CONTENT;
        _tipsLab.text = model.EXTRASPARAM;
    }else{
//        _textLab.text = @"能力学堂";
        _timeLab.text = [ZEUtil compareCurrentTime:model.SYSCREATEDATE];
        _contentLab.text = model.MSG_TITLE;
        _contentLab.height = 50;
        _contentLab.numberOfLines = 0;
        //        _subContentLab.text = model.MSG_CONTENT;
        _tipsLab.text = model.EXTRASPARAM;
    }
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
