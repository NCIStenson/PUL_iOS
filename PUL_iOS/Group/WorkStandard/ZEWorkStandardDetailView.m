//
//  ZEWorkStandardDetailView.m
//  PUL_iOS
//
//  Created by Stenson on 2017/11/20.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//
#define kContentViewMarginLeft  0.0f
#define kContentViewMarginTop   0.0f
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      SCREEN_HEIGHT - ( NAV_HEIGHT )

#import "ZEWorkStandardDetailView.h"

@interface ZEWorkStandardDetailView()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _contentView;
    NSDictionary * _workStandardDic;
    
    NSMutableArray * _detailArr;
    NSMutableArray * _detailFileTypeArr;
}
@end

@implementation ZEWorkStandardDetailView

-(id)initWithFrame:(CGRect)frame withWorkStandard:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _workStandardDic = dic;
//        NSString * FILETYPE = [dic objectForKey:@"FILETYPE"];
//        NSArray * FILEURLArr = [FILEURL componentsSeparatedByString:@","];
//        _detailArr = [NSMutableArray arrayWithArray:FILEURLArr];

        
        _workStandardDic = dic;
        
        [self initView];
    }
    return self;
}

-(void)initView
{
    _contentView = [[UITableView alloc]initWithFrame:CGRectMake(kContentViewMarginLeft, kContentViewMarginTop, kContentViewWidth, kContentViewHeight) style:UITableViewStylePlain];
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    [self addSubview:_contentView];
//    MJRefreshHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
//    _contentView.mj_header = header;
//
//    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    _contentView.mj_footer = footer;
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * FILEURL = [_workStandardDic objectForKey:@"FILEURL"];
 
    NSArray * FILEURLArr = [FILEURL componentsSeparatedByString:@","];
    _detailArr = [NSMutableArray arrayWithArray:FILEURLArr];
//    if (_detailArr.count > 1) {
//        [_detailArr removeFirstObject];
//    }
    return _detailArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString * workStandarnExplain = [_workStandardDic objectForKey:@"STANDARDEXPLAIN"];
    float expalinHeight = [ZEUtil heightForString:workStandarnExplain font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    
    return 80 + expalinHeight + 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [UIView new];
    
    NSString * PHOTOURL = [[_workStandardDic objectForKey:@"PHOTOURL"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString * STANDARDEXPLAIN = [_workStandardDic objectForKey:@"STANDARDEXPLAIN"];
    NSString * STANDARDNAME = [_workStandardDic objectForKey:@"STANDARDNAME"];
    NSString * CLICKCOUNT = [_workStandardDic objectForKey:@"CLICKCOUNT"];
    
    [ZEUtil addLineLayerMarginLeft:0 marginTop:0 width:SCREEN_WIDTH height:5 superView:headerView];
    
    UIImageView * contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 100, 70)];
    [headerView addSubview:contentImageView];
    if ([ZEUtil isStrNotEmpty:PHOTOURL]) {
        [contentImageView sd_setImageWithURL:ZENITH_IMAGEURL(PHOTOURL) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    }
    
    UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(125, contentImageView.top, SCREEN_WIDTH - 190, 40.0f)];
    contentLab.text = STANDARDNAME;
    contentLab.textColor = kTextColor;
    contentLab.numberOfLines = 2;
    contentLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [headerView addSubview:contentLab];
    
    NSString * praiseNumLabText =[NSString stringWithFormat:@"%ld",(long)[CLICKCOUNT integerValue]];
    
    float praiseNumWidth = [ZEUtil widthForString:praiseNumLabText font:[UIFont boldSystemFontOfSize:10] maxSize:CGSizeMake(200, 20)];
    
    UILabel * commentLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 20,contentImageView.top + 5,praiseNumWidth,20.0f)];
    commentLab.text  = praiseNumLabText;
    commentLab.font = [UIFont boldSystemFontOfSize:10];
    commentLab.textColor = MAIN_SUBTITLE_COLOR;
    [headerView addSubview:commentLab];
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - praiseNumWidth - 45.0f, commentLab.top + 1, 20, 15)];
    commentImg.image = [UIImage imageNamed:@"discuss_pv.png"];
    commentImg.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:commentImg];
    
    UIImageView * circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(contentLab.left, contentLab.bottom + 5, 15, contentLab.height - 5)];
    circleImg.image = [UIImage imageNamed:@"answer_tag"];
    circleImg.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:circleImg];
    
    UILabel * circleLab = [[UILabel alloc]initWithFrame:CGRectMake(circleImg.frame.origin.x + 20,contentLab.bottom + 5,contentLab.width,contentLab.height - 5)];
    circleLab.text = [_workStandardDic objectForKey:@"QUESTIONTYPENAME"];
    circleLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    circleLab.textColor = MAIN_SUBTITLE_COLOR;
    [headerView addSubview:circleLab];
    circleLab.numberOfLines = 0;

    [ZEUtil addLineLayerMarginLeft:20 marginTop:circleLab.bottom + 5 width:SCREEN_WIDTH - 40 height:1 superView:headerView];

    UILabel * explainLab = [[UILabel alloc]initWithFrame:CGRectMake(20, circleLab.bottom + 10, SCREEN_WIDTH - 40, 40.0f)];
    explainLab.text = STANDARDEXPLAIN;
    explainLab.textColor = kSubTitleColor;
    explainLab.numberOfLines = 0;
    explainLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [headerView addSubview:explainLab];
    float expalinHeight = [ZEUtil heightForString:STANDARDEXPLAIN font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 40];
    explainLab.height = expalinHeight;

    [ZEUtil addLineLayerMarginLeft:0 marginTop:explainLab.bottom + 5 width:SCREEN_WIDTH height:3 superView:headerView];
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(20, explainLab.bottom + 30, SCREEN_WIDTH - 40, 1);
    lineView.backgroundColor = MAIN_NAV_COLOR;
    [headerView addSubview:lineView];
    
    UILabel * detailLab = [[UILabel alloc]initWithFrame:CGRectMake(20, circleLab.bottom + 10, SCREEN_WIDTH - 40, 40.0f)];
    detailLab.text = @"详情";
    detailLab.textColor = MAIN_NAV_COLOR;
    detailLab.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:detailLab];
    detailLab.backgroundColor = [UIColor whiteColor];
    detailLab.textAlignment = NSTextAlignmentCenter;
    [detailLab sizeToFit];
    detailLab.width = detailLab.width + 10;
    detailLab.center = CGPointMake(SCREEN_WIDTH / 2, lineView.centerY);

    
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    while ([cell.contentView subviews].lastObject) {
        [[[cell.contentView subviews] lastObject] removeFromSuperview];
    }

    [self initCellWithView:cell.contentView withIndexpath:indexPath];
    
    return cell;
}

