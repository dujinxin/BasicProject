//
//  LocationViewController.h
//  GJieGo
//
//  Created by liubei on 16/4/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol LocationViewControllerDelegate <NSObject>
 @optional
- (void)locationViewControllerSelectedLocation:(NSString *)locationName;
@end

@interface LocationViewController :BaseViewController
@property (nonatomic, weak) id<LocationViewControllerDelegate> delegate;
@end
