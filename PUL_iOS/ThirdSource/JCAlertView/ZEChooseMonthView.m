//
//  ZEPointRegChooseCountView.m
//  NewCentury
//
//  Created by Stenson on 16/3/15.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#define START_YEAR 2015

#import "ZEChooseMonthView.h"

@interface ZEChooseMonthView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView * _picker;
    CGRect _viewFrame;
    
    NSString * _currentMonth;
    NSString * _currentYear;
}
@end

@implementation ZEChooseMonthView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 288.0f)];
    if (self) {
        _viewFrame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 288.0f);
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        [self initView];
    }
    return self;
}

-(void)initView
{
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44.0f)];
    titleLab.text = @"请选择";
    titleLab.backgroundColor = MAIN_NAV_COLOR;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44.0f, SCREEN_WIDTH - 40, 220)];
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.delegate = self;
    _picker.dataSource = self;
    [self addSubview:_picker];
    _currentMonth = [ZEUtil getCurrentDate:@"MM"];
    _currentYear = [ZEUtil getCurrentDate:@"yyyy"];
    
    [_picker selectRow:[[ZEUtil getCurrentDate:@"yyyy"] integerValue] - START_YEAR inComponent:0 animated:YES];
    [_picker selectRow:[[ZEUtil getCurrentDate:@"MM"] integerValue] - 1 inComponent:1 animated:YES];
    
    for (int i = 0; i < 2; i ++) {
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        optionBtn.frame = CGRectMake(0 + _viewFrame.size.width / 2 * i , 244.0f, _viewFrame.size.width / 2, 44.0f);
        [optionBtn setTitle:@"取消" forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [optionBtn setBackgroundColor:MAIN_NAV_COLOR];
        optionBtn.tag = i;
        [optionBtn addTarget:self action:@selector(chooseDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:optionBtn];
        if (i == 1) {
            [optionBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
    }
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(_viewFrame.size.width / 2 - 0.25f, 244.0f, 0.5, 44.0f);
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    [self.layer addSublayer:lineLayer];
    
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return 30;
    }
    return 12;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if(component == 0){
        return [NSString stringWithFormat:@"%ld年",(long)row + START_YEAR];
    }

    return [NSString stringWithFormat:@"%ld月",(long)row + 1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if(component == 0){
        _currentYear = [NSString stringWithFormat:@"%ld",(long)row + START_YEAR];
    }else{
        if (row < 9) {
            _currentMonth = [NSString stringWithFormat:@"0%ld",(long)row + 1];
        }else{
            _currentMonth = [NSString stringWithFormat:@"%ld",(long)row + 1];
        }
    }
}
#pragma mark - selfDelegate

-(void)chooseDateBtnClick:(UIButton *)button{
    
    if (button.tag == 0) {
        if ([self.delegate respondsToSelector:@selector(cancelChooseCount)]) {
            [self.delegate cancelChooseCount];
        }
    }else{
        if (![ZEUtil isStrNotEmpty:_currentMonth]) {
            _currentMonth = @"01";
        }
        if ([self.delegate respondsToSelector:@selector(confirmChooseCount:)]) {
            [self.delegate confirmChooseCount:[NSString stringWithFormat:@"%@-%@",_currentYear,_currentMonth]];
        }
    }
    
}




@end
