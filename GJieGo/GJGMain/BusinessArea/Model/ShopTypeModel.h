//
//  ShopTypeModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---店铺信息  4.8.6	根据名称搜索店铺  4.8.9	获取用户收藏的店铺

#import "BaseModel.h"


@interface ShopTypeItem : BaseModel
/*店铺ID*/
@property (nonatomic, assign)NSInteger ShopID;
/*收藏数*/
@property (nonatomic, assign)NSInteger Collection;
/*商场ID*/
@property (nonatomic, assign)NSInteger MallID;
/*距离*/
@property (nonatomic, copy)NSString *Distance;
/*店铺名称*/
@property (nonatomic, copy)NSString *ShopName;
/*店铺图片*/
@property (nonatomic, copy)NSString *Image;
/*店铺楼层*/
@property (nonatomic, copy)NSString *Floor;
/*商场名称*/
@property (nonatomic, copy)NSString *MallName;
/*店铺业态类型*/
@property (nonatomic, copy)NSString *TypeKey;

@end


@interface ShopTypeModel : BaseModel

@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end