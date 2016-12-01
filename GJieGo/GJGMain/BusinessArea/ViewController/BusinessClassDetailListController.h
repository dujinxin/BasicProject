//
//  BusinessClassDetailListController.h
//  GJieGo
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface BusinessClassDetailListController : BaseViewController
@property (nonatomic, strong)NSString *businessName;//生活类型名称

@property (nonatomic, copy)NSString *Type;    //生活类型ID
@property (nonatomic, copy)NSString *bcId;      //商圈id
@property (nonatomic, copy)NSString *eventID;   //事件id
@end
//@property (nonatomic, copy)NSString *TypeKey;   //商场业态类型
