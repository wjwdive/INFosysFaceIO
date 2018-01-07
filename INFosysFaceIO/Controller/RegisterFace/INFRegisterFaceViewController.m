//
//  INFRegisterFaceViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/4.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFRegisterFaceViewController.h"
#import "INFInputTextFiled.h"

@interface INFRegisterFaceViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *backgroundIMG;
@property (nonatomic, strong) UIImageView *userPhotoIMG;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *registBtn;

@property (nonatomic, strong) INFInputTextFiled *userNameInPutView;
@property (nonatomic, strong) INFInputTextFiled *userNoInPutView;
@property (nonatomic, strong) INFInputTextFiled *userPasswordView;
@property (nonatomic, strong) INFInputTextFiled *userPasswordConfirmView;

@property (nonatomic, strong) UIImagePickerController *_imagePicker;

@end

@implementation INFRegisterFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubViews];
    
}

- (void)configSubViews {
    [self.view addSubview:self.backgroundIMG];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.userPhotoIMG];
    [self.view addSubview:self.registBtn];
    [self.view addSubview:self.userNameInPutView];
    [self.view addSubview:self.userNoInPutView];
    [self.view addSubview:self.userPasswordView];
    [self.view addSubview:self.userPasswordConfirmView];
    
    _backgroundIMG.frame = self.view.bounds;
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.centerX.equalTo(self.view);
    }];
    
    [self.userPhotoIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.userNameInPutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.userPhotoIMG.mas_bottom).offset(30);
    }];
    
    [self.userNoInPutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameInPutView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [_userPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNoInPutView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [_userPasswordConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userPasswordView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    
}


#pragma  mark --控件getter
- (UIImageView *)backgroundIMG {
    if (!_backgroundIMG) {
        _backgroundIMG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    }
    return _backgroundIMG;
}

- (UILabel *)titleLab {
    if(!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"人脸注册";
        _titleLab.textColor = [UIColor whiteColor];
    }
    return _titleLab;
}

- (UIImageView *)userPhotoIMG {
    if (!_userPhotoIMG) {
        _userPhotoIMG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user1"]];
    }
    return _userPhotoIMG;
}

- (INFInputTextFiled *)userNameInPutView {
    if (!_userNameInPutView) {
        _userNameInPutView =  [[INFInputTextFiled alloc] initWithFrame:CGRectZero andImge:@"user" andTag:1001];
    }
    return _userNameInPutView;
}

- (INFInputTextFiled *)userNoInPutView {
    if (!_userNoInPutView) {
        _userNoInPutView = [[INFInputTextFiled alloc] initWithFrame:CGRectZero andImge:@"identity" andTag:1002];
    }
    return _userNoInPutView;
}

- (INFInputTextFiled *)userPasswordView {
    if (!_userPasswordView) {
        _userPasswordView = [[INFInputTextFiled alloc] initWithFrame:CGRectZero andImge:@"password" andTag:1003];
    }
    return _userPasswordView;
}

- (INFInputTextFiled *)userPasswordConfirmView {
    if (!_userPasswordConfirmView) {
        _userPasswordConfirmView = [[INFInputTextFiled alloc] initWithFrame:CGRectZero andImge:@"password" andTag:1004];
    }
    return _userPasswordConfirmView;
}

- (UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 316, 200, 50)];
    }
    _registBtn.titleLabel.text = @"Register";
    _registBtn.titleLabel.textColor = [UIColor whiteColor];
    _registBtn.backgroundColor = [UIColor clearColor];
    return _registBtn;
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
