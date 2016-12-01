//
//  RenderServiceCell.m
//  GJieGo
//
//  Created by apple on 16/7/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "RenderServiceCell.h"

@implementation RenderServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSourceArray:(NSArray *)sourceArray{
    if (_sourceArray != sourceArray) {
        _sourceArray = sourceArray;
        [self creatUI];
    }
}
- (void)creatUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.bounds.size.height)];
    CGFloat num = self.sourceArray.count / 5;
    if (self.sourceArray.count % 5 != 0) {
        num++;
    }
    scrollView.contentSize = CGSizeMake(num * ScreenWidth, self.bounds.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    [self.contentView addSubview:scrollView];
    
    for (int i = 0; i < self.sourceArray.count; i++) {
        NSDictionary *sourceDic = self.sourceArray[i];
        UIImage *image;
        if ([sourceDic[@"DicExt"] isKindOfClass:[NSNull class]]) {
            image = [UIImage imageNamed:@"default_portrait_less"];
        }else{
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sourceDic[@"DicExt"]]]];
        }
        UIButton *classButton = [UIButton buttonWithType:UIButtonTypeCustom
                                                     tag:i
                                                   title:nil
                                               titleSize:11.0f
                                                   frame:CGRectMake(i * (ScreenWidth / 5) + [self viewsWithFloat:18], 10, [self viewsWithFloat:37], [self viewsWithFloat:37])
                                                   Image:image
                                                  target:self
                                                  action:@selector(didClickClassButton:)];
        classButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        classButton.tag = i;
        [scrollView addSubview:classButton];
        [classButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(i * (ScreenWidth / 5) + [self viewsWithFloat:18]);
            make.top.equalTo(10);
            make.size.equalTo(CGSizeMake([self viewsWithFloat:37], [self viewsWithFloat:37]));
        }];
        UILabel *classLabel = [UILabel labelWithFrame:CGRectZero text:sourceDic[@"DicName"] tinkColor:GJGBLACKCOLOR fontSize:12];
        [scrollView addSubview:classLabel];
        [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(classButton);
            make.top.equalTo(classButton.bottom).offset(10);
        }];
    }
    
    UIView *lineTwoView = [[UIView alloc] initWithFrame:CGRectZero];//CGRectMake(self.bounds.origin.x, self.bounds.origin.y + 85, self.bounds.size.width, 10)
    lineTwoView.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [self.contentView addSubview:lineTwoView];
    [lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.top.equalTo(85);
        make.size.equalTo(CGSizeMake(ScreenWidth, 10));
    }];
}

#pragma mark - scaleAspect
- (CGFloat)viewsWithFloat:(CGFloat)f{
    return f * (ScreenWidth / 350);
}

- (void)didClickClassButton:(UIButton *)button{
    [self.delegate RenderServiceButtonAction:button];
}
@end
