//
//  GJGActivityClassView.m
//  GJieGo
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 购物中心 最新活动部分 ---

#import "GJGActivityClassView.h"
#define subTag 2500

@implementation GJGActivityClassView

- (id)initWithFrame:(CGRect)frame withSourceArray:(NSArray *)sourceArray{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addViewWithSourceArray:sourceArray];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setSourceArray:(NSMutableArray *)sourceArray{
    if (_sourceArray != sourceArray) {
        [self addViewWithSourceArray:sourceArray];
    }
}

#pragma mark - scaleAspect
- (CGFloat)viewsWithFloat:(CGFloat)f{
    return f * (ScreenWidth / 350);
}

- (void)addViewWithSourceArray:(NSArray *)sourceArray{
    NSLog(@"sssf: %lf", self.bounds.size.height);
    NSInteger activityClassHeight = 0;
    if (ScreenWidth < 375) {
        activityClassHeight = 86;
    }else{
        if (ScreenWidth > 375) {
            activityClassHeight = 106;
        }else{
            activityClassHeight = 96;
        }
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, activityClassHeight)];
    CGFloat num = sourceArray.count / 5;
    if (sourceArray.count % 5 != 0) {
        num++;
    }
    scrollView.contentSize = CGSizeMake(num * ScreenWidth, self.bounds.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    [self addSubview:scrollView];
    
    for (int i = 0; i < sourceArray.count; i++) {
        NSDictionary *sourceDic = [NSDictionary dictionaryWithDictionary:sourceArray[i]];
        UIImage *image;
        CGFloat btnH;
        if ([self viewsWithFloat:100] > ScreenWidth / 5) {
            btnH = ScreenWidth / 5 - 30;
        }else{
            btnH = [self viewsWithFloat:100] - 30;
        }
        [self isBlankString:sourceDic[@"DicExt"]] ? (image = [UIImage imageNamed:@"default_portrait_less"]) : (image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sourceDic[@"DicExt"]]]]);
        UIButton *classButton = [UIButton buttonWithType:UIButtonTypeCustom
                                                     tag:subTag + i
                                                   title:sourceDic[@"DicName"]
                                               titleSize:0.0f
                                                   frame:CGRectZero//CGRectMake(i * (ScreenWidth / 5) + [self viewsWithFloat:18] - 3.5, 35 - 3.5, [self viewsWithFloat:40], [self viewsWithFloat:40])
                                                   Image:image
                                                  target:self
                                                  action:@selector(didClickClassButton:)];
        classButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [scrollView addSubview:classButton];
        [classButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(i * (ScreenWidth / 5) + [self viewsWithFloat:18] - 3.5);
            make.top.equalTo(35 - 3.5);
            make.size.equalTo(CGSizeMake(btnH, btnH));
        }];

        UILabel *classLabel = [UILabel labelWithFrame:CGRectZero text:sourceDic[@"DicName"] tinkColor:GJGBLACKCOLOR fontSize:12];
        [scrollView addSubview:classLabel];
        [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(classButton);
            make.bottom.equalTo(classButton.top).offset(-10);
        }];
    }
    UIView *lineTwoView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + activityClassHeight - 10, self.bounds.size.width, 10)];
    lineTwoView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [self addSubview:lineTwoView];
}

#pragma mark - 点击自运营按钮
- (void)didClickClassButton:(UIButton *)button{
    [self.activityDelegate didClickActivityButton:button];
}
@end
