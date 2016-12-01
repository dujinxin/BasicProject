//
//  CouponDetailTableCell.m
//  GJieGo
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "CouponDetailTableCell.h"

@implementation CouponDetailTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatCouponDetailTableViewCellUI];
    }
    return self;
}

- (UILabel *)makeLabelWithFont:(CGFloat)font textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
- (void)creatCouponDetailTableViewCellUI{
    self.CouponImageView = [[UIImageView alloc] init];
    self.titleLabel = [self makeLabelWithFont:13.0f textColor:GJGRGB16Color(0x333333)];
    self.addressLabel = [self makeLabelWithFont:11.0f textColor:GJGRGB16Color(0x999999)];
    self.addressLabel.numberOfLines = 0;
    UIImage *image = [UIImage imageNamed:@"my_content_positioning"];
    UIImageView *distanceImageView = [[UIImageView alloc] initWithImage:image];
    self.distanceLabel = [self makeLabelWithFont:11.0f textColor:GJGRGB16Color(0x333333)];
    self.distanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    UILabel *ru = [self makeLabelWithFont:14.0f textColor:GJGRGB16Color(0xff5252)];
    ru.text = @"规则";
    self.ruleLabel = [self makeLabelWithFont:11.0f textColor:GJGRGB16Color(0x999999)];
    self.ruleLabel.numberOfLines = 0;
    
    [self addSubview:self.CouponImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:distanceImageView];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.distanceButton];
    [self addSubview:lineView];
    [self addSubview:ru];
    [self addSubview:self.ruleLabel];
    
    [self.CouponImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.top.equalTo(10);
        make.width.equalTo(55);
        make.height.equalTo(55);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.CouponImageView.trailing).offset(10);
        make.top.equalTo(self).offset(17);
        make.height.equalTo(15);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom);
        make.bottom.equalTo(lineView.top);
        make.trailing.equalTo(self).offset(-15);
    }];
    [distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.distanceLabel.leading).offset(-10);
        make.top.equalTo(self.titleLabel);
        make.size.equalTo(image.size);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self.titleLabel);
        make.size.equalTo(self.distanceLabel);
    }];
    [self.distanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(distanceImageView);
        make.trailing.equalTo(self.distanceLabel);
        make.height.equalTo(30);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(75);
        make.size.equalTo(CGSizeMake(ScreenWidth, 1));
    }];
    [ru mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.CouponImageView);
        make.top.equalTo(lineView.bottom).offset(10);
        make.size.equalTo(ru);
    }];
    [self.ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.CouponImageView);
        make.top.equalTo(ru.bottom).offset(12);
        make.size.equalTo(self.ruleLabel);
    }];
}
@end
