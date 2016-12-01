//
//  GJGSelectorBar.h
//  Radar
//
//  Created by liubei on 16/4/26.
//  Copyright © 2016年 ABCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectedBlock)(NSString *classification, NSString *type);

@interface GJGSelectorBar : UIView {
    
    UIButton *classificationButton;
    UIButton *typeButton;
}

@property (nonatomic, strong) UILabel *classificationLabel; // 左边的提示栏

@property (nonatomic, strong) NSArray *classifications;     // 分类数据源
@property (nonatomic, strong) NSArray *types;               // 距离选项数据源

@property (nonatomic, assign) NSInteger classSelectedIndex; // 分类第一次选择的位置
@property (nonatomic, assign) NSInteger typeSelectedIndex;  // 同上
@property (nonatomic, strong) UIImageView *rightIndicImgView;

- (void)hiddenSelectView;
+ (instancetype)selectorBarWithClassificaitons:(NSArray *)classifications types:(NSArray *)types selectedBlock:(didSelectedBlock)block;

@end
