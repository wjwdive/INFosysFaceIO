//
//  INFRegisterView.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/5.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFRegisterView.h"

@interface INFRegisterView () <UITextFieldDelegate>
@end
@implementation INFRegisterView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName placeHold:(NSString *)placeHold tagId:(NSInteger)tagId{
    if (self = [super initWithFrame:frame]) {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(28);
            make.left.top.equalTo(self);
        }];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = placeHold;
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:15];
//        [textField setValue:[UIColor colorWithWhite:1.0 alpha:0.4] forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(10);
            make.height.right.top.equalTo(self);
        }];
        
        UIView *underLine = [[UIView alloc] init];
        underLine.backgroundColor = [UIColor colorWithHexString:@"c4c4c4"];
        [self addSubview:underLine];
        self.textField = textField;
        [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(textField);
            make.height.mas_equalTo(1.5);
        }];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1001:{
//            self.userName = textField.text;
            self.passValueBlock(textField.text);
//            :^(NSString *textFiledStr) {
//                textFiledStr = textField.text;
//            }];
        }
            break;
        case 1002:
            self.userNo = textField.text;
            ;
            self.passValueBlock(textField.text);
        case 1003:
            self.password = textField.text;
            self.passValueBlock(textField.text);
            break;
        default:
            break;
    }
    
}

@end
