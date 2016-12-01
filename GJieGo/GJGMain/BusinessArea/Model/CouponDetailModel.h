//
//  CouponDetailModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---4.9.3	获取优惠券详情

#import "BaseModel.h"

@interface CouponDetailItem : BaseModel
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
/*规则*/
@property (nonatomic, copy)NSString *Rules;
/*店铺地址*/
@property (nonatomic, copy)NSString *ShopAddress;
/*距离*/
@property (nonatomic, copy)NSString *Distance;
/*折扣5元*/
@property (nonatomic, copy)NSString *Discount;
/*类型名称【折扣券】*/
@property (nonatomic, copy)NSString *TypeName;
/*TypeID*/
@property (nonatomic, assign)NSInteger TypeID;
/*店铺logo*/
@property (nonatomic, copy)NSString *ShopImage;
/*经度*/
@property (nonatomic, assign)float Longitude;
/*纬度*/
@property (nonatomic, assign)float Latitude;


@end

@interface CouponDetailModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSDictionary *Data;
@end
