//
//  OrderContentView.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "OrderContentView.h"

@implementation OrderContentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(tap:)];
//    [self addGestureRecognizer:tap];
    [self addSubview:self.orderTimeLabel];
    [self addSubview:self.orderNumLabel];
    [self addSubview:self.orderImageView];
    [self addSubview:self.orderMoneyLabel];
    [self addSubview:self.VIPDiscountLabel];
    [self addSubview:self.couponDiscountLabel];
    [self addSubview:self.guiderLabel];
    [self autoLayoutSubviews];
}
- (void)autoLayoutSubviews{
    [_orderTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(10);
        make.width.equalTo(kScreenWidth/2);
    }];
    [_orderNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderTimeLabel.right);
        make.top.equalTo(_orderTimeLabel);
        make.right.equalTo(-15);
        make.height.equalTo(_orderTimeLabel);
    }];
    [_orderImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(_orderTimeLabel.bottom).offset(10);
        make.width.equalTo(67);
        make.height.equalTo(67);
    }];
    [_orderMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderImageView.right).offset(15);
        make.top.equalTo(_orderTimeLabel.bottom).offset(20);
        make.height.equalTo(15);
        make.right.equalTo(-15);
    }];
    [_VIPDiscountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderImageView.right).offset(15);
        make.top.equalTo(_orderMoneyLabel.bottom).offset(12);
        make.height.equalTo(11);
        make.right.equalTo(-15);
    }];
    [_couponDiscountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderImageView.right).offset(15);
        make.top.equalTo(_VIPDiscountLabel.bottom).offset(7);
        make.height.equalTo(11);
        make.right.equalTo(-15);
    }];
    [_guiderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderImageView.right).offset(15);
        make.bottom.equalTo(self.bottom).offset(-10);
        make.height.equalTo(11);
        make.right.equalTo(-15);
    }];
}

#pragma mark - subView init
- (UIImageView *)orderImageView{
    if (!_orderImageView) {
        _orderImageView = [UIImageView new ];
        _orderImageView.backgroundColor = JXDebugColor;
        _orderImageView.image = JXImageNamed(@"default_portrait_less");
    }
    return _orderImageView;
}
- (UILabel *)orderTimeLabel{
    if (!_orderTimeLabel) {
        _orderTimeLabel = [UILabel new ];
        _orderTimeLabel.textAlignment = NSTextAlignmentLeft;
        _orderTimeLabel.font = [UIFont systemFontOfSize:10];
        _orderTimeLabel.backgroundColor = JXDebugColor;
        _orderTimeLabel.textColor = JX999999Color;
        _orderTimeLabel.text = @"消费时间：2016-03-02 14：33";
    }
    return _orderTimeLabel;
}
- (UILabel *)orderNumLabel{
    if (!_orderNumLabel) {
        _orderNumLabel = [UILabel new ];
        _orderNumLabel.textAlignment = NSTextAlignmentRight;
        _orderNumLabel.font = [UIFont systemFontOfSize:10];
        _orderNumLabel.backgroundColor = JXDebugColor;
        _orderNumLabel.textColor = JX999999Color;
        _orderNumLabel.text = @"订单号：23434234234";
    }
    return _orderNumLabel;
}
- (UILabel *)orderMoneyLabel{
    if (!_orderMoneyLabel) {
        _orderMoneyLabel = [UILabel new ];
        _orderMoneyLabel.textAlignment = NSTextAlignmentRight;
        _orderMoneyLabel.font = [UIFont systemFontOfSize:15];
        _orderMoneyLabel.backgroundColor = JXDebugColor;
        _orderMoneyLabel.textColor = JX333333Color;
        _orderMoneyLabel.text = @"￥890";
    }
    return _orderMoneyLabel;
}
- (UILabel *)VIPDiscountLabel{
    if (!_VIPDiscountLabel) {
        _VIPDiscountLabel = [UILabel new ];
        _VIPDiscountLabel.textAlignment = NSTextAlignmentRight;
        _VIPDiscountLabel.font = [UIFont systemFontOfSize:11];
        _VIPDiscountLabel.backgroundColor = JXDebugColor;
        _VIPDiscountLabel.textColor = JX333333Color;
        _VIPDiscountLabel.text = @"节省：会员折上扣-20";
    }
    return _VIPDiscountLabel;
}
- (UILabel *)couponDiscountLabel{
    if (!_couponDiscountLabel) {
        _couponDiscountLabel = [UILabel new ];
        _couponDiscountLabel.textAlignment = NSTextAlignmentRight;
        _couponDiscountLabel.font = [UIFont systemFontOfSize:11];
        _couponDiscountLabel.backgroundColor = JXDebugColor;
        _couponDiscountLabel.textColor = JX333333Color;
        _couponDiscountLabel.text = @"优惠券抵扣-50";
    }
    return _couponDiscountLabel;
}

- (UILabel *)guiderLabel{
    if (!_guiderLabel) {
        _guiderLabel = [UILabel new ];
        _guiderLabel.textAlignment = NSTextAlignmentRight;
        _guiderLabel.font = [UIFont systemFontOfSize:11];
        _guiderLabel.backgroundColor = JXDebugColor;
        _guiderLabel.textColor = JX999999Color;
        _guiderLabel.text = @"服务导购-花花";
    }
    return _guiderLabel;
}

- (void)setGuiderViewHidden:(BOOL)hidden{
    _guiderLabel.hidden = hidden;
}
@end
