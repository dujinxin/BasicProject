//
//  FirstViewCell.m
//  FJ_Project
//
//  Created by dujinxin on 15/11/27.
//  Copyright © 2015年 BLW. All rights reserved.
//

#import "FirstViewCell.h"

@implementation FirstViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleView];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height -0.5, frame.size.width, 0.5)];
        line.backgroundColor = JXColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:line];
    }
    return self;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleView];
        [self addSubview:self.line];
    }
    return self;
}
-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc ]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = JXFontForNormal(14);
        _titleView.textColor = JX333333Color;
    }
    return _titleView;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height -0.5, self.frame.size.width, 0.5)];
        _line.backgroundColor = JXColorFromRGB(0xdcdcdc);
    }
    return _line;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
