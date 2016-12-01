//
//  YTOperationModel.h
//  GJieGo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseModel.h"

@interface YTOperationModel : BaseModel
@property (nonatomic, assign)NSInteger Status;
@property (nonatomic, strong)NSString *Msg;
@property (nonatomic, strong)NSString *Data;
@property (nonatomic, strong)NSString *TotalPage;

@end
