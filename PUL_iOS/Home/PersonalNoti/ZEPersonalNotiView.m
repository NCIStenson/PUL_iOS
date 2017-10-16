//
//  ZEPersonalNotiView.m
//  PUL_iOS
//
//  Created by Stenson on 17/5/10.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPersonalNotiView.h"
#import "ZEExpertChatVC.h"

@interface ZEPersonalNotiView()
{    
    UITableView * _notiContentView;
    
    UIView * _editingView;
}

@property (nonatomic,strong) NSMutableArray * personalNotiArr;
@property (nonatomic,strong) NSMutableArray * deletePersonalNotiArr;

@end

@implementation ZEPersonalNotiView

-(id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self initEditingView];
    }
    return self;
}

-(void)setUI{
    
    _notiContentView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 109.0f) style:UITableViewStylePlain];
    _notiContentView.dataSource = self;
    _notiContentView.delegate =self;
    [self addSubview:_notiContentView];
    _notiContentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _notiContentView.allowsMultipleSelectionDuringEditing=YES;

    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _notiContentView.mj_header = header;
    
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _notiContentView.mj_footer = footer;
}

-(void)initEditingView
{
    _editingView = [[UIView alloc] init];
    [self addSubview:_editingView];
    _editingView.frame = CGRectMake(0,SCREEN_HEIGHT - NAV_HEIGHT - 60.0f - TAB_BAR_HEIGHT, SCREEN_WIDTH, 60);
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    [_editingView.layer addSublayer:lineLayer];
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:kTextColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(editingViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        button.frame = CGRectMake(0 + _editingView.width / 3 * i, 10, _editingView.width / 3, _editingView.height - 10);
        [_editingView addSubview:button];
        button.tag = 100 + i;
        
        switch (i) {
            case 0:
                [button setTitle:@"全部已读" forState:UIControlStateNormal];
                [button setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"全部删除" forState:UIControlStateNormal];
                [button setTitleColor:MAIN_NAV_COLOR forState:UIControlStateNormal];
                break;
            case 2:
                [button setTitle:@"删除" forState:UIControlStateNormal];
                break;
   
            default:
                break;
        }
    }
}

