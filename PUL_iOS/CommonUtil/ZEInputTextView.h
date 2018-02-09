//
//  ZEInputTextView.h
//  TextView
//
//  Created by Stenson on 2017/10/25.
//  Copyright © 2017年 HangZhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZEInputTextView : UIView<UITextViewDelegate>
{
    CGRect _viewFrame;
}

@property (nonatomic,strong) UITextView * inputView;
@property (nonatomic,strong) UILabel * lengthLab;
@property (nonatomic,assign) long marginLength;

@end
