//
//  OrderListCell.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)enterStore:(id)sender {
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.orderStoreView];
        [self addSubview:self.orderContentView];
        
        [self layoutSubView];
    }
    return self;
}
- (OrderStoreView *)orderStoreView{
    if (!_orderStoreView) {
        _orderStoreView = [OrderStoreView new];
    }
    return _orderStoreView;
}
- (OrderContentView *)orderContentView{
    if (!_orderContentView){
        _orderContentView = [OrderContentView new];
    }
    return _orderContentView;
}
- (void)layoutSubView{
    [_orderStoreView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self);
        make.height.equalTo(40);
    }];
    [_orderContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(_orderStoreView.bottom).offset(5);
        make.height.equalTo(127);
    }];
}
- (void)setOrderListCell:(id)entity indexPath:(NSIndexPath *)indexPath{
    OrderEntity * orderEntity = (OrderEntity *)entity;
    self.orderStoreView.nameLabel.text = orderEntity.ShopName;
    [self.orderStoreView setStoreName:orderEntity.ShopName];
    self.orderStoreView.detailLabel.text = orderEntity.State;

    self.orderContentView.orderTimeLabel.text = [NSString stringWithFormat:@"消费时间：%@",orderEntity.PayDate];
    self.orderContentView.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",orderEntity.OrderNumber];
    [self.orderContentView.orderImageView sd_setImageWithURL:[NSURL URLWithString:@""]placeholderImage:JXImageNamed(@"default_portrait_less")];
    self.orderContentView.orderMoneyLabel.text = [NSString stringWithFormat:@"￥%@",orderEntity.Cost];
    self.orderContentView.VIPDiscountLabel.text = [NSString stringWithFormat:@"节省：会员折上扣-%@",orderEntity.Discount];
    self.orderContentView.couponDiscountLabel.text = [NSString stringWithFormat:@"优惠券抵扣-%@",nil];
    self.orderContentView.guiderLabel.text = [NSString stringWithFormat:@"服务导购-%@",orderEntity.GuideName];
}
@end
