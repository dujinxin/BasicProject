//
//  BrandCouponListTableCell.m
//  GJieGo
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BrandCouponListTableCell.h"

@implementation BrandCouponListTableCell

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
    self.getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.getButton setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    self.getButton.backgroundColor = GJGRGB16Color(0xfee330);
    self.getButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.getButton.layer.borderColor = GJGRGB16Color(0xfee330).CGColor;
//    self.getButton.layer.borderWidth = 0.5f;
    self.getButton.layer.cornerRadius = 5;
    self.getButton.layer.masksToBounds = YES;
    
    UIView *hView = [[UIView alloc] init];
    hView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    self.brandLabel = [[UILabel alloc] init];
    self.brandLabel.text = self.titleLabel.text;
    self.brandLabel.font = [UIFont systemFontOfSize:15];
    self.brandLabel.textColor = GJGRGB16Color(0x333333);
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    self.moreButton.titleLabel.textAlignment = NSTextAlignmentRight;
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    UILabel *moreLabel = [UILabel labelWithFrame:CGRectZero text:@"更多" tinkColor:GJGRGB16Color(0x999999) fontSize:11.0f];
    UIImage *mImage = [UIImage imageNamed:@"list_arrow"];
    UIImageView *moreImageView = [[UIImageView alloc] initWithImage:mImage];
    moreImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:self.couponButton];
    [self.moreButton addSubview:moreLabel];
    [self.moreButton addSubview:moreImageView];
    [self addSubview:hView];
    [self addSubview:self.brandLabel];
    [self addSubview:self.moreButton];
    [self addSubview:lineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.couponLabel];
    [self addSubview:self.ruleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.getButton];
    
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.moreButton).offset(-15);
        make.centerY.equalTo(self.moreButton).with.offset(0);
        make.size.equalTo(mImage.size);
    }];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(moreImageView.leading).offset(-5);
        make.centerY.equalTo(moreImageView.centerY).with.offset(0);
    }];
    [hView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.top.equalTo(0);
        make.size.equalTo(CGSizeMake(ScreenWidth, 10));
    }];
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(hView.bottom);
        make.bottom.equalTo(lineView.top);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(0);
        make.top.equalTo(self.brandLabel);
        make.height.equalTo(self.brandLabel);
        make.width.equalTo(ScreenWidth);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.top.equalTo(50);
        make.size.equalTo(CGSizeMake(ScreenWidth, 5));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(lineView).offset(10);
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
    [self.couponButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self).offset(55);
        make.bottom.equalTo(self);
    }];
}
@end
