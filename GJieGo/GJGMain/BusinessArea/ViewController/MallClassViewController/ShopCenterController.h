//
//  ShopCenterController.h
//  GJieGo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopCenterController : BaseViewController

@property (nonatomic, copy)NSString *mId;       //商场ID
@property (nonatomic, assign)NSInteger type;    //1:购物中心 和 百货商场  2:电器卖场 家具卖场 家具城
@property (nonatomic, copy)NSString *typeKey;   //事件id
@property (nonatomic, copy)NSString *bcId;      //商圈id
@end
