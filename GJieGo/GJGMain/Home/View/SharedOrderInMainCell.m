//
//  SharedOrderInMainCell.m
//  GJieGo
//
//  Created by liubei on 16/5/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SharedOrderInMainCell.h"
#import "LBUserM.h"
#import "AppMacro.h"

@interface SharedOrderInMainCell () {
    
    UIImageView *bigImgView;
    UIImageView *iconView;
    UILabel *userNameLabel;
    UILabel *introLabel;
    UIButton *viewCountButton;
    UIButton *loveCountButton;
}

@end

@implementation SharedOrderInMainCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath{
    
    SharedOrderInMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[self alloc] initWithFrame:CGRectZero];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.layer.cornerRadius = 3;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = GJGRGBAColor(255.f, 255.f, 255.f, 0.9);
        
        bigImgView = [[UIImageView alloc] init];//    [bigImgView setImage:[UIImage imageNamed:@"login_bg"]];
        bigImgView.contentMode = UIViewContentModeScaleAspectFill;
        bigImgView.clipsToBounds = YES;
        [self.contentView addSubview:bigImgView];
        [bigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.and.right.equalTo(self.contentView).with.offset(0);
            make.height.equalTo([SharedOrderInMainCell getSizeWithType:SharedOrderCellTypeIsMain].width * 1.08);
        }];
        
        iconView = [[UIImageView alloc] init];// [iconView setImage:[UIImage imageNamed:@"icon_consumption"]];
        iconView.layer.cornerRadius = 12;
        iconView.layer.masksToBounds = YES;
        iconView.layer.shouldRasterize = YES;
        iconView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        iconView.contentMode = UIViewContentModeScaleToFill;
//        iconView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser)];
//        [iconView addGestureRecognizer:imgTap];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).with.offset(8);
            make.top.equalTo(bigImgView.mas_bottom).with.offset(8);
            make.width.and.height.mas_equalTo(@24);
        }];
        
        userNameLabel = [[UILabel alloc] init];//     userNameLabel.text = @"爱购物的Sela";
        [userNameLabel setFont:[UIFont systemFontOfSize:13]];
        [userNameLabel setTextAlignment:NSTextAlignmentLeft];
        [userNameLabel setTextColor:COLOR(51.f, 51.f, 51.f, 1)];
        [self.contentView addSubview:userNameLabel];
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUser)];
        [userNameLabel addGestureRecognizer:nameTap];
        [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(iconView.mas_right).with.offset(6);
            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
            make.centerY.equalTo(iconView.mas_centerY).with.offset(0);
        }];
        
        viewCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewCountButton setEnabled:NO];
        [viewCountButton setAdjustsImageWhenDisabled:NO];
        [viewCountButton setAdjustsImageWhenHighlighted:NO];
        [viewCountButton setImage:[UIImage imageNamed:@"Read_"] forState:UIControlStateNormal];
        [viewCountButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [viewCountButton setTitleColor:COLOR(153.f, 153.f, 153.f, 1) forState:UIControlStateNormal];
        [viewCountButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [viewCountButton setTitle:@"0" forState:UIControlStateNormal];
        [viewCountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
        [self.contentView addSubview:viewCountButton];
        [viewCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-7);
            make.height.mas_equalTo(@12);
        }];
        
        loveCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loveCountButton setEnabled:NO];
        [loveCountButton setAdjustsImageWhenDisabled:NO];
        [loveCountButton setAdjustsImageWhenHighlighted:NO];
        [loveCountButton setImage:[UIImage imageNamed:@"content_icon_collect_disabled"] forState:UIControlStateNormal];
        [loveCountButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [loveCountButton setTitleColor:COLOR(153.f, 153.f, 153.f, 1) forState:UIControlStateNormal];
        [loveCountButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [loveCountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
        [loveCountButton setTitle:@"0" forState:UIControlStateNormal];
        [self.contentView addSubview:loveCountButton];
        [loveCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.centerY.equalTo(viewCountButton.mas_centerY).with.offset(0);
            make.height.mas_equalTo(@12);
        }];
        
        introLabel = [[UILabel alloc] init];//        introLabel.text = @"YSL小羊皮的手感一流的进口皮质的净值干练";
        [introLabel setFont:[UIFont systemFontOfSize:14]];
        [introLabel setNumberOfLines:2];
        [introLabel setTextColor:COLOR(51.f, 51.f, 51.f, 1)];
//        [self.contentView addSubview:introLabel];
////        [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////            
////            make.left.equalTo(self.contentView).with.offset(10);
////            make.top.equalTo(iconView.mas_bottom).with.offset(2);
////            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
////            make.bottom.equalTo(viewCountButton.mas_top).with.offset(-4);
////        }];
    }
    return self;
}

