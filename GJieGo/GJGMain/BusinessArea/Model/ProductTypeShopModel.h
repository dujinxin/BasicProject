//
//  ProductTypeShopModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---获取店铺商品分类 4.8.4	获取店铺运营分类  4.8.5	获取超市促销分类

#import "RunTypeMallModel.h"

@interface ProductTypeShopModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;

@end


@interface ProductTypeShopItem : RunTypeMallItem
//@property (nonatomic, assign)NSInteger DicID;
//@property (nonatomic, copy)NSString *DicKey;
//@property (nonatomic, copy)NSString *DicName;
//@property (nonatomic, copy)NSString *DicExt;
@property(nonatomic, assign)NSInteger ShopID;
@end