//
//  LBShopM.h
//  GJieGo
//
//  Created by liubei on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"

@interface LBShopM : LBBaseModel
/** 店铺ID */
@property (nonatomic, assign) NSInteger ShopID;
/** 店铺名称 */
@property (nonatomic, copy) NSString *ShopName;
/** 店铺图片 */
@property (nonatomic, copy) NSString *Image;
/** 店铺楼层 */
@property (nonatomic, copy) NSString *Floor;
/** 收藏数 */
@property (nonatomic, assign) NSInteger Collection;
/** 商场名称 */
@property (nonatomic, copy) NSString *MallName;
/** 商场ID */
@property (nonatomic, assign) NSInteger MallID;
/** 距离 */
@property (nonatomic, copy) NSString *Distance;
/** 店铺类型 */
@property (nonatomic, copy) NSString *TypeKey;
@end
