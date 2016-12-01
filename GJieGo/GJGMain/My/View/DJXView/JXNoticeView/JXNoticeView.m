//
//  JXNoticeView.m
//  JXView
//
//  Created by dujinxin on 15/11/19.
//  Copyright © 2015年 e-future. All rights reserved.
//

#import "JXNoticeView.h"

@interface JXNoticeView (){
    UIWindow          * _bgWindow;
}
@property (nonatomic,strong)UIWindow  * bgWindow;
@property (nonatomic,strong)JXLabel   * textLabel;

@end


@implementation JXNoticeView

@synthesize message = _message;


#pragma CustomInit
-(instancetype)init{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 10.f;
        self.alpha = 0.8;
        self.backgroundColor = [UIColor blackColor];
        _noticeViewDuration = JXNoticeViewDurationNormal;
    }
    return self;
}
-(instancetype)initWithText:(NSString *)text{
    self = [self init];
    if (self) {
        _message = text;
        self.textLabel.text = _message;
        //[self addSubview:self.textLabel];
    }
    return self;
}
#pragma mark -
- (void)show{
    [self showInView:nil animate:YES];
}
- (void)showInView:(UIView *)view animate:(BOOL)animated{

    UIFont * font = _font ? _font : [UIFont boldSystemFontOfSize:16];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 7;
    //paragraphStyle.paragraphSpacing = 6;
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGRect textSize = [_message boundingRectWithSize:CGSizeMake(kScreenWidth -60, 1000) options:option attributes:attributes context:nil];
    
    [self.textLabel setFrame:CGRectMake(0, 0, textSize.size.width +10, textSize.size.height +5)];
    [self setFrame:CGRectMake(0, 0, textSize.size.width +20, textSize.size.height +20)];
    [self.textLabel setFont:font];
    
    UIView * bgView = view ? view : self.bgWindow;
    CGPoint point = self.frame.origin;
    if (_noticeViewPosition == JXNoticeViewShowPositionTop) {
        point = CGPointMake(bgView.frame.size.width / 2, 50);
    }else if (_noticeViewPosition == JXNoticeViewShowPositionBottom) {
        point = CGPointMake(bgView.frame.size.width / 2, bgView.frame.size.height - 60);
    }else if (_noticeViewPosition == JXNoticeViewShowPositionMiddle) {
        point = CGPointMake(bgView.frame.size.width/2, bgView.frame.size.height/2 - 35);
    }else{
        
    }
    
    self.center = point;
    _textLabel.center = point;
    //_textLabel.center = CGPointMake(self.frame.size.width /2, self.frame.size.height /2);
    [bgView addSubview:self];
    [bgView addSubview:_textLabel];
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            //self.transform = CGAffineTransformMakeScale(0.95, 0.95);
            self.alpha = 0.8;
            _textLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:_noticeViewDuration];
}
- (void)dismiss
{
    [self dismiss:YES];
}
- (void)dismiss:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            //self.transform = CGAffineTransformMakeScale(0.95, 0.95);
            self.alpha = 0.0;
            _textLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self clearInfo];
        }];
    }else{
        [self clearInfo];
    }
}
- (void)clearInfo{
    [_textLabel removeFromSuperview];
    [self removeFromSuperview];
    if (_bgWindow) {
        _bgWindow.hidden = YES;
        _bgWindow = nil;
    }
}
#pragma mark - setter method
-(void)setMessage:(NSString *)message{
    _message = message;
}
-(void)setNoticeViewDuration:(JXNoticeViewDuration)noticeViewDuration{
    _noticeViewDuration = noticeViewDuration;
}
-(void)setNoticeViewPosition:(JXNoticeViewShowPosition)noticeViewPosition{
    _noticeViewPosition = noticeViewPosition;
}
-(void)setFont:(UIFont *)font{
    _font = font;
}
#pragma mark - getter method
-(UIWindow *)bgWindow{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgWindow.windowLevel = UIWindowLevelAlert + 1;
        _bgWindow.backgroundColor = [UIColor clearColor];
        _bgWindow.hidden = NO;
    }
    return _bgWindow;
}
-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[JXLabel alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width -40, 40)];
        _textLabel.useContextHeight = YES;
        //        messageLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _textLabel.backgroundColor = [UIColor redColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = _message;
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
//        _textLabel.shadowColor = [UIColor darkGrayColor];
//        _textLabel.shadowOffset = CGSizeMake(1,1);
        
        _textLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _textLabel.layer.shadowOpacity = 0.8;
        _textLabel.layer.shadowRadius = 6;
        _textLabel.layer.shadowOffset = CGSizeMake(4,4);
        __block JXNoticeView * notice = self;
        [_textLabel setClickEvent:^(id sender) {
            [notice dismiss:YES];
        }];
        
    }
    return _textLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
