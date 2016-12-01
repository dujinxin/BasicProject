
//
//  GJGShopListCell.m
//  GJieGo
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGShopListCell.h"

@interface GJGShopListCell ()
@property (nonatomic, strong)UIImageView *shopImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *distanceLabel;
@end

@implementation GJGShopListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeGJGShopListCell];
    }
    return self;
}

- (void)makeGJGShopListCell{
    self.shopImageView = [[UIImageView alloc] init];
    _shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    _shopImageView.clipsToBounds = YES;
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor blackColor].CGColor];
    layer.startPoint = CGPointMake(1, 0);
    layer.endPoint = CGPointMake(1, 1);
    layer.frame = CGRectMake(0, ScreenWidth * 0.2, ScreenWidth, ScreenWidth * 0.2);

    self.nameLabel = [self makeLabelWithTextColor:[UIColor whiteColor] textFont:14.0f];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel = [self makeLabelWithTextColor:[UIColor whiteColor] textFont:10.0f];
    UIImageView *dImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_content_icon_positioning_white_disabled"]];
    self.distanceLabel = [self makeLabelWithTextColor:[UIColor whiteColor] textFont:12.0f];
    
    [self.contentView addSubview:self.shopImageView];
    [self.contentView.layer addSublayer:layer];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:dImageView];
    [self.contentView addSubview:self.distanceLabel];
    
    [self.shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(95);
        make.bottom.equalTo(-7);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(self.nameLabel);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.right).offset(15);
        make.bottom.equalTo(self.nameLabel);
    }];
    [dImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.distanceLabel.leading).offset(-5);
        make.bottom.equalTo(self.distanceLabel).offset(-3);
    }];
    
}
- (UILabel *)makeLabelWithTextColor:(UIColor *)color textFont:(CGFloat)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

- (void)setItem:(MallBCListItem *)item{
    
    if (self.item != item) {
        self.nameLabel.text = item.Name;
        self.timeLabel.hidden = !(BOOL)(item.BusinessHours.length);
        self.timeLabel.text = [NSString stringWithFormat:@"营业时间：%@", item.BusinessHours];
        self.distanceLabel.text = item.Distance;
        [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", item.Image, (int)self.contentView.bounds.size.width]] placeholderImage:[UIImage imageNamed:@"default_landscape_normal"]];
    }
    
}
@end
