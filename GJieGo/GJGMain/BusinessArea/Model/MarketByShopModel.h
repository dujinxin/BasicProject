//
//  MarketByShopModel.h
//  GJieGo
//
//  Created by apple on 16/7/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//  4.8.9	获取超市促销信息列表

#import "BaseModel.h"

@interface MarketByShopModel : BaseModel

@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end

@interface MarketByShopItem : BaseModel

/*超市促销ID*/
@property (nonatomic, assign)NSInteger PPID;
/*店铺ID*/
@property (nonatomic, assign)NSInteger ShopID;
/*商场ID*/
@property (nonatomic, assign)NSInteger MallID;
/*促销名称*/
@property (nonatomic, strong)NSString *PPName;
/*图片*/
@property (nonatomic, strong)NSString *PPImage;
/*类型名称*/
@property (nonatomic, strong)NSString *PPType;
/*原始价格*/
@property (nonatomic, assign)CGFloat OPrice;
/*折扣价格*/
@property (nonatomic, assign)CGFloat DPrice;
/*促销时间*/
@property (nonatomic, strong)NSString *AvailableDate;
@end