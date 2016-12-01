//
//  TopbarView.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "TopbarView.h"

@interface TopbarView (){
    CGSize    _size;
}
@end

@implementation TopbarView


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetStrokeColorWithColor(context, _attribute.separatorColor.CGColor);
    CGContextBeginPath(context);
    
    if (_titles.count >0) {
        for (int i = 0; i <_titles.count ;i ++ ) {
            if (i < _titles.count -1) {
                CGContextMoveToPoint(context, self.frame.size.width /_titles.count *(i+1), self.frame.size.height /4);
                CGContextAddLineToPoint(context, self.frame.size.width /_titles.count *(i+1), self.frame.size.height /4 *3);
            }
            
        }
        
    }
    
    CGContextStrokePath(context);
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles attribute:(TopBarAttribute *)attribute{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JXFfffffColor;
        _selectIndex = 0;
        _currentTitle = [titles firstObject];
        _size = frame.size;
        
        _titles = [NSMutableArray arrayWithArray:titles];
        self.attribute = attribute;
        
        for (int i = 0; i < _titles.count; i ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(_size.width/_titles.count *i, 0, _size.width/_titles.count, _size.height)];
            [button setTitle:_titles[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [button setTitleColor:_attribute.highlightedColor forState:UIControlStateSelected];
            [button setTitleColor:_attribute.normalColor forState:UIControlStateNormal];
            [button setTag:i];
            [button addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (i == 0) {
                button.selected = YES;
            }
        }
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (TopBarAttribute *)attribute{
    if (!_attribute) {
        _attribute = [[TopBarAttribute alloc ]init ];
        _attribute.normalColor = JX999999Color;
        _attribute.highlightedColor = JX333333Color;
        _attribute.separatorColor = JXSeparatorColor;
    }
    return _attribute;
}
- (void)setBottomLineEnabled:(BOOL)bottomLineEnabled{
    if (bottomLineEnabled) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * button = (UIButton *)obj;
                if (button.tag == _selectIndex) {
                    [button addSubview:self.bottomLine];
                }
            }
        }];
    }
}
- (void)setBottomLineSize:(CGSize)size{
    self.bottomLine.frame = CGRectMake((_size.width/_titles.count -size.width)/2, _size.height -size.height, size.width, size.height);
}
- (void)setBottomLineColor:(UIColor *)color{
    self.bottomLine.backgroundColor = color;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _size.height -1, _size.width /_titles.count, 1)];
        _bottomLine.backgroundColor = JXColorFromRGB(0xfee330);
    }
    return _bottomLine;
}

-(void)tabBtnClick:(UIButton *)button{
    _selectIndex = button.tag;
    _currentTitle = _titles[_selectIndex];
    button.selected = YES;
    if (_bottomLine) {
        [_bottomLine removeFromSuperview];
        [button addSubview:_bottomLine];
    }
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            if (btn.tag != button.tag) {
                btn.selected = NO;
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(topBarView:clickItemIndex:)]) {
        [self.delegate topBarView:self clickItemIndex:_selectIndex];
    }
}
@end

@implementation TopBarAttribute

- (instancetype)init{
    if (self == [super init]) {
        self.normalColor = JX999999Color;
        self.highlightedColor = JX333333Color;
        self.separatorColor = JXSeparatorColor;
    }
    return self;
}

@end
