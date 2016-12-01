//
//  MenuModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---4.8.7	获取餐厅菜单  4.8.8	获取店铺环境

#import "BaseModel.h"

@interface MenuModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;

@end

@interface MenuItem : BaseModel
@property (nonatomic, copy)NSString *MenuImage;
@property (nonatomic, copy)NSString *ShowImage;
@end