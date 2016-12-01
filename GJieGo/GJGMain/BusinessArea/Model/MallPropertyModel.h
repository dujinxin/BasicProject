//
//  MallPropertyModel.h
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---获取商场相关属性

#import "BaseModel.h"


//@interface MallPropertyItem : BaseModel
//@property (nonatomic, copy)NSString *PropertyImage;
//@property (nonatomic, copy)NSString *PropertyName;
//@property (nonatomic, copy)NSString *PropertyContent;
//@end


@interface MallPropertyModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, copy)NSString *message;
//@property (nonatomic, strong)MallPropertyItem *Data;
@end
