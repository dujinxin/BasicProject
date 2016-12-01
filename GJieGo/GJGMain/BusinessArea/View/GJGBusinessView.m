//
//  GJGBusinessView.m
//  GJieGo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 选择商圈 ---

#import "GJGBusinessView.h"
#define tagNum 1100

@interface GJGBusinessView ()
{
    NSMutableArray *businessArray;
    NSString *title;
}
@end

@implementation GJGBusinessView

- (id)initWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArray location:(NSString *)location className:(NSString *)className{
    self = [super initWithFrame:frame];
    if (self) {
        self.sourceArray = sourceArray;
        self.location = location;
        [self makeBusinessUIWithArray:sourceArray location:location className:className];
    }
    return self;
}
- (void)initWithSourceArray:(NSArray *)sourceArray location:(NSString *)location className:(NSString *)className{
    [self makeBusinessUIWithArray:sourceArray location:location className:className];
}
- (void)makeBusinessUIWithArray:(NSArray*)sourceArray location:(NSString *)location className:(NSString *)className{
   self.backgroundColor = GJGRGB16Color(0xf1f1f1);
    if (sourceArray.count != 0) {
        
        CGFloat horMargin = 14;
        CGFloat outDerMargin = 24;
        CGFloat inDerMargin = 10;
        int colCount = 3;
        
        CGFloat buttonH = 34;
        CGFloat buttonW = (self.frame.size.width - horMargin * (colCount + 1))/colCount;
        businessArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        for (int i = 0; i < sourceArray.count; i++) {
            CGFloat businessButtonX = horMargin + (buttonW + horMargin) * (i % colCount);
            CGFloat businessButtonY = outDerMargin + (buttonH + inDerMargin) * (i / colCount);
            
            NSDictionary *dic = sourceArray[i];
            if ([className isEqualToString:@"business"]) {
                title = dic[@"BCName"];
            }else{
                title = dic[@"DicName"];
            }
            
            UIButton *businessButton = [UIButton buttonWithType:UIButtonTypeCustom tag:tagNum + i title:title titleSize:13.0f frame:CGRectMake(businessButtonX, businessButtonY, buttonW, buttonH) Image:nil target:self action:@selector(clickBusinessButton:)];
            businessButton.tag = i;//[sourceArray[i][@"BCID"] integerValue];
            businessButton.layer.cornerRadius = 5;
            businessButton.layer.masksToBounds = YES;
            [businessButton setTitleColor:COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
            [businessButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [businessButton setBackgroundColor:[UIColor whiteColor]];
            businessButton.layer.shouldRasterize = YES;
            businessButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
            [self addSubview:businessButton];
            [businessArray addObject:businessButton];
            if (i == 0) {
                businessButton.backgroundColor = GJGRGB16Color(0xfee330);
            }
            [businessButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(businessButtonX);
                make.top.equalTo(businessButtonY);
                make.size.equalTo(CGSizeMake(buttonW, buttonH));
            }];
        }
        if (location != nil) {
            self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom tag:1190 title:[NSString stringWithFormat:@"当前位置 %@", location] titleSize:15.0f frame:CGRectMake(15, self.bounds.size.height - 56, 346, 33) Image:NULL target:self action:@selector(didClickMapButton:)];
            self.mapButton.layer.cornerRadius = 7.5;
            self.mapButton.layer.masksToBounds = YES;
            self.mapButton.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:self.mapButton];
            [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(15);
                make.bottom.equalTo(self).offset(-23);
                make.size.equalTo(CGSizeMake(self.bounds.size.width - 15 * 2, 33));
            }];
        }
    
    }else{
        //如果无分类，显示一张图片
        if (location != nil) {
            self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom tag:1190 title:[NSString stringWithFormat:@"当前位置 %@", location] titleSize:15.0f frame:CGRectMake(15, self.bounds.size.height - 56, 346, 33) Image:NULL target:self action:@selector(didClickMapButton:)];
            self.mapButton.layer.cornerRadius = 7.5;
            self.mapButton.layer.masksToBounds = YES;
            self.mapButton.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:self.mapButton];
            [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(15);
                make.bottom.equalTo(self).offset(-23);
                make.size.equalTo(CGSizeMake(self.bounds.size.width - 15 * 2, 33));
            }];
        }
//        UIImage *showImage = [UIImage imageNamed:@""];
//        UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//        showImageView.image = showImage;
//        showImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [self addSubview:showImageView];
    }
    
    
}

- (void)clickBusinessButton:(UIButton *)button{
    [self.delegate clickBusinessButtonAction:button];
    
    for (UIButton *btn in businessArray) {
        if (button == btn) {
            button.backgroundColor = GJGRGB16Color(0xfee330);//[UIColor yellowColor];
        }else{
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)didClickMapButton:(UIButton *)button{
    [self.delegate clickMapButtonAction:button];
    NSLog(@"定位");
}
@end
