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
#import "INFCheckFailureViewController.h"
#import "INFCheckVipSuccessViewController.h"

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
@property (strong, nonatomic) MBProgressHUD *hudAll;
@end

@implementation INFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    
//    [self getCurrentTime];
    
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
//        self.overlayView = nil;
        //    _imagePicker.cameraOverlayView = [self customViewForImagePicker:_imagePicker];
        
        WeakObj(self);
        [self presentViewController:_imagePicker animated:YES completion:^{
            //            [selfWeak timerStart];
            NSTimer *timerTmp = [NSTimer timerWithTimeInterval:2 target:selfWeak selector:@selector(takePhoto)  userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:timerTmp forMode:NSRunLoopCommonModes];
            
            [UIView animateWithDuration: 2 delay: 0 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations: ^{
                [selfWeak.barImg layoutIfNeeded];
                [selfWeak.barImg setFrame:CGRectMake(77, 383, 220, 4)];
                selfWeak.scanImg.alpha = 0;
            } completion: ^(BOOL finished) {
                //                    [UIView animateWithDuration: 2 animations: ^{
                //                        selfWeak.scanImg.alpha = 1;
                //                    }];
            }];
        }];
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
        WeakObj(self);
        _hudAll = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        _hudAll.label.text = @"adjusting photo";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //压缩 到 50k
            NSData *compressedImgData = [UIImage compressOriginalImage:image toMaxDataSizeKBytes:50.0];
            _faceImgBase64str = [compressedImgData base64EncodedStringWithOptions:0];
            [[NSUserDefaults standardUserDefaults] setObject:_faceImgBase64str forKey:@"userPhotoCheck"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [selfWeak checkFace];
        });
        
        //相片获取成功之后 do post
        NSLog(@"do checkFace post");
        
        //保存到相册
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//关闭刷脸界面
- (IBAction)cancleTakePhoto:(id)sender {
    [self imagePickerControllerDidCancel:_imagePicker];
}

#pragma mark --打卡成功 失败处理
//userStatus = 3 的时候，用户已经登录且注册成功。用户点击刷脸进入刷脸打卡界面
- (void)checkFace {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userPhotoData = [defaults objectForKey:@"userPhotoCheck"];
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
    
//    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:_imagePicker.cameraOverlayView animated:YES];
//    hud1.label.text = @"checking...";
    WeakObj(self);
    [NetWorkManager requestWithType:1 withUrlString:chechFaceUrl withParaments:checkFaceParams withSuccessBlock:^(NSDictionary *responseObject) {
        NSLog(@"打卡成功，准备跳转");
        [selfWeak.hudAll hideAnimated:YES];
        [selfWeak gotoCheckResult:(NSDictionary *)responseObject];
        
        //打卡成功，跳转到祝贺成功界面
//        INFCheckSuccessViewController *checkSuccesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"INFCheckSuccessViewController"];
//        [self presentViewController:checkSuccesVC animated:YES completion:^{}];
    } withFailureBlock:^(NSError *error) {
        //打卡失败，给出提示
        NSLog(@"打卡失败，准备跳转");
        [selfWeak.hudAll hideAnimated:YES];
        NSLog(@"errror :%@", error);
        [selfWeak gotoCheckFailure];
    } progress:^(float progress) {
        
    }];
}

#pragma mark -- 打卡结果处理
- (void)gotoCheckResult:(NSDictionary *)responseObject {
    NSString *successFlag = [NSString  stringWithFormat:@"%@", [responseObject objectForKey:@"success"]];
    //打卡成功
    if ([successFlag isEqualToString:@"1"]) {
        NSLog(@"打卡成功");
        SLog(@"response obj: %@", responseObject);
        //如果登录失败，也应该返回 userName 和 score
        INFCheckVipSuccessViewController *checkSuccessVC = [[INFCheckVipSuccessViewController alloc] init];
        
        NSDictionary *dataInfo = [responseObject objectForKey:@"data"];
        NSDictionary *userInfo = [responseObject objectForKey:@"user"];
        NSString *userName = [userInfo objectForKey:@"username"];
        NSString *scoreStr = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"score"]];
        scoreStr = [scoreStr substringToIndex:4];
        NSString *isVip = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"vip"]];
        NSDictionary *timeDic = [dataInfo objectForKey:@"timeStamp"];
        NSString *timeStempStr = [NSString stringWithFormat:@"%@",[timeDic objectForKey:@"time"]];
        checkSuccessVC.userName = userName;
        checkSuccessVC.score = scoreStr;
        checkSuccessVC.isVip = isVip;
        checkSuccessVC.time = timeStempStr;
        //        checkSuccessVC.time = timeStempStr;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:checkSuccessVC animated:YES completion:nil];
    }else {
        //如果登录失败，也应该返回 userName 和 score
        NSString *scoreStr = [responseObject objectForKey:@"score"];
        INFCheckFailureViewController *checkFailureVC = [[INFCheckFailureViewController alloc] init];
        checkFailureVC.score = scoreStr;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:checkFailureVC animated:YES completion:nil];
    }
    
}

- (void)gotoCheckFailure {
        //如果登录失败，也应该返回 userName 和 score
        INFCheckFailureViewController *checkFailureVC = [[INFCheckFailureViewController alloc] init];
        [self.navigationController pushViewController:checkFailureVC animated:YES];
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

- (void)dealloc {
    NSLog(@"dealloc");
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
