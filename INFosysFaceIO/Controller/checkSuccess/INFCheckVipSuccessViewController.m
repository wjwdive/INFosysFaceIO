//
//  INFCheckVipSuccessViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/8.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFCheckVipSuccessViewController.h"

@interface INFCheckVipSuccessViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoIMG;
@property (strong, nonatomic) IBOutlet UILabel *scoreLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *ampmLab;
@property (strong, nonatomic) IBOutlet UILabel *userNameLab;
@property (strong, nonatomic) IBOutlet UIImageView *vipImg;

@end

@implementation INFCheckVipSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configData];
    [self animation2];

//    if ([_isVip isEqualToString:@"Y"]) {
//        [self animation2];
//        self.vipImg.hidden = NO;
//    }else {
//        self.vipImg.hidden = YES;
//    }
    
    
}


- (void)configData {
    self.userPhotoIMG.layer.masksToBounds = YES;
    self.userPhotoIMG.layer.cornerRadius = 75.5;
    [self.userPhotoIMG setNeedsDisplay];
    NSUserDefaults  *def = [NSUserDefaults standardUserDefaults];
    NSString *imgStr = [def objectForKey:@"userLoinPhoto"];
    NSData *imgData = [[NSData alloc] initWithBase64EncodedString:imgStr options:0];
    self.userPhotoIMG.image = [UIImage imageWithData:imgData];
    
    self.scoreLab.text = @"Similarity Score:95%";
    self.timeLab.text = @"11:11";
    self.ampmLab.text = @"AM";
    self.userNameLab.text = @"Welcome xxx";
    
}


- (void)animation2 {
    // Cells spawn in the bottom, moving up
    
    //分为3种粒子，子弹粒子，爆炸粒子，散开粒子
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize    = CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworksEmitter.emitterMode    = kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape    = kCAEmitterLayerLine;
    fireworksEmitter.renderMode        = kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate        = 1.0;
    rocket.emissionRange    = 0.25 * M_PI;  // some variation in angle
    rocket.velocity            = 500;
    rocket.velocityRange    = 100;
    rocket.yAcceleration    = 30;
    rocket.lifetime            = 1.02;    // we cannot set the birthrate < 1.0 for the burst
    
    //小圆球图片
    rocket.contents            = (id) [[UIImage imageNamed:@"DazRing"] CGImage];
    rocket.scale            = 0.2;
    rocket.color            = [[UIColor redColor] CGColor];
    rocket.greenRange        = 1.0;        // different colors
    rocket.redRange            = 1.0;
    rocket.blueRange        = 1.0;
    rocket.spinRange        = M_PI;        // slow spin
    
    
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate            = 1.0;        // at the end of travel
    burst.velocity            = 0;        //速度为0
    burst.scale                = 2.5;      //大小
    burst.redSpeed            =-1.5;        // shifting
    burst.blueSpeed            =+1.5;        // shifting
    burst.greenSpeed        =+1.0;        // shifting
    burst.lifetime            = 1.0;     //存在时间
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate            = 400;
    spark.velocity            = 125;
    spark.emissionRange        = 2* M_PI;    // 360 度
    spark.yAcceleration        = 100;        // gravity
    spark.lifetime            = 2.0;
    //星星图片
    spark.contents            = (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
    spark.scaleSpeed        =-0.2;
    spark.greenSpeed        =-0.1;
    spark.redSpeed            = 0.4;
    spark.blueSpeed            =-0.1;
    spark.alphaSpeed        =-0.25;
    spark.spin                = 2* M_PI;
    spark.spinRange            = 2* M_PI;
    
    // 3种粒子组合，可以根据顺序，依次烟花弹－烟花弹粒子爆炸－爆炸散开粒子
    fireworksEmitter.emitterCells    = [NSArray arrayWithObject:rocket];
    rocket.emitterCells                = [NSArray arrayWithObject:burst];
    burst.emitterCells                = [NSArray arrayWithObject:spark];
    [self.bgImgView.layer addSublayer:fireworksEmitter];
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
