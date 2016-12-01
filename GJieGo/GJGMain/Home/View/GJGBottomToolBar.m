//
//  GJGBottomToolBar.m
//  GJieGo
//
//  Created by liubei on 16/5/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGBottomToolBar.h"
#import "AppMacro.h"

@implementation GJGBottomToolBar

static NSInteger selfTag = 192;

+ (instancetype)bottomToolBarWithTitles:(NSArray *)titles imgs:(NSArray *)imgs hightLightImgs:(NSArray *)hlImgs{
    
    GJGBottomToolBar *bottomBar = [[self alloc] init];
    [bottomBar setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat marginW = 1;
    CGFloat buttonW = (ScreenWidth - marginW * (titles.count - 1)) / titles.count;
    
    UIView *topLine = [[UIView alloc] init];
    [topLine setBackgroundColor:GJGRGB16Color(0xdadada)];
    [bottomBar addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.and.right.equalTo(bottomBar).with.offset(0);
        make.height.equalTo(@0.5);
    }];
    
    bottomBar.btns = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:bottomBar
                   action:@selector(bottomButtonDidClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [bottomBar.btns addObject:button];
        [button setTag:(selfTag + i)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:hlImgs[i]] forState:UIControlStateSelected];
        }
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [bottomBar addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.and.bottom.equalTo(bottomBar).with.offset(0);
            make.left.equalTo(bottomBar.mas_left).with.offset(i * (buttonW + marginW));
            make.width.mas_equalTo([NSNumber numberWithDouble:buttonW]);
        }];
    }
    for (int i = 0; i < titles.count; i++) {
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:GJGRGB16Color(0xdadada)];
        [bottomBar addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(bottomBar.mas_top).with.offset(10);
            make.bottom.equalTo(bottomBar.mas_bottom).with.offset(-10);
            make.left.equalTo(bottomBar.mas_left).with.offset(buttonW + i * (buttonW + marginW));
            make.width.mas_equalTo([NSNumber numberWithDouble:0.5]);
        }];
    }
    return bottomBar;
}

- (void)bottomButtonDidClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(bottomToolBarDidSelected:title:)]) {
        
        [self.delegate bottomToolBarDidSelected:(button.tag - selfTag) title:[button titleForState:UIControlStateNormal]];
    }
}

@end
