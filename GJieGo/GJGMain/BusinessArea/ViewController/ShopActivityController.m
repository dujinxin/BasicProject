//
//  ShopActivityController.m
//  GJieGo
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---店铺活动

#import "ShopActivityController.h"
#import "ShopActivityListCell.h"
#import "PromotionDetailController.h"

@interface ShopActivityController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)BaseTableView *activityTableView;
@end

@implementation ShopActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.activityTableView.dataSource = self;
    self.activityTableView.delegate = self;
    self.activityTableView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    self.activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.activityTableView.rowHeight = UITableViewAutomaticDimension;
    self.activityTableView.estimatedRowHeight = 44.f;
    [self.activityTableView registerClass:[ShopActivityListCell class] forCellReuseIdentifier:@"ShopActivityListCell"];
    [self.view addSubview:self.activityTableView];
    [self.activityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionDetailController *controller = [[PromotionDetailController alloc] init];
    controller.title = @"活动详情";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopActivityListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.activityImage.image = [UIImage imageNamed:@"Image"];
    cell.activityName.text = @"Zara新春打折优惠活动";
    cell.activityTime.text = @"2016.3.22";
    cell.activityStow.text = @"230";
    return cell;
}

@end
