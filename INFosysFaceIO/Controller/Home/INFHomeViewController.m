//
//  INFHomeViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "AppDelegate.h"

#import "BaseNavigationController.h"
#import "INFCameraOverlayView.h"
#import "INFOverlayViewController.h"
#import "INFHomeViewController.h"
#import "INFMyViewController.h"
#import "INFLoginViewController.h"
#import "INFCheckViewController.h"
#import "INFCheckSuccessViewController.h"
#import "INFRegisterFaceViewController.h"
#import "NetWorkManager.h"
#import "UIImage+Utils.h"
#import "MBProgressHUD/MBProgressHUD.h"

#import "INFRegisterViewController.h"

extern NSInteger userStatus;
NSString *registeFaceUrl = @"facade/registerUserFacade";
NSString *chechFaceUrl = @"facade/faceClockFacade";
@interface INFHomeViewController ()<takePhotoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) INFCameraOverlayView *overView;
//@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIImageView *scanImg;
@property (strong, nonatomic) IBOutlet UIImageView *barImg;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NetWorkManager *netManager;
@property (strong, nonatomic) NSData *faceImgData;
@property (strong, nonatomic) NSString *faceImgBase64str;

@end

@implementation INFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.imagePicker = [[UIImagePickerController alloc] init];
    //给图片 添加手势，失败 原因未知
//    UITapGestureRecognizer *tapTakePicture = [[UITapGestureRecognizer alloc] initWithTarget:self.scanImg action:@selector(takePhoto)];
//    [self.scanImg addGestureRecognizer:tapTakePicture];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoMyVC:(id)sender {
    INFMyViewController *myVC = [[INFMyViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:myVC];
    [self presentViewController:nav animated:YES completion:^{
        NSLog(@"跳转到MyVC");
    }];
}
//第一种方法，自定义界面、动画显得乏力
- (void)gotoCheckVCUseImgePicker {
    
    if (![self tokenValided]) {
        //未注册人脸
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caution" message:@"You haven't register your face or not login, pleace register FACE or login first" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles: nil];
            [alert show];
        return;
    }
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (!_imagePicker) {
            _imagePicker = [[UIImagePickerController alloc] init];
        }
        //代理
        _imagePicker.delegate = self;
        //类型
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        _imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //关闭闪光灯
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        //设置使用前置摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //隐藏系统相机操作
        _imagePicker.showsCameraControls = NO;
        _imagePicker.editing = NO;
        [[NSBundle mainBundle] loadNibNamed:@"INFCameraOverlayView" owner:self options:nil];
        //设定相机全屏
        CGSize screenBounds = [UIScreen mainScreen].bounds.size;
        CGFloat cameraAspectRatio = 4.0f/3.0f;
        CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
        CGFloat scale = screenBounds.height / camViewHeight;
        _imagePicker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        _imagePicker.cameraViewTransform = CGAffineTransformScale(_imagePicker.cameraViewTransform, scale, scale);
        self.overlayView.frame = _imagePicker.cameraOverlayView.frame;
        self.overlayView.backgroundColor = [UIColor clearColor];
        self.imagePicker.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
        //    _imagePicker.cameraOverlayView = [self customViewForImagePicker:_imagePicker];
        
        WeakObj(self);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:_imagePicker animated:YES completion:^{
                //            [selfWeak timerStart];
                NSTimer *timerTmp = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(takePhoto)  userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:timerTmp forMode:NSRunLoopCommonModes];
                
                [UIView animateWithDuration: 2 delay: 0.35 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations: ^{
                    [selfWeak.barImg layoutIfNeeded];
                    [selfWeak.barImg setFrame:CGRectMake(77, 383, 220, 4)];
                    selfWeak.scanImg.alpha = 0;
                } completion: ^(BOOL finished) {
                    [UIView animateWithDuration: 2 animations: ^{
                        selfWeak.scanImg.alpha = 1;
                    }];
                }];
            }];
        });
    } else {
        NSLog(@"照相机不可用");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caution" message:@"your camera is invalided, please check your camera!" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles: nil];
        [alert show];
    }
    
    
}
//第二种方法 用AVFoundation 自定义相机
- (void)gotoCheckVCUseAVSession {
    INFCheckViewController *checkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"INFCheckViewController"];
    [self presentViewController:checkVC animated:NO completion:^{
        NSLog(@"跳转到chechkVC");
    }];
}

//第三种方法
- (void)gotoCheckFaceUseNomalVC {
    INFOverlayViewController *overlayVC = [[INFOverlayViewController alloc] initWithNibName:@"INFOverlayViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:overlayVC animated:YES completion:nil];
    NSLog(@"跳转到overLay VC");
}

- (IBAction)scanBtnAction:(id)sender {
    
    [self gotoCheckVCUseImgePicker];
}

#pragma mark -- 界面跳转
//跳转到LoginVC
- (void)gotoLoginVC {
    INFLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"INFLoginViewController"];
    NSLog(@"LginVC:%@",loginVC);
    [self presentViewController:loginVC animated:YES completion:^{
        NSLog(@"跳转到LoginVC");
    }];
}

