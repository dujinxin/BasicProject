//
//  GJGBusinessAlertView.m
//  GJieGo
//
//  Created by 杨朝霞 on 16/4/26.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGBusinessAlertView.h"

@implementation GJGBusinessAlertView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBusinessAlertView];
    }
    return self;
}

- (void)setBusinessAlertView{
//    UIView *businessAlert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, ScreenHeight)];
    
}

- (void)loadProvinceWithProvinceArray:(NSArray *)provinceArray andBusinessArray:(NSArray *)businessArray toView:(UIView *)view{
    UIScrollView *provinceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    provinceScrollView.backgroundColor = [UIColor greenColor];
    
    [view addSubview:provinceScrollView];
    
}
@end
