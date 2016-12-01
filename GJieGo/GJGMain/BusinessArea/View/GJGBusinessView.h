//
//  GJGBusinessView.h
//  GJieGo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseView.h"

@protocol businessDelegate <NSObject>

- (void)clickBusinessButtonAction:(UIButton *)button;
- (void)clickMapButtonAction:(UIButton *)button;
@end

@interface GJGBusinessView : BaseView
@property (nonatomic, weak)id <businessDelegate>delegate;
//商圈数组
@property (nonatomic, strong)NSArray *sourceArray;
//当前位置
@property (nonatomic, strong)NSString *location;
//定位按钮
@property (nonatomic, strong)UIButton *mapButton;
@property (nonatomic, strong)UIView *alphaView;

- (id)initWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArray location:(NSString *)location className:(NSString *)className;
- (void)initWithSourceArray:(NSArray *)sourceArray location:(NSString *)location className:(NSString *)className;
@end
