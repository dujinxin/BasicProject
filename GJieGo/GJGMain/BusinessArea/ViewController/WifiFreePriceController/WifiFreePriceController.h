//
//  WifiFreePriceController.h
//  GJieGo
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface WifiFreePriceController : BaseViewController
@property (nonatomic, copy)NSString *shopId;        //店铺id
@property (nonatomic, copy)NSString *mallId;        //商场id
@property (nonatomic, copy)NSString *Type;          //商场还是店铺类型  2.商场  3.店铺
@end
