//
//  MallDetailModel.h
//  GJieGo
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 yangzx. All rights reserved.
//  4.7.4	获取商场详情

#import "BaseModel.h"

@interface MallDetailServicesItem : BaseModel
@property (nonatomic, copy)NSString *Image;
@property (nonatomic, copy)NSString *Name;

@end

@interface MallDetailItem : BaseModel
/*商场ID*/
@property (nonatomic, assign)NSInteger MallID;
/*店铺ID*/
@property (nonatomic, assign)NSInteger ShopID;
/*图片*/
@property (nonatomic, copy)NSString *Image;
/*名称*/
@property (nonatomic, copy)NSString *Name;
/*营业时间*/
@property (nonatomic, copy)NSString *BusinessHours;
/*地址*/
@property (nonatomic, copy)NSString *Address;
/*联系电话*/
@property (nonatomic, copy)NSString *PhoneNumber;
/*商场服务列表*/
@property (nonatomic, strong)NSMutableArray *Services;
@end

@interface MallDetailModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, strong)NSDictionary *Data;
@end

