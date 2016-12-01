//
//  ModifyGenderViewController.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "BasicViewController.h"

typedef void(^CallBackBlock)(id object);
@interface ModifyGenderViewController : BasicViewController

@property (nonatomic, copy, readwrite) NSNumber * gender;
@property (nonatomic, copy, readwrite) CallBackBlock block;
@end
