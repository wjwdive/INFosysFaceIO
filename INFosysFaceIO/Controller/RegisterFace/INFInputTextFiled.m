//
//  INFInputTextFiled.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/4.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFInputTextFiled.h"
#import "Masonry/Masonry/Masonry.h"
@implementation INFInputTextFiled

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.bottom.equalTo(self.iconView);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTF.mas_bottom);
        make.width.left.equalTo(self.inputTF);
        make.height.mas_equalTo(1.5);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame andImge:(NSString *)imageName andTag:(NSUInteger)tag {
    if (self = [super initWithFrame:frame]) {
        self.iconView = [[UIImageView alloc] init];
        [self addSubview: self.iconView];
        self.inputTF = [[UITextField alloc] init];
        [self addSubview: self.inputTF];

    
        self.iconView.image = [UIImage imageNamed:imageName];
        [self.inputTF setBorderStyle:UITextBorderStyleNone];
        [self.inputTF setTextColor:[UIColor whiteColor]];
        self.underLine = [[UIView alloc] init];
        self.underLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.underLine];
        if (tag == 1001) {
            self.inputTF.placeholder = @"请输入新的用户名";
        }
        if (tag == 1002) {
            self.inputTF.placeholder = @"请输入新的用户ID";
        }
        if (tag == 1003) {
            self.inputTF.placeholder = @"请输入密码";
            self.inputTF.secureTextEntry = YES;
        }
        if (tag == 1004) {
            self.inputTF.placeholder = @"确认密码";
            self.inputTF.secureTextEntry = YES;
        }
    }
    return self;
}

@end
