//
//  ShopActivityListCell.m
//  GJieGo
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShopActivityListCell.h"

@implementation ShopActivityListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatShopActivityListCellUI];
    }
    return self;
}

- (UILabel *)creatLabelWithFont:(CGFloat )font textColor:(UIColor* )color{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    return label;
}
- (void)creatShopActivityListCellUI{
    self.activityImage = [[UIImageView alloc] init];
    self.activityName = [self creatLabelWithFont:13.0f textColor:GJGBLACKCOLOR];
    self.activityTime = [self creatLabelWithFont:11.0f textColor:GJGGRAYCOLOR];
    self.activityStow = [self creatLabelWithFont:11.0f textColor:GJGGRAYCOLOR];
    UIImageView *stowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumbup_default"]];
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    
    [self addSubview:self.activityImage];
    [self addSubview:self.activityName];
    [self addSubview:self.activityTime];
    [self addSubview:self.activityStow];
    [self addSubview:stowImage];
    [self addSubview:linView];
    
    [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.top.equalTo(10);
        make.centerY.equalTo(self);
        make.height.equalTo(self.height).offset(-30);
        make.width.equalTo(self.height).with.offset(-20);
    }];
    [self.activityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.activityImage.trailing).offset(10);
        make.top.equalTo(self.activityImage);
    }];
    [self.activityTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.activityName);
        make.top.equalTo(self.activityName.bottom).offset(12);
    }];
    [self.activityStow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(-15);
        make.bottom.equalTo(linView.top).offset(-10);
    }];
    [stowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.activityStow.leading).offset(-5);
        make.centerY.equalTo(self.activityStow);
    }];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.bottom.equalTo(0);
        make.size.equalTo(CGSizeMake(ScreenWidth, 10));
    }];
}
@end
