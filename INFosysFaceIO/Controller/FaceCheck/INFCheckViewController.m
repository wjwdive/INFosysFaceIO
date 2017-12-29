//
//  INFCheckViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "INFCheckViewController.h"
#import "NetWorkManager.h"
#import "INFOverlayViewController.h"
#import <AVFoundation/AVFoundation.h>


extern NSInteger userStatus;


// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1
// this works for iOS 4.x
#define CAMERA_TRANSFORM_Y 1.24299


@interface INFCheckViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *userPhotoIMG;
@property (weak, nonatomic) IBOutlet UIImageView *maskIMG;
@property (weak, nonatomic) IBOutlet UIImageView *scanIMG;

@property (nonatomic, strong) INFOverlayViewController *overView;



@end

@implementation INFCheckViewController


- (void)viewWillAppear:(BOOL)animated {
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"caution" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    
    
    [self imagePicker];
    [self presentViewController:_imagePicker animated:NO completion:nil];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [_maskIMG addGestureRecognizer:singleTap];
    NSLog(@" INFCheckViewController view did load ");
    
}

- (void)singleTap {
    NSLog(@"拍照。。。");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeCheckVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController代理方法
//拍完照片的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
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
        NSData *imageData;
        if (UIImagePNGRepresentation(image) == nil) {
            imageData = UIImageJPEGRepresentation(image, 1);
        } else {
            imageData = UIImagePNGRepresentation(image);
        }
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:imageData forKey:@"userPhoto"];
        [def synchronize];
        if (image) {
            self.userPhotoIMG.image = image;
        }
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

#pragma mark - 重写iamgePicker的getter方法
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        //设置imagePicker 的来源，这里设置为摄像头
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置使用哪个摄像头，这里默认设置为前置摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //设置摄像头模式为照相
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //允许编辑
        _imagePicker.allowsEditing = YES;
        //设置代理，检测操作
        _imagePicker.delegate = self;
        self.overView = [self.storyboard instantiateViewControllerWithIdentifier:@"INFOverlayViewController"];
//        self.overView.view.backgroundColor = [UIColor clearColor];//设定透明背景色
        _imagePicker.cameraOverlayView = self.overView.view;
    }
    return _imagePicker;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)checkFace {
    if (userStatus == 2) {
        NSLog(@"face check for register you face");
    }else {
        NSLog(@"face check for attendence records");
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
