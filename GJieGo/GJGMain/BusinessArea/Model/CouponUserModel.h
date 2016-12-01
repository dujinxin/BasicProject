//
//  CouponUserModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---4.9.4	获取用户优惠券

#import "BaseModel.h"

@interface CouponUserItem : BaseModel
@property (nonatomic, assign)NSInteger ShopID;
@property (nonatomic, assign)NSInteger CouponID;
@property (nonatomic, copy)NSString *ShopName;
@property (nonatomic, copy)NSString *CouponName;
@property (nonatomic, copy)NSString *DiscountDesc;
@property (nonatomic, copy)NSString *AvailableTime;
@end

@interface CouponUserModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)CouponUserItem *Data;
@end
