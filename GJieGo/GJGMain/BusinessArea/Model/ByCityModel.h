//
//  ByCityModel.h
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---获取城市下商圈

#import "BaseModel.h"

@interface ByCityItem : BaseModel
/*城市ID*/
@property (nonatomic, assign)NSInteger CityId;
/*商圈ID*/
@property (nonatomic, assign)NSInteger BCID;
/*商圈名称*/
@property (nonatomic, copy)NSString *BCName;
@end

@interface ByCityModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;

@end