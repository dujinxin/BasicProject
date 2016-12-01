//
//  PromotionDetailController.h
//  GJieGo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionDetailController : BaseViewController
@property (nonatomic, copy)NSString *infoId;       //优惠券ID

@property (nonatomic, copy)NSString *shopId;                //店铺ID
@property (nonatomic, copy)NSString *mId;                   //商场ID
@property (nonatomic, copy)NSString *vcClass;               //类型 商场mall还是店铺shop
@property (nonatomic, copy)NSString *typeKey;   //事件id  shoppingcenter
@property (nonatomic, copy)NSString *bcId;      //商圈id
@property (nonatomic, copy)NSString *event;   //事件id
@property (nonatomic, copy)NSString *hType;                 //热推分类ID
@end
