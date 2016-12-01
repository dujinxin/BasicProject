//
//  BrandCouponController.h
//  GJieGo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface BrandCouponController : BaseViewController

@property (nonatomic, strong)NSArray *sourceArray;          //品牌分类数组
@property (nonatomic, copy)NSString *mId;                   //商场id
@property (nonatomic, copy)NSString *type;                  //店铺商品类型
@end
