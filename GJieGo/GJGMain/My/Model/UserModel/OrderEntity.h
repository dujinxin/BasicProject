//
//  OrderEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface OrderEntity : BasicEntity

@property (nonatomic,copy) NSString * OrderID;//订单ID
@property (nonatomic,copy) NSString * ShopID;//店铺ID
@property (nonatomic,copy) NSString * ShopName;//店铺名称
@property (nonatomic,copy) NSString * PayDate;//支付时间
@property (nonatomic,copy) NSString * Cost;//金额
@property (nonatomic,copy) NSString * Discount;//折扣
@property (nonatomic,copy) NSString * State;//点单状态
@property (nonatomic,copy) NSString * GuideID;//导购ID
@property (nonatomic,copy) NSString * GuideName;//导购名称
@property (nonatomic,copy) NSString * GuideImage;//导购头像
@property (nonatomic,copy) NSString * OrderNumber;//订单号

@end

@interface OrderDetailEntity : OrderEntity

@property (nonatomic,copy) NSString * FollowNumber;//关注数

@end

@interface OrderObj : DJXRequest

@end

@interface OrderDetailObj : DJXRequest

@end