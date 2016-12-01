//
//  PromotionActivityCollectionCell.m
//  GJieGo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "PromotionActivityCollectionCell.h"
#import "AppMacro.h"

@interface PromotionActivityCollectionCell ()

@end

@implementation PromotionActivityCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makePromotionActivityCollectionCellUI];
    }
    return self;
}
- (void)makePromotionActivityCollectionCellUI{
    self.tradeImageView = [[UIImageView alloc] init];
    self.tradeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tradeImageView.clipsToBounds = YES;
    UIImageView *ViewCountImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Read_default"]];
    self.ViewCountLabel = [[UILabel alloc] init];
    self.ViewCountLabel.textColor = [UIColor whiteColor];
    self.ViewCountLabel.font = [UIFont systemFontOfSize:11.0f];//self.glanceLabel.text = @"9999";
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = GJGRGB16Color(0x333333);
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.numberOfLines = 0;
    UIImageView *praiseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumbup_default"]];
    self.praiseLabel = [[UILabel alloc] init];
    self.praiseLabel.textColor = GJGRGB16Color(0x999999);
    self.praiseLabel.font = [UIFont systemFontOfSize:11.0f];
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = GJGRGB16Color(0x999999);
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    
    [self.tradeImageView addSubview:ViewCountImageView];
    [self.tradeImageView addSubview:self.ViewCountLabel];
    [self addSubview:self.tradeImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:praiseImageView];
    [self addSubview:self.praiseLabel];
    [self addSubview:self.timeLabel];
    
    [ViewCountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
    }];
    [self.ViewCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ViewCountImageView.right).offset(5);
        make.centerY.equalTo(ViewCountImageView);
    }];
    [self.tradeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(ScreenWidth * 0.45);
        make.height.equalTo(ScreenWidth * 0.48);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tradeImageView).offset(5);
        make.top.equalTo(self.tradeImageView.bottom).offset(5);
        make.bottom.equalTo(praiseImageView.top).offset(-5);
        make.trailing.equalTo(self.tradeImageView).offset(-10);
    }];
    [praiseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.bottom.equalTo(-10);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(praiseImageView.trailing).offset(3);
        make.bottom.equalTo(praiseImageView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.tradeImageView).offset(-15);
        make.bottom.equalTo(praiseImageView);
    }];
}

@end
