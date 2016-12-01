//
//  JXButton.m
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "JXButton.h"

@implementation JXButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setClickEvent:(
    void (^) (id sender)) block {
    // 这一行只是简单地赋值....
    saveA = block;
    [self addTarget:self
      action:@selector(defaultClick:)
      forControlEvents:UIControlEventTouchUpInside];
}
- (void) defaultClick:(id) sender{
    // 这里再次调用回去...
    if (saveA) {
        saveA(self);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
