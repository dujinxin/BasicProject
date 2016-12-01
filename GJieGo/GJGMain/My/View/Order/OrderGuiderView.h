//
//  OrderGuiderView.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger ,OrderGuiderStyle) {
    OrderGuiderStyleDefault,
    OrderGuiderStyleSubtitle
};

typedef void(^GuiderViewBlock)(id object);

@interface OrderGuiderView : UIView

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *userImageView;

@property (strong, nonatomic) UIImageView *infoDetalView;

@property (copy , nonatomic) GuiderViewBlock clickBlock;

- (instancetype)initWithStyle:(OrderGuiderStyle)style;

- (void)setClickEvents:(GuiderViewBlock)block;
@end
