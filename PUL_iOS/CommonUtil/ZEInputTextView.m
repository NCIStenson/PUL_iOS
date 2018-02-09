//
//  ZEInputTextView.m
//  TextView
//
//  Created by Stenson on 2017/10/25.
//  Copyright © 2017年 HangZhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEInputTextView.h"
@implementation ZEInputTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.inputView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, _viewFrame.size.width, _viewFrame.size.height - 20)];
    _inputView.font = [UIFont systemFontOfSize:14];
    _inputView.textColor = [UIColor lightGrayColor];
    _inputView.delegate = self;
    [self addSubview:_inputView];

    self.lengthLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _viewFrame.size.height - 20, _viewFrame.size.width - 5, 20)];
    self.lengthLab.textAlignment = NSTextAlignmentRight;
    self.lengthLab.text = [NSString stringWithFormat:@"0/%ld",(long)_marginLength];
    [self addSubview:_lengthLab];
    self.lengthLab.backgroundColor = [UIColor cyanColor];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > _marginLength){
        
    }else{
        self.lengthLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)_marginLength];
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
