//
//  SecondViewCell.m
//  FJ_Project
//
//  Created by dujinxin on 15/11/26.
//  Copyright © 2015年 BLW. All rights reserved.
//

#import "SecondViewCell.h"

@interface SecondViewCell (){
    CGRect _frame;
}

@end
@implementation SecondViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        [self addSubview:self.imageView];
        [self addSubview:self.titleView];
    }
    return self;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.width)];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}
-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc ]initWithFrame:CGRectMake(0, _frame.size.width, _frame.size.width, _frame.size.height -_frame.size.width)];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = JXFontForNormal(13);
        _titleView.textColor = JXColorFromRGB(0x666666);
    }
    return _titleView;
}
@end
