/*
 
 The MIT License (MIT)
 
 Copyright (c) 2015 ABM Adnan
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "Dot.h"

@interface Dot () {
    
    UIImageView *icon;
}
@property (nonatomic, strong) UIImageView *userIconView;
@property (nonatomic, strong) UIImageView *dot_imageView;
/** 动画数组 */
@property (nonatomic, strong) NSMutableArray<CAAnimation *> *anis;

@end

@implementation Dot

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _subDots = [NSMutableArray array];
        _anis = [NSMutableArray array];
        [self addSubview:self.userIconView];
        self.userIconView.hidden = YES;
        [self addSubview:self.dot_imageView];
        self.dot_imageView.hidden = YES;
        [self setOpaque:NO];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    // Drawing code
//    self.image = [UIImage imageNamed:@"icon_image"];
    
    if (self.type == DotTypeIsImage) {
        if (self.image) {
            [self.image drawInRect:rect];
        }
        self.badge.hidden = YES;
    }else if (self.type == DotTypeIsGroup) {
        if (self.image) {
            [self.image drawInRect:rect];
        }
        self.badge.hidden = NO;
    }else {
        if (self.type == DotTypeIsUser) {
            [GJGRGB16Color(0x368bff) setFill];
        }else if (self.type == DotTypeIsGuider) {
            [GJGRGB16Color(0xf51c5e) setFill];
        }
        UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,
                                                                                  0,
                                                                                  rect.size.width,
                                                                                  rect.size.height)];
        [dotPath fill];
        [self addSubview:self.badge];
    }
}


#pragma mark - Getting

- (UILabel *)badge {
    
    if (!_badge) {
        
        CGFloat badgeW = 14;
        _badge = [[UILabel alloc] init];
        _badge.backgroundColor = GJGRGB16Color(0x368bff);
        _badge.textColor = [UIColor whiteColor];
        _badge.font = [UIFont systemFontOfSize:12];
        _badge.textAlignment = NSTextAlignmentCenter;
        _badge.layer.cornerRadius = badgeW * 0.5;
        _badge.layer.masksToBounds = YES;
        _badge.layer.shouldRasterize = YES;
        _badge.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _badge.frame = CGRectMake(self.frame.size.width - 12, -2, badgeW, badgeW);
        _badge.hidden = YES;
    }
    return _badge;
}

- (UIImageView *)userIconView
{
    if (!_userIconView) {
        
        static CGFloat iconMag = 2.f;
        static CGFloat iconBgW = 43.f;
        static CGFloat iconBgH = 59.5f;
        static CGFloat iconBgX = -16.5f;
        static CGFloat iconBgY = -48.f;
        CGFloat iconW = iconBgW - iconMag * 2;
        CGFloat iconH = iconW;
        CGFloat iconX = iconMag;
        CGFloat iconY = iconMag;
        static CGFloat iconBorW = 1.5f;
        _userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconBgX, iconBgY, iconBgW, iconBgH)];
        
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconW, iconH)];
        icon.contentMode = UIViewContentModeScaleToFill;
        icon.layer.borderWidth = iconBorW;
        icon.layer.borderColor = GJGRGB16Color(0x292929).CGColor;
        icon.layer.cornerRadius = iconW * 0.5;
        icon.layer.masksToBounds = YES;
        icon.layer.shouldRasterize = YES;
        icon.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [icon sd_setImageWithURL:[NSURL URLWithString:self.radarItem.Image] placeholderImage:[UIImage imageNamed:@"image_four"]];
        [_userIconView addSubview:icon];
    }
    return _userIconView;
}

- (UIImageView *)dot_imageView {
    
    if (!_dot_imageView) {
        
        _dot_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _dot_imageView.contentMode = UIViewContentModeScaleToFill;
        _dot_imageView.layer.cornerRadius = 7;
        _dot_imageView.layer.masksToBounds = YES;
        _dot_imageView.layer.shouldRasterize = YES;
        _dot_imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [_dot_imageView setImage:[UIImage imageNamed:@"icon_image"]];
    }
    return _dot_imageView;
}


#pragma mark - Setting

- (void)setType:(DotType)type {
    _type = type;
    
    if (self.type == DotTypeIsGuider) {
        [_userIconView setImage:[UIImage imageNamed:@"bubble_red"]];
    }else if (self.type == DotTypeIsUser) {
        [_userIconView setImage:[UIImage imageNamed:@"bubble_blue"]];
    }
}

