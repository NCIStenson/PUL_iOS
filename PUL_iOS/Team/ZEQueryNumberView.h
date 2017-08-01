//
//  ZEQueryNumberView.h
//  PUL_iOS
//
//  Created by Stenson on 17/3/9.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEQueryNumberView;

@protocol ZEQueryNumberViewDelegate <NSObject>

-(void)goBack;


-(void)goSearch:(NSString *)searchStr;
@end

@interface ZEQueryNumberView : UIView <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *  searchTF;
    UITableView * contentView;
}

@property (nonatomic,strong) NSMutableArray * searchNumbersArr;  //  搜索到的人员信息
@property (nonatomic,strong) NSMutableArray * alreadyInviteNumbersArr;  // 当前页面已将邀请过的人员
@property (nonatomic,weak) id <ZEQueryNumberViewDelegate> delegate;

-(void)showSearchNumberResult:(NSArray *)dataArr;

@end
