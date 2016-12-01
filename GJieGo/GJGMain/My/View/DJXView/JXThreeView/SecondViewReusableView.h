//
//  SecondViewReusableView.h
//  FJ_Project
//
//  Created by dujinxin on 15/11/27.
//  Copyright © 2015年 BLW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXLabel.h"

@interface SecondViewReusableView : UICollectionReusableView

@property (nonatomic,strong) JXLabel * titleLabel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) UIView      * topLine;
@property (nonatomic, strong) UIView      * bottomLine;

@end