- (void)setSubDots:(NSMutableArray *)subDots {
    
    _subDots = subDots;
    
    NSInteger dotCount = subDots.count;
    self.badge.hidden = NO;
    [self addSubview:self.badge];
    self.badge.font = [UIFont systemFontOfSize:dotCount > 9 ? 11 : 12];
    self.badge.text = [NSString stringWithFormat:@"%ld", dotCount];
    
    if ([[self.subDots firstObject].radarItem.Image hasPrefix:@"http"]) {
        [self addSubview:self.dot_imageView];
        self.dot_imageView.hidden = NO;
        if ([[self.subDots firstObject].radarItem.Image hasPrefix:@"http"]) {
            NSString *smallImgUrl = [NSString stringWithFormat:@"%@@80w_1o", [self.subDots firstObject].radarItem.Image];
            [self.dot_imageView sd_setImageWithURL:[NSURL URLWithString:smallImgUrl]
                                  placeholderImage:[UIImage imageNamed:@"image_four"]];
        }
    }
    [self bringSubviewToFront:self.badge];
}

- (void)setNeedLoadImg:(BOOL)needLoadImg {
    _needLoadImg = needLoadImg;
    if (needLoadImg) {
        [self addSubview:self.dot_imageView];
        self.dot_imageView.hidden = NO;
        if ([self.radarItem.Image hasPrefix:@"http"]) {
            NSString *smallImgUrl = [NSString stringWithFormat:@"%@@80w_1o", self.radarItem.Image];
            [self.dot_imageView sd_setImageWithURL:[NSURL URLWithString:smallImgUrl]
                                  placeholderImage:[UIImage imageNamed:@"image_four"]];
        }
    }
}

- (void)setRadarItem:(LBRadarItemM *)radarItem {
    _radarItem = radarItem;

    if (radarItem.Type == 3 || radarItem.Type == 4) {   // 如果是促销信息或晒单
//        [self addSubview:self.dot_imageView];
//        self.dot_imageView.hidden = NO;
//        if ([radarItem.Image hasPrefix:@"http"]) {
//            [self.dot_imageView sd_setImageWithURL:[NSURL URLWithString:radarItem.Image]
//                                  placeholderImage:[UIImage imageNamed:@"icon_image"]];
//        }
    }else if (radarItem.Type == 1 || radarItem.Type == 2) { // 如果是用户
        [self userIconView];    // NSLog(@"lb_radarItem_user&guider_headIcon:%@", radarItem.Image);
        [icon sd_setImageWithURL:[NSURL URLWithString:radarItem.Image] placeholderImage:[UIImage imageNamed:@"image_four"]];
    }
}

- (void)setShowIcon:(BOOL)showIcon {
    
    _showIcon = showIcon;
    
    if (showIcon) {
        self.userIconView.hidden = NO;
        [self.userIconView removeFromSuperview];
        [self.superview bringSubviewToFront:self];
        [self addSubview:self.userIconView];
    
    }else {
        self.userIconView.hidden = YES;
        [self.userIconView removeFromSuperview];
    }
}

