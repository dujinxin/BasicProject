//
//  OrderUserModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---4.11.1	获取用户订单列表

#import "BaseModel.h"

@interface OrderUserItem : BaseModel
@property (nonatomic, assign)NSInteger OrderID;
@property (nonatomic, assign)NSInteger ShopID;
@property (nonatomic, assign)NSInteger State;
@property (nonatomic, assign)NSInteger GuideID;
@property (nonatomic, assign)CGFloat cost;
@property (nonatomic, copy)NSString *shopName;
@property (nonatomic, copy)NSString *PayDate;
@property (nonatomic, copy)NSString *Discount;
@property (nonatomic, copy)NSString *GuideName;
@property (nonatomic, copy)NSString *OrderNumber;
@end

@interface OrderUserModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end