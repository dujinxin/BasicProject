//
//  ADViewEntity.h
//  GJieGo
//
//  Created by gjg on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface ADViewEntity : BasicEntity <NSCoding>

@property (nonatomic,strong) NSNumber * ADId;//广告编号
@property (nonatomic,strong) NSNumber * LinkId;//链接信息编号
@property (nonatomic,strong) NSNumber * LinkType;//链接信息类型
@property (nonatomic,copy) NSString *Image;//广告图片
@property (nonatomic,copy) NSString *LinkUrl;//跳转链接
@property (nonatomic,copy) NSString *BusinessFormat;// 店铺类型或商场类型

@end

@interface ADObj : DJXRequest

@end
