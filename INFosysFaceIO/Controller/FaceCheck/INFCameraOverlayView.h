//
//  INFCamerOverlayView.h
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/27.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol takePhotoDelegate
@required
- (void)closeCamera;
- (void)takePhoto;
@end

@interface INFCameraOverlayView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoIMG;
@property (weak, nonatomic) IBOutlet UIImageView *scanIMG;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UILabel *cautionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barIMG;
@property (nonatomic, weak) id<takePhotoDelegate> delegate;
@end
