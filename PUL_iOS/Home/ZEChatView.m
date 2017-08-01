//
//  ZEChatView.m
//  PUL_iOS
//
//  Created by Stenson on 16/12/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEChatView.h"

@implementation ZEChatInputView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor =  [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton * cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(10, 5, 30, 30);
    [cameraBtn setImage:[UIImage imageNamed:@"camera_gray" color:MAIN_GREEN_COLOR] forState:UIControlStateNormal];
    [self addSubview:cameraBtn];
    cameraBtn.clipsToBounds = YES;
    cameraBtn.layer.cornerRadius = 15.0f;
    cameraBtn.layer.borderWidth = 1.5;
    cameraBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
    [cameraBtn addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
    
    _inputField = [[UITextField alloc]initWithFrame:CGRectMake(50, 5.0f, SCREEN_WIDTH - 140.0f, 30.0f)];
    _inputField.delegate = self;
    _inputField.returnKeyType = UIReturnKeySend;
    _inputField.font = [UIFont systemFontOfSize:12];
    [self addSubview:_inputField];
    _inputField.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
    _inputField.layer.borderWidth = 1.5f;
    _inputField.layer.cornerRadius = 5.0f;
    _inputField.leftViewMode = UITextFieldViewModeAlways;
    _inputField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 5.0f, 60, 30);
    [self addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sendBtn.clipsToBounds = YES;
    sendBtn.layer.cornerRadius = 5;
    sendBtn.layer.borderColor = [MAIN_GREEN_COLOR CGColor];
    sendBtn.layer.borderWidth = 1.5;
}

-(void)showCondition
{
    if ([_chatView.delegate respondsToSelector:@selector(didSelectCameraBtn)]) {
        [_chatView.delegate didSelectCameraBtn];
    }
}

-(void)sendComment
{
    if([_chatView.delegate respondsToSelector:@selector(didSelectSend:)]){
        [_chatView.delegate didSelectSend:_inputField.text];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([_chatView.delegate respondsToSelector:@selector(didSelectSend:)]){
        [_chatView.delegate didSelectSend:_inputField.text];
    }

    return YES;
}

@end

@interface ZEChatView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PYPhotoBrowseViewDelegate>
{
    UITableView * _contentTableView;
    BOOL _isShowedKeyboard;
}

@property (nonatomic,strong) NSMutableArray * layouts;

@end

@implementation ZEChatView

-(id)initWithFrame:(CGRect)frame
 withQuestionInfoM:(ZEQuestionInfoModel *)quesinfo
   withAnswerInfoM:(ZEAnswerInfoModel *)answerInfo
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.layouts = [NSMutableArray new];
        self.answerInfoM = answerInfo;
        self.questionInfoM = quesinfo;
        
        [self initChatView];

//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
//        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//        tapGestureRecognizer.cancelsTouchesInView = NO;
//        //将触摸事件添加到当前view
//        [self addGestureRecognizer:tapGestureRecognizer];

        _isShowedKeyboard = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

-(void)keyboardHide
{
    [self endEditing:YES];
}

-(void)initChatView
{
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStylePlain];
    _contentTableView.backgroundColor = [UIColor clearColor];
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    [self  addSubview:_contentTableView];
    _contentTableView.showsVerticalScrollIndicator = NO;    
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_contentTableView registerClass:[ZEChatBaseCell class] forCellReuseIdentifier:@"cell"];
    
    if ([_answerInfoM.ANSWERUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]] || [_questionInfoM.QUESTIONUSERCODE isEqualToString:[ZESettingLocalData getUSERCODE]]) {
        _inputView = [ZEChatInputView new];
        _inputView.chatView = self;
        _inputView.origin = CGPointMake(0, SCREEN_HEIGHT - 40);
        _inputView.size = CGSizeMake(SCREEN_WIDTH, 40);
        [self addSubview:_inputView];
    }else{
        _contentTableView.height = SCREEN_HEIGHT - NAV_HEIGHT - 5;
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    _isShowedKeyboard = YES;
    //获取键盘的高度
//    CGRect begin = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    CGRect end = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if(end.size.height > 0 ){
        [UIView animateWithDuration:0.29 animations:^{
            _contentTableView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - end.size.height - 45);
            _inputView.frame = CGRectMake(0, SCREEN_HEIGHT - NAV_HEIGHT - end.size.height + 20, SCREEN_WIDTH, 40);
            if(_contentTableView.contentSize.height > SCREEN_HEIGHT - NAV_HEIGHT - end.size.height - 45){
                [_contentTableView scrollToBottom];
            }
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _isShowedKeyboard = NO;
    [UIView animateWithDuration:0.29 animations:^{
        _contentTableView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 45);
        _inputView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - PublicMethod

-(void)reloadDataWithArr:(NSArray *)arr
{
    @weakify(self);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weak_self.layouts = [NSMutableArray array];
        [self initLayoutArr];
        
        for (int i = 0; i < arr.count ; i ++) {
            ZEQuesAnsDetail * quesAnsDetail = [ZEQuesAnsDetail getDetailWithDic:arr[i]];
            if (quesAnsDetail.EXPLAIN.length > 0) {
                ZEChatLayout * layout;
                if([quesAnsDetail.SYSCREATORID isEqualToString:_questionInfoM.QUESTIONUSERCODE]){
                    if(_questionInfoM.ISANONYMITY){
                        layout = [[ZEChatLayout alloc]initWithDetailTextContent:quesAnsDetail
                                                                  withHeadImage:nil];
                    }else{
                        layout = [[ZEChatLayout alloc]initWithDetailTextContent:quesAnsDetail
                                                                  withHeadImage:_questionInfoM.HEADIMAGE];
                    }
                }else{
                    layout = [[ZEChatLayout alloc]initWithDetailTextContent:quesAnsDetail
                                                              withHeadImage:_answerInfoM.HEADIMAGE];
                }
                
                NSDictionary * dic = @{@"layout":layout,
                                       @"type":TYPETEXT};
                
                [_layouts addObject:dic];
            }
        

            if (quesAnsDetail.FILEURLARR.count > 0) {
                for (int j = 0; j < quesAnsDetail.FILEURLARR.count; j ++) {
                    
                    NSString * headImageUrl = nil;
                    if([quesAnsDetail.SYSCREATORID isEqualToString:_questionInfoM.QUESTIONUSERCODE]){
                        headImageUrl = _questionInfoM.HEADIMAGE;
                        if (_questionInfoM.ISANONYMITY) {
                            headImageUrl = @"";
                        }
                    }else{
                        headImageUrl = _answerInfoM.HEADIMAGE;
                    }

                    ZEChatLayout * layout = [[ZEChatLayout alloc]initWithChatImgaeUrl:quesAnsDetail.FILEURLARR[j]
                                                                         chatUsercode:quesAnsDetail.SYSCREATORID
                                                                     chatHeadImageUrl:headImageUrl];
                    
                    NSDictionary * dic = @{@"layout":layout,
                                           @"type":TYPEIMAGE};

                    [_layouts addObject:dic];
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_contentTableView reloadData];
            if( _isShowedKeyboard ){
                if(_contentTableView.contentSize.height > SCREEN_HEIGHT - NAV_HEIGHT - 288 - 45){
                    [_contentTableView scrollToBottom];
                }
            }else{
                if(_contentTableView.contentSize.height > SCREEN_HEIGHT - NAV_HEIGHT - 45){
                    [_contentTableView scrollToBottom];
                }
            }
        });
    });
}

-(void)initLayoutArr
{
    if (_questionInfoM.QUESTIONEXPLAIN.length > 0) {
        ZEChatLayout * layout = [[ZEChatLayout alloc]initWithTextContent:_questionInfoM withAnswerInfo:nil];
        
        NSDictionary * dic = @{@"layout":layout,
                               @"type":TYPETEXT};
        
        [_layouts addObject:dic];
    }
    
    if (_questionInfoM.FILEURLARR.count > 0) {
        for (int j = 0; j < _questionInfoM.FILEURLARR.count; j ++) {
            NSString * headImageUrl = _questionInfoM.HEADIMAGE;
            if (_questionInfoM.ISANONYMITY) {
                headImageUrl = @"";
            }
            ZEChatLayout * layout = [[ZEChatLayout alloc]initWithImgaeUrl:_questionInfoM.FILEURLARR[j]
                                                                 usercode:_questionInfoM.QUESTIONUSERCODE
                                                             headImageUrl:headImageUrl];
            
            NSDictionary * dic = @{@"layout":layout,
                                   @"type":TYPEIMAGE};
            
            [_layouts addObject:dic];
        }
    }
    
    if (_answerInfoM.ANSWEREXPLAIN.length > 0) {
        ZEChatLayout * layout = [[ZEChatLayout alloc]initWithTextContent:nil withAnswerInfo:_answerInfoM];
        
        NSDictionary * dic = @{@"layout":layout,
                               @"type":TYPETEXT};
        
        [_layouts addObject:dic];
    }
        
    if (_answerInfoM.FILEURLARR.count > 0) {
        for (int j = 0; j < _answerInfoM.FILEURLARR.count; j ++) {
            ZEChatLayout * layout = [[ZEChatLayout alloc]initWithImgaeUrl:_answerInfoM.FILEURLARR[j]
                                                                 usercode:_answerInfoM.ANSWERUSERCODE
                                                             headImageUrl:_answerInfoM.HEADIMAGE];
            
            NSDictionary * dic = @{@"layout":layout,
                                   @"type":TYPEIMAGE};
            
            [_layouts addObject:dic];
        }
    }
}

-(void)uploadTextSuccess
{
    self.inputView.inputField.text = @"";
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _layouts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _layouts[indexPath.row];
    ZEChatLayout * layout = [dic objectForKey:@"layout"];
    return layout.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZEChatBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZEChatBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.delegate = self;

        
    NSDictionary * dic = _layouts[indexPath.row];
    [cell setLayout:dic[@"layout"] withContentType:dic[@"type"]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)contentImageClick:(NSString *)contentImageURL
{
    [self endEditing:YES];
    contentImageURL = [contentImageURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    PYPhotoBrowseView *browser = [[PYPhotoBrowseView alloc] init];
    browser.imagesURL = @[[NSString stringWithFormat:@"%@/file/%@",Zenith_Server,contentImageURL]]; // 图片总数
    browser.delegate = self;
    [browser show];
}

- (void)photoBrowseView:(PYPhotoBrowseView *)photoBrowseView willHiddenWithImages:(NSArray *)images index:(NSInteger)index;
{
    photoBrowseView.hidden = YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
