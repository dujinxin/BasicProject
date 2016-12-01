//
//  ShopShowModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---4.8.8	获取店铺环境

#import "BaseModel.h"

@interface ShopShowModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end

@interface ShopShowItem : BaseModel
@property (nonatomic, copy)NSString *ShowImage;
@end
