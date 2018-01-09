//
//  INFLoginSuccessViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/8.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFLoginSuccessViewController.h"
#import "NSString+Utils.h"

@interface INFLoginSuccessViewController ()
@property (strong, nonatomic) IBOutlet UILabel *usrNameLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *ampmLab;
@property (strong, nonatomic) IBOutlet UILabel *scoreLab;

@end

@implementation INFLoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _usrNameLab.text = [NSString stringWithFormat:@"%@ %@ ",@"Welcome",_userName];
    _scoreLab.text = [NSString stringWithFormat:@"%@ %@",@"Similarity Score: ",_score];
    NSLog(@" score %@", _score);
    
    NSDictionary *timeDic = [NSString getCurrentTime];
    self.timeLab.text = [timeDic objectForKey:@"time"];
    self.ampmLab.text = [timeDic objectForKey:@"ampm"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navToRoot)];
    [self.view addGestureRecognizer:tap];
    
    //设置导航栏
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.hidden = YES;
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    //去掉navbarbtn 文字
//    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
//    //设置
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

- (void)navToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
