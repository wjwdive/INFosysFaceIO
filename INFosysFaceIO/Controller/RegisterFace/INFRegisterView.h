//
//  INFRegisterView.h
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/5.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^textFiledDidEndEditingBlock) (NSString *textFiledStr);

@interface INFRegisterView : UIView
@property (nonatomic, copy) textFiledDidEndEditingBlock passValueBlock;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNo;
@property (nonatomic, strong) NSString *password;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName placeHold:(NSString *)placeHold tagId:(NSInteger)tagId;

- (void)passValueBlock:(textFiledDidEndEditingBlock)myBlock;
@end
