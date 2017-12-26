//
//  INFCheckViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "INFCheckViewController.h"
#import "NetWorkManager.h"

extern NSInteger userStatus;

@interface INFCheckViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoIMG;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation INFCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化imagePicker
    [self imagePicker];
    [self.view addSubview:_imagePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //判断现在可以获得多媒体的方式
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            //设置imagePicker 的来源，这里设置为摄像头
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //设置使用哪个摄像头，这里默认设置为前置摄像头
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
//            self.isVedio
            if (TRUE) {
                _imagePicker.mediaTypes = @[(NSString*)kUTTypeMovie];
//              _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
                // 设置摄像头模式（拍照，录制视频）
                _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                
            }else {
//                设置摄像头模式为照相
                _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                
            }
        } else {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        //允许编辑
        _imagePicker.allowsEditing = YES;
        //设置代理，检测操作
    }
    return _imagePicker;
}

- (void)checkFace {
    if (userStatus == 2) {
        NSLog(@"face check for register you face");
    }else {
        NSLog(@"face check for attendence records");
    }
}
//判断是否有摄像头
//－ (BOOL)isCameraAvailable {
//    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//}
//判断前置摄像头是否可用
//－ (BOOL)isFrontCameraAvailable {
//    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
