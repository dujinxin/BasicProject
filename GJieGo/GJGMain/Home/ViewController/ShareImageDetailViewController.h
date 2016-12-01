//
//  ShareImageDetailViewController.h
//  GJieGo
//
//  Created by liubei on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol ShareImageDetailViewControllerDelegate <NSObject>

@optional
- (void)shareImageDetailViewControllerDeleteThisImage:(BOOL)delete;

@end

@interface ShareImageDetailViewController : BaseViewController

@property (nonatomic, weak) id<ShareImageDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *showImage;

@end
