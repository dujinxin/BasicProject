//
//  FilmTopView.m
//  GJieGo
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "FilmTopView.h"

@implementation FilmTopView

- (id)initWithFrame:(CGRect)frame backImage:(UIImage *)image name:(NSString *)name distance:(NSString *)distance{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeMovieToViewUIWithBackImage:image name:name distance:distance];
    }
    return self;
}

- (void)makeMovieToViewUIWithBackImage:(UIImage *)image name:(NSString *)name distance:(NSString *)distance{
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = image;
    UIView *alphaView = [[UIView alloc] init];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = maskAlpha;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    UIImageView *distanceImageView = [[UIImageView alloc] init];
    distanceImageView.image = [UIImage imageNamed:@"content_formats_map"];
    UILabel *distanceLabel = [[UILabel alloc] init];
    distanceLabel.text = distance;
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.font = [UIFont systemFontOfSize:11.0f];
    self.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [self addSubview:backImageView];
    [self addSubview:alphaView];
    [self addSubview:nameLabel];
    [self addSubview:distanceImageView];
    [self addSubview:distanceLabel];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(backImageView.bottom).offset(-64);
        make.width.equalTo(self);
        make.bottom.equalTo(backImageView);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(alphaView).offset(11);
        make.size.greaterThanOrEqualTo(nameLabel);
    }];
    [distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(nameLabel);
        make.top.equalTo(nameLabel.bottom).offset(10);
        make.size.equalTo(distanceImageView);
    }];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(distanceImageView.trailing).offset(5);
        make.centerY.equalTo(distanceImageView);
        make.size.equalTo(distanceLabel);
    }];
}
@end
