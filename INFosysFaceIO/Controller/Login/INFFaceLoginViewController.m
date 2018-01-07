//
//  INFFaceLoginViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/7.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFFaceLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NetWorkManager.h"
#import "UIImage+Utils.h"

NSString *faceLoginUrl = @"";

@interface INFFaceLoginViewController ()<UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationBarDelegate>
@property (strong, nonatomic) IBOutlet UIView *cameraOverlayView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSString *faceImgBase64str;
//@property (strong, nonatomic) IBOutlet UIImageView *scanImg;
//@property (strong, nonatomic) IBOutlet UIImageView *barImg;
@property (strong, nonatomic) UIImageView *wanggeImg;
@property (strong, nonatomic) UIImageView *faceProfileImg;
@property (strong, nonatomic) UIImageView *scanBarImg;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIImageView *maskImg;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UIButton *loginBtn;

@end



@implementation INFFaceLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //给人脸登录界面 添加一个背景图
    NSLog(@"self.view .frame width:%f, height:%f",self.view.frame.size.width,  self.view.frame.size.height);
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImageView.frame = self.view.frame;
    [self.view addSubview:bgImageView];
    NSLog(@"self.view frame width:%f -- height:%f",self.view.frame.size.width, self.view.frame.size.height);
    [self initOverlayView];
    [self confiUI];
}
//动画在这里做不了
- (void)viewWillAppear:(BOOL)animated {
    
}

//必须界面显示完成才能做动画
- (void)viewDidAppear:(BOOL)animated {
    //配置相机也必须在这里做
    [self configImagePicker];
    [self animation];
}

- (void)initOverlayView {
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//    UIImageView *overlayImgView = [[UIImageView alloc] initWithFrame:_overlayView.frame];
//    UIImage *overLayImg = [UIImage imageNamed:@"mask"];
//    overlayImgView.image = overLayImg;

    _wanggeImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _wanggeImg.image = [UIImage imageNamed:@"wangge"];
    
    _faceProfileImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _faceProfileImg.image = [UIImage imageNamed:@"scan"];
    
    _scanBarImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _scanBarImg.backgroundColor = [UIColor blueColor];
    _maskImg = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    UIImage *overLayImg = [UIImage imageNamed:@"mask"];
    _maskImg.image = overLayImg;
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.text = @"make your face in the rect and press 'Face login' button to login";
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:24];
    _cancleBtn = [[UIButton alloc] init];
    _cancleBtn.imageView.image = [UIImage imageNamed:@"close"];
//    _cancleBtn.titleLabel.text =
    _loginBtn = [[UIButton alloc] init];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:36];
    _loginBtn.backgroundColor = [UIColor whiteColor];
//    _loginBtn.titleLabel.textColor = [UIColor blueColor];
    [_loginBtn setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];

    
//    [_overlayView addSubview:overlayImgView];
    [_overlayView addSubview:_maskImg];
    [_overlayView addSubview:_wanggeImg];
    [_overlayView addSubview:_faceProfileImg];
    [_overlayView addSubview:_scanBarImg];
    [_overlayView addSubview:_titleLab];
    [_overlayView addSubview:_cancleBtn];
    [_overlayView addSubview:_loginBtn];
    
    [self.view addSubview:_overlayView];
    
    
    [_cancleBtn addTarget:self action:@selector(cancleCamera:) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn addTarget:self action:@selector(faceLogin:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)confiUI{
    
    [_overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.and.right.equalTo(self.view);
        make.height.and.width.equalTo(self.view);
    }];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.top.equalTo(_overlayView);
        make.right.equalTo(_overlayView);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_overlayView).width.offset(100);
        make.height.mas_equalTo(40);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_overlayView).with.offset(100);
        make.height.mas_equalTo(60);
    }];
    
    
    if (IS_IPHONE_6) {
        [self.wanggeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(112);
            make.top.equalTo(_cameraOverlayView).with.offset(82);
            make.left.equalTo(_cameraOverlayView).with.offset(36);
        }];
        
        [self.faceProfileImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_wanggeImg).with.offset(20);
            make.left.equalTo(_wanggeImg).with.offset(20);
            make.right.equalTo(_wanggeImg).with.offset(-20);
            make.bottom.equalTo(_wanggeImg);
        }];
        
        [self.scanBarImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_wanggeImg).with.offset(4);
            make.left.equalTo(_wanggeImg).with.offset(4);
            make.width.mas_equalTo(104);//Y坐标 动画到最低端是 191 - 4
            make.height.mas_equalTo(4);
        }];
        
    }
    if (IS_IPHONE_6_PLUS) {
        [self.wanggeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(324);
            make.top.mas_equalTo(240);
            make.left.mas_equalTo(108);
        }];
        
        [self.faceProfileImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_wanggeImg).offset(70);
            make.left.equalTo(_wanggeImg).offset(70);
            make.right.equalTo(_wanggeImg).offset(70);
            make.bottom.equalTo(_wanggeImg);
        }];
        
        [self.scanBarImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_wanggeImg).offset(13);
            make.left.equalTo(_wanggeImg).offset(13);
            make.width.mas_equalTo(323);//Y坐标 动画到最低端 是575 - 4
            make.height.mas_equalTo(4);
        }];
        
    }
}

//面部识别动画
- (void)animation{
    WeakObj(self);
    [UIView animateWithDuration: 2 delay: 0.35 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations: ^{
        [selfWeak.scanBarImg layoutIfNeeded];
        if (IS_IPHONE_6) {
            [selfWeak.scanBarImg setFrame:CGRectMake(82, 383, 104, 4)];
        }
        if (IS_IPHONE_6_PLUS) {
            [selfWeak.scanBarImg setFrame:CGRectMake(95, 571, 323, 4)];
        }
        selfWeak.faceProfileImg.alpha = 0;
    } completion: ^(BOOL finished) {
        [UIView animateWithDuration: 2 animations: ^{
            selfWeak.faceProfileImg.alpha = 1;
        }];
    }];
}

- (void)configImagePicker {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (!_imagePicker) {
            _imagePicker = [[UIImagePickerController alloc] init];
        }
        
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        _imagePicker.showsCameraControls = NO;
        _imagePicker.allowsEditing = NO;
//        [[NSBundle mainBundle] loadNibNamed:@"INFFaceLoginOverlayView" owner:self options:nil];
        
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
        [self presentViewController:_imagePicker animated:NO completion:^{
            
        }];
        
    }
}


- (void)faceLogin {
    [_imagePicker takePicture];
}

- (void)cancleCamera {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)faceLogin:(id)sender {
    [_imagePicker takePicture];
}
- (IBAction)cancleCamera:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

//请求人脸登录
- (void)doPost {
    NSDictionary *params = @{
        @"image" : self.faceImgBase64str
    };
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.imagePicker.cameraOverlayView animated:YES];
    hud.label.text = @"正在登录";
    dispatch_queue_t doPostQueue = dispatch_queue_create("doFaceLoginQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(doPostQueue, ^{
        [NetWorkManager requestWithType:1 withUrlString:faceLoginUrl
                          withParaments:params
                       withSuccessBlock:^(NSDictionary *responseObject) {
                           NSLog(@"面部识别成功！");
                           [hud hideAnimated:YES];
                       } withFailureBlock:^(NSError *error) {
                           NSLog(@"面部识别失败，你没有注册人脸或者上传了非面部照片！请拍摄正常的照片");
                           [hud hideAnimated:YES];
                       } progress:^(float progress) {
                           
                       }];
    });
    
}

#pragma mark -- imagPickerDelegate
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
        //[self doPost];
        NSLog(@"do post");
        //保存到相册
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
