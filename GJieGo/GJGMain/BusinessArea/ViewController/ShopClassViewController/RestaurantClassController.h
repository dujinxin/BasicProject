//
//  RestaurantClassController.h
//  GJieGo
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface RestaurantClassController : BaseViewController
@property (nonatomic, copy)NSString *shopId;
@property (nonatomic, copy)NSString *bcId;      //商圈id
@property (nonatomic, copy)NSString *TypeKey;   //商场业态类型
@property (nonatomic, copy)NSString *dicID;    //生活类型ID
@property (nonatomic, copy)NSString *dicName;    //生活类型名称
@end
