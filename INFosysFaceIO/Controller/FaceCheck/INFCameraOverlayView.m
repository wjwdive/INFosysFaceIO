//
//  INFCamerOverlayView.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/27.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "INFCameraOverlayView.h"
BOOL upOrdown = YES;
@implementation INFCameraOverlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)backToHome:(id)sender {
    NSLog(@"cancle 按钮响应");
    NSLog(@"tackPhotoDelegate %@",self.delegate);
//    if (self.delegate && [self.delegate respondsToSelector:@selector(takePhoto)]) {
//        NSLog(@"代理有效");
//        [self.delegate takePhoto];
//    }
    [self.delegate closeCamera];

    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self animatedView:_barIMG];

}

#pragma mark 初始化扫描界面 
-(void)lineAnimation:(NSTimer*)timer 
{ 
    const CGFloat yOffset = 8; 
    if (upOrdown) 
    { 
        CGRect lineFrame = _barIMG.frame;
        CGRect bgFrame = _scanIMG.frame;
        lineFrame.origin.y -= 2; 
        _barIMG.frame = lineFrame;
        lineFrame = _barIMG.frame;
        if (lineFrame.origin.y - yOffset < bgFrame.origin.y) 
            upOrdown = !upOrdown; 
    } 
    else 
    { 
        CGRect lineFrame = _barIMG.frame;
        CGRect bgFrame = _scanIMG.frame;
        lineFrame.origin.y += 2; 
        _barIMG.frame = lineFrame;
        lineFrame = _barIMG.frame;
        if (lineFrame.origin.y + yOffset> bgFrame.origin.y + bgFrame.size.height) 
            upOrdown = !upOrdown; 
    } 
} 

- (void)animatedView:(UIView *)view{
//    [UIView animateWithDuration: 10 delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
//        CGPoint center = view.center;
//        center.y -= 20;
//        view.center = center;
//    } completion: nil];
    
    //开始
    [UIView beginAnimations:nil context:nil];
    //设置动画时间
    [UIView setAnimationDuration:3.0];
    
    //note:设置动画重复的两句代码一定要在动画结束位置代码的前边
    //设置动画是否重复来回
    [UIView setAnimationRepeatAutoreverses:YES];
    //设置动画重复次数，0和1都是一次，
    //LONG_MAX就是无限大
    [UIView setAnimationRepeatCount:LONG_MAX];
    
    //设置结束的位置
    _barIMG.frame = CGRectMake(77, 370, 220, 8);
    //提交动画
    [UIView commitAnimations];
    
}

- (void)animatedView1 {
    [UIView animateWithDuration:3//动画持续时间
                          delay:0//动画延迟执行的时间
         usingSpringWithDamping:1.0//震动效果，范围0~1，数值越小震动效果越明显
          initialSpringVelocity:5.0//初始速度，数值越大初始速度越快
                        options:UIViewAnimationOptionRepeat//动画的过渡效果
                     animations:^{
                         [self layoutIfNeeded];
//                         CGPoint point =
                         _barIMG.frame = CGRectMake(77, 370, 220, 8);
                         //                        while (1) {
                         //                            //执行的动画
                         //                            if (_barIMG.frame.origin.y < 370) {
                         //                                CGFloat endY = _scanIMG.frame.origin.y + _scanIMG.frame.size.height;
                         //                                //                            _barIMG.frame = CGRectMake(77, 370, 220, 8);
                         //                                _barIMG.frame = CGRectMake(77, endY, 220, 8);
                         //
                         //                            }
                         //
                         //                            if (_barIMG.frame.origin.y > 168) {
                         //                                CGFloat beginY = _scanIMG.frame.origin.y;
                         //
                         //                                _barIMG.frame = CGRectMake(77, beginY, 220, 8);
                         //                                //                            _barIMG.frame = CGRectMake(77, 168, 220, 8);
                         //                            }
                         //                        }
                         
                         //                        [self lineAnimation:<#(NSTimer *)#>]
                     }
                     completion:^(BOOL finished){
                         //动画执行完毕后的操作
                         NSLog(@"动画执行完毕");
                         [self.delegate takePhoto];
                     }];
}

@end
