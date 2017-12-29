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

@end

@implementation AttendanceViewController

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
}

- (void)configUI {
    _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Week]) Date:[NSDate date] Type:CalendarType_Week];
    
    _calendarBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 12)];
    _calendarBottomView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [_calendar addSubview:_calendarBottomView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 12);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    button.centerX = _calendarBottomView.centerX;
    [_calendarBottomView addSubview:button];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _calendar.maxY + 12, self.view.width, kScreenH - _calendar.maxY + 12) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak typeof (_calendarBottomView) weakCalendarBottomView = _calendarBottomView;
    __weak typeof(_calendar) weakCalendar = _calendar;
    __weak typeof (_tableView) weakTableView = _tableView;
    
    //刷新状态
    _calendar.refreshH = ^(CGFloat viewH) {
        [UIView animateWithDuration:0.3 animations:^{
            weakCalendar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewH);
        }];
        if (viewH == 100) {
            weakCalendarBottomView.frame = CGRectMake(0, weakCalendar.maxY, kScreenW, 12);
            weakTableView.frame = CGRectMake(0, weakCalendar.maxY + 12, kScreenW, kScreenH - weakCalendar.maxY + 12);
            
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                weakCalendarBottomView.frame = CGRectMake(0, weakCalendar.maxY, kScreenW, 12);
                weakTableView.frame = CGRectMake(0, weakCalendar.maxY + 12, kScreenW, kScreenH - weakCalendar.maxY + 12);
            }];
        }
    };
    _calendar.sendSelectDate = ^(NSDate *selDate) {
        NSLog(@"%@",[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate]);
    };
    [self.view addSubview:_calendar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
