//
//  ShopInMallTypeModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---获取商场下某类型店铺列表

#import "BaseModel.h"

@interface ShopInMallTypeModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end


@interface ShopInMallTypeItem : BaseModel
/*店铺ID*/
@property (nonatomic, assign)NSInteger ShopID;
/*收藏数*/
@property (nonatomic, assign)NSInteger Collection;
/*店铺名称*/
@property (nonatomic, copy)NSString *ShopName;
/*店铺图片*/
@property (nonatomic, copy)NSString *Image;
/*店铺楼层*/
@property (nonatomic, copy)NSString *Floor;
/*店铺业态类型*/
@property (nonatomic, copy)NSString *TypeKey;
@end