- (void)setValue:(CGFloat)value {
    //    NSLog(@"value: %lf", value);
    int lessCount = (int)self.subDots.count * value;
    long outCount = self.subDots.count - lessCount;
    if (outCount == self.subDots.count) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
    }
    if (lessCount > self.subDots.count || lessCount < 0 || outCount > self.subDots.count || outCount < 0) {
        return;
    }
    CGPoint centerPoint = CGPointMake(kScreenWidth * 0.5, kScreenWidth * 0.5);
    CGPoint currenPoint = [[self.layer.presentationLayer valueForKey:@"position"] CGPointValue];
    CGPoint bezierPoint;
    CGPoint otherPoint;
    
    // 出去
    if (currenPoint.x < centerPoint.x) {
        if (currenPoint.y < centerPoint.y) { // 左上角
            NSLog(@"左上");
            bezierPoint = CGPointMake( -kScreenWidth * 0.1, currenPoint.y);
            otherPoint = CGPointMake(kScreenWidth * 0.25, kScreenWidth * 1.1);
        }else { // 左下
            NSLog(@"左下");
            bezierPoint = CGPointMake(currenPoint.x, kScreenWidth * 1.1);
            otherPoint = CGPointMake(kScreenWidth * 1.1, kScreenWidth * 0.75);
        }
    }else {
        if (currenPoint.y < centerPoint.y) { // 右上角
            NSLog(@"右上角");
            bezierPoint = CGPointMake(currenPoint.x, -kScreenWidth * 0.1);
            otherPoint = CGPointMake(-kScreenWidth * 0.1, kScreenWidth * 0.25);
        }else { // 右下
            NSLog(@"右下");
            bezierPoint = CGPointMake(kScreenWidth * 1.1, currenPoint.y);
            otherPoint = CGPointMake(kScreenWidth * 0.75, -kScreenWidth * 0.1);
        }
    }
    for (int i = 0; i < outCount; i ++) {
        Dot *dot = _subDots[i];
        if (dot.out == NO) {
            NSLog(@"dot out ！！！");
            dot.out = YES;
//            if (i != _subDots.count - 1) {
//                [self.dot_imageView sd_setImageWithURL:[NSURL URLWithString:_subDots[i + 1].radarItem.Image]
//                                      placeholderImage:[UIImage imageNamed:@"image_four"]];
//            }
            // 执行动画
            [self.superview addSubview:dot];
            dot.transform = self.transform;
            CGAffineTransformRotate(dot.transform, -M_PI);
            CAAnimation *arcAni = [self getInOutAnimate:currenPoint endPoint:otherPoint controlPoint:bezierPoint isOutAni:YES];
            //            arcAni.delegate = dot;
            [dot.layer addAnimation:arcAni forKey:@"ani.out"];
        }
    }
    // 进来
    if (currenPoint.x < centerPoint.x) {
        if (currenPoint.y < centerPoint.y) { // 左上角
            NSLog(@"左上");
            bezierPoint = CGPointMake(currenPoint.x + kScreenWidth * 0.25, -kScreenWidth * 0.1);
            otherPoint = CGPointMake(kScreenWidth * 1.1, currenPoint.y);
        }else { // 左下
            NSLog(@"左下");
            bezierPoint = CGPointMake(-kScreenWidth * 0.1, currenPoint.y - kScreenWidth * 0.25);
            otherPoint = CGPointMake(currenPoint.x, -kScreenWidth * 1.1);
        }
    }else {
        if (currenPoint.y < centerPoint.y) { // 右上角
            NSLog(@"右上角");
            bezierPoint = CGPointMake(kScreenWidth * 1.1, currenPoint.y + kScreenWidth * 0.25);
            otherPoint = CGPointMake(currenPoint.x, kScreenWidth * 1.1);
        }else { // 右下
            NSLog(@"右下");
            bezierPoint = CGPointMake(currenPoint.x - kScreenWidth * 0.25, kScreenWidth * 1.1);
            otherPoint = CGPointMake(-kScreenWidth * 0.1, currenPoint.y);
        }
    }
    for (int i = 0; i < lessCount; i ++) {
        Dot *dot = _subDots[_subDots.count - 1 - i];
        if (dot.out == YES) {
            dot.out = NO;
            NSLog(@"@@@  dot in @@@@@@");
//            if ((_subDots.count - 1 - i) != 0) {
//                [self.dot_imageView sd_setImageWithURL:[NSURL URLWithString:_subDots[_subDots.count - 1 - i - 1].radarItem.Image]
//                                      placeholderImage:[UIImage imageNamed:@"image_four"]];
//            }
            [self.superview addSubview:dot];
            CAAnimation *arcAni = [self getInOutAnimate:otherPoint endPoint:currenPoint controlPoint:bezierPoint isOutAni:NO];
            arcAni.delegate = dot;
            [dot.layer addAnimation:arcAni forKey:@"ani.in"];
        }
    }
    for (int i = 0; i < _subDots.count; i++) {
        if (_subDots[i].isOut == NO) {
            [self.dot_imageView sd_setImageWithURL:[NSURL URLWithString:self.subDots[i].radarItem.Image] placeholderImage:[UIImage imageNamed:@"image_four"]];
            break;
        }
    }
    int showCount = 0;
    for (Dot *dot in _subDots) {
        if (!dot.isOut) {
            showCount ++;
        }
    }
    self.badge.text = [NSString stringWithFormat:@"%d", showCount];
    //    for (int i = 0; i < self.subDots.count; i ++) {
    //        if (!self.subDots[self.subDots.count - 1 - i].isOut) {
    //            [self.dot_imageView sd_setImageWithURL:[NSURL URLWithString:self.subDots[i].radarItem.Image]
    //                                  placeholderImage:[UIImage imageNamed:@"image_four"]];
    //        }
    //    }
}


