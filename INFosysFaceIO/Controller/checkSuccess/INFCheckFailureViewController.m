//
//  INFCheckFailureViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/8.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import "INFCheckFailureViewController.h"

@interface INFCheckFailureViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *faceIMG;
@property (strong, nonatomic) IBOutlet UILabel *scoreLab;

@end

@implementation INFCheckFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.faceIMG.layer.masksToBounds = YES;
//    self.faceIMG.layer.cornerRadius = 82.5;
//    [self.faceIMG setNeedsDisplay];
    self.scoreLab.text = [NSString stringWithFormat:@"%@ %@",@"Simility Score: ",_score];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
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
