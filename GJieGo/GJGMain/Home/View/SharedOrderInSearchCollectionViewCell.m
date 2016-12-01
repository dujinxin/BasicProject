//
//  SharedOrderInSearchCollectionViewCell.m
//  GJieGo
//
//  Created by liubei on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SharedOrderInSearchCollectionViewCell.h"
#import "LBUserM.h"
#import "AppMacro.h"

@interface SharedOrderInSearchCollectionViewCell () {
    
    UIImageView *bigImgView;
    UIImageView *iconView;
    UILabel *userNameLabel;
    UILabel *introLabel;
    UIButton *msgCountButton;
    UIButton *loveCountButton;
}

@end

@implementation SharedOrderInSearchCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath{
    
    SharedOrderInSearchCollectionViewCell *cell = nil;
    cell =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class])
                                                    forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[self alloc] initWithFrame:CGRectZero];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        bigImgView = [[UIImageView alloc] init];
        [bigImgView setImage:[UIImage imageNamed:@"image_four"]];
        bigImgView.contentMode = UIViewContentModeScaleAspectFill;
        bigImgView.clipsToBounds = YES;
        [self.contentView addSubview:bigImgView];
        [bigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.and.right.equalTo(self.contentView).with.offset(0);
            make.height.equalTo([SharedOrderInSearchCollectionViewCell getSize].width * 1.08);
        }];
        
        iconView = [[UIImageView alloc] init];
        [iconView setImage:[UIImage imageNamed:@"image_four"]];
        iconView.layer.cornerRadius = 12;
        iconView.layer.masksToBounds = YES;
        iconView.layer.shouldRasterize = YES;
        iconView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(clickUser)];
        [iconView addGestureRecognizer:imgTap];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).with.offset(6);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-6);
            make.width.and.height.mas_equalTo(@24);
        }];
        
        loveCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loveCountButton setEnabled:NO];
        [loveCountButton setAdjustsImageWhenDisabled:NO];
        [loveCountButton setAdjustsImageWhenHighlighted:NO];
        [loveCountButton setImage:[UIImage imageNamed:@"thumbup_default"] forState:UIControlStateNormal];
        [loveCountButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [loveCountButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
        [loveCountButton setTitleColor:COLOR(153.f, 153.f, 153.f, 1) forState:UIControlStateNormal];
        [loveCountButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [loveCountButton setTitle:@"278" forState:UIControlStateNormal];
        [self.contentView addSubview:loveCountButton];
        [loveCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).with.offset(-8);
            make.centerY.equalTo(iconView.mas_centerY).with.offset(0);
            make.height.mas_equalTo(@12);
        }];
        
        userNameLabel = [[UILabel alloc] init];     userNameLabel.text = @"爱购物的Sela";
        [userNameLabel setFont:[UIFont systemFontOfSize:12]];
        [userNameLabel setTextColor:GJGRGB16Color(0x333333)];
        userNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:userNameLabel];
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser)];
        [userNameLabel addGestureRecognizer:nameTap];
        [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(iconView.mas_right).with.offset(8);
            make.centerY.equalTo(iconView.mas_centerY).with.offset(0);
        }];
        
        introLabel = [[UILabel alloc] init];        introLabel.text = @"YSL小羊皮的手感一流的进口皮质的净值干练";
        [introLabel setFont:[UIFont systemFontOfSize:14]];
        [introLabel setNumberOfLines:2];
        [introLabel setTextColor:COLOR(51.f, 51.f, 51.f, 1)];
        [self.contentView addSubview:introLabel];
        [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(8);
            make.top.equalTo(bigImgView.mas_bottom).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-8);
            make.bottom.equalTo(iconView.mas_top).with.offset(0);
        }];
    }
    return self;
}

+ (CGSize)getSize{
    
    CGFloat cellW = ([UIScreen mainScreen].bounds.size.width - 15.f * 2 - 10.f) * 0.5;
    CGFloat cellH = cellW * 1.58f;
    return CGSizeMake(cellW, cellH);
}

+ (UIEdgeInsets)getEdgeInsets {
    
    return UIEdgeInsetsMake(6.f, 15.f, 6.f, 15.f);
}

- (void)clickUser {
    
    GJGLog(@"enter user home.");
}

- (void)setSharedOrder:(LBSharedOrderM *)sharedOrder {
    
    _sharedOrder = sharedOrder;

    if ([sharedOrder.image hasPrefix:@"http"]) {
        [bigImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@525w_1o", sharedOrder.image]]
                      placeholderImage:[UIImage imageNamed:@"image_four"]
                             completed:nil];
    }
    introLabel.text = sharedOrder.Title;

    if ([sharedOrder.userM.HeadPortrait hasPrefix:@"http"]) {
        [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@90w_1o", sharedOrder.userM.HeadPortrait]]
                    placeholderImage:[UIImage imageNamed:@"image_four"]
                           completed:nil];
    }
    userNameLabel.text = sharedOrder.userM.UserName ? sharedOrder.userM.UserName : @"";
    [loveCountButton setTitle:[NSString stringWithFormat:@"%lu", sharedOrder.Like] forState:UIControlStateNormal];
}

@end
