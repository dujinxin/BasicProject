//
//  LevelView.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/4.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelView : UIView

@property (nonatomic, strong) UIImageView * levelBgImageView;
@property (nonatomic, strong) UILabel * numLabel;
@property (nonatomic, strong) UILabel * titleLabel;

- (instancetype)initWithFrame:(CGRect)frame num:(NSString *)num title:(NSString *)title;

- (void)setLevelNum:(NSString *)num levelTitle:(NSString *)title;

@end

@interface LevelImageView : UIImageView

@end
