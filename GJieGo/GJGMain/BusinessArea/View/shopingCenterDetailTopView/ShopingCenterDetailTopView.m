//
//  :
//  GJieGo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShopingCenterDetailTopView.h"

@interface ShopingCenterDetailTopView ()
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *subNameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@end

@implementation ShopingCenterDetailTopView

- (id)initWithFrame:(CGRect)frame backImageName:(NSString *)imageName businessName:(NSString *)businessName subName:(NSString *)subName time:(NSString *)time{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GJGRGB16Color(0xf1f1f1);
        [self makeShopingCenterDetailTopViewWithBackImageName:imageName businessName:businessName subName:subName time:time];
    }
    return self;
}

- (void)makeShopingCenterDetailTopViewWithBackImageName:(NSString *)imageName businessName:(NSString *)businessName subName:(NSString *)subName time:(NSString *)time{
    
    self.backImageView = [[UIImageView alloc] init];
    if ([imageName isEqual:[NSNull null]]) {
        self.backImageView.image = [UIImage imageNamed:@"default_landscape_normal"];
    }else{
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", imageName, (int)ScreenWidth]] placeholderImage:[UIImage imageNamed:@"default_landscape_normal"]];
    }
    
    UIView *alphaView = [[UIView alloc] init];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = maskAlpha;
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = businessName;
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.subNameLabel = [[UILabel alloc] init];
    self.subNameLabel.text = subName;
    self.subNameLabel.numberOfLines = 0;
    self.subNameLabel.font = [UIFont systemFontOfSize:11.0f];
    self.subNameLabel.textColor = [UIColor whiteColor];
    self.timeInfoLabel = [[UILabel alloc] init];
    self.timeInfoLabel.text = @"营业时间：";
    self.timeInfoLabel.textColor = [UIColor whiteColor];
    self.timeInfoLabel.font = [UIFont systemFontOfSize:11.0f];
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = time;
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    
    [self addSubview:self.backImageView];
    [self addSubview:alphaView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.subNameLabel];
    [self addSubview:self.timeInfoLabel];
    [self addSubview:self.timeLabel];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self).offset(0);
        make.width.equalTo(self);
        make.height.equalTo(self).offset(-10);
    }];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self.backImageView.bottom).offset(-64);
        make.width.equalTo(self);
        make.height.equalTo(64);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(alphaView).offset(5);
        make.width.equalTo(ScreenWidth - 150);
    }];
    [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.bottom).offset(5);
        make.width.equalTo(ScreenWidth * 0.5 + 10);
        make.height.equalTo(30);//self.subNameLabel.backgroundColor = [UIColor orangeColor];
    }];
    [self.timeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.timeLabel.leading);
        make.top.equalTo(self.subNameLabel);
//        make.size.equalTo(timeInfoLabel);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(alphaView).offset(-15);
        make.top.equalTo(self.timeInfoLabel);
        make.size.equalTo(self.timeLabel);
    }];
}
@end
