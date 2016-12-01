//
//  BusinessClassMoreCell.m
//  GJieGo
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BusinessClassMoreCell.h"

@implementation BusinessClassMoreCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeBusinessClassMoreView];
    }
    return self;
}

- (void)makeBusinessClassMoreView{
    CGFloat kWidth = self.bounds.size.width;
    CGFloat kHeight = self.bounds.size.height;
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo((kWidth - 44) / 2);
        make.top.equalTo(24);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y + self.imageView.frame.size.height + 9, kWidth, kHeight - self.imageView.frame.origin.y - self.imageView.frame.size.height - 9)];
    self.textLabel.font = [UIFont systemFontOfSize:11.0f];
    self.tintColor = GJGRGB16Color(0x333333);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.top.equalTo(self.imageView.bottom).offset(9);
        make.size.equalTo(CGSizeMake(kWidth, 10));
    }];
}
@end
