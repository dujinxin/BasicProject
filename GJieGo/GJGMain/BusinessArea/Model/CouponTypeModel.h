//
//  CouponTypeModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---4.9.1	按商品分类获取商场下优惠券列表  4.9.2	获取店铺优惠券列表

#import "BaseModel.h"

@interface CouponTypeModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end

@interface CouponTypeItem : BaseModel
/*店铺ID*/
@property (nonatomic, assign)NSInteger ShopID;
/*店铺名称*/
@property (nonatomic, copy)NSString *ShopName;
/*优惠券ID*/
@property (nonatomic, assign)NSInteger CouponID;
/*优惠券名称*/
@property (nonatomic, copy)NSString *CouponName;
/*折扣描述*/
@property (nonatomic, copy)NSString *DiscountDesc;
/*可领数量*/
@property (nonatomic, assign)NSInteger QuantityLimit;
/*可用时间*/
@property (nonatomic, copy)NSString *AvailableTime;
/*折扣【5元】*/
@property (nonatomic, copy)NSString *Discount;
/*类型名称【折扣券】*/
@property (nonatomic, copy)NSString *TypeName;
/*类型ID 0 折扣   1 满减   2 满赠*/
@property (nonatomic, copy)NSString *TypeID;
@end
