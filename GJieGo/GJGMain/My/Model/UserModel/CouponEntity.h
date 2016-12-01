//
//  CouponEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface CouponEntity : BasicEntity

@property (nonatomic,copy) NSString * CouponID;//优惠券ID
@property (nonatomic,copy) NSString * CouponName;//优惠券名称
@property (nonatomic,copy) NSString * ShopID;//店铺ID
@property (nonatomic,copy) NSString * ShopName;//店铺名称
@property (nonatomic,copy) NSString * DiscountDesc;//折扣描述
@property (nonatomic,copy) NSString * AvailableTime;//可用时间
@property (nonatomic,copy) NSString * Discount;//折扣【5元】
@property (nonatomic,copy) NSString * TypeID;//类型
@property (nonatomic,copy) NSString * TypeName;//类型名称【折扣券】
@property (nonatomic,copy) NSString * Status;//优惠券状态


@end


@interface CouponShopEntity : CouponEntity

@property (nonatomic,copy) NSString * QuantityLimit;//可领数量

@end


@interface CouponDetailEntity : CouponEntity

@property (nonatomic,copy) NSString * QuantityLimit;//可领数量
@property (nonatomic,copy) NSString * ShopDesc;//店铺介绍
@property (nonatomic,copy) NSString * ShopAddress;//店铺地址
@property (nonatomic,copy) NSString * Distance;//距离


@end


@interface CouponObj : DJXRequest

@end

@interface CouponShopObj : DJXRequest

@end

@interface CouponDetailObj : DJXRequest

@end
