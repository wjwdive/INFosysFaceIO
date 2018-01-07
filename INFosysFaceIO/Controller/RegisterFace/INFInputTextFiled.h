//
//  INFInputTextFiled.h
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/4.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INFInputTextFiled : UIView
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UITextField *inputTF;
@property (nonatomic, strong) UIView *underLine;

- (instancetype)initWithImg:(NSString *)imageName withTag:(NSUInteger)tag;
- (instancetype)initWithFrame:(CGRect)frame andImge:(NSString *)imageName andTag:(NSUInteger)tag;
@end
