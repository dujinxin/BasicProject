//
//  SecordReusableView.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/10.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "SecordReusableView.h"

@implementation SecordReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topbarView];
        
    }
    return self;
}
- (TopbarView *)topbarView{
    if (!_topbarView) {
//        _topbarView = [[TopbarView alloc ]initWithFrame:self.bounds titles:@[@"导购",@"用户"]];
//        topBarView.delegate = self;
//        topBarView.tag = 10 + _categoryType;
//        [headView addSubview:topBarView];
    }
    return _topbarView;
}
@end