-(void)initCellWithView:(UIView *)cellView withIndexpath:(NSIndexPath *)indexpath
{
    NSArray * FIELTYPEArr = [[_workStandardDic objectForKey:@"FILETYPE"] componentsSeparatedByString:@","];
    NSArray * FIELNAMEArr = [[_workStandardDic objectForKey:@"FILENAME"] componentsSeparatedByString:@","];

    UIImageView * typeImageView = [UIImageView new];
    typeImageView.frame = CGRectMake(20, 5, 34, 34);
    typeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cellView addSubview:typeImageView];
    
    if ([FIELTYPEArr[indexpath.row] isEqualToString:@".doc"] || [FIELTYPEArr[indexpath.row] isEqualToString:@".docx"] ) {
        [typeImageView setImage:[UIImage imageNamed:@"icon_circle_word"] ];
    }else if ([FIELTYPEArr[indexpath.row] isEqualToString:@".xls"]) {
        [typeImageView setImage:[UIImage imageNamed:@"icon_circle_excel"] ];
    }else{
        [typeImageView setImage:[UIImage imageNamed:@"icon_circle_pdf"] ];
    }

    
    UILabel * workStandardName = [UILabel new];
    workStandardName.frame = CGRectMake(70, 0, SCREEN_WIDTH - 90, 44);
    [cellView addSubview:workStandardName];
    [workStandardName setText:FIELNAMEArr[indexpath.row]];
    workStandardName.font = [UIFont systemFontOfSize:kTiltlFontSize];
    workStandardName.textColor = kTextColor;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * SEQKEY = [_workStandardDic objectForKey:@"SEQKEY"];
    
    if ([self.delegate respondsToSelector:@selector(goWorkStandardDetailWithURL:withWorkStandardSeqkey:)]) {
        [self.delegate goWorkStandardDetailWithURL:_detailArr[indexPath.row] withWorkStandardSeqkey:SEQKEY];
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
