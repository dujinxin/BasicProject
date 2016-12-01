//
//  ShopCenterListController.h
//  GJieGo
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopCenterListController : BaseViewController
@property (nonatomic, copy)NSString *TypeKey;   //商场业态类型
@property (nonatomic, assign)NSInteger bcId;    //商圈id
@property (nonatomic, assign)NSInteger bId;    //业态分类id
@property (nonatomic, copy)NSString *eventID;   //事件id
@end
