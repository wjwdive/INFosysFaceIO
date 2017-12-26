//
//  INFHomeViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "AppDelegate.h"

#import "INFHomeViewController.h"
#import "INFMyViewController.h"
#import "INFLoginViewController.h"
#import "INFCheckViewController.h"

extern NSInteger userStatus;
@interface INFHomeViewController ()

@end

@implementation INFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoMyVC:(id)sender {
    INFMyViewController *myVC = [self.storyboard instantiateViewControllerWithIdentifier:@"INFMyViewController"];
    [self presentViewController:myVC animated:YES completion:^{
        NSLog(@"跳转到MyVC");
    }];
}

- (IBAction)scanBtnAction:(id)sender {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    extern NSInteger userStatus;
//    = [defaults integerForKey:@"userStatus"];
    NSLog(@"scanBtn userStatus:%ld",userStatus);
    switch (userStatus) {
        case 1:
            NSLog(@"用户未登录，请先登录");
            [self gotoLoginVC];
            break;
        case 2:
            NSLog(@"用户登录成功，但是未注册人脸，请先注册人脸");
            [self gotoCheckFaceVC];
            break;
        case 3:
            NSLog(@"用户已经登陆成功，可以直接刷脸打卡");
        default:
            break;
    }
}
//跳转到LoginVC
- (void)gotoLoginVC {
    INFLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"INFLoginViewController"];
    NSLog(@"LginVC:%@",loginVC);
    [self presentViewController:loginVC animated:YES completion:^{
        NSLog(@"跳转到LoginVC");
    }];
}
//跳转到CHeckfaceVC
- (void)gotoCheckFaceVC {
    INFCheckViewController *checkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"INFCheckViewController"];
    [self presentViewController:checkVC animated:YES completion:^{
        NSLog(@"跳转到chechkVC");
    }];
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
