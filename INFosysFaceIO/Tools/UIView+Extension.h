//
//  UIView+Extension.h
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;        ///<  xxx.frame.origin.x
@property (nonatomic, assign) CGFloat y;        ///<  xxx.frame.origin.y

@property (nonatomic, assign ,readonly) CGFloat maxX;     ///<  CGRectGetMaxX(xxx.frame)
@property (nonatomic, assign ,readonly) CGFloat maxY;     ///<  CGRectGetMaxY(xxx.frame)

@property (nonatomic, assign) CGFloat centerX;  ///<  xxx.center.x
@property (nonatomic, assign) CGFloat centerY;  ///<  xxx.center.Y

@property (nonatomic, assign) CGFloat width;    ///<  xxx.frame.size.width
@property (nonatomic, assign) CGFloat height;   ///<  xxx.frame.size.height

@property (nonatomic, assign) CGSize size;      ///<  xxx.frame.size

@property (nonatomic, assign) CGPoint origin;   ///<  xxx.frame.origin


/**
 *  9.上 < Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat top;

/**
 *  10.下 < Shortcut for frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 *  11.左 < Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat left;

/**
 *  12.右 < Shortcut for frame.origin.x + frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;
/**
 *  判断是否显示在主窗口上面
 *
 *  @return 是否
 */
- (BOOL)isShowOnWindow;


/**
 设置任意一边的border

 @param color border颜色
 @param borderWidth border宽度
 */
-(void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
-(void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

@end
