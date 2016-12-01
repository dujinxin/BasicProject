//
//  GJGBusinessClassDetailCell.m
//  GJieGo
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGBusinessClassDetailCell.h"

@implementation GJGBusinessClassDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeBusinessClassDetailCellUI];
    }
    return self;
}

- (UILabel *)makeLabelWithSizeFont:(CGFloat)size color:(UIColor *)color weight:(CGFloat)weight{
    UILabel *label = [[UILabel alloc] init];
    if (weight != 0) {
        label.font = [UIFont systemFontOfSize:size weight:weight];
    }else{
        label.font = [UIFont systemFontOfSize:size];
    }
    label.textColor = color;
    return label;
}

- (void)makeBusinessClassDetailCellUI{
    self.backImageView = [[UIImageView alloc] initWithFrame:self.frame];
    UIView *alphaView = [[UIView alloc] initWithFrame:self.frame];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = maskAlpha;
    self.nameLabel = [self makeLabelWithSizeFont:17 color:[UIColor whiteColor] weight:0];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    UIView *addressView = [[UIView alloc] init];
    self.addressLabel = [self makeLabelWithSizeFont:12 color:[UIColor whiteColor] weight:0];
    self.floorAddressLabel = [self makeLabelWithSizeFont:12 color:[UIColor whiteColor] weight:0];
    UIView *sDistanceView = [[UIView alloc] init];
    UIImageView *stowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_content_icon_focus_white_disabled"]];
    self.strowLabel = [self makeLabelWithSizeFont:12 color:[UIColor whiteColor] weight:0];
    UIImageView *distanceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_content_icon_positioning_white_disabled"]];
    self.distanceLabel = [self makeLabelWithSizeFont:12 color:[UIColor whiteColor] weight:0];
    self.backgroundColor = [UIColor blueColor];
    [addressView addSubview:self.addressLabel];
    [addressView addSubview:self.floorAddressLabel];
    [sDistanceView addSubview:stowImageView];
    [sDistanceView addSubview:self.strowLabel];
    [sDistanceView addSubview:distanceImageView];
    [sDistanceView addSubview:self.distanceLabel];
    [self addSubview:self.backImageView];
    [self addSubview:alphaView];
    [self addSubview:self.nameLabel];
    [self addSubview:addressView];
    [self addSubview:sDistanceView];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.trailing.equalTo(self);
    }];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.trailing.equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(41);
        make.centerX.equalTo(self);
        make.width.lessThanOrEqualTo(self).multipliedBy(0.5);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(addressView);
        make.top.equalTo(addressView);
        make.width.lessThanOrEqualTo(self.addressLabel);
    }];
    [self.floorAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.addressLabel.trailing).offset(6);
        make.top.equalTo(addressView);
        make.width.lessThanOrEqualTo(self.floorAddressLabel);
    }];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(10);
        make.centerX.equalTo(self);
        make.height.greaterThanOrEqualTo(self.addressLabel);
        make.leading.equalTo(self.addressLabel);
        make.trailing.equalTo(self.floorAddressLabel);
    }];
    [stowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sDistanceView);
        make.leading.equalTo(sDistanceView);
        make.width.lessThanOrEqualTo(stowImageView);
    }];
    [self.strowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(stowImageView.trailing).offset(8);
        make.top.equalTo(stowImageView);
        make.width.lessThanOrEqualTo(self.strowLabel);
    }];
    [distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.strowLabel).offset(25);
        make.top.equalTo(stowImageView);
        make.width.lessThanOrEqualTo(distanceImageView);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(distanceImageView.trailing).offset(8);
        make.top.equalTo(stowImageView);
        make.width.lessThanOrEqualTo(self.distanceLabel);
    }];
    [sDistanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.bottom).offset(10);
        make.centerX.equalTo(self);
        make.height.greaterThanOrEqualTo(stowImageView);
        make.leading.equalTo(stowImageView);
        make.trailing.equalTo(self.distanceLabel);
    }];
}
@end
