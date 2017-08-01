//
//  JFCalendarPickerView.m
//  JFCalendarPicker
//
//  Created by 保修一站通 on 15/9/29.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFCalendarPickerView.h"
#import "JFCollectionViewCell.h"
#import "JCAlertView.h"
#import "ZEChooseMonthView.h"
NSString *const JFCalendarCellIdentifier = @"cell";


@interface JFCalendarPickerView ()<ZEChooseMonthViewDelegate>
{
    JCAlertView * _alertView;
    UIButton * signinBtn;
    UIButton * monthBtn;
    UILabel * titleLable;
}
@property (strong, nonatomic) UICollectionView *JFCollectionView;

@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic , strong) UIView *mask;

@property (nonatomic , strong) NSMutableArray * isSigninArr;

@end

@implementation JFCalendarPickerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
//        [self addSwipe];
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
//    [_JFCollectionView reloadData];
}

-(void)initView
{
    UIView * tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.0f)];
    [self addSubview:tipsView];
    
    monthBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [monthBtn addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchUpInside];
    [monthBtn setTitle:[ZEUtil getCurrentDate:@"yyyy-MM"] forState:UIControlStateNormal];
    monthBtn.frame = CGRectMake(10, 15, 70, 30);
    [tipsView addSubview:monthBtn];
    [monthBtn setClipsToBounds: YES];
    [monthBtn.layer setCornerRadius:5.0f];
    [monthBtn.layer setBorderWidth:0.5];
    [monthBtn.layer setBorderColor:[MAIN_NAV_COLOR CGColor]];
    [monthBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    titleLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 0, SCREEN_WIDTH / 2, 60)];
    titleLable.userInteractionEnabled = NO;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:kTiltlFontSize];
    titleLable.attributedText = [self getAttrText:@"活跃天数 0 天"];
    [tipsView addSubview:titleLable];
    
    signinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signinBtn.alpha = 1;
    signinBtn.enabled = YES;
    [signinBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signinBtn addTarget:self action:@selector(viewGoSignin:) forControlEvents:UIControlEventTouchUpInside];
    signinBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    signinBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 15, 60, 30);
    signinBtn.backgroundColor = MAIN_NAV_COLOR;
    [tipsView addSubview:signinBtn];
    [signinBtn setClipsToBounds: YES];
    [signinBtn.layer setCornerRadius:5.0f];
    [signinBtn.layer setBorderWidth:0.5];
    [signinBtn.layer setBorderColor:[MAIN_NAV_COLOR CGColor]];
    
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0,59.0f, SCREEN_WIDTH, 1.0f);
    [self.layer addSublayer:lineLayer];
    [lineLayer setBackgroundColor:[MAIN_LINE_COLOR CGColor]];
    
    _isSigninArr = [NSMutableArray array];
    for (int i = 1; i < 32 ; i ++) {
        BOOL isSign = NO;
        NSDictionary * dic = @{@"isSingin":[NSString stringWithFormat:@"%d",isSign]};
        [_isSigninArr addObject:dic];
    }

    CGFloat itemWidth = SCREEN_WIDTH / 7;
    CGFloat itemHeight = SCREEN_WIDTH / 7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    _JFCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [_JFCollectionView registerClass:[JFCollectionViewCell class] forCellWithReuseIdentifier:JFCalendarCellIdentifier];
    _JFCollectionView.frame = CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_WIDTH);
    _JFCollectionView.backgroundColor = [UIColor whiteColor];
    _JFCollectionView.delegate = self;
    _JFCollectionView.dataSource  =self;
    [self addSubview:_JFCollectionView];
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

-(NSMutableAttributedString *)getAttrText:(NSString * )titleText
{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleText];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont boldSystemFontOfSize:20.0f]
     
                          range:NSMakeRange(4,3)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:MAIN_NAV_COLOR
     
                          range:NSMakeRange(4, 3 )];
        
    return AttributedStr;
}

#pragma mark - Public Method

-(void)reloadDateData:(NSArray *)arr;
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [dateFormatter stringFromDate:_today];

    _isSigninArr = [NSMutableArray array];
    for (int i = 1; i < 32 ; i ++) {
        BOOL isSign = NO;
        for (int j = 0; j < arr.count; j ++) {
            NSDictionary * dic = arr[j];
            NSString * dayStr = [[dic objectForKey:@"SIGNINDATE"] substringWithRange:NSMakeRange(8, 2)];
            if (i == [dayStr integerValue]) {
                isSign = YES;
                if([todayString isEqualToString:[[dic objectForKey:@"SIGNINDATE"] substringToIndex:10]]){
                    signinBtn.alpha = 0.3;
                    signinBtn.enabled = NO;
                    [signinBtn setTitle:@"已签到" forState:UIControlStateNormal];
                }
            }
        }
        NSDictionary * dic = @{@"isSingin":[NSString stringWithFormat:@"%d",isSign]};
        [_isSigninArr addObject:dic];
    }

    titleLable.attributedText = [self getAttrText:[NSString stringWithFormat:@"活跃天数 %ld 天",(long)arr.count]];

    [_JFCollectionView reloadData];
}

