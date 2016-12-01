//
//  UIView+Addition.m
//  THCustomer
//
//  Created by lichentao on 13-8-11.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)jxLeft {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)jxTop {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)jxRight {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)jxBottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)jxCenterX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)jxCenterY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)jxWidth {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)jxHeight {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)jxOrigin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)jxSize {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setJxSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        if ([child isKindOfClass:[UIImageView class]]) {
            ((UIImageView*)child).image = nil;
        }
        [child removeFromSuperview];
        child = nil;
    }
}

- (void)hideShadow
{
	self.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void)shadowColor:(UIColor*)color shadowOffset:(CGSize)offset shadowRadius:(CGFloat)radius shadowOpacity:(CGFloat)opacity {
	self.layer.shadowColor = color.CGColor;
	self.layer.shadowOffset = offset;
	self.layer.shadowRadius = radius;
	self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
}

- (void)cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color {
	CALayer *layer = [self layer];
	[layer setMasksToBounds:YES];
	[layer setCornerRadius:radius];
	[layer setBorderWidth:width];		// 添加边框宽度
	[layer setBorderColor:color.CGColor];
}

- (void)shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)offset shadowRadius:(CGFloat)sradius shadowOpacity:(CGFloat)opacity
	   cornerRadius:(CGFloat)cradius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor {
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = sradius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
    self.layer.cornerRadius = cradius;
    self.layer.borderWidth = width;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)shake
{
	CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	[keyAn setDuration:0.5f];
	NSArray *array = [[NSArray alloc] initWithObjects:
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
					  [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
					  nil];
	[keyAn setValues:array];
	NSArray *times = [[NSArray alloc] initWithObjects:
					  [NSNumber numberWithFloat:0.1f],
					  [NSNumber numberWithFloat:0.2f],
					  [NSNumber numberWithFloat:0.3f],
					  [NSNumber numberWithFloat:0.4f],
					  [NSNumber numberWithFloat:0.5f],
					  [NSNumber numberWithFloat:0.6f],
					  [NSNumber numberWithFloat:0.7f],
					  [NSNumber numberWithFloat:0.8f],
					  [NSNumber numberWithFloat:0.9f],
					  [NSNumber numberWithFloat:1.0f],
					  nil];
	[keyAn setKeyTimes:times];
	[self.layer addAnimation:keyAn forKey:@"TextAnim"];
}

- (void)doHide
{
    self.hidden = YES;
}

- (void)addCustomActivityIndicator
{
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.center = self.center;
    aiv.tag = 10009;
    [aiv startAnimating];
    [self addSubview:aiv];
}


+ (UIView *)backButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont   *titleFont  = [UIFont systemFontOfSize:14];
    //	CGSize    titleSize  = [title sizeWithFont:titleFont];
    if (kIOS_VERSION >= 7) {
        backButton.frame           = CGRectMake(-15, 0.0f, 52.f, 44.0f);
    }else{
        backButton.frame           = CGRectMake(-5, 0.0f, 52.f, 44.0f);
    }
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    backButton.titleLabel.font = titleFont;
    backButton.titleLabel.shadowColor = [UIColor blackColor];
    backButton.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
    //	[backButton setTitle:title forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:TuPian_Icon_214] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:TuPian_Icon_213] forState:UIControlStateSelected];
//    [backButton setBackgroundImage:[UIImage imageNamed:TuPian_Icon_213] forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:controlEvents];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 52, 44)];
    [backView addSubview:backButton];
    
    return backView;
}




- (void)removeCustomActivityIndicator
{
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[self viewWithTag:10009];
    if ([aiv respondsToSelector:@selector(stopAnimating)]) {
        [aiv stopAnimating];
    }
    [aiv removeFromSuperview];
    aiv = nil;
}

- (UIView*)findViewRecursively:(BOOL(^)(UIView* subview, BOOL* stop))recurse
{
    for( UIView* subview in self.subviews )
    {
        BOOL stop = NO;
        if( recurse( subview, &stop ) )
        {
            return [subview findViewRecursively:recurse];
        }
        else if( stop )
        {
            return subview;
        }
    }
    
    return nil;
}

@end
