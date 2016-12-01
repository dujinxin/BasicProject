//
//  OpenedCityModel.h
//  GJieGo
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 yangzx. All rights reserved.
//   4.13.1	获取开放城市列表

#import "BaseModel.h"

@interface OpenedCityModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end

@interface OpenedCityItem : BaseModel

@property (nonatomic, assign)NSInteger CityID;
@property (nonatomic, copy)NSString *CityName;
@end