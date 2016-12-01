//
//  OrderGuiderView.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "OrderGuiderView.h"

@implementation OrderGuiderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:OrderGuiderStyleDefault];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup:OrderGuiderStyleDefault];
    }
    return self;
}
-(instancetype)initWithStyle:(OrderGuiderStyle)style{
    self = [super init];
    if (self) {
        [self setup:style];
    }
    return self;
}
- (void)setup:(OrderGuiderStyle)style{
    self.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(tap:)];
//    [self addGestureRecognizer:tap];
    [self addSubview:self.userImageView];
    [self addSubview:self.nameLabel];
    
    //[self addSubview:self.infoDetalView];
    if (style == OrderGuiderStyleSubtitle) {
        [self addSubview:self.detailLabel];
    }
    [self autoLayoutSubviews:style];
}
- (void)autoLayoutSubviews:(OrderGuiderStyle)style{
    [_userImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self.bottom).offset(-15);
        make.width.equalTo(_userImageView.height);
    }];
    [_nameLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userImageView.right).offset(13);
        make.top.equalTo(self).offset(15);
        make.width.equalTo(260);
        //(CGRectGetHeight(self.frame) -10)/2
        if (style == OrderGuiderStyleSubtitle) {
            make.height.equalTo(20);
        }else{
            make.bottom.equalTo(self.bottom).offset(-15);
        }
        
    }];
    if (style == OrderGuiderStyleSubtitle) {
        [_detailLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userImageView.right).offset(13);
            make.top.equalTo(_nameLabel.bottom);
            make.width.equalTo(_nameLabel);
            make.height.equalTo(_nameLabel);
        }];}
    }
    

#pragma mark - subView init
- (UIImageView *)userImageView{
    if (!_userImageView) {
        _userImageView = [UIImageView new ];
        _userImageView.backgroundColor = JXDebugColor;
        _userImageView.clipsToBounds = YES;
        _userImageView.image = JXImageNamed(@"portrait_default");
    }
    return _userImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new ];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.backgroundColor = JXDebugColor;
        _nameLabel.textColor = JX333333Color;
        _nameLabel.text = @"导购";
    }
    return _nameLabel;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new ];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:11];
        _detailLabel.backgroundColor = JXDebugColor;
        _detailLabel.textColor = JX999999Color;
        _detailLabel.text = @"详情";
    }
    return _detailLabel;
}
- (void)setClickEvents:(GuiderViewBlock)block{
    if (block) {
        _clickBlock = block;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
}
- (void)tap:(UITapGestureRecognizer *)tap{
    if (_clickBlock) {
        self.clickBlock(self);
    }
}
@end
