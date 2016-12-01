//
//  OrderStoreView.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "OrderStoreView.h"

@implementation OrderStoreView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    [self addSubview:self.infoDetalView];
    [self addSubview:self.detailLabel];
    [self autoLayoutSubviews];
}
- (void)autoLayoutSubviews{
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(260);
        make.bottom.equalTo(-10);
    }];
    [_infoDetalView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.right).offset(12);
        make.top.equalTo(self).offset(15.5);
        make.bottom.equalTo(-15.5);
        make.width.equalTo(5);
    }];
    [_detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-15);
        make.top.equalTo(10);
        make.width.equalTo(70);
        make.bottom.equalTo(-10);
    }];
}

#pragma mark - subView init
- (UIImageView *)infoDetalView{
    if (!_infoDetalView) {
        _infoDetalView = [UIImageView new ];
        _infoDetalView.backgroundColor = JXDebugColor;
        _infoDetalView.image = JXImageNamed(@"list_arrow");
    }
    return _infoDetalView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new ];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.backgroundColor = JXDebugColor;
        _nameLabel.textColor = JX999999Color;
        _nameLabel.text = @"导购";
    }
    return _nameLabel;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new ];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.backgroundColor = JXDebugColor;
        _detailLabel.textColor = JXColorFromRGB(0xff7676);
        _detailLabel.text = @"详情";
    }
    return _detailLabel;
}

- (void)setStoreName:(NSString *)name{
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:_nameLabel.font forKey:NSFontAttributeName];
   
    CGRect rect = [name boundingRectWithSize:CGSizeMake(CGRectGetWidth(_nameLabel.frame), CGRectGetHeight(_nameLabel.frame)) options:option attributes:attributes context:nil];
    _nameLabel.text = name;
    [_nameLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(rect.size.width +2);
        make.bottom.equalTo(-10);
    }];
}
- (void)setClickEvents:(StoreViewBlock)block{
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
