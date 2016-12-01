//
//  LoginTextField.m
//  GJieGo
//
//  Created by dujinxin on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x +=28.5;
    return rect;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.x -=10;
    rect.origin.y +=1;
    return rect;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    int margin =10;
    CGRect inset = CGRectMake(rect.origin.x + margin, rect.origin.y, rect.size.width - margin, rect.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    int margin =10;
    CGRect inset = CGRectMake(rect.origin.x + margin, rect.origin.y, rect.size.width - margin, rect.size.height);
    return inset;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
