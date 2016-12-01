//
//  BusinessInfoController.h
//  GJieGo
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface BusinessInfoController : BaseViewController

@property (nonatomic, copy)NSString * mId;          //商场id     Mid
@property (nonatomic, copy)NSString * pt;           //属性类型    Pt
@property (nonatomic, copy)NSString * viewRequest;    //区别商场还是店铺
@property (nonatomic, strong)NSDictionary *requestDic; //上传参数
@end
