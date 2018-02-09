//
//  ZEShowQuestionTypeView.m
//  PUL_iOS
//
//  Created by Stenson on 16/8/17.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kOptionViewMarginLeft   0.0f
#define kOptionViewMarginTop    44.0f
#define kOptionViewWidth        _viewFrame.size.width

#define kMaxHeight SCREEN_HEIGHT * 0.7

#import "ZEShowQuestionTypeView.h"

@interface ZEShowQuestionTypeView ()<UITableViewDataSource,UITableViewDelegate>
{
    CGRect _viewFrame;
    NSMutableArray * _kindTaskArr;
    NSMutableArray * _detailTaskArr;
    UITableView * _optionTableView;
    NSMutableArray * _maskArr;
}
@property (nonatomic,retain) NSArray * optionsArray;
@end


@implementation ZEShowQuestionTypeView
-(id)initWithOptionArr:(NSArray *)options
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, kMaxHeight)];
    if (self) {
        _optionsArray = options;
        _viewFrame = CGRectMake(0, 0, SCREEN_WIDTH - 40, kMaxHeight);
        self.backgroundColor = [UIColor whiteColor];
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
    
    _optionTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _optionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _optionTableView.delegate = self;
    _optionTableView.dataSource = self;
    [self addSubview:_optionTableView];
    
    if (_viewFrame.size.height != kMaxHeight) _optionTableView.scrollEnabled = NO;
    [_optionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kOptionViewMarginLeft);
        make.top.offset(kOptionViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kOptionViewWidth,kMaxHeight - 44.0f));
    }];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _optionsArray.count;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = [_optionsArray[indexPath.row] objectForKey:@"QUESTIONTYPENAME"];
    cell.textLabel.textColor = MAIN_COLOR;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(10, 43.5f, SCREEN_WIDTH - 10, 0.5f);
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    [cell.contentView.layer addSublayer:lineLayer];
    
    return cell;
}

#pragma mark - UITabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSeclect:withData:)]) {
        [self.delegate didSeclect:self withData:_optionsArray[indexPath.row]];
    }
}


@end
