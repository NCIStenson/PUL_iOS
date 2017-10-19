//
//  JCHATToolBar.h
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMUIRecordAnimationView.h"
#import "JMUIMessageTextView.h"
#import <JMUICommon/JMUIConstants.h>


@protocol JMUIToolBarDelegate <NSObject>

@optional
/**
 *  发送文本
 *
 *  @param text 文本
 */

/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(JMUIMessageTextView *)messageInputTextView;

- (void)inputTextViewDidEndEditing:(JMUIMessageTextView *)messageInputTextView;

- (void)inputTextViewDidChange:(JMUIMessageTextView *)messageInputTextView;
/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(JMUIMessageTextView *)messageInputTextView;

- (void)sendText :(NSString *)text;

- (void)noPressmoreBtnClick :(UIButton *)btn;

- (void)pressMoreBtnClick :(UIButton *)btn;

- (void)startRecordVoice;

- (void)playVoice :(NSString *)voicePath time:(NSString * )time;

- (void)pressVoiceBtnToHideKeyBoard;
/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction;
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction;
/**
 *  松开手指完成录音
 */
- (void)didFinishRecordingVoiceAction;
/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsideAction;
/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction;

@end
@interface JMUIInputToolbar : UIView<UITextViewDelegate>
/**
 *  表情button
 */
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

/**
 *  更多功能button
 */
@property (weak, nonatomic) IBOutlet UIButton *addButton;
/**
 *  语音button
 */
/**
 *  文本输入view
 */
@property (weak, nonatomic) IBOutlet JMUIMessageTextView *textView;

/**
 *  Height of textView
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

/**
 *  开始录音button
 */
@property (strong, nonatomic) UIButton *startRecordButton;

/**
 *  是否正在录音
 */
@property (nonatomic) BOOL isRecording;
@property (assign, nonatomic) id<JMUIToolBarDelegate> delegate;
@property (strong, nonatomic)  JMUIRecordAnimationView *recordAnimationView;
@property (nonatomic) BOOL isPlaying;


/**
 *  当录音按钮被按下所触发的事件，这时候是开始录音
 */
- (void)holdDownButtonTouchDown;

/**
 *  当手指在录音按钮范围之外离开屏幕所触发的事件，这时候是取消录音
 */
- (void)holdDownButtonTouchUpOutside;

/**
 *  当手指在录音按钮范围之内离开屏幕所触发的事件，这时候是完成录音
 */
- (void)holdDownButtonTouchUpInside;

/**
 *  当手指滑动到录音按钮的范围之外所触发的事件
 */
- (void)holdDownDragOutside;

/**
 *  当手指滑动到录音按钮的范围之内所触发的时间
 */
- (void)holdDownDragInside;

/**
 *  切换为文本输入模式
 */
- (void)switchToTextInputMode;

/**
 *  动态改变高度
 *
 *  @param changeInHeight 目标变化的高度
 */
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

/**
 *  获取输入框内容字体行高
 *
 *  @return 返回行高
 */
+ (CGFloat)textViewLineHeight;

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
+ (CGFloat)maxHeight;
@end
