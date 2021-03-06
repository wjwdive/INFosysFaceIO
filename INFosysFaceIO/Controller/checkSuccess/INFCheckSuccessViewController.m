//
//  INFCheckSuccessViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/2.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFCheckSuccessViewController.h"
#import "NSString+Utils.h"

@interface INFCheckSuccessViewController ()
@property (strong, nonatomic) IBOutlet UILabel *checkTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *ampmSymble;

@end

@implementation INFCheckSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *timeDic = [NSString getCurrentTime];
    self.checkTimeLab.text = [timeDic objectForKey:@"time"];
    self.ampmSymble.text = [timeDic objectForKey:@"ampm"];
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
