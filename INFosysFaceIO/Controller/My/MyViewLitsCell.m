//
//  MyViewLitsCell.m
//  INFosysFaceIO
//
//  Created by Infosys Ltd. on 2017/12/27.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "MyViewLitsCell.h"

@interface MyViewLitsCell () {
    UILabel     *_titleLabel;
    UIImageView *_imageView;
}
@end

@implementation MyViewLitsCell

+ (CGFloat)cellHeight {
    return 50;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MyViewLitsCell";
    MyViewLitsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyViewLitsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell configUI];
    }
    
    return cell;
}

- (void)configUI {
    UIImageView *image = [[UIImageView alloc] init];
    _imageView = image;
    [self.contentView addSubview:image];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor colorWithHexString:@"#717171"];
    title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:title];
    _titleLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(75);
        make.height.equalTo(self);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37);
        make.centerY.equalTo(title);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(22);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setImage:(NSString *)image {
    _image = image;
    
    _imageView.image = [UIImage imageNamed:image];
}

@end
