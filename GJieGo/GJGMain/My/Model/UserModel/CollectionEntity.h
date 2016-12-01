//
//  CollectionEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/8.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface CollectionEntity : BasicEntity

@property (nonatomic,copy) NSString * ShopID;//店铺ID
@property (nonatomic,copy) NSString * ShopName;//店铺名称
@property (nonatomic,copy) NSString * Image;//店铺图片
@property (nonatomic,copy) NSString * Floor;//店铺楼层
@property (nonatomic,copy) NSString * Collection;//收藏数
@property (nonatomic,copy) NSString * MallName;//商场名称
@property (nonatomic,copy) NSString * MallID;//商场ID
@property (nonatomic,copy) NSString * Distance;//距离
@property (nonatomic,copy) NSString * TypeKey;//业态类型

@end

@interface CategoryEntity : BasicEntity

@property (nonatomic,copy) NSString * DicID;//收藏店铺商品类型ID
@property (nonatomic,copy) NSString * DicKey;//收藏店铺商品类型标识
@property (nonatomic,copy) NSString * DicName;//收藏店铺商品类型名称
@property (nonatomic,copy) NSString * DicExt;//收藏店铺商品类型图片

@end

@interface CollectionObj : DJXRequest

@end

@interface CategoryObj : DJXRequest

@end