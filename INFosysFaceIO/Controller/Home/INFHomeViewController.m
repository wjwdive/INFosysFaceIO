//
//  INFHomeViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "AppDelegate.h"

#import "INFCameraOverlayView.h"
#import "INFOverlayViewController.h"
#import "INFHomeViewController.h"
#import "INFMyViewController.h"
#import "INFLoginViewController.h"
#import "INFCheckViewController.h"
#import "NetWorkManager.h"
extern NSInteger userStatus;
@interface INFHomeViewController ()<takePhotoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) INFCameraOverlayView *overView;
//@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIImageView *scanImg;
@property (strong, nonatomic) IBOutlet UIImageView *barImg;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NetWorkManager *netManager;
@property (strong, nonatomic) NSData *faceImgData;

@end

@implementation INFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.hidden = YES;
    self.imagePicker = [[UIImagePickerController alloc] init];
    //给图片 添加手势，失败 原因未知
//    UITapGestureRecognizer *tapTakePicture = [[UITapGestureRecognizer alloc] initWithTarget:self.scanImg action:@selector(takePhoto)];
//    [self.scanImg addGestureRecognizer:tapTakePicture];
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration: 2 delay: 0.35 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations: ^{
        [self.barImg layoutIfNeeded];
        [self.barImg setFrame:CGRectMake(77, 383, 220, 4)];
        self.scanImg.alpha = 0;
    } completion: ^(BOOL finished) {
        [UIView animateWithDuration: 2 animations: ^{
//            [self.barImg setFrame:CGRectMake(77, 383, 220, 4)];
            self.scanImg.alpha = 1;
        }];
    }];
    
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
//第一种方法，自定义界面、动画显得乏力
- (void)gotoCheckVCUseImgePicker {
    //未注册人脸
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"caution" message:@"You haven't register your face, pleace register FACE first" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles: nil];
//    [alert show];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (!_imagePicker) {
            _imagePicker = [[UIImagePickerController alloc] init];
        }
        //代理
        _imagePicker.delegate = self;
        //类型
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //设置使用前置摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //隐藏系统相机操作
        _imagePicker.showsCameraControls = NO;
        _imagePicker.editing = YES;
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
        
        [self presentViewController:_imagePicker animated:YES completion:^{
            _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(takePhoto)  userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            
            [UIView animateWithDuration: 2 delay: 0.35 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations: ^{
                [self.barImg layoutIfNeeded];
                [self.barImg setFrame:CGRectMake(77, 383, 220, 4)];
                self.scanImg.alpha = 0;
            } completion: ^(BOOL finished) {
                [UIView animateWithDuration: 2 animations: ^{
                    //            [self.barImg setFrame:CGRectMake(77, 383, 220, 4)];
                    self.scanImg.alpha = 1;
                }];
            }];
            
            
        }];

    } else {
        NSLog(@"照相机不可用");
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
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    extern NSInteger userStatus;
//    = [defaults integerForKey:@"userStatus"];
    NSLog(@"scanBtn userStatus:%ld",userStatus);
//    userStatus = 2;
    switch (userStatus) {
        case 1:
            NSLog(@"用户未登录，请先登录");
            [self gotoLoginVC];
            break;
        case 2:
            NSLog(@"用户登录成功，但是未注册人脸，请先注册人脸");
            
            [self gotoCheckVCUseImgePicker];
//            [self gotoCheckVCUseAVSession];
//            [self gotoCheckFaceUseNomalVC];
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
        if (UIImagePNGRepresentation(image) == nil) {
            _faceImgData = UIImageJPEGRepresentation(image, 1);
        } else {
            _faceImgData = UIImagePNGRepresentation(image);
        }
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:_faceImgData forKey:@"userPhoto"];
        [def synchronize];
        //相片获取成功之后 do post
        [self doPost];
        
        
//        NSLog(@"保存图片。。");
        //保存到相册
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (_imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}

- (IBAction)cancleTakePhoto:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)registerFace {
    
}


- (void)doPost {
    if(userStatus == 2){
        //调用注册人脸的api
        //        [NetWorkManager requestWithType:1 withUrlString:<#(NSString *)#> withParaments:<#(id)#> withSuccessBlock:<#^(NSDictionary *responseObject)successBlock#> withFailureBlock:<#^(NSError *error)failureBlock#> progress:<#^(float progress)progress#> ]
    } else {
        //调用刷脸签到的api
    }
    
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
