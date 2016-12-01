
//
//  ShopingCenterDetailServiceView.m
//  GJieGo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShopingCenterDetailServiceView.h"

@interface ShopingCenterDetailServiceView ()
@property (nonatomic, strong)UIScrollView *serviceScrollView;
@property (nonatomic, strong)UILabel *serviceName;
@end

@implementation ShopingCenterDetailServiceView

- (id)initWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArray serviceName:(NSString *)serviceName{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GJGRGB16Color(0xf1f1f1);
        [self makeShopingCenterDetailServiceViewWithsourceArray:sourceArray serviceName:serviceName];
    }
    return self;
}

- (void)makeShopingCenterDetailServiceViewWithsourceArray:(NSArray *)sourceArray serviceName:(NSString *)serviceName{
    CGFloat scrl = ScreenWidth / 375;
    
    UIView *serviceBackView = [[UIView alloc] init];
    serviceBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:serviceBackView];
    [serviceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.top.equalTo(0);
        make.size.equalTo(CGSizeMake(ScreenWidth, 70 * ceilf(sourceArray.count / 4.0) * scrl));
    }];
  
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = serviceName;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:12.0f];
    nameLabel.textColor = GJGRGB16Color(0x333333);
    if (sourceArray.count < 1) {
        nameLabel.hidden = YES;
    }else{
        nameLabel.hidden = NO;
    }
    [serviceBackView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.top.equalTo(10);
    }];
    
    for (int i = 0; i < sourceArray.count; i++) {
        NSDictionary *sourceDic = sourceArray[i];
        UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image ;
        if ([sourceDic[@"Image"] isEqual:[NSNull null]]) {
            image = [UIImage imageNamed:@"default_portrait_less"];
        }else{
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sourceDic[@"Image"]]]];
        }
        [serviceButton setImage:image forState:UIControlStateNormal];
        serviceButton.userInteractionEnabled = NO;
        serviceButton.contentMode = UIViewContentModeScaleAspectFill;
        [serviceBackView addSubview:serviceButton];
        [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(95.5 + (i % 4) * (27 + 38) * scrl );
            make.top.equalTo(10 + (i / 4) * (27 + 38));
            make.size.equalTo(CGSizeMake(27 * scrl, 27 * scrl));
        }];
        
        UILabel * serviceLabel = [UILabel labelWithFrame:CGRectZero text:sourceDic[@"Name"] tinkColor:GJGRGB16Color(0x333333) fontSize:11.0f];
        serviceLabel.textAlignment = NSTextAlignmentCenter;
        [serviceBackView addSubview:serviceLabel];
        [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(serviceButton);
            make.top.equalTo(serviceButton.bottom).offset(8);
        }];
    }
}
@end
