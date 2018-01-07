//
//  INFCheckSuccessViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/2.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFCheckSuccessViewController.h"

@interface INFCheckSuccessViewController ()
@property (strong, nonatomic) IBOutlet UILabel *checkTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *ampmSymble;

@end

@implementation INFCheckSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.AMSymbol = @"AM";
    dateFormat.PMSymbol = @"PM";
    [dateFormat setDateFormat:@"hh:ss aaa"];
    NSString *timeStr = [dateFormat stringFromDate:currentDate];
    NSLog(@"time : %@",[timeStr substringToIndex:5]);
    NSLog(@"am/pm :%@",[timeStr substringFromIndex:6]);
    
    self.checkTimeLab.text = [timeStr substringToIndex:5];
    self.ampmSymble.text = [timeStr substringFromIndex:6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