-(void)signinSuccess
{
    signinBtn.alpha = 0.3;
    signinBtn.enabled = NO;
    [signinBtn setTitle:@"已签到" forState:UIControlStateNormal];
    
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HHmmss"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSDate * date =[[NSDate alloc]init];
    date =[df dateFromString:[ZEUtil getCurrentDate:@"yyyy-MM-dd HHmmss"]];
    self.date = date;
    
    [monthBtn setTitle:[ZEUtil getCurrentDate:@"yyyy-MM"] forState:UIControlStateNormal];
}
#pragma mark - date
//这个月的天数
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//第几月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

//年份
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

//这个月的第一天是周几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}



//这个月有几天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

//上个月的的时间
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//下一个月的时间
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//下一个月的时间
- (NSDate*)userChoosedMonth:(NSDate *)date withMonth:(NSString *)monthStr{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = [monthStr integerValue];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JFCalendarCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
        cell.dateLabel.textColor = [UIColor brownColor];
    } else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            [cell.dateLabel setText:@""];
            cell.dateLabel.backgroundColor = [UIColor whiteColor];
        }else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.dateLabel setText:@""];
            cell.dateLabel.backgroundColor = [UIColor whiteColor];
        }else{
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.dateLabel setTextColor:[ZEUtil colorWithHexString:@"#6f6f6f"]];
            [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];

            cell.isSignin = [_isSigninArr[day-1] objectForKey:@"isSingin"] ;
            //this month
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *todayString = [dateFormatter stringFromDate:_today];
            NSString *dateString = [dateFormatter stringFromDate:self.date];
//            if ([_today isEqualToDate:_date]) {
            if ([todayString isEqualToString:dateString]) {
                if ([[_isSigninArr[day-1] objectForKey:@"isSingin"] boolValue])  {
                    [cell.dateLabel setBackgroundColor:MAIN_NAV_COLOR];
                    cell.dateLabel.textColor = [UIColor whiteColor];
                }else{
                    [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
                }

                if (day == [self day:_date]) {
                    cell.dateLabel.textColor = [UIColor redColor];
                } else if (day > [self day:_date]) {
                    [cell.dateLabel setTextColor:[UIColor blackColor]];
                    [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
                }
                
            } else if ([_today compare:_date] == NSOrderedAscending) {
                [cell.dateLabel setTextColor:[UIColor blackColor]];
                [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
            }else{
                if ([[_isSigninArr[day-1] objectForKey:@"isSingin"] boolValue])  {
                    [cell.dateLabel setBackgroundColor:MAIN_NAV_COLOR];
                    cell.dateLabel.textColor = [UIColor whiteColor];
                }else{
                    [cell.dateLabel setBackgroundColor:[UIColor whiteColor]];
                }
            }
        }
    }
    return cell;
}

- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
//        [self customInterface];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    
    if(day <= 0){
        return;
    }
    if (day > [self day:_date]){
        NSLog(@"时间还没到");
    }else if ([[_isSigninArr[day-1] objectForKey:@"isSingin"] boolValue] )  {
        NSLog(@"已签到过的");
    }else{
        if (self.calendarBlock) {
            self.calendarBlock(day, [comp month], [comp year]);
        }
    }
}

- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextButton:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(priviousButton:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}



- (void)priviousButton:(id)sender {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *destDateString = [dateFormatter stringFromDate:self.date];

        if ([self.delegate respondsToSelector:@selector(reloadDataWithMonth:)]) {
            [self.delegate reloadDataWithMonth:destDateString];
        }
    } completion:nil];

}
//
- (void)nextButton:(id)sender {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *destDateString = [dateFormatter stringFromDate:self.date];
        if ([self.delegate respondsToSelector:@selector(reloadDataWithMonth:)]) {
            [self.delegate reloadDataWithMonth:destDateString];
        }
    } completion:nil];
}

-(void)viewGoSignin:(UIButton *)btn
{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(goSignin)]) {
        [self.delegate goSignin];
    }
}


#pragma mark - SHOWALERTVIEW
-(void)chooseMonth
{
    ZEChooseMonthView * showTypeView = [[ZEChooseMonthView alloc]initWithFrame:CGRectZero];
    showTypeView.delegate = self;
    _alertView = [[JCAlertView alloc]initWithCustomView:showTypeView dismissWhenTouchedBackground:YES];
    [_alertView show];
}

#pragma mark - ZEChooseMonthViewDelegate
-(void)cancelChooseCount
{
    [_alertView dismissWithCompletion:nil];
}

-(void)confirmChooseCount:(NSString *)countStr
{
    [_alertView dismissWithCompletion:nil];
    [monthBtn setTitle:[NSString stringWithFormat:@"%@",countStr] forState:UIControlStateNormal];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HHmmss"];
    NSString *destDateString = [dateFormatter stringFromDate:self.date];

    [dateFormatter setDateFormat:@"yyyy-MM"];
    
    NSString * choosedDate =[destDateString stringByReplacingCharactersInRange:NSMakeRange(0, 10) withString:[NSString stringWithFormat:@"%@-28",countStr]];

    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HHmmss"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSDate * date =[[NSDate alloc]init];
    date =[df dateFromString:choosedDate];

    self.date = date;
    NSLog(@" %@ ",self.date);

    [dateFormatter setDateFormat:@"yyyy-MM"];
    
    NSString *choosedMonthStr = [dateFormatter stringFromDate:self.date];

    NSLog(@" %@ ",choosedMonthStr);
    
    if ([self.delegate respondsToSelector:@selector(reloadDataWithMonth:)]) {
        [self.delegate reloadDataWithMonth:choosedMonthStr];
    }
}

@end
