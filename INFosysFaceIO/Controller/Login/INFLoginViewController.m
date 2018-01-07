//
//  INFLoginViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//
//#import "AppDelegate.h"
#import "INFLoginViewController.h"
#import "INFUser.h"
#import "NetWorkManager.h"
#import "MBProgressHUD/MBProgressHUD.h"

//#define FACE_CHECK_URL @"http://infosys.com/faceCheck"
static NSString *faceCheckUrl = @"facade/faceClockFacade";
static NSString *loginUrl = @"loginfacade/loginFacade";
extern NSInteger userStatus;
@interface INFLoginViewController ()<UITextFieldDelegate>{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userNoTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (nonatomic, strong) INFUser *user;
@property (nonatomic, strong) NetWorkManager *netManager;

@end

@implementation INFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self user];
    [self netManager];
    
    self.userNoTF.delegate = self;
    self.userNameTF.delegate = self;
    self.passwordTF.delegate = self;
    //测试 时间
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    dateFormat.AMSymbol = @"AM";
//    dateFormat.PMSymbol = @"PM";
//    [dateFormat setDateFormat:@"hh:ss aaa"];
//    NSString *timeStr = [dateFormat stringFromDate:currentDate];
//    NSLog(@"time : %@",[timeStr substringToIndex:5]);
//    NSLog(@"am/pm :%@",[timeStr substringFromIndex:6]);
    
    
    
}
//user  对象初始化
- (INFUser *)user{
    if (!_user) {
        _user = [[INFUser alloc] init];
        _user.userName = @"";
        _user.userNo = @"";
        _user.password = @"";
     }
    return _user;
}

//netWork manager
- (NetWorkManager *)netManager {
    if (!_netManager) {
        _netManager = [NetWorkManager shareManager];
    }
    return _netManager;
}
//点击view，隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//textFiled 结束编辑 修改_user的各个属性值。
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFiled end editing");
    if ([textField isEqual:self.userNameTF]) {
        _user.userName = textField.text;
    }else if([textField isEqual:self.userNoTF]){
        _user.userNo = textField.text;
    }else {
        _user.password = textField.text;
    }
}


//登录按钮 事件
- (IBAction)loginBtnAction:(id)sender {
    //用户从未登陆过
    userStatus = 1;
    if (userStatus == 1) {
        if ((self.userNameTF.text.length != 0   && self.passwordTF.text.length !=0 ) || (self.userNoTF.text.length !=0 && self.passwordTF.text.length != 0)) {
        
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在请求登录";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //登录操作
        [self doPostLogin];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        });
        }else {
            //若用户没有输入用户名和密码，给出提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caution" message:@"please input your userName&password or userNo&password" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles: nil];
            [alert show];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.margin = 10.f;
////            hud.yOffset = 150.f;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.label.text = @"please input your userName&password or userNo&password";
//            [hud hideAnimated:YES afterDelay:1.5];
        }
    }else {
        //用户登陆成功过，且本地存储了 token
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        NSString *token = [defaults integerForKey:@"token"];
        [self doPostLogin];
    }
    
}
#pragma mark - 本地保存token

//第一次登录
- (void)firstLogin {
    NSDictionary *params = @{
                             //                                 @"empid":_user.userNo,
                             //                                 @"userNo":_user.userNo,
                             @"password":_user.password,
                             @"empid":_user.userNo,
                             @"password":_user.userName
                             };
    
    [NetWorkManager requestWithType:1
                      withUrlString:loginUrl withParaments:params
                   withSuccessBlock:^(NSDictionary *responseObject) {
                       NSLog(@"请求成功：%@",responseObject);
                       NSString *token = [responseObject objectForKey:@"token"];
                       NSLog(@"token %@",token);
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       [defaults setObject:token forKey:@"token"];
                       //返回到 扫脸界面
                       userStatus = 2;
                       [defaults setInteger:userStatus forKey:@"userStatus"];
                       [defaults setObject:[params valueForKey:@"empid"] forKey:@"empid"];
                       [defaults setObject:[params valueForKey:@"userName"] forKey:@"userName"];
                       [defaults synchronize];
                   }
                   withFailureBlock:^(NSError *error) {
                       NSLog(@"请求失败：%@",error);
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       userStatus = 1;
                       [defaults setInteger:userStatus forKey:@"userStatus"];
                       [defaults synchronize];
                   }
                           progress:^(float progress) {
                               NSLog(@"请求过程");
                           }];
}

//第二次登录，不用账号和密码，自动登录。登录成功跳转到。这里应该放到 AppDelegate或者home页比较好。自动登录时不显示登录界面
- (void)autoLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSDictionary *params = @{@"token":token};
    [NetWorkManager requestWithType:1
                      withUrlString:faceCheckUrl
                      withParaments:params
                   withSuccessBlock:^(NSDictionary *responseObject) {
                       NSLog(@"token 登录 请求成功：%@",responseObject);
                   }
                   withFailureBlock:^(NSError *error) {
                       NSLog(@"token 登录 请求失败：%@",error);
                   }
                           progress:^(float progress) {
                               NSLog(@"请求过程");
                           }];
    [NSThread sleepForTimeInterval:1.5];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//登录请求
- (void)doPostLogin {
    NSLog(@"userStatus in login vc:%ld", userStatus);
    if (userStatus == 1) {
        NSDictionary *params = @{
//                                 @"empid":_user.userNo,
//                                 @"userNo":_user.userNo,
                                 @"password":_user.password,
                                 @"empid":_user.userNo,
                                 @"password":_user.userName
                                 };
        
        [NetWorkManager requestWithType:1
                          withUrlString:loginUrl withParaments:params
                       withSuccessBlock:^(NSDictionary *responseObject) {
                           NSLog(@"请求成功：%@",responseObject);
                           NSString *token = [responseObject objectForKey:@"token"];
                           NSLog(@"token %@",token);
                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                           [defaults setObject:token forKey:@"token"];
                           //返回到 扫脸界面
                           userStatus = 2;
                           [defaults setInteger:userStatus forKey:@"userStatus"];
                           [defaults setObject:[params valueForKey:@"empid"] forKey:@"empid"];
                           [defaults setObject:[params valueForKey:@"userName"] forKey:@"userName"];
                           [defaults synchronize];
                       }
                       withFailureBlock:^(NSError *error) {
                           NSLog(@"请求失败：%@",error);
                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                           userStatus = 1;
                           [defaults setInteger:userStatus forKey:@"userStatus"];
                           [defaults synchronize];
                       }
                               progress:^(float progress) {
                                   NSLog(@"请求过程");
                               }];
    }else {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *token = [defaults integerForKey:@"token"];
        NSDictionary *params = @{@"token":@"ad108004-a1ba-4d2e-83e5-3a7b5d1a8963"};
        [NetWorkManager requestWithType:1
                          withUrlString:faceCheckUrl
                          withParaments:params
                       withSuccessBlock:^(NSDictionary *responseObject) {
                            NSLog(@"token 登录 请求成功：%@",responseObject);
                    }
                       withFailureBlock:^(NSError *error) {
                            NSLog(@"token 登录 请求失败：%@",error);
                       }
                               progress:^(float progress) {
                                   NSLog(@"请求过程");
                               }];
    }
    
    [NSThread sleepForTimeInterval:1.5];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
