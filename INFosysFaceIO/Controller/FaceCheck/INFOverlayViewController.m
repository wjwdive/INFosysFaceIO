//
//  INFOverlayViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/27.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "INFOverlayViewController.h"

@interface INFOverlayViewController ()<UINavigationBarDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIImageView *maskIMG;
@property (strong, nonatomic) IBOutlet UIImageView *scanIMG;
@property (strong, nonatomic) IBOutlet UILabel *cautionLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancleBtn;

@end

@implementation INFOverlayViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"NFOverlayViewController" owner:self options:nil];
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame];
//    if (self) {
//        <#statements#>
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imagePicker];
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
}


- (IBAction)closeCamera:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImagePickerController *)imagePicker {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        if (!_imagePicker) {
            _imagePicker = [[UIImagePickerController alloc] init];
            //代理
            _imagePicker.delegate = self;
            //类型
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            //设置使用前置摄像头
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            //隐藏系统相机操作
            _imagePicker.showsCameraControls = NO;
//            设定相机全屏
            CGSize screenBounds = [UIScreen mainScreen].bounds.size;
            CGFloat cameraAspectRatio = 4.0f/3.0f;
            CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
            CGFloat scale = screenBounds.height / camViewHeight;
            _imagePicker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
            _imagePicker.cameraViewTransform = CGAffineTransformScale(_imagePicker.cameraViewTransform, scale, scale);
            self.overlayView.frame = self.imagePicker.cameraOverlayView.frame;
            self.overlayView.backgroundColor = [UIColor clearColor];
            self.view.backgroundColor = [UIColor clearColor];
            self.imagePicker.cameraOverlayView = self.overlayView;
            self.overlayView = nil;
            [self presentViewController:_imagePicker animated:NO completion:nil];
            NSLog(@"_imagePicker %@",_imagePicker);
        }
        
    } else {
        NSLog(@"照相机不可用");
    }
    
    return  _imagePicker;
    
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
            //            self.userPhotoIMG.image = image;
        }
        NSLog(@"保存图片。。");
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithCameraPicker:picker {
//    
//}
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
