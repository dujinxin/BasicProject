//
//  SecondViewReusableView.m
//  FJ_Project
//
//  Created by dujinxin on 15/11/27.
//  Copyright © 2015年 BLW. All rights reserved.
//

#import "SecondViewReusableView.h"

@implementation SecondViewReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JXColorFromRGB(0xfbfbfb);
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.topLine];
        [self addSubview:self.bottomLine];
    }
    return self;
}
-(JXLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[JXLabel alloc]initWithFrame:CGRectMake(30, 0, self.frame.size.width -30, self.frame.size.height)];
        _titleLabel.font = JXFontForNormal(13);
        _titleLabel.textColor = JX333333Color;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 10, 10)];
        _imageView.image = JXImageNamed(@"secondImage");
    }
    return _imageView;
}
-(UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        _topLine.backgroundColor = JXColorFromRGB(0xc3c3c3);
    }
    return _topLine;
}
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height -0.5, self.frame.size.width,0.5)];
        _bottomLine.backgroundColor = JXColorFromRGB(0xdcdcdc);
    }
    return _bottomLine;
}
@end
