//
//  AttendanceView.m
//  INFosysFaceIO
//
//  Created by Infosys Ltd. on 2017/12/27.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "AttendanceView.h"
#import "BXHCalendarView.h"
#import "NSDate+BXHCalendar.h"
#import "NSDate+BXHCategory.h"

@interface AttendanceView () <BXHCalendarViewDelegate>

@property (nonatomic, strong) BXHCalendarView *calendarView;

@property (nonatomic, strong) UIButton *todayBtn;

@property (nonatomic, strong) UIButton *typeButton;

@end

@implementation AttendanceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    
    return self;
}

- (void)configUI {
    CGFloat itemWH = self.frame.size.width / 7;
    self.calendarView = [[BXHCalendarView alloc] initWithFrame:CGRectMake(0, 88, self.bounds.size.width, itemWH * CalendarDayView_HW_Ration * 6 + 30)];
    self.calendarView.delegate = self;
    [self addSubview:self.calendarView];
}

//- (void)viewWillLayoutSubviews
//{
//    self.todayBtn.frame = CGRectMake(30, CGRectGetMaxY(self.calendarView.frame) + 10, 80, 30);
//    self.typeButton.frame = CGRectMake(150, CGRectGetMaxY(self.calendarView.frame) + 10, 80, 30);
//
//    [super viewWillLayoutSubviews];
//}

- (void)todayButtonAction {
    [self.calendarView goToToday];
}

- (void)typeBUttonAction {
    CGFloat itemWH = self.frame.size.width / 7;
    BXHCalendarDisplayType type = self.calendarView.displayType == BXHCalendarDisplayWeekType ? BXHCalendarDisplayMonthType : BXHCalendarDisplayWeekType;
    [self.calendarView changeDisplayType:type animated:YES];
    CGRect frame = self.calendarView.frame;
    if (type == BXHCalendarDisplayWeekType)
    {
        frame.size.height = itemWH + 30;
    }
    else
    {
        frame.size.height = itemWH * CalendarDayView_HW_Ration * 6 + 30;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.calendarView.frame = frame;
    }];
    
}

- (void)calendarView:(BXHCalendarView *)calendarView didSelectDayView:(BXHCalendarDayView *)dayView {
    
    NSLog(@"select %@",[dayView.date bxh_stringWithFormate:@"yyyy-MM-dd"]);
}

@end
