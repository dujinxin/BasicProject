//
//  RunTypeMallModel.h
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//  4.7.7	获取商场运营分类【新品到店、店长推荐、】       ---4.7.8	获取商场服务【停车场】     4.7.9	获取商场功能【wifi】    4.7.6	获取商场商品分类【男装、女装、】

#import "BaseModel.h"

@interface RunTypeMallModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end


@interface RunTypeMallItem : BaseModel
/*webView网址*/
@property (nonatomic, assign)NSString *DicParam;
/*商场功能类型ID*/
@property (nonatomic, assign)NSInteger DicID;
/*商场功能类型标识*/
@property (nonatomic, copy)NSString *DicKey;
/*商场功能类型名称*/
@property (nonatomic, copy)NSString *DicName;
/*商场功能类型图片*/
@property (nonatomic, copy)NSString *DicExt;
/*店铺ID*/
@property (nonatomic, assign)NSInteger ShopID;
/*商场ID*/
@property (nonatomic, assign)NSInteger MallID;

@end
