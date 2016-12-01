//
//  OftenInSearchResultTableViewCell.m
//  GJieGo
//
//  Created by liubei on 16/8/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "OftenInSearchResultTableViewCell.h"

@interface OftenInSearchResultTableViewCell () {
    
    UIView *holder;
    UIImageView *iconView;
    UILabel *titleLabel;
    UILabel *addressLabel;
    UIImageView *loveImg;
    UIImageView *distanceImg;
    UILabel *loveCount;
    UILabel *distance;
}

@end

@implementation OftenInSearchResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        CGFloat insideMag = 10.f;
        CGFloat outMag = 5.f;
        CGFloat leftMag = 15.f;
        CGFloat imgSize = 55.f;
        
        holder = [[UIView alloc] init];
        holder.backgroundColor = [UIColor whiteColor];
        
        iconView = [[UIImageView alloc] init];// iconView.image = [UIImage imageNamed:@"image"];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.clipsToBounds = YES;
        [holder addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(holder.mas_top).with.offset(@(insideMag));
            make.left.equalTo(holder.mas_left).with.offset(@(leftMag));
            make.width.and.height.mas_equalTo(@(imgSize));
        }];
        
        titleLabel = [[UILabel alloc] init];//    titleLabel.text = @"title";
        [titleLabel setTextColor:GJGBLACKCOLOR];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [holder addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(iconView.mas_right).with.offset(@8);
            make.top.equalTo(iconView.mas_top).with.offset(@0);
            make.right.equalTo(holder.mas_right).with.offset(-15);
            make.height.mas_equalTo(@(imgSize * 0.5));
        }];
        
        addressLabel = [[UILabel alloc] init];//  addressLabel.text = @"龙德广场 F1";
        [addressLabel setTextColor:GJGGRAYCOLOR];
        [addressLabel setFont:[UIFont systemFontOfSize:11]];
        [addressLabel setTextAlignment:NSTextAlignmentLeft];
        [holder addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(iconView.mas_right).with.offset(@8);
            make.bottom.equalTo(iconView.mas_bottom).with.offset(@0);
//            make.right.equalTo(loveImg.mas_left).with.offset(-15);
            make.height.mas_equalTo(@(imgSize * 0.5));
            make.width.mas_equalTo(@(kScreenWidth * 0.4));
        }];
        
        distanceImg = [[UIImageView alloc] init];
        distanceImg.image = [UIImage imageNamed:@"content_icon_positioning_disabled"];
        distanceImg.contentMode = UIViewContentModeScaleAspectFit;
        [holder addSubview:distanceImg];
        [distanceImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
//            make.bottom.equalTo(iconView.mas_bottom).with.offset(0);
            make.centerY.equalTo(addressLabel.mas_centerY).with.offset(0);
            make.right.equalTo(holder.mas_right).with.offset(@(-25));
            make.width.and.height.mas_equalTo(@(14));
        }];
        
        distance = [[UILabel alloc] init];//  distance.text = @"900";
        [distance setTextColor:GJGGRAYCOLOR];
        [distance setFont:[UIFont systemFontOfSize:10]];
        [holder addSubview:distance];
        [distance mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(distanceImg.mas_centerY).with.offset(0);
            make.right.equalTo(distanceImg.mas_left).with.offset(0);
            make.height.mas_equalTo(18);
        }];
        
        loveImg = [[UIImageView alloc] init];
        loveImg.image = [UIImage imageNamed:@"search_often_collection"];
        loveImg.contentMode = UIViewContentModeScaleAspectFit;
        [holder addSubview:loveImg];
        [loveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(distanceImg.mas_centerY).with.offset(0);
            make.right.equalTo(distance.mas_left).with.offset(-32);
            make.width.and.height.mas_equalTo(@(12));
        }];
        
        loveCount = [[UILabel alloc] init];// loveCount.text = @"900";
        [loveCount setTextColor:GJGGRAYCOLOR];
        [loveCount setFont:[UIFont systemFontOfSize:10]];
        [holder addSubview:loveCount];
        [loveCount mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(distanceImg.mas_centerY).with.offset(0);
            make.left.equalTo(loveImg.mas_right).with.offset(2);
            make.height.mas_equalTo(18);
        }];
        
        [self.contentView addSubview:holder];
        [holder mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.equalTo(self.contentView).with.offset(0);
            make.top.equalTo(self.contentView.mas_top).with.offset(outMag);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-outMag);
        }];
    }
    return self;
}


#pragma mark - Setting

- (void)setShop:(LBShopM *)shop {
    
    _shop = shop;
    if ([shop.Image hasPrefix:@"http"]) {
        [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@150w_1o", shop.Image]]
                    placeholderImage:[UIImage imageNamed:@"image"]];
    }
    titleLabel.text = shop.ShopName;
    addressLabel.text = shop.Floor.length ? [NSString stringWithFormat:@"%@ %@", shop.MallName, shop.Floor] : shop.MallName;
    loveCount.text = [NSString stringWithFormat:@"%lu", shop.Collection >= 0 ? shop.Collection : 0];
    distance.text = shop.Distance;
}

@end
