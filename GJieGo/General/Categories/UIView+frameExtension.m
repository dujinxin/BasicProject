//
//  UIView+frameExtension.h
//

#import "UIView+frameExtension.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat CSToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat CSToastHorizontalPadding   = 10.0;
static const CGFloat CSToastVerticalPadding     = 10.0;
static const CGFloat CSToastCornerRadius        = 10.0;
static const CGFloat CSToastOpacity             = 0.8;
static const CGFloat CSToastFontSize            = 16.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const CGFloat CSToastFadeDuration        = 0.2;

// shadow appearance
static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 6.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSToastDisplayShadow       = YES;

// display duration and position
static const CGFloat CSToastDefaultDuration     = 3.0;
static const NSString * CSToastDefaultPosition  = @"center";

// image view size
static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;

// activity
static const CGFloat CSToastActivityWidth       = 100.0;
static const CGFloat CSToastActivityHeight      = 100.0;
static const NSString * CSToastActivityDefaultPosition = @"center";
static const NSString * CSToastActivityViewKey  = @"CSToastActivityViewKey";


@implementation UIView (frameExtension)

#pragma mark - Size
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

#pragma mark - Width
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

#pragma mark - Height
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

#pragma mark - X
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

#pragma mark - Y
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}


#pragma mark - view's frame in main screen
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v {
    
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != screenWidth || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}

#pragma mark - Toast Methods

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position {
    UIView *toast = [self viewForMessage:message title:nil image:nil];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title {
    UIView *toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:interval position:position];
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point {
    toast.center = [self centerPointForPosition:point withToast:toast];
    toast.alpha = 0.0;
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
}

// fansj
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position isRemove:(BOOL)isRemove {
    UIView *toast = [self viewForMessage:message title:nil image:nil];
    [self showToast:toast duration:interval position:position isRemove:isRemove];
}

// fansj
- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point isRemove:(BOOL)isRemove {
    toast.center = [self centerPointForPosition:point withToast:toast];
    toast.alpha = 0.0;
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                              if (isRemove) {
                                                  [self removeFromSuperview];
                                              }
                                          }];
                     }];
}

#pragma mark - Toast Activity Methods

- (void)makeToastActivity {
    [self makeToastActivity:CSToastActivityDefaultPosition];
}

- (void)makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSToastActivityWidth, CSToastActivityHeight)];
    activityView.center = [self centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = CSToastShadowOpacity;
        activityView.layer.shadowRadius = CSToastShadowRadius;
        activityView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate ourselves with the activity view
    objc_setAssociatedObject (self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:CSToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Private Methods

- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        // convert string literals @"top", @"bottom", @"center", or any point wrapped in an NSValue object into a CGPoint
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    NSLog(@"Warning: Invalid position for toast.");
    return [self centerPointForPosition:CSToastDefaultPosition withToast:toast];
}

- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;
    
    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
        wrapperView.layer.shadowRadius = CSToastShadowRadius;
        wrapperView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, CSToastImageViewWidth, CSToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = CSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = titleLabel.lineBreakMode;
        CGSize expectedSizeTitle = [title boundingRectWithSize:maxSizeTitle options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        //        [title sizeWithFont:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = messageLabel.lineBreakMode;
        CGSize expectedSizeMessage = [message boundingRectWithSize:maxSizeMessage options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:messageLabel.font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        //        [message sizeWithFont:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

@end

@implementation UIButton (extension)

+ (UIButton *)buttonWithType:(UIButtonType)buttonType
                         tag:(NSInteger)tag
                       title:(NSString *)title
                   titleSize:(CGFloat)size
                       frame:(CGRect)frame
                       Image:(UIImage *)image
                      target:(id)target
                      action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:buttonType];
    btn.tag = tag;
    btn.frame = frame;
    if (title != nil) {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:size];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (image != nil) {
        [btn setImage:image forState:UIControlStateNormal];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end

@implementation UIScrollView (extension)

+(UIScrollView *)allocScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)size page:(BOOL)page{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.pagingEnabled = page;
    scrollView.contentSize = size;
    return scrollView;
}

@end

@implementation UILabel (extension)

/***
 ** 给label加斜线
 **/
//+ (void)addLineTopWithLabel:(UILabel *)label{
//    NSString *oldPrice = @"¥ 12345";
//    NSUInteger length = [oldPrice length];
//    
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
//    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(2, length-2)];
//    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(0x999999, 1) range:NSMakeRange(2, length-2)];
//    [label setAttributedText:attri];
//}
- (void)drawLabelRect:(CGRect)rect
{
    // 调用super的drawRect:方法,会按照父类绘制label的文字
    [super drawRect:rect];
    
    // 取文字的颜色作为删除线的颜色
    [[UIColor colorWithRed:((float)((0x999999 & 0xFF0000) >> 16))/255.0 green:((float)((0x999999 & 0xFF00) >> 8))/255.0 blue:((float)(0x999999 & 0xFF))/255.0 alpha:1.0] set];
    CGFloat w = rect.size.width + 10;
    CGFloat h = rect.size.height;
    // 绘制(这个数字是为了找到label的中间位置,0.35这个数字是试出来的,如果不在中间可以自己调整)
    UIRectFill(CGRectMake(-5, h * 0.35, w + 10, 1));
}
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text tinkColor:(UIColor *)color fontSize:(CGFloat)size{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

@end
