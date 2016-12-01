//
//  ShareActivityViewController.h
//  GJieGo
//
//  Created by liubei on 2016/11/15.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ShareActivityModel.h"

@protocol ShareActivityViewControllerDelegate <NSObject>

@optional
- (void)shareActivityViewControllerDidSelectedActivity:(ShareActivityModel *)model;
- (void)shareActivityViewControllerDidDeleteActivity:(BOOL)delete;

@end

@interface ShareActivityViewController : BaseViewController
@property (nonatomic, weak) id<ShareActivityViewControllerDelegate> delegate;
@end
