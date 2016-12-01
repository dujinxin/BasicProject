//
//  BrandCouponTableCell.m
//  GJieGo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 品牌优惠券cell ---

#import "BrandCouponTableCell.h"

@implementation BrandCouponTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeBrandCouponCell];
    }
    return self;
}

- (void)makeBrandCouponCell{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.titleLabel.textColor = GJGRGB16Color(0x333333);
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:11.0f];
    self.subTitleLabel.textColor = GJGRGB16Color(0x999999);
    self.couponLabel = [[UILabel alloc] init];
    self.couponLabel.font = [UIFont systemFontOfSize:15.0f];
    self.couponLabel.textColor = GJGRGB16Color(0x333333);
    self.ruleLabel = [[UILabel alloc] init];
    self.ruleLabel.font = [UIFont systemFontOfSize:11.0f];
    self.ruleLabel.textColor = GJGRGB16Color(0x999999);
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    self.timeLabel.textColor = GJGRGB16Color(0x999999);
    self.getButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:@"" titleSize:11.0f frame:CGRectZero Image:nil target:self action:@selector(didClikGetButtonAction:)];
    self.getButton.backgroundColor = GJGRGB16Color(0xfee330);
    [self.getButton setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    self.getButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.getButton.layer.borderColor = GJGRGB16Color(0xfee330).CGColor;
//    self.getButton.layer.borderWidth = 0.5f;
    self.getButton.layer.cornerRadius = 5;
    self.getButton.layer.masksToBounds = YES;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.couponLabel];
    [self addSubview:self.ruleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.getButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.size.equalTo(self.titleLabel);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(8);
        make.size.equalTo(self.subTitleLabel);
    }];
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.subTitleLabel.bottom).offset(8);
        make.size.equalTo(self.couponLabel);
    }];
    [self.ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.couponLabel.bottom).offset(8);
        make.size.equalTo(self.ruleLabel);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.ruleLabel.bottom).offset(8);
        make.size.equalTo(self.timeLabel);
    }];
    [self.getButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(self.titleLabel);
        make.size.equalTo(CGSizeMake(50, 30));
    }];
}
- (void)didClikGetButtonAction:(UIButton*)button{
    
}
@end
