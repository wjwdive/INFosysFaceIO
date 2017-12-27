//
//  AttendanceViewController.m
//  INFosysFaceIO
//
//  Created by Infosys Ltd. on 2017/12/27.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "AttendanceViewController.h"
#import "AttendanceView.h"

@interface AttendanceViewController ()

@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤查询";
    self.view.backgroundColor = [UIColor whiteColor];
    AttendanceView *view = [[AttendanceView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:view];
}

@end