+ (CGSize)getSizeWithType:(SharedOrderCellType)type {
    
    CGFloat cellW = ([UIScreen mainScreen].bounds.size.width - 15.f * 2 - 10.f) * 0.5;
    CGFloat cellH = (type == SharedOrderCellTypeIsMain) ? cellW * 1.7f : cellW * 1.48f;
    
    return CGSizeMake(cellW, cellH);
}

+ (UIEdgeInsets)getEdgeInsets {
    
    return UIEdgeInsetsMake(6.f, 15.f, 6.f, 15.f);
}

- (void)clickUser {
    
    GJGLog(@"enter user home.");
}


#pragma mark - Setting

- (void)setSharedOrderType:(SharedOrderCellType)sharedOrderType {
    
    _sharedOrderType = sharedOrderType;
    
    if (sharedOrderType == SharedOrderCellTypeIsMain) {
        iconView.hidden = NO;
        userNameLabel.hidden = NO;
        [introLabel removeFromSuperview];
        [self.contentView addSubview:introLabel];
        [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(iconView.mas_bottom).with.offset(2);
            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
            make.bottom.equalTo(viewCountButton.mas_top).with.offset(-4);
        }];
    }else {
        iconView.hidden = YES;
        userNameLabel.hidden = YES;
        [introLabel removeFromSuperview];
        [self.contentView addSubview:introLabel];
        [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(bigImgView.mas_bottom).with.offset(2);
            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
            make.bottom.equalTo(viewCountButton.mas_top).with.offset(-4);
        }];
    }
}

- (void)setSharedOrder:(LBSharedOrderM *)sharedOrder {
    
    _sharedOrder = sharedOrder;
    
    [bigImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@335w_1o", sharedOrder.image]]
                  placeholderImage:[UIImage imageNamed:@"image_four"]
                         completed:nil];
    [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@72w_1o", sharedOrder.userM.HeadPortrait]]
                placeholderImage:[UIImage imageNamed:@"image_four"]
                       completed:nil];
    userNameLabel.text = sharedOrder.userM.UserName;
    
    if (sharedOrder.activityM) {
        NSString *activityName = sharedOrder.activityM.ActivityName;
        if (activityName.length > 8) {
            activityName = [NSString stringWithFormat:@"%@..", [activityName substringWithRange:NSMakeRange(0, 8)]];
        }
        NSString *showStr = [NSString stringWithFormat:@"#%@# %@", activityName, sharedOrder.Title];
        [showStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:showStr];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:GJGRGB16Color(0x368bff), NSForegroundColorAttributeName, nil];
        [AttributedStr setAttributes:attributeDict range:NSMakeRange(0, activityName.length + 2)];
        [introLabel setAttributedText:AttributedStr];
    }else {
        introLabel.text = sharedOrder.Title;
    }
    
    [viewCountButton setTitle:[NSString stringWithFormat:@"%lu", sharedOrder.ViewNum] forState:UIControlStateNormal];
    [loveCountButton setTitle:[NSString stringWithFormat:@"%lu", sharedOrder.Like] forState:UIControlStateNormal];
}

@end
