//
//  LBBaseModel.h
//  GJieGo
//
//  Created by liubei on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBBaseModel : NSObject
/** 状态，0 == 成功， 1 == 失败 */
@property (nonatomic, assign) int status;
/** 弹窗样式，0 == 静默， 1 == 弹窗， 2 == ..... */
@property (nonatomic, assign) int alerttype;
/** 提示信息 */
@property (nonatomic, copy) NSString *message;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
+ (NSArray *)objectsWithArray:(NSArray *)array;

@end
