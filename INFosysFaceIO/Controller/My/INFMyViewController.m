//
//  INFMyViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "INFMyViewController.h"
#import "AttendanceViewController.h"
#import "MyViewLitsCell.h"

@interface INFMyViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *_lists;
    UITableView *_tableView;
    UILabel *_count1;
    UILabel *_count2;
}

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation INFMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    [self configTopView];
    [self configBottomView];
}

- (void)configTopView {
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.bgImageView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [self.view addSubview:self.bgImageView];
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo"]];
    [self.view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.mas_equalTo(50);
        make.height.width.mas_equalTo(70);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"lvy_wang06";
    nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(130);
        make.top.mas_equalTo(55);
    }];
    
    UILabel *acount = [[UILabel alloc] init];
    acount.text = @"429536";
    acount.textColor = [UIColor whiteColor];
    acount.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:acount];
    [acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
        make.left.equalTo(nameLabel);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(54);
        make.right.mas_equalTo(-15);
        make.height.width.mas_equalTo(28);
    }];
}

- (void)closeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backToHomeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"跳会Home");
    }];
}

- (void)configBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, kScreenW, kScreenH - 140)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.bgImageView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(140);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = [UIColor colorWithHexString:@"#717171"];
    [bottomView addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(76);
        make.height.mas_equalTo(0.5);
        make.width.equalTo(bottomView);
    }];
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = [UIColor colorWithHexString:@"#717171"];
    [bottomView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(17);
        make.width.mas_equalTo(0.5);
        make.bottom.equalTo(hLine.mas_top).offset(-17);
        make.centerX.equalTo(bottomView);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"本月出勤";
    label1.textColor = [UIColor colorWithHexString:@"#717171"];
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.equalTo(vLine.mas_left).offset(-50);
    }];
    
    UILabel *count1 = [[UILabel alloc] init];
    count1.text = @"20";
    count1.textColor = [UIColor colorWithHexString:@"#1d84d1"];
    count1.font = [UIFont boldSystemFontOfSize:20];
    [bottomView addSubview:count1];
    _count1 = count1;
    [count1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom);
        make.bottom.equalTo(hLine.mas_top);
        make.centerX.equalTo(label1);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"本月缺勤";
    label2.textColor = [UIColor colorWithHexString:@"#717171"];
    label2.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.equalTo(vLine.mas_right).offset(50);
    }];
    
    UILabel *count2 = [[UILabel alloc] init];
    count2.text = @"2";
    count2.textColor = [UIColor colorWithHexString:@"#1d84d1"];
    count2.font = [UIFont boldSystemFontOfSize:20];
    [bottomView addSubview:count2];
    _count2 = count2;
    [count2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom);
        make.bottom.equalTo(hLine.mas_top);
        make.centerX.equalTo(label2);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 86, kScreenW, kScreenH - 250) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [bottomView addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    self.bgImageView.userInteractionEnabled = YES;
    bottomView.userInteractionEnabled = YES;
    _tableView.userInteractionEnabled = YES;
}

- (void)loadData {
    _lists = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *titles = @[@"首页", @"查询考勤", @"身份验证"];
    NSArray *images = @[@"", @"", @""];
    [_lists setObject:titles forKey:@"titles"];
    [_lists setObject:images forKey:@"images"];
}

#pragma mark TableViewDelegate, TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lists[@"titles"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyViewLitsCell *cell = [MyViewLitsCell cellWithTableView:tableView];
    cell.image = [_lists[@"images"] objectAtIndex:indexPath.row];
    cell.title = [_lists[@"titles"] objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MyViewLitsCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            //.....
            break;
        case 1:
            [self presentViewController:[[AttendanceViewController alloc] init] animated:YES completion:nil];
            break;
        default:
            break;
    }
}

@end
