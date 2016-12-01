//
//  GJGADTool.h
//  GJieGo
//
//  Created by gjg on 16/7/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADViewEntity.h"
#define GJGADFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GJGAD.data"]
#define GJGADImageFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GJGADImage.png"]

@interface GJGADTool : NSObject

@property (nonatomic,strong) ADViewEntity *entity;


+ (instancetype)sharedManager;

/**保存网络模型*/
- (BOOL)preserveADEntity:(ADViewEntity *)entity;

/**清楚单利中的模型*/
- (void)anyAD;

/**请求失败 判断缓存*/
- (void)isHaveADEntity;
@end