- (void)gotoRegisterVC {
    INFRegisterViewController *registerVC = [[INFRegisterViewController  alloc] init];
    [self presentViewController:registerVC animated:YES completion:^{
        
    }];
}
//跳转到CHeckfaceVC
//- (void)gotoCheckFaceVC {
//
//
//}

//加载自定义的View
- (UIView *)customViewForImagePicker:(UIImagePickerController *)imagePicker {
    _overView = [[[UINib nibWithNibName:@"INFCameraOverlayView" bundle:nil]instantiateWithOwner:nil options:nil]objectAtIndex:0];
    _overView.delegate = self;
    return  _overView;
}

#pragma mark -- 自定义tackPhotoDelegate
//拍照
- (void)takePhoto {
    NSLog(@" takePhoto in imagePicker");
    [_imagePicker takePicture];
}
//取消拍照
- (void)closeCamera {
    NSLog(@"代理方法 closeCamera 被调用");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)timerStart {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(takePhoto) userInfo:nil repeats:NO];
    }
}

- (void)removeTimer {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

#pragma mark - UIImagePickerController代理方法
//拍完照片的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"拍完照片回调");
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //如果是拍照
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image;
        //如果允许编辑则获得编辑后的照片， 否则获取原始照片
        if (self.imagePicker.allowsEditing) {
            //获取编辑后的照片
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else {
            //获取原始照片
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //        NSData *imageData = [iamge ]
//        NSData *imageData;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_imagePicker.cameraOverlayView animated:YES];
        hud.label.text = @"正在处理图片";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //压缩 到 500k
            NSData *compressedImgData = [UIImage compressOriginalImage:image toMaxDataSizeKBytes:100.0];
            _faceImgBase64str = [compressedImgData base64EncodedStringWithOptions:0];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:_faceImgBase64str forKey:@"userPhoto"];
            [def synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        });
        
        //相片获取成功之后 do post
        [self doPost];
        NSLog(@"do post");
        
        
        //保存到相册
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
//        [self removeTimer];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [_timer invalidate];
    [self removeTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (_imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
//    }
//}

//关闭刷脸界面
- (IBAction)cancleTakePhoto:(id)sender {
    [self removeTimer];
    [self imagePickerControllerDidCancel:_imagePicker];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

// userStatus = 2 的时候，为新注册人脸
- (void)registerFace {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userPhotoBase64Str = [defaults objectForKey:@"userPhoto"];
//    NSString *userPhotoBase64String = [userPhotoData base64EncodedStringWithOptions:0];
    NSString *token = [defaults objectForKey:@"token"];
//    DLog(@"Encode String Value: %@", base64String);

    NSDictionary *registerFaceParams = @{@"image":userPhotoBase64Str,
                                         @"token":token
                                         };
    
    
    [NetWorkManager requestWithType:1 withUrlString:registeFaceUrl withParaments:registerFaceParams withSuccessBlock:^(NSDictionary *responseObject) {
        //提示注册人脸成功，返回首页让用户登录，同时更新用户状态。为3
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:3 forKey:@"userStatus"];
        [defaults synchronize];
    } withFailureBlock:^(NSError *error) {
        //提示错误信息
        [self dismissViewControllerAnimated:YES completion:nil];
    } progress:^(float progress) {
        //显示进度
    }];
    
}

//userStatus = 3 的时候，用户已经登录且注册成功。用户点击刷脸进入刷脸打卡界面
- (void)checkFace {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userPhotoData = [defaults objectForKey:@"userPhoto"];
    
    NSString *token = [defaults objectForKey:@"token"];
    
    if (userPhotoData.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caution" message:@"获取照片失败" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles: nil];
        [alert show];
    }
    
    if (token.length == 0) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caution" message:@"获取照片失败" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles: nil];
        [alert show];
    }
    
    NSDictionary *checkFaceParams = @{@"image":userPhotoData,
                                      @"token":token};
    
    [NetWorkManager requestWithType:1 withUrlString:chechFaceUrl withParaments:checkFaceParams withSuccessBlock:^(NSDictionary *responseObject) {
        //打卡成功，跳转到祝贺成功界面
        INFCheckSuccessViewController *checkSuccesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"INFCheckSuccessViewController"];
        [self presentViewController:checkSuccesVC animated:YES completion:^{}];
    } withFailureBlock:^(NSError *error) {
        //打卡失败，给出提示
        [self dismissViewControllerAnimated:YES completion:nil];
    } progress:^(float progress) {
        
    }];
}
- (void)doPost {
    if(userStatus == 2){
        //调用注册人脸的api
        NSLog(@"调用注册人脸的api");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_imagePicker.cameraOverlayView animated:YES];
        hud.label.text = @"正在注册人脸";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self registerFace];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        });
    } else {
        NSLog(@"调用刷脸签到的api");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_imagePicker.cameraOverlayView animated:YES];
        hud.label.text = @"正在打卡";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self checkFace];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        });
        //调用刷脸签到的api
    }
    
}
#pragma mark --用户状态检测
- (NSInteger)checkUserStatus {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def integerForKey:@"userStatus"];
    return [def integerForKey:@"userStatus"];
}

// TODO 需要加入token验证的逻辑，如是否有token，token是否失效等
- (BOOL)tokenValided {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length != 0) {
        return YES;
    }
    return NO;
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
