//
//  UIView+frameExtension.h
//
//  对UIView的扩展, 在这里对书写比较长而且常用的属性扩展成为成员属性, 方便调用
//
//  例:  view.frame.size.width => view.width
//
//

#import <UIKit/UIKit.h>

@interface UIView (frameExtension)

/** view的尺寸.    可直接进行赋值,取值操作. */
@property (nonatomic, assign) CGSize size;

/** view的宽.    可直接进行赋值,取值操作. */
@property (nonatomic, assign) CGFloat width;

/** view的高.    可直接进行赋值,取值操作. */
@property (nonatomic, assign) CGFloat height;

/** view的x.    可直接进行赋值,取值操作. */
@property (nonatomic, assign) CGFloat x;

/** view的y.    可直接进行赋值,取值操作. */
@property (nonatomic, assign) CGFloat y;

+ (CGRect)relativeFrameForScreenWithView:(UIView *)v;
// each makeToast method creates a view and displays it as toast
- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

// fansj
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position isRemove:(BOOL)isRemove;

// displays toast with an activity spinner
- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

// the showToast methods display any view as toast
- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;

@end

@interface UIButton (extension)

+ (UIButton *)buttonWithType:(UIButtonType)buttonType tag:(NSInteger)tag title:(NSString *)title titleSize:(CGFloat)size frame:(CGRect)frame Image:(UIImage *)image target:(id)target action:(SEL)action;

@end


@interface UIScrollView (extension)

+(UIScrollView *)allocScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)size page:(BOOL)page;

@end

@interface UILabel (extension)
/***
 ** 给label加斜线
 **/
- (void)drawLabelRect:(CGRect)rect;
/***
 ** 快速定义label
 **/
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text tinkColor:(UIColor *)color fontSize:(CGFloat)size ;

@end













