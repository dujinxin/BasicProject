//
//  GJGTopView.m
//  GJieGo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 购物中心分类最上面展示图部分 ---

#import "GJGTopView.h"
#define navH 0//64

@implementation GJGTopView

- (id)initWithFrame:(CGRect)frame Height:(CGFloat)height imageName:(NSString *)imageName name:(NSString *)name subName:(NSString *)subName distance:(NSString *)distance{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GJGRGB16Color(0xf1f1f1);
        [self makeTopViewWithHeight:height imageName:imageName name:name subName:subName distance:distance];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GJGRGB16Color(0xf1f1f1);
    }
    return self;
}
- (void)setMallHomeInfoItem:(MallHomeInfoItem *)mallHomeInfoItem{
    if (mallHomeInfoItem != _mallHomeInfoItem) {
        _mallHomeInfoItem = mallHomeInfoItem;
        [self makeTopViewWithHeight:187 imageName:mallHomeInfoItem.MallImage name:mallHomeInfoItem.MallName subName:mallHomeInfoItem.MallAddress distance:mallHomeInfoItem.Distance];
    }
}

- (void)setShopHomeInfoItem:(ShopHomeInfoItem *)shopHomeInfoItem{
    if (shopHomeInfoItem != _shopHomeInfoItem) {
        _shopHomeInfoItem = shopHomeInfoItem;
        [self makeTopViewWithHeight:187 imageName:shopHomeInfoItem.ShopImage name:shopHomeInfoItem.ShopName subName:shopHomeInfoItem.ShopAddress distance:shopHomeInfoItem.Distance];
    }
}
- (void)makeTopViewWithHeight:(CGFloat)height imageName:(NSString *)imageName name:(NSString *)name subName:(NSString *)subName distance:(NSString *)distance{
    
//    底图
    UIImageView *imageView = [[UIImageView alloc] init];
//    imageName.
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o",imageName, (int)ScreenWidth]] placeholderImage:[UIImage imageNamed:@"default_landscape_normal"]];
//    蒙版
    UIView *alphaView = [[UIView alloc] init];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = maskAlpha;
//    商场名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = name;
//    if (name.length > 15) {
//        nameLabel.text = [name substringToIndex:15];
//    }
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.textColor = [UIColor whiteColor];
//    商场地址
    UILabel *subNameLabel = [[UILabel alloc] init];
    subNameLabel.text = subName;
    subNameLabel.numberOfLines = 0;
    subNameLabel.font = [UIFont systemFontOfSize:11.0f];
    subNameLabel.textColor = [UIColor whiteColor];
//    商场地址
//    UIImage *locationImage = [UIImage imageNamed:@"content_formats_map"];
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton addTarget:self action:@selector(didClickLocationButton:) forControlEvents:UIControlEventTouchUpInside];//[UIButton buttonWithType:UIButtonTypeCustom tag:0 title:@"" titleSize:11.0f frame:CGRectMake(ScreenWidth - locationImage.size.width - 28, nameLabel.frame.origin.y, locationImage.size.width, locationImage.size.height) Image:locationImage target:self action:@selector(didClickLocationButton:)];
    UIImageView *locationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_formats_map"]];
    imageView.userInteractionEnabled = YES;
//    [locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    locationImage.contentMode = UIViewContentModeScaleAspectFill;//
//    locationButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    if ([distance isKindOfClass:[NSString class]]) {
        label.text = distance;
    }else{
        label.text = [NSString stringWithFormat:@"%f",[distance floatValue]];
    }
    label.font = [UIFont systemFontOfSize:11.0f];
    
//    [locationButton setImageEdgeInsets:UIEdgeInsetsMake(0,10,17,locationButton.titleLabel.bounds.size.width + 12)];
//    [locationButton setTitleEdgeInsets:UIEdgeInsetsMake(locationButton.imageView.bounds.size.height + 12 + 11, -locationButton.titleLabel.bounds.size.width - locationImage.size.width, 0, 0)];
    
    [imageView addSubview:alphaView];
    [imageView addSubview:nameLabel];
    [imageView addSubview:subNameLabel];
    [imageView addSubview:locationButton];
    [locationButton addSubview:locationImage];
    [locationButton addSubview:label];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);//距离左面0
        make.top.equalTo(0);//距离上边10
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, height));
    }];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(imageView.bottom).offset(-64);
        make.width.equalTo(self);
        make.height.equalTo(64);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(alphaView).offset(15);
        make.top.equalTo(alphaView).offset(5);
        make.width.equalTo(ScreenWidth - 150);
    }];
    [subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(nameLabel);
        make.top.equalTo(nameLabel.bottom).offset(0);
        make.width.equalTo(ScreenWidth * 0.8 - 20);
        make.height.equalTo(30);//subNameLabel.backgroundColor = [UIColor redColor];
    }];
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(alphaView.trailing).offset(- 28 - locationImage.size.width);
        make.top.equalTo(nameLabel);//.offset(11);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(label);
        make.top.equalTo(locationButton);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(-15);
        make.top.equalTo(locationButton.bottom).offset(-15);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.bottom.equalTo(0);
        make.width.equalTo(ScreenWidth);
        make.height.equalTo(10);
    }];
}

- (void)didClickLocationButton:(UIButton *)button{
//    NSLog(@"地图");
    [self.delegate clickMapButtonAction:button];
}
@end
