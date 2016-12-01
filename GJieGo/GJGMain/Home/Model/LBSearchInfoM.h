//
//  LBSearchInfoM.h
//  GJieGo
//
//  Created by liubei on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"

@interface LBSearchInfoM : LBBaseModel
/** 热门搜索数组 */
@property (nonatomic, strong) NSArray *hots;
/** 高度 */
@property (nonatomic, assign) NSInteger lb_rowHeight;
@end
