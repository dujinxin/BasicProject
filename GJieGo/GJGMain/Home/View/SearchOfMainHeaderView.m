//
//  SearchOfMainHeaderView.m
//  GJieGo
//
//  Created by liubei on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SearchOfMainHeaderView.h"
#import "AppMacro.h"

@interface SearchOfMainHeaderView ()

@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UILabel *label;

@end


@implementation SearchOfMainHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = COLOR(254, 227, 48, 1);
        [self.contentView addSubview:_leftLine];
        [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.contentView).with.offset(0);
            make.top.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.width.equalTo(@3);
        }];
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = COLOR(102, 102, 102, 1);
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_leftLine.mas_right).with.offset(12);
            make.top.and.bottom.equalTo(self.contentView).with.offset(0);
        }];
    }
    return self;
}

- (void)setText:(NSString *)text {
    
    _text = [text copy];
    _label.text = text;
}
@end
