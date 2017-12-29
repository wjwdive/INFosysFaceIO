//
//  AttendanceViewController.m
//  INFosysFaceIO
//
//  Created by Infosys Ltd. on 2017/12/27.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "AttendanceViewController.h"
#import "YXCalendarView.h"
#import "AttendanceCell.h"
#import "AttendanceModel.h"

@interface AttendanceViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YXCalendarView *calendar;
@property (nonatomic, strong) UIView *calendarBottomView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userName;

@end

@implementation AttendanceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *dayItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_today"] style:UIBarButtonItemStylePlain target:self action:@selector(todayClick)]; 
    [dayItem setImageInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    UIBarButtonItem *dateItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_date"] style:UIBarButtonItemStylePlain target:self action:@selector(dateClick)];
    
    self.navigationItem.rightBarButtonItems = @[dateItem, dayItem];
}

- (void)todayClick {
    
}

- (void)dateClick {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"考勤查询";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    [self loadMocData];
}

- (void)loadMocData {
    _datas = [NSMutableArray arrayWithCapacity:0];
    AttendanceModel *model1 = [[AttendanceModel alloc] init];
    model1.time = @"08:50";
    model1.state = @"进入";
    [_datas addObject:model1];
    
    AttendanceModel *model2 = [[AttendanceModel alloc] init];
    model2.time = @"11:45";
    model2.state = @"离开";
    [_datas addObject:model2];
    
    AttendanceModel *model3 = [[AttendanceModel alloc] init];
    model3.time = @"13:00";
    model3.state = @"进入";
    [_datas addObject:model3];
    
    AttendanceModel *model4 = [[AttendanceModel alloc] init];
    model4.time = @"18:00";
    model4.state = @"离开";
    [_datas addObject:model4];
    
    [self.tableView reloadData];
}

- (void)configUI { 
    UIView *topImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    topImageView.backgroundColor = [UIColor colorWithHexString:@"#017ec5"];
    topImageView.layer.cornerRadius = 2;
    topImageView.layer.masksToBounds = YES;
    [self.view addSubview:topImageView];
    
    _userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-1"]];
    [topImageView addSubview:_userIcon];
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-12);
        make.height.width.mas_equalTo(40);
    }];
    
    _userName = [[UILabel alloc] init];
    _userName.text = @"Feng.Li";
    _userName.textColor = [UIColor whiteColor];
    [topImageView addSubview:_userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIcon.mas_right).offset(10);
        make.centerY.equalTo(_userIcon);
    }];
    
    _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, topImageView.maxY - 30, [UIScreen mainScreen].bounds.size.width, [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Week]) Date:[NSDate date] Type:CalendarType_Week];
    _calendarBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _calendar.maxY - 30, self.view.width, 12)];
    _calendarBottomView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [_calendar addSubview:_calendarBottomView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 12);
    [button setImage:[UIImage imageNamed:@"AttendancePull"] forState:UIControlStateNormal];
    button.centerX = _calendarBottomView.centerX;
    [_calendarBottomView addSubview:button];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _calendar.maxY + 12, self.view.width, kScreenH - _calendar.maxY + 12) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.userInteractionEnabled = NO;
    [self.view addSubview:_tableView];
    
    __weak typeof (_calendarBottomView) weakCalendarBottomView = _calendarBottomView;
    __weak typeof(_calendar) weakCalendar = _calendar;
    __weak typeof (_tableView) weakTableView = _tableView;
    
    //刷新状态
    _calendar.refreshH = ^(CGFloat viewH) {
        [UIView animateWithDuration:0.3 animations:^{
            weakCalendar.frame = CGRectMake(0, topImageView.maxY - 30, [UIScreen mainScreen].bounds.size.width, viewH);
            weakCalendarBottomView.frame = CGRectMake(0, weakCalendar.maxY - 30, kScreenW, 12);
            weakTableView.frame = CGRectMake(0, weakCalendar.maxY + 12, kScreenW, kScreenH - weakCalendar.maxY + 12);
        }];
    };
    _calendar.sendSelectDate = ^(NSDate *selDate) {
        NSLog(@"%@",[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate]);
    };
    [self.view addSubview:_calendar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttendanceCell *cell = [AttendanceCell cellWithTableView:tableView];
    cell.model = _datas[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AttendanceCell cellHeight];
}

@end