-(void)editingViewBtnClick:(UIButton *)btn
{
    if ([[btn titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        self.deletePersonalNotiArr = [NSMutableArray array];
        [[_notiContentView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.deletePersonalNotiArr addObject:self.personalNotiArr[obj.row]];
        }];
        if (self.deletePersonalNotiArr.count ==0) {
            MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud3.mode = MBProgressHUDModeText;
            hud3.labelText = @"请至少选择一条删除";
            [hud3 hide:YES afterDelay:1.0f];
            return;
        }

        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"删除消息记录" message:@"当前选中的消息记录将被删除，是否确认?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteNumberOfPersonalDynamic];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [[ZEUtil getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
    }else if(btn.tag == 101){
        if ([self.delegate respondsToSelector:@selector(didSelectDeleteAllDynamic)]) {
            [self.delegate didSelectDeleteAllDynamic];
        }
    }else if (btn.tag == 100){
        NSLog(@" ========  全部标为已读  ====== ");
        if([self.delegate respondsToSelector:@selector(clearUnreadDynamic)]){
            [self.delegate clearUnreadDynamic];
        }
    }
}

-(void)deleteNumberOfPersonalDynamic
{
    self.deletePersonalNotiArr = [NSMutableArray array];
    NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
    [[_notiContentView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.deletePersonalNotiArr addObject:self.personalNotiArr[obj.row]];
        [insets addIndex:obj.row];
    }];
    if (self.deletePersonalNotiArr.count ==0) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.labelText = @"请至少选择一条删除";
        [hud3 hide:YES afterDelay:1.0f];
        return;
    }
    
    NSString * deleteSeqkey = @"";
    for (NSDictionary * dic in self.deletePersonalNotiArr) {
        if(deleteSeqkey.length > 0){
            deleteSeqkey = [NSString stringWithFormat:@"%@,%@",deleteSeqkey, [dic objectForKey:@"SEQKEY"]];
        }else{
            deleteSeqkey = [dic objectForKey:@"SEQKEY"];
        }
    }


    [self.personalNotiArr removeObjectsAtIndexes:insets];
    [_notiContentView deleteRowsAtIndexPaths:[_notiContentView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
    
    if([self.delegate respondsToSelector:@selector(didSelectDeleteNumberOfDynamic:)]){
        [self.delegate didSelectDeleteNumberOfDynamic:deleteSeqkey];
    }
    
    /** 数据清空情况下取消编辑状态*/
    if (self.personalNotiArr.count == 0) {
        [_notiContentView setEditing:NO animated:YES];
        [self showEitingView:NO];
    }
}


#pragma mark - Public Method

-(void)reloadContentViewWithArr:(NSArray *)arr{
    [self.personalNotiArr addObjectsFromArray:arr];
    
    [_notiContentView.mj_header endRefreshing];
    
    if (arr.count < MAX_PAGE_COUNT) {
        [_notiContentView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_notiContentView.mj_footer endRefreshing];
    }
    
    [_notiContentView reloadData];
}

-(void)canLoadMoreData
{
    MJRefreshFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _notiContentView.mj_footer = footer;
}
-(void)reloadFirstView:(NSArray *)array
{    
    self.personalNotiArr = [NSMutableArray array];
    [self reloadContentViewWithArr:array];
}
-(void)loadNewData
{
    if([self.delegate respondsToSelector:@selector(loadNewData)]){
        [self.delegate loadNewData];
    }
}

-(void)loadMoreData{
    if([self.delegate respondsToSelector:@selector(loadMoreData)]){
        [self.delegate loadMoreData];
    }
}
/**
 *  停止刷新
 */
-(void)headerEndRefreshing
{
    [_notiContentView.mj_header endRefreshing];
}

-(void)loadNoMoreData
{
    [_notiContentView.mj_footer endRefreshingWithNoMoreData];
}

- (void)showEitingView:(BOOL)isShow{
    if(self.personalNotiArr.count == 0){
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.labelText = @"当前没有个人动态";
        [hud3 hide:YES afterDelay:1.0f];
        return;
    }
    
    if (isShow) {
        _editingView.top = SCREEN_HEIGHT - NAV_HEIGHT - 60 - 60 - TAB_BAR_HEIGHT;
        _notiContentView.height = _notiContentView.height - 60;
    }else{
        _editingView.frame = CGRectMake(0,SCREEN_HEIGHT - NAV_HEIGHT - 60.0f - TAB_BAR_HEIGHT, SCREEN_WIDTH, 60);
        _notiContentView.height = _notiContentView.height + 60;
    }
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personalNotiArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    ZETeamNotiCenModel * notiCenM = [ZETeamNotiCenModel getDetailWithDic:self.personalNotiArr[indexPath.row]];

    if ([notiCenM.MESTYPE integerValue] == 1) {
        [self initTeamCellViewWithIndexpath:indexPath withCell:cell withMestype:1];
    }else if ([notiCenM.MESTYPE integerValue] == 2){
        [self initQuestionCellViewWithIndexpath:indexPath withCell:cell];
    }else if ([notiCenM.MESTYPE integerValue] == 4){
        [self initTeamCellViewWithIndexpath:indexPath withCell:cell withMestype:4];
    }
        
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ZETeamNotiCenModel * notiCenM = [ZETeamNotiCenModel getDetailWithDic:self.personalNotiArr[indexPath.row]];

//    if ([notiCenM.MESTYPE integerValue] == 1) {
//        float explainHeight = [ZEUtil heightForString:notiCenM.QUESTIONEXPLAIN font:[UIFont systemFontOfSize:kTiltlFontSize] andWidth:SCREEN_WIDTH - 120];
//        return explainHeight + 80;
        return 80;
//    }else if ([notiCenM.MESTYPE integerValue] == 2){
//        float questionHeight = [ZEUtil heightForString:notiCenM.QUESTIONEXPLAIN font:[UIFont systemFontOfSize:18] andWidth:SCREEN_WIDTH - 20];
//        return questionHeight + 65;
//    }
//    return 0;
}

-(void)initTeamCellViewWithIndexpath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell withMestype:(NSInteger)mestype
{
    NSDictionary * dynamicDic =self.personalNotiArr[indexPath.row];

    ZETeamNotiCenModel * notiM = [ZETeamNotiCenModel getDetailWithDic:dynamicDic];
    NSString * fileUrl = [[[dynamicDic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    UIImageView * headeImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
    [headeImage setImage:ZENITH_PLACEHODLER_TEAM_IMAGE];
    [headeImage sd_setImageWithURL:ZENITH_IMAGEURL(fileUrl) placeholderImage:[UIImage imageNamed:@"xihz_td.png"]];
    [cell.contentView addSubview:headeImage];
    [headeImage setContentMode:UIViewContentModeScaleAspectFit];
    if(fileUrl.length > 0){
        [headeImage sd_setImageWithURL:ZENITH_IMAGEURL(fileUrl) placeholderImage:[UIImage imageNamed:@"xihz_td.png"]];
    }
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 120, 20)];
    nameLab.text = @"团队消息";
    if(mestype == 4){
        nameLab.text = @"团队消息（已撤回）";
    }
    nameLab.numberOfLines = 0;
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:nameLab];
    nameLab.textColor = kTextColor;
    
    YYLabel * dynamiLab = [[YYLabel alloc]initWithFrame:CGRectMake(100, 30, SCREEN_WIDTH - 120, 40)];
    dynamiLab.numberOfLines = 2;
    dynamiLab.textAlignment = NSTextAlignmentLeft;
    dynamiLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:dynamiLab];
    dynamiLab.textColor = kTextColor;
    dynamiLab.text = notiM.QUESTIONEXPLAIN;
    dynamiLab.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    dynamiLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    dynamiLab.text = [NSString stringWithFormat:@"%@  |  %@",notiM.QUESTIONEXPLAIN,notiM.CREATORNAME];
    float explainHeight = [ZEUtil heightForString:dynamiLab.text font:dynamiLab.font andWidth:dynamiLab.width];
    if(explainHeight > 40){
        explainHeight = 40;
    }
    dynamiLab.height = explainHeight;
    
    UILabel * receiptLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90,10,70,20.0f)];
    receiptLab.textAlignment = NSTextAlignmentRight;
    receiptLab.textColor = MAIN_SUBTITLE_COLOR;
    receiptLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:receiptLab];
    receiptLab.text = [ZEUtil compareCurrentTime:[NSString stringWithFormat:@"%@",notiM.SYSCREATEDATE]];
    
    if (![notiM.ISREAD boolValue]) {
        UIImageView * redImage = [[UIImageView alloc]init];
        redImage.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:redImage];
        redImage.bounds = CGRectMake(0, 0, 10, 10);
        redImage.centerX = headeImage.right;
        redImage.centerY = headeImage.top;
        redImage.clipsToBounds = YES;
        redImage.layer.cornerRadius = redImage.height / 2;
    }
    if (indexPath.row == 0) {
        UIView * lineView = [UIView new];
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = MAIN_LINE_COLOR;
        [cell.contentView addSubview:lineView];
    }
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, headeImage.bottom + 9.5, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [cell.contentView addSubview:lineView];
    
}

