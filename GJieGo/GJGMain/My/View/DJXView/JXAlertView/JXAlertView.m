//
//  JXAlertView.m
//  JXView
//
//  Created by dujinxin on 14-11-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "JXAlertView.h"

@interface JXAlertView (){
    UIWindow          * _bgWindow;
//    UIView * bgView;
    NSMutableArray    * _buttonTitles;
    JXAlertViewStyle    _style;
}
@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)JXLabel * textLabel;
@property (nonatomic,strong)UIView * customView;
@property (nonatomic,assign)CGFloat top;
@end

#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)

#define kAlertViewX  10
#define kAlertViewY  10

@implementation JXAlertView
@synthesize title = _title;
@synthesize message = _message;
@synthesize delegate = _delegate;

#pragma CustomInit
- (JX_INSTANCETYPE)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//纯文本信息
- (JX_INSTANCETYPE)initWithTitle:(NSString *)title message:(NSString *)message target:(id)target buttonTitles:(NSArray *)buttonTitles{
    self = [super init];
    if (self) {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, kScreenWidth -40, 200);
        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor yellowColor];
        self.center = [UIApplication sharedApplication].keyWindow.center;

        //添加标题
        BOOL isHasTitle = NO;
        if (title) {
            self.title = title;
            [self addSubview:self.titleLabel];
            isHasTitle = YES;
            _style = kAlertViewMessage;
            _showSeparateLine = YES;
        }
        //文本信息
        self.top = isHasTitle ? _titleLabel.frame.size.height : 10;
        if (message) {
            self.message = message;
            [self addSubview:self.textLabel];
        }
        if (_showSeparateLine) {
            //分割线
            _separateLine = ({
                UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.frame.size.height-1, self.frame.size.width, 1)];
                line.backgroundColor = JXColorFromRGB(0xfc5860);
                line;
            });
            [self addSubview:_separateLine];
        }
        if (target) {
            self.delegate = target;
        }
        totalHeight = _textLabel.frame.size.height + _top;
        if (buttonTitles) {
            _buttonTitles = [NSMutableArray arrayWithArray:buttonTitles];
        }
        CGPoint origin = CGPointMake(10, _textLabel.frame.size.height + _textLabel.frame.origin.y +10);
        totalHeight = [self addButtonItemWithOrigin:origin];
        
        self.frame = CGRectMake(0, 0, kScreenWidth -40, totalHeight +10);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        
    }
    return self;
}
//可以自定义内容
- (JX_INSTANCETYPE)initWithTitle:(NSString *)title customView:(UIView *)customView target:(id)target buttonTitles:(NSArray *)buttonTitles{
    self = [super init];
    if (self) {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, kScreenWidth -40, 200);
        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor whiteColor];
        
        //添加标题
        BOOL isHasTitle = NO;
        if (title) {
            self.title = title;
            [self addSubview:self.titleLabel];
            isHasTitle = YES;
            
            _showSeparateLine = YES;
        }
        if (_showSeparateLine) {
            //分割线
            _separateLine = ({
                UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.frame.size.height-1, self.frame.size.width, 1)];
                line.backgroundColor = JXColorFromRGB(0xfc5860);
                line;
            });
            [self addSubview:_separateLine];
        }
        //自定义视图
        _top = isHasTitle ? self.titleLabel.frame.size.height : 10;
        CGRect frame;
        if (customView) {
            _style = kAlertViewCustomView;
            frame = customView.frame;
            _customView = ({
                customView.frame = CGRectMake(10, _top, self.frame.size.width -20, frame.size.height);
                customView;
            });
            [self addSubview:_customView];
        }
