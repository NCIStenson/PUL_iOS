//
//  ZEHomeBaseCell.m
//  PUL_iOS
//
//  Created by Stenson on 17/2/22.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEHomeBaseCell.h"

@implementation ZEHomeQuestionUserMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kZEHomeCellUserMsgViewHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _userMessageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
//        [userImg sd_setImageWithURL:ZENITH_IMAGEURL(quesInfoM.HEADIMAGE) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        [self addSubview:_userMessageImageView];
        _userMessageImageView.clipsToBounds = YES;
        _userMessageImageView.layer.cornerRadius = 10;
        
        _userNickName = [[UILabel alloc]initWithFrame:CGRectMake(45,0,100.0f,20.0f)];
//        QUESTIONUSERNAME.text = quesInfoM.NICKNAME;
        
//        if(quesInfoM.ISANONYMITY){
//            [userImg setImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
//            QUESTIONUSERNAME.text = @"匿名提问";
//        }
        _userNickName.backgroundColor = [UIColor redColor];
        [_userNickName sizeToFit];
        _userNickName.textColor = MAIN_SUBTITLE_COLOR;
        _userNickName.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [self addSubview:_userNickName];
        
        _questionAskTime = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60,0,40,20.0f)];
        //        QUESTIONUSERNAME.text = quesInfoM.NICKNAME;
        
        //        if(quesInfoM.ISANONYMITY){
        //            [userImg setImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
        //            QUESTIONUSERNAME.text = @"匿名提问";
        //        }
        _questionAskTime.textAlignment = NSTextAlignmentRight;
        _questionAskTime.backgroundColor = [UIColor redColor];
        [_questionAskTime sizeToFit];
        _questionAskTime.textColor = MAIN_SUBTITLE_COLOR;
        _questionAskTime.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [self addSubview:_questionAskTime];
    }
    
    return self;
}

@end

@implementation ZEHomeQuestionExplainView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kZEHomeCellUserMsgViewHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        
        _questionContentLab = [[YYLabel alloc]initWithFrame:CGRectMake(20,0,SCREEN_WIDTH - 40,20.0f)];
        _questionContentLab.textAlignment = NSTextAlignmentRight;
        _questionContentLab.backgroundColor = MAIN_ARM_COLOR;
        [_questionContentLab sizeToFit];
        _questionContentLab.numberOfLines = 0;
        _questionContentLab.textColor = MAIN_SUBTITLE_COLOR;
        _questionContentLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
        [self addSubview:_questionContentLab];
        
    }
    
    return self;
}

@end

@implementation ZEHomeTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kZEHomeCellUserMsgViewHeight;
    }
    self = [super initWithFrame:frame];
    
    return self;
}

@end

@implementation ZEHomeAnswerMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kZEHomeCellUserMsgViewHeight;
    }
    self = [super initWithFrame:frame];

    
    
    return self;
}

@end

@implementation ZEHomeBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kZEHomeCellUserMsgViewHeight;
    }
    self = [super initWithFrame:frame];
    
    return self;
}

@end

@implementation ZEHomeBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _homeView = [ZEHomeBaseView new];
        
        _homeView.cell = self;
        _homeView.homeQueImageView.cell = self;
        _homeView.homeQueTagView.cell = self;
        _homeView.homeAnswerMsgView.cell = self;
        _homeView.homeQueExplainView.cell = self;
        _homeView.homeQueUserMsgView.cell = self;
        
        [self.contentView addSubview:_homeView];

    }
    return self;
}

- (void)setLayout:(ZEHomeLayout *)layout
{
    self.height = layout.height;
    self.contentView.height = layout.height;
    _homeView.layout = layout;
}

-(void)setUI:(ZEHomeLayout *)layout{
    
}

@end
