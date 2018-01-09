//
//  INFLoginFailureViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/8.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFLoginFailureViewController.h"

@interface INFLoginFailureViewController ()
/**
 *  绘制层
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/**
 *  重绘定时器
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/**
 *  水波的高度
 */
@property (nonatomic, assign) CGFloat waterWaveHeight;

/**
 *  Y 轴方向的缩放
 */
@property (nonatomic, assign) CGFloat zoomY;

/**
 *  X 轴方向的平移
 */
@property (nonatomic, assign) CGFloat translateX;

@property (strong, nonatomic) IBOutlet UIImageView *persentImg;
@end

@implementation INFLoginFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.persentImg.layer.masksToBounds = YES;
    self.persentImg.layer.cornerRadius = 91.5;
    [self.persentImg setNeedsDisplay];
    
    self.navigationController.navigationBarHidden = YES;
    
    
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
