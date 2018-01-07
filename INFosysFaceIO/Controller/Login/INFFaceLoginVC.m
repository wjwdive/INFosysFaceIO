//
//  INFFaceLoginVC.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/7.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFFaceLoginVC.h"
#import "UIImage+Utils.h"
#import "NetWorkManager.h"
#import "INFLoginSuccessViewController.h"
#import "INFVipLoginSuccessViewController.h"
#import "INFLoginFailureViewController.h"


NSString *faceLoginUrl1 = @"loginfacade/faceLoginFacade";

@interface INFFaceLoginVC ()<UIImagePickerControllerDelegate, UINavigationBarDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *wanggeIMG;
@property (strong, nonatomic) IBOutlet UIView *barImg;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIImageView *faceMask;

@property (strong, nonatomic) NSString *faceImgBase64str;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) NSMutableDictionary *mUserInfoDic;
@property (strong, nonatomic) NSNotification *notifaication;
@end

@implementation INFFaceLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImageView *bgIMG = [[UIImageView alloc] init];
//    bgIMG.image = [UIImage imageNamed:@"background"];
//    [self.view addSubview:bgIMG];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#155AC5"];
    
    [self configCamera];
    _mUserInfoDic = [NSMutableDictionary dictionary];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
//    UIImageView *bgIMG = [[UIImageView alloc] init];
//    bgIMG.image = [UIImage imageNamed:@"background"];
//    [self.view addSubview:bgIMG];
}

- (void)configCamera {
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
        [[NSBundle mainBundle] loadNibNamed:@"INFFaceLoginOverlayView" owner:self options:nil];
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
                [UIView animateWithDuration: 2 delay: 0.35 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations: ^{
                    [selfWeak.barImg layoutIfNeeded];
                    [selfWeak.barImg setFrame:CGRectMake(77, 383, 220, 4)];
                    selfWeak.faceMask.alpha = 0;
                } completion: ^(BOOL finished) {
                    [UIView animateWithDuration: 2 animations: ^{
                        selfWeak.faceMask.alpha = 1;
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

- (void)viewDidAppear:(BOOL)animated {
    
   
    
}

- (IBAction)cancleCamera:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (IBAction)faceLogin:(id)sender {
    [_imagePicker takePicture];
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
            [def setObject:_faceImgBase64str forKey:@"loginUserPhoto"];
            [def synchronize];
            [_mUserInfoDic setObject:_faceImgBase64str forKey:@"loginUserPhoto"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                 [self doLoginPost];
            });
        });
        
        //相片获取成功之后 do post
       
        NSLog(@"do post");
        
        
        //保存到相册
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        //        [self removeTimer];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //    [_timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doLoginPost {
    
    NSDictionary *params = @{@"image":_faceImgBase64str};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_imagePicker.cameraOverlayView animated:YES];
    hud.label.text = @"正在登录...";
    [NetWorkManager requestWithType:1
                      withUrlString:faceLoginUrl1
                      withParaments:params
                   withSuccessBlock:^(NSDictionary *responseObject) {
                       SLog(@"人脸登陆成功！");
                       SLog(@"responseObject :%@", responseObject);
                       [hud hideAnimated:YES];
                       NSString *token = [responseObject valueForKey:@"token"];
                       NSDictionary *userInfo = [responseObject valueForKey:@"user"];
                       NSString *userName = [userInfo objectForKey:@"username"];
                       [_mUserInfoDic setObject:userName forKey:@"loginUserName"];
                       NSString *isVip = [userInfo objectForKey:@"isadmin"];
                        [_mUserInfoDic setObject:isVip forKey:@"loginIsVip"];
                       
                       NSValue *scoreDouble = [userInfo valueForKey:@"score"];
                       NSLog(@"score :%@", scoreDouble);
                       NSUserDefaults  *def = [NSUserDefaults  standardUserDefaults];
                      
                       //记录token
                       [def setObject:token forKey:@"token"];
                       NSDate *currentDate = [NSDate new];
                       //记录token的生效时间
                       [def setObject:currentDate forKey:@"tokenTime"];
                       
                       INFLoginSuccessViewController *succVC = [[INFLoginSuccessViewController alloc] init];
                       succVC.userName = userName;
                       
                       NSString *scoreStr = [NSString stringWithFormat:@"%@",scoreDouble];
                       NSLog(@"scoreStr %@",scoreStr);
                       NSString *empidStr = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"empid"]];
                        [_mUserInfoDic setObject:empidStr forKey:@"loginEmpid"];
                       
                       NSDictionary *dic = @{@"loginEmpid":empidStr,
                                             @"loginIsVip":isVip,
//                                        @"loginUserPhoto":_faceImgBase64str,
                                             @"loginUserName":userName
                                             };
                       _notifaication = [NSNotification notificationWithName:@"changeUserNotification" object:nil userInfo:dic];
                       
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserNotification" object:nil];
                       
                       succVC.score = [scoreStr  substringToIndex:2]; dispatch_async(dispatch_get_main_queue(), ^{
                           [self dismissViewControllerAnimated:YES completion:^{
                               [self.navigationController pushViewController:succVC animated:YES];
                           }];
                       });
                       
                       
                       
    } withFailureBlock:^(NSError *error) {
        NSLog(@"人脸登录失败！");
        [hud hideAnimated:YES];
    } progress:^(float progress) {
        
    }];
    
}

- (void)gotoLoginSuccessVC {
    
}

- (void)gotoLoginFilueVC {
    
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
