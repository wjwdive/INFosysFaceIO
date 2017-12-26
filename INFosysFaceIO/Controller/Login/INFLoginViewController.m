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

//#define FACE_CHECK_URL @"http://infosys.com/faceCheck"
static const NSString *faceCheckUrl = @"http://infosys.com/faceCheck";
extern NSInteger userStatus;
@interface INFLoginViewController ()<UITextFieldDelegate>
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
}
//user  对象初始化
- (INFUser *)user{
    if (!_user) {
        _user = [[INFUser alloc] init];
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
    userStatus = 2;
    if (userStatus == 1) {
        if ((_user.userName != nil || _user.userNo != nil) && _user.password) {
            [self doPostLogin];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caution" message:@"please input your userName&password or userNo&password" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles: nil];
            [alert show];
        }
    }else {
        //用户登陆成功过，且本地存储了 token
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        NSString *token = [defaults integerForKey:@"token"];
        [self doPostLogin];
    }
    
}
#pragma mark - 本地保存token
//登录请求
- (void)doPostLogin {
    NSLog(@"userStatus in login vc:%ld", userStatus);
    if (userStatus == 1) {
        NSDictionary *params = @{
                                 @"userName":_user.userNo,
                                 @"userNo":_user.userNo,
                                 @"password":_user.password
                                 };
        
        [NetWorkManager requestWithType:1
                          withUrlString:faceCheckUrl withParaments:params
                       withSuccessBlock:^(NSDictionary *responseObject) {
                           NSLog(@"请求成功：%@",responseObject);
                           //                       todo
//                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                           NSString *token = responseObject.tocken;
//                           [defaults setObject:token forKey:@"token"];
//                           返回到 扫脸界面
                       }
                       withFailureBlock:^(NSError *error) {
                           NSLog(@"请求失败：%@",error);
                       }
                               progress:^(float progress) {
                                   NSLog(@"请求过程");
                               }];
    }else {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *token = [defaults integerForKey:@"token"];
        NSDictionary *params = @{@"token":@"token.............."};
        [NetWorkManager requestWithType:1
                          withUrlString:faceCheckUrl
                          withParaments:params
                       withSuccessBlock:^(NSDictionary *responseObject) {
                            NSLog(@"请求成功：%@",responseObject);
                    }
                       withFailureBlock:^(NSError *error) {
                            NSLog(@"请求失败：%@",error);
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