#pragma mark - Animation

- (CAAnimation *)getInOutAnimate:(CGPoint)beginPoint endPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint isOutAni:(BOOL)isOutAni {
    
    static CGFloat duration = 0.4;
    NSMutableArray *anis = [NSMutableArray array];
    
    UIBezierPath *arcPath;
    arcPath = [UIBezierPath bezierPath];
    arcPath.lineCapStyle = kCGLineCapRound;
    arcPath.lineJoinStyle = kCGLineCapRound;
    [arcPath moveToPoint:beginPoint];
    [arcPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    CAKeyframeAnimation *arc = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    arc.duration             = duration;
    arc.fillMode             = kCAFillModeForwards;
    arc.autoreverses         = NO;
    arc.removedOnCompletion  = NO;
    arc.timingFunction       = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    arc.path                 = arcPath.CGPath;
    [anis addObject:arc];
    
    if (isOutAni) {
        CABasicAnimation *alphaAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [alphaAni setDuration:duration];
        alphaAni.fillMode = kCAFillModeForwards;
        alphaAni.autoreverses = NO;
        alphaAni.removedOnCompletion = NO;
        [alphaAni setFromValue:[NSNumber numberWithFloat:isOutAni ? 1.f : 0.f]];
        [alphaAni setToValue:[NSNumber numberWithFloat:isOutAni ? 0.f : 1.f]];
        [anis addObject:alphaAni];
    }else {
        CAKeyframeAnimation *alphaAni = [CAKeyframeAnimation animation];
        alphaAni.keyPath = @"opacity";
        alphaAni.duration = duration;
        alphaAni.removedOnCompletion = NO;
        alphaAni.fillMode = kCAFillModeForwards;
        alphaAni.autoreverses = NO;
        //        NSValue *value2 = [NSNumber;
        //        NSValue *value4 = [NSNumber numberWithFloat:0.6];
        //        NSValue *value6 = [NSNumber numberWithFloat:0.9];
        //        NSValue *value7 = [NSNumber numberWithFloat:0.f];
        alphaAni.values=@[@1, @0];
        alphaAni.keyTimes = @[@0.9, @1];
        [anis addObject:alphaAni];
    }
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = duration;
    group.autoreverses = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group.animations = [anis copy];
    
    return group;
}

- (void)setAni:(CAAnimation *)ani {
    _ani.delegate = nil;
//    [self.layer removeAllAnimations];
    _ani = ani;
    ani.delegate = self;
}

//- (void)dotAddAnimation:(CAAnimation *)ani {
//    
//    [self.anis addObject:ani];
//    ani.delegate = self;
//}

#pragma mark - Animation Delegate

- (void)animationDidStart:(CAAnimation *)anim {

//    self.moving = YES;
    if ([anim isEqual:[self.layer animationForKey:@"dotEnterAnimation"]] ||
        [anim isEqual:[self.layer animationForKey:@"dotOutAnimation"]]) {   // 如果是进出场动画, 告诉外界正在进行进出场动画
        self.inOutAnima = YES;
//        self.outAnimation = YES; // NSLog(@"lb_radarItem_ani_moving");
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
//    self.moving = NO;
//    if ([_anis containsObject:anim]) {
//        NSLog(@"存在这个动画");
//    }
//    [self.anis removeObject:anim];
    if ([anim isEqual:[self.layer animationForKey:@"dotEnterAnimation"]] ||
        [anim isEqual:[self.layer animationForKey:@"dotOutAnimation"]]) {
        self.inOutAnima = NO;
//        self.outAnimation = NO; // NSLog(@"lb_radarItem_ani_endMoving");
    }
}


#pragma mark - Super class func

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    if (_badge) {
//        CGFloat badgeW = 10;
//        _badge.layer.cornerRadius = badgeW * 0.5;
//        _badge.layer.masksToBounds = YES;
//        _badge.frame = CGRectMake(self.frame.size.width - badgeW * 0.5, -badgeW * 0.5, badgeW, badgeW);
//    }
//}

@end


