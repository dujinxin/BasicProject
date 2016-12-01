//
//  UserEntity.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJXRequest.h"
#import "MJExtension.h"

@interface UserEntity : NSObject

@property (nonatomic,copy) NSString * store_name;
@property (nonatomic,copy) NSString * store_id;

@end


@interface UserObj : DJXRequest

@end