//
//  ZEChooseNumberView.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZEChooseNumberView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * contentView;
}
@property (nonatomic,strong) NSMutableArray * alreadyInviteNumbersArr;

@property (nonatomic,strong) ZEUSER_BASE_INFOM * currentSelectUserinfo;

@property (nonatomic,assign) BOOL whetherMultiselect; // 是否可以多选
@property (nonatomic,copy) NSString * TEAMCODE;
@property (nonatomic,strong) NSMutableArray * maskArr;

-(void)reloadViewWithAlreadyInviteNumbers:(NSArray *)arr;

@end
