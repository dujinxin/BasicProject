//
//  ProductTypeMallModel.h
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---获取商场商品分类【男装、女装、】

#import "BaseModel.h"

@interface ProductTypeMallItem : BaseModel
@property (nonatomic, assign)NSInteger DicID;
@property (nonatomic, copy)NSString *DicKey;
@property (nonatomic, copy)NSString *DicName;
@property (nonatomic, copy)NSString *DicExt;

@end

@interface ProductTypeMallModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end