-(void)initQuestionCellViewWithIndexpath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell{

    NSDictionary * dynamicDic =self.personalNotiArr[indexPath.row];
    
    ZETeamNotiCenModel * notiM = [ZETeamNotiCenModel getDetailWithDic:dynamicDic];
    NSString * fileUrl = [[[dynamicDic objectForKey:@"FILEURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    if(fileUrl.length > 0){
        UIImageView * headimage = [UIImageView new];
        headimage.frame = CGRectMake(20, 10, 60, 60);
        [cell.contentView addSubview:headimage];
        headimage.clipsToBounds = YES;
        headimage.layer.cornerRadius = headimage.height/ 2;
        [headimage sd_setImageWithURL:ZENITH_IMAGEURL(fileUrl) placeholderImage:ZENITH_PLACEHODLER_USERHEAD_IMAGE];
    }else{
        UIImageView * headimage = [UIImageView new];
        headimage.frame = CGRectMake(20, 10, 60, 60);
        [cell.contentView addSubview:headimage];
        headimage.clipsToBounds = YES;
        headimage.layer.cornerRadius = headimage.height/ 2;
        [headimage setImage:[UIImage imageNamed:@"xxhz_no_name.png"]];
        
        UILabel * lastName = [UILabel new];
        [cell.contentView addSubview:lastName];
        lastName.frame = CGRectMake(20, 10, 60, 60);
        lastName.clipsToBounds = YES;
        lastName.layer.cornerRadius = lastName.height / 2;
        if(notiM.USERNAME.length > 1){
            lastName.text = [notiM.USERNAME substringToIndex:1];
        }
        lastName.textAlignment = NSTextAlignmentCenter;
        lastName.textColor = [UIColor whiteColor];
    }
    
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 160, 20)];
    nameLab.text = notiM.TIPS;
    nameLab.numberOfLines = 1;
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:nameLab];
    nameLab.textColor = kTextColor;
    
    UILabel * dynamiLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, SCREEN_WIDTH - 120, 40)];
    dynamiLab.numberOfLines = 2;
    dynamiLab.textAlignment = NSTextAlignmentLeft;
    dynamiLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:dynamiLab];
    dynamiLab.textColor = kTextColor;
    dynamiLab.text = notiM.QUESTIONEXPLAIN;
    dynamiLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    dynamiLab.text = [NSString stringWithFormat:@"%@",notiM.ANSWEREXPLAIN];
    float explainHeight = [ZEUtil heightForString:dynamiLab.text font:dynamiLab.font andWidth:dynamiLab.width];
    if(explainHeight > 40){
        explainHeight = 40;
    }
    dynamiLab.height = explainHeight;
    
    UILabel * receiptLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90,10,70,20.0f)];
    receiptLab.textAlignment = NSTextAlignmentRight;
    receiptLab.numberOfLines = 0;
    receiptLab.textColor = MAIN_SUBTITLE_COLOR;
    receiptLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    [cell.contentView addSubview:receiptLab];
    //    if ([notiM.DYNAMICTYPE integerValue] == 1 || [notiM.DYNAMICTYPE integerValue] == 2) {
    //        receiptLab.text = @"需回执";
    //    }else{
    
    //        receiptLab.hidden = YES;
    //    }
    receiptLab.text = [ZEUtil compareCurrentTime:[NSString stringWithFormat:@"%@",notiM.SYSCREATEDATE]];
    
    if (![notiM.ISREAD boolValue]) {
        UIImageView * redImage = [[UIImageView alloc]init];
        redImage.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:redImage];
        redImage.bounds = CGRectMake(0, 0, 10, 10);
        redImage.centerX = 80;
        redImage.centerY = 10;
        redImage.clipsToBounds = YES;
        redImage.layer.cornerRadius = redImage.height / 2;
    }
    if (indexPath.row == 0) {
        UIView * lineView = [UIView new];
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = MAIN_LINE_COLOR;
        [cell.contentView addSubview:lineView];
    }
    
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = MAIN_LINE_COLOR;
    [cell.contentView addSubview:lineView];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//滑动删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_notiContentView.isEditing){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//左滑点击事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除事件
        
        if([self.delegate respondsToSelector:@selector(didSelectDeleteBtn:)]){
            [self.delegate didSelectDeleteBtn:[ZETeamNotiCenModel getDetailWithDic:self.personalNotiArr[indexPath.row]]];
        }

        [self.personalNotiArr removeObjectAtIndex:indexPath.row];//tableview数据源
        if ([self.personalNotiArr count] == 0) { //删除此行后数据源为空
            [_notiContentView reloadData];
//            NSLog(@" =======  %d  %d",indexPath.row , indexPath.section);
//            [_notiContentView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [_notiContentView deleteSections: [NSIndexSet indexSetWithIndex: indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
        } else {
            [_notiContentView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_notiContentView.isEditing){
        return;
    }

    ZETeamNotiCenModel * notiModel = [ZETeamNotiCenModel getDetailWithDic:self.personalNotiArr[indexPath.row]];
    if([notiModel.MESTYPE integerValue] == 1 && [self.delegate respondsToSelector:@selector(didSelectTeamMessage:)] ){
        [self.delegate didSelectTeamMessage:notiModel];
    }else if([notiModel.MESTYPE integerValue] == 2 && [self.delegate respondsToSelector:@selector(didSelectQuestionMessage:)] ){
        [self.delegate didSelectQuestionMessage:notiModel];
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
