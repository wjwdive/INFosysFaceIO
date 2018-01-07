//
//  INFRegisterViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/5.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFRegisterViewController.h"
#import "INFRegisterView.h"
#import <IQKeyboardManager.h>
#import "UIImage+Utils.h"
#import "NetWorkManager.h"
#import "MBProgressHUD/MBProgressHUD.h"

NSString *registerUrl = @"loginfacade/registerUserFacade";

@interface INFRegisterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIButton *_takePhotoBtn;
    UIImagePickerController *_imagePickerController;
    NSString *userName;
    NSString *password;
    NSString *userNo;
}

@end

@implementation INFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configOtherUI];
    
    //设置导航栏
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.hidden = NO;
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    //去掉navbarbtn 文字
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    //设置
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)configOtherUI {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [bgImageView addSubview:backButton];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.width.height.mas_equalTo(14);
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [bgImageView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.text = @"Time Attendance";
    subTitle.textColor = [UIColor whiteColor];
    [bgImageView addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor whiteColor];
    title.text = @"人 脸 识 别 考 勤 系 统";
    title.font = [UIFont systemFontOfSize:20];
    [bgImageView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitle.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    UIView *bgMidleView = [[UIView alloc] init];
    bgMidleView.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:bgMidleView];
    bgMidleView.layer.cornerRadius = 5;
    bgMidleView.layer.masksToBounds = YES;
    [bgMidleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(80);
        make.left.mas_equalTo(54);
        make.right.mas_equalTo(-54);
        make.bottom.mas_equalTo(-100);
    }];
    
    _takePhotoBtn = [[UIButton alloc] init];
    _takePhotoBtn.layer.cornerRadius = 40;
    _takePhotoBtn.layer.masksToBounds = YES;
    _takePhotoBtn.layer.borderWidth = 5;
    _takePhotoBtn.layer.borderColor = [UIColor whiteColor].CGColor;

    NSString *imageString = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoto"];
    
    UIImage *takePhotoImage;
    if (imageString) {
        // 将base64字符串转为NSData
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:imageString options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        // 将NSData转为UIImage
        takePhotoImage = [UIImage imageWithData: decodeData];
    } else {
        takePhotoImage = [UIImage imageNamed:@"图层38"];
    }
    [_takePhotoBtn setImage:takePhotoImage forState:UIControlStateNormal];
    [bgImageView addSubview:_takePhotoBtn];
    [_takePhotoBtn addTarget:self action:@selector(takePhotoBtn) forControlEvents:UIControlEventTouchUpInside];
    [_takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(bgMidleView.mas_top);
        make.width.height.mas_equalTo(80);
    }];
    
    NSArray *imageNames = @[@"username-1", @"password-1", @"ID-1"];
    NSArray *placeHolds = @[@" UserName", @" Password", @" Employee Number"];
    for (int i = 0; i < 3; i ++) {
        NSInteger tagId = 1001 +i;
        INFRegisterView *textField = [[INFRegisterView alloc] initWithFrame:CGRectZero imageName:imageNames[i] placeHold:placeHolds[i] tagId:tagId];
        textField.textField.tag = tagId;
        if (i == 1) {
            textField.textField.secureTextEntry = YES;
            textField.passValueBlock = ^(NSString *str){
                NSLog(@"block 传回的值1 %@",str);
                password = str;
            };
        }
        if (i == 2) {
            textField.textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.passValueBlock = ^(NSString *str){
                NSLog(@"block 传回的值2 %@",str);
                userNo = str;
            };
        }
        if (i == 0) {
            textField.passValueBlock = ^(NSString *str){
                NSLog(@"block 传回的值0 %@",str);
                userName = str;
            };
        }
        [bgMidleView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(67 + 40*i);
            make.centerX.equalTo(bgImageView);
            make.left.mas_equalTo(21);
            make.right.mas_equalTo(-21);
            make.height.mas_equalTo(30);
        }];
    }
    
    UIButton *registButton = [[UIButton alloc] init];
    [registButton setTitle:@"Register" forState:UIControlStateNormal];
    registButton.backgroundColor = [UIColor colorWithHexString:@"#1b86e7"];
    registButton.layer.cornerRadius = 5;
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    registButton.layer.masksToBounds = YES;
    [bgMidleView addSubview:registButton];
    [registButton addTarget:self action:@selector(registerPress) forControlEvents:UIControlEventTouchUpInside];
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
}

- (void)takePhotoBtn {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    _imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    _imagePickerController.allowsEditing = YES;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)registerPress {
    if (userName.length == 0) {
//        userName = @"666";
        
        
    }
    if (userNo.length == 0) {
        userNo = userName;
    }
    if (password.length == 0) {
        password = userName;
    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *imgBase64 = [def objectForKey:@"userPhoto"];
    NSDictionary *params = @{@"username" : userName,
                             @"empid" : userNo,
                             @"password" : userName,
                             @"image" : imgBase64,
                             @"firstname":@"",
                             @"lastname":@"",
                             @"namec":@"",
                             @"namej":@"",
                             @"sex":@"male",
                             @"phone":@"",
                             @"mobile":@"",
                             @"address":@"",
                             @"address1":@"",
                             @"confirmpassword":userName,
                                 };
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在注册..";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [NetWorkManager  requestWithType:1 withUrlString:registerUrl withParaments:params
                        withSuccessBlock:^(NSDictionary *responseObject) {
                            NSLog(@"responseObject %@", responseObject);
                            NSLog(@"注册新用户成功");
                            [hud hideAnimated:YES];
                            
                            MBProgressHUD *hudCaution = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            hudCaution.label.text = @"注册成功！";
                            [hudCaution hideAnimated:YES afterDelay:2];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } withFailureBlock:^(NSError *error) {
                            NSLog(@"error reason: %@",error);
                            NSLog(@"新用户注册失败");
                            [hud hideAnimated:YES];
                            
                            MBProgressHUD *hudCaution = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            hudCaution.label.text = @"注册失败！";
                            [hudCaution hideAnimated:YES afterDelay:2];
                            [hud hideAnimated:YES];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } progress:^(float progress) {
                            
                        }];
    });
    
    

    
}

- (void)backClick {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"拍完照片回调");
    
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    //获取原始照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //压缩 到 100k
        NSData *compressedImgData = [UIImage compressOriginalImage:image toMaxDataSizeKBytes:100.0];
        NSString *faceImgBase64str = [compressedImgData base64EncodedStringWithOptions:0];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:faceImgBase64str forKey:@"userPhoto"];
        [def synchronize];
    });

    [_takePhotoBtn setImage:image forState:UIControlStateNormal];
}
@end
