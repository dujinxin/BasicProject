//
//  PublicModel.h
//  GJieGo
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseModel.h"

@interface PublicModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@end
