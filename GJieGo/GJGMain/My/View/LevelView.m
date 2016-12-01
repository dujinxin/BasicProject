//
//  LevelView.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/4.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "LevelView.h"

@implementation LevelView



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.levelBgImageView];
        [self addSubview:self.numLabel];
        //[self addSubview:self.titleLabel];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame num:(NSString *)num title:(NSString *)title{
    self = [self initWithFrame:frame];
    if (self) {
        _numLabel.text = num;
        //_titleLabel.text = title;
        
        [self layoutSubview];
    }
    return self;
}
- (void)setLevelNum:(NSString *)num levelTitle:(NSString *)title{
    _numLabel.text = num;
    //_titleLabel.text = title;
    [self layoutSubview];
}
- (void)layoutSubview{
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObject:_numLabel.font forKey:NSFontAttributeName];
//    NSDictionary *attributes2 = [NSDictionary dictionaryWithObject:_titleLabel.font forKey:NSFontAttributeName];
    CGRect rect1 = [_numLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes1 context:nil];
//    CGRect rect2 = [_titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes2 context:nil];
    
    CGRect frame = self.frame;
    CGFloat infoLeading;
//    if (frame.size.width >= rect1.size.width +rect2.size.width +8) {
//        infoLeading = (self.frame.size.width -rect1.size.width -rect2.size.width -8)/2;
//    }else{
//        infoLeading = -(self.frame.size.width -rect1.size.width -rect2.size.width -8)/2;
//    }
//    frame.size.width = rect1.size.width +rect2.size.width +8;
    if (frame.size.width >= rect1.size.width +4) {
        infoLeading = (self.frame.size.width -rect1.size.width -4)/2;
    }else{
        infoLeading = -(self.frame.size.width -rect1.size.width -4)/2;
    }
    frame.size.width = rect1.size.width +4;
    self.frame = frame;
    
    [_levelBgImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(infoLeading);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.equalTo(rect1.size.width +4);
    }];
    [_numLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(infoLeading);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.equalTo(rect1.size.width +4);
    }];
//    [_titleLabel remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_numLabel.right).offset(0);
//        make.top.equalTo(self).offset(0);
//        make.bottom.equalTo(self).offset(0);
//        make.width.equalTo(rect2.size.width +4);
//    }];

}
- (UIImageView *)levelBgImageView{
    if (!_levelBgImageView) {
        _levelBgImageView = [[UIImageView alloc]init ];
        _levelBgImageView.image = JXImageNamed(@"lavel_bg");
    }
    return _levelBgImageView;
}
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc ]init];
        _numLabel.backgroundColor = [UIColor clearColor];
//        _numLabel.font = JXFontForNormal(12);
        _numLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:12];
        _numLabel.textColor = JXFfffffColor;
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc ]init];
        //_titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.textColor = JX999999Color;
        _titleLabel.font = JXFontForNormal(12);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end

@implementation LevelImageView

- (void)drawRect:(CGRect)rect{
    UIImage *field = JXImageNamed(@"lavel_bg");
    [field drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    
}

- (CGSize)setText:(NSString *)text font:(NSFont *)font size:(CGSize *)size{
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes context:nil];
    CGRect frame = self.frame;
    frame.size.width = rect.size.width +4;
    self.frame = frame;
    [self setNeedsDisplay];
    return rect.size;
}
@end