//        customView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        if (target) {
            self.delegate = target;
        }
        totalHeight = frame.size.height + _top;
        
        if (buttonTitles) {
            _buttonTitles = [NSMutableArray arrayWithArray:buttonTitles];
        }
        CGPoint origin = CGPointMake(10, _customView.frame.size.height + _customView.frame.origin.y +10);
        totalHeight = [self addButtonItemWithOrigin:origin];
        
        self.frame = CGRectMake(0, 0, kScreenWidth -40, totalHeight +10);

    }
    return self;
}
- (CGFloat)addButtonItemWithOrigin:(CGPoint)buttonOrigin{
    //添加按钮---暂定一行显示2个，奇数个时最后一个放满一行。其他显示以后有空再加
    CGFloat space = 20;
    CGFloat width = (self.frame.size.width - space -10*2)/2;
    CGFloat height = 30;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat totalHeight = 0;
    for (int i = 0 ; i < _buttonTitles.count; i ++) {
        x = i %2;
        y = i /2;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonOrigin.x + (width +space) * x, buttonOrigin.y+ (10 +height) *y, width, height);
        button.backgroundColor = JXColorFromRGB(0xfc5860);
        button.tag = kJXAlertButtonTag + i;
        button.layer.cornerRadius = 5;
        [button setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (_buttonTitles.count %2 != 0){
            if (i == _buttonTitles.count -1) {
                if (_style == kAlertViewMessage) {
                    button.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y+ (10 +height) *y, (self.frame.size.width -10*2), height);
                }else if (_style == kAlertViewCustomView){
                    button.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y + (10 +height) *y, (self.frame.size.width -10*2), height);
                }
                
            }
        }
        if (i == _buttonTitles.count -1) {
            totalHeight = button.frame.origin.y + button.frame.size.height ;
        }
    }
    return totalHeight;
}
- (void)buttonClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [_delegate alertView:self willDismissWithButtonIndex:btn.tag -kJXAlertButtonTag];
    }
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:btn.tag -kJXAlertButtonTag];
        [self dismiss];
    }
    if ([_delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [_delegate alertView:self didDismissWithButtonIndex:btn.tag -kJXAlertButtonTag];
    }
}

- (void)show{
    [self showInView:nil animate:YES];
}
- (void)showInView:(UIView *)view animate:(BOOL)animated{
    //将要出现
    if ([_delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [_delegate willPresentAlertView:self];
    }
    //添加背景
    CGPoint center;
    if (view) {
        //动画暂时先不加了。。。
        [view addSubview:self.bgView];
        center = view.center;
        self.center = CGPointMake(center.x, center.y -64/2);
        [view addSubview:self];
        
    }else{
        _bgWindow = ({
                     UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                     window.windowLevel = UIWindowLevelAlert + 1;
                     window.backgroundColor = [UIColor clearColor];
                     window.hidden = NO;
                     window;
        });
        center = _bgWindow.center;
        self.center = CGPointMake(center.x, center.y -64/2);
        [_bgWindow addSubview:self.bgView];
        [_bgWindow addSubview:self];
        
//        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
//        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(0.95, 0.95);
            self.bgView.alpha = 0.5;
        } completion:^(BOOL finished) {
            
        }];
    }
    //已经出现
    if ([_delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [_delegate willPresentAlertView:self];
    }
}
- (void)dismiss
{
    [self dismiss:YES];
}
- (void)dismiss:(BOOL)animated
{
    //    UIView * bgView = [self.superview viewWithTag:kBgViewTag];
    //    [bgView removeFromSuperview];
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            //self.transform = CGAffineTransformMakeScale(0.95, 0.95);
            self.bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self clearInfo];
        }];
    }else{
        [self clearInfo];
    }
}
- (void)clearInfo{
    if (_bgView) {
        [_bgView removeFromSuperview];
    }
    [self removeFromSuperview];
    if (_bgWindow) {
        _bgWindow.hidden = YES;
        _bgWindow = nil;
    }
}
#pragma mark - ViewInit
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.tag = kJXAlertBgViewTag;
        _bgView.alpha = 0.0;
    }
    return _bgView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        //添加标题
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _title;
    }
    return _titleLabel;
}
-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[JXLabel alloc]initWithFrame:CGRectMake(10, _top, self.frame.size.width -40, 40)];
        _textLabel.useContextHeight = YES;
        //        messageLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _textLabel.backgroundColor = [UIColor redColor];
        _textLabel.text = _message;
        _textLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _textLabel;
}
-(UIView *)customView{
    if (!_customView) {
        //....
    }
    return nil;
}
- (NSString *)title{
    return _title;
}
- (NSString *)message{
    return _message;
}
- (id<JXAlertViewDelegate>)delegate{
    return _delegate;
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
