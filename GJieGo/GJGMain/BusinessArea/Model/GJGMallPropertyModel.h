//
//  GJGMallPropertyModel.h
//  GJieGo
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 yangzx. All rights reserved.
//  4.7.3	获取商场相关属性

#import "BaseModel.h"

@interface MallPropertyItem : BaseModel
/*图片*/
@property (nonatomic, copy)NSString *PropertyImage;
/*名称*/
@property (nonatomic, copy)NSString *PropertyName;
/*内容*/
@property (nonatomic, copy)NSString *PropertyContent;
@end

@interface GJGMallPropertyModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, strong)NSDictionary *Data;
@end
