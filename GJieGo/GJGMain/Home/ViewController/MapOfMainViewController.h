//
//  MapOfMainViewController.h
//  GJieGo
//
//  Created by liubei on 16/5/17.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MapOfMainViewController : BaseViewController
/** 导购所在商店ID */
@property (nonatomic, assign) NSInteger shopId;
/** 商店名 */
@property (nonatomic, copy) NSString *shopName;
/** 商店地址 */
@property (nonatomic, copy) NSString *shopAddress;
/** 坐标 */
@property (nonatomic, strong) CLLocation *shopLocation;
@end
