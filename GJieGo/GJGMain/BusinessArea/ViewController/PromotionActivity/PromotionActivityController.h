//
//  PromotionActivityController.h
//  GJieGo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface PromotionActivityController : BaseViewController
@property (nonatomic, copy)NSString *shopId;                //店铺ID
@property (nonatomic, copy)NSString *mId;                   //商场ID
@property (nonatomic, copy)NSString *iType;                 //热推商品分类
@property (nonatomic, copy)NSString *hType;                 //热推分类ID

@property (nonatomic, strong)NSArray *sourceArray;          //品牌分类数组
@property (nonatomic, copy)NSString *vcClass;               //类型 商场mall还是店铺shop

@property (nonatomic, copy)NSString *bcId;      //商圈id
@end
