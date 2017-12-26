//
//  UIImage+Utils.h
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/21.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

//自由拉伸图片
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

//根据颜色和大小获取一张图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//根据图片和颜色返回一张加深颜色之后的图片
+ (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;

//- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;
- (UIImage *)cropImageWithSize:(CGSize)size;

//给定图片宽度，等比压缩图片
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//图片正向处理，相册读出来的图片有时候头不朝上
+ (UIImage *)fixImageOrientation:(UIImage *)aImage;

//将图片压缩到指定大小之内
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

//将图片转化为Base64编码的字符串
+ (NSString *)imageToBase64Str:(UIImage *)image;

//将给定的图片名对应的图片转化为Base64编码的字符串
+ (NSString *)imageNameToBase64Str:(NSString *)imageName;

//压缩图片到宽度1024
+ (UIImage *)imageCompressSizeToMin1024Width:(UIImage *)image;

//修改图片size
+ (UIImage *)image:(UIImage *)image byScalingToSize:(CGSize)targetSize;

//UIColor 转UIImage
+ (UIImage *)imageWithColor: (UIColor*) color;

//图片转换成黑白(type1:灰 type2:橙 type3:蓝 other:不变)
+ (UIImage *)grayscale:(UIImage*)anImage type:(int)type;

//view转图片
+(UIImage *)getImageFromView:(UIView *)view;

//图片转化成png
+ (UIImage *)imageToPng:(UIImage *)image;

//图片转换成jpg格式
+ (UIImage *)imageToJpg:(UIImage *)image;

@end
