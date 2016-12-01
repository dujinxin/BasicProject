
//
//  ShopMallTableCell.m
//  GJieGo
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 yangzx. All rights reserved.
//  男装，女装

#import "ShopMallTableCell.h"

@implementation ShopMallTableCell

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
    /*背景图*/
    self.backImageView = [[UIImageView alloc] initWithFrame:self.frame];
    /*遮盖层*/
    UIView *alphaView = [[UIView alloc] initWithFrame:self.frame];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = maskAlpha;
    /*店铺名称*/
    self.nameLabel = [self makeLabelWithSizeFont:17 color:[UIColor whiteColor] weight:0];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    /*商场名称*/
//    self.addressLabel = [self makeLabelWithSizeFont:12 color:[UIColor whiteColor] weight:0];
    /*位置几层*/
    self.floorAddressLabel = [self makeLabelWithSizeFont:12 color:[UIColor whiteColor] weight:0];
    /*收藏图片*/
    UIImageView *stowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_content_icon_focus_white_disabled"]];
    /*收藏数量*/
    self.strowLabel = [self makeLabelWithSizeFont:12 color:[UIColor whiteColor] weight:0];
    
    [self.contentView addSubview:self.backImageView];
    [self.contentView addSubview:alphaView];
    [self.contentView addSubview:self.nameLabel];
//    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.floorAddressLabel];
    [self.contentView addSubview:stowImageView];
    [self.contentView addSubview:self.strowLabel];

    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backImageView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(41);
        make.centerY.equalTo(self).offset(-20);
        make.centerX.equalTo(self);
    }];
//    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.floorAddressLabel.leading).offset(-8);
//        make.centerY.equalTo(self.floorAddressLabel);
//    }];
    [self.floorAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(10);
        make.centerX.equalTo(self.contentView).offset(-20);
        
    }];
    
    [stowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.floorAddressLabel);
        make.leading.equalTo(self.floorAddressLabel.trailing).offset(10);
    }];
    
    [self.strowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(stowImageView.trailing).offset(5);
        make.centerY.equalTo(self.floorAddressLabel);
    }];
    

}
@end
