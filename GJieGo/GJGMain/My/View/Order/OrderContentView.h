//
//  OrderContentView.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderContentView : UIView

@property (strong, nonatomic) UILabel *orderTimeLabel;
@property (strong, nonatomic) UILabel *orderNumLabel;
@property (strong, nonatomic) UIImageView *orderImageView;

@property (strong, nonatomic) UILabel *orderMoneyLabel;
@property (strong, nonatomic) UILabel *VIPDiscountLabel;
@property (strong, nonatomic) UILabel *couponDiscountLabel;

@property (strong, nonatomic) UILabel *guiderLabel;

- (void)setGuiderViewHidden:(BOOL)hidden;

@end
