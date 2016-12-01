//
//  JXImageView.m
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "JXImageView.h"

@implementation JXImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setClickEvent:(
                        void (^) (id sender))block {
    saveA = block;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *g =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(clickMe:)];
    [self addGestureRecognizer:g];
}
- (void) clickMe:(UITapGestureRecognizer *)g {
    if (saveA) {
        saveA(self);
    }
}


@end
