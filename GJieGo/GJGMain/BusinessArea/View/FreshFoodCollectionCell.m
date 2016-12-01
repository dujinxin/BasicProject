//
//  FreshFoodCollectionCell.m
//  GJieGo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "FreshFoodCollectionCell.h"
#import "BaseView.h"

@implementation FreshFoodCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makePromotionActivityCollectionCellUI];
    }
    return self;
}
- (void)makePromotionActivityCollectionCellUI{
    self.tradeImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = GJGRGB16Color(0x333333);
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.numberOfLines = 0;
    self.originalPriceLabel = [[UILabel alloc] init];
//    self.originalPriceLabel.textColor = GJGRGB16Color(0xff5252);
//    self.originalPriceLabel.font = [UIFont systemFontOfSize:14.0f];
    self.currentPriceLabel = [[UILabel alloc] init];
    self.currentPriceLabel.textColor = GJGRGB16Color(0x333333);
    self.currentPriceLabel.font = [UIFont systemFontOfSize:14.0f];
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = GJGRGB16Color(0x999999);
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    
    [self addSubview:self.tradeImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.originalPriceLabel];
    [self addSubview:self.currentPriceLabel];
    [self addSubview:self.timeLabel];
    
    [self.tradeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);//self.tradeImageView.backgroundColor = [UIColor brownColor];
        make.top.equalTo(self);
        make.width.equalTo(ScreenWidth * 0.45); //NSLog(@"%f", ScreenWidth);
        make.height.equalTo(ScreenWidth * 0.48);//NSLog(@"%f", self.tradeImageView.width * 1.07);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tradeImageView).offset(10);
//        make.bottom.equalTo(self.originalPriceLabel.top);
        make.top.equalTo(self.tradeImageView.bottom).offset(10);
//        make.trailing.equalTo(self.tradeImageView);
    }];
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(10);

        
//        make.bottom.equalTo(self.originalPriceLabel);
//        make.size.equalTo(self.currentPriceLabel);
    }];
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentPriceLabel.trailing).offset(7);
        make.centerY.equalTo(self.currentPriceLabel);
        //        make.bottom.equalTo(self.timeLabel.top).offset(-5);
//        make.height.equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.currentPriceLabel.bottom).offset(10);
//        make.bottom.equalTo(self.bottom).offset(-5);
//        make.height.equalTo(10);//size.equalTo(self.timeLabel);
    }];
}
@end
