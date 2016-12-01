//
//  ShopInSearchTableViewCell.m
//  GJieGo
//
//  Created by liubei on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShopInSearchTableViewCell.h"
#import "AppMacro.h"

@interface ShopInSearchTableViewCell () {
    
    UIView *holderView;
    
    UIImageView *bgImgView;
    UIView *alphaView;
    UIView *midHolderView;
    UILabel *nameLabel;
    UILabel *locationLabel;
    UIButton *distanceBtn;
}

@end

@implementation ShopInSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        CGFloat topMargin = 17.f;
        CGFloat botMargin = 17.f;
        CGFloat horMargin = 21.f;
        CGFloat verMargin = 10.f;
        
        holderView = [[UIView alloc] init];
        holderView.backgroundColor = [UIColor clearColor];
        
        bgImgView = [[UIImageView alloc] init];// bgImgView.image = [UIImage imageNamed:@"image_two"];
        [holderView addSubview:bgImgView];
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.and.right.equalTo(holderView).with.offset(0);
        }];
        
        alphaView = [[UIView alloc] init];
        alphaView.backgroundColor = [UIColor blackColor];
        alphaView.alpha = 0.3;
        [holderView addSubview:alphaView];
        [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.left.bottom.and.right.equalTo(holderView).with.offset(0);
        }];
        
        midHolderView = [[UIView alloc] init];
        midHolderView.backgroundColor = [UIColor clearColor];
        midHolderView.layer.borderWidth = 1.5;
        midHolderView.layer.borderColor = GJGRGB16Color(0xffffff).CGColor;
        
        nameLabel = [[UILabel alloc] init];//     nameLabel.text = @"Basic House";
        [nameLabel setFont:[UIFont systemFontOfSize:17]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:GJGRGB16Color(0xffffff)];
        [midHolderView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(midHolderView).with.offset(topMargin);
            make.left.and.right.equalTo(midHolderView).with.offset(0);
        }];
        
        locationLabel = [[UILabel alloc] init];//  locationLabel.text = @"朝阳区 望京国际商业中心E座 1楼";
        [locationLabel setTextColor:GJGRGB16Color(0xffffff)];
        [locationLabel setFont:[UIFont systemFontOfSize:13]];
        [midHolderView addSubview:locationLabel];
        [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(midHolderView).with.offset(horMargin);
            make.bottom.equalTo(midHolderView).with.offset(-botMargin);
            make.top.equalTo(nameLabel.mas_bottom).with.offset(verMargin);
        }];
        
        distanceBtn = [[UIButton alloc] init];//   [distanceBtn setTitle:@"320m" forState:UIControlStateNormal];
        [distanceBtn setEnabled:NO];
        [distanceBtn setAdjustsImageWhenDisabled:NO];
        [distanceBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [distanceBtn setTitleColor:GJGRGB16Color(0xffffff) forState:UIControlStateNormal];
        [distanceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, -3)];
        [distanceBtn setImage:[UIImage imageNamed:@"content_positioning"] forState:UIControlStateNormal];
        [midHolderView addSubview:distanceBtn];
        [distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(midHolderView).with.offset(-botMargin);
            make.right.equalTo(midHolderView).with.offset(-horMargin);
            make.left.equalTo(locationLabel.mas_right).with.offset(horMargin);
            make.top.equalTo(locationLabel.mas_top).with.offset(0);
        }];
        
        [holderView addSubview:midHolderView];
        [midHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.center.equalTo(holderView.center);
        }];
        
        [self.contentView addSubview:holderView];
        [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.bottom.and.right.equalTo(self.contentView).with.offset(0);
        }];
    }
    return self;
}

- (void)setShop:(LBShopM *)shop {
    
    _shop = shop;
    nameLabel.text = shop.ShopName;
    if ([shop.Image hasPrefix:@"http"]) {
        [bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@1080w_1o", shop.Image]]
                     placeholderImage:[UIImage imageNamed:@"image_two"]];
    }
    locationLabel.text = [NSString stringWithFormat:@"%@ %@", shop.MallName, shop.Floor];
    [distanceBtn setTitle:shop.Distance forState:UIControlStateNormal];
}

@end
