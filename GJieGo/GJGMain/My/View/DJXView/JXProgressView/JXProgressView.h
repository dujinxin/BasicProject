//
//  JXProgressView.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/4.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  JXProgressDelegate<NSObject>
//修改进度标签内容
- (void)changeTextProgress:(NSString*)string;
//进度条结束时
- (void)endTime;
//- (void)setProgress:(CGFloat)progress;//设置进度
@end

@interface JXProgressView : UIView

// 背景图像
@property (strong, nonatomic) UIImageView *trackView;
// 填充图像
@property (strong, nonatomic) UIImageView *progressView;

@property (strong, nonatomic) NSTimer *progressTimer; //时间定时器
// 背景图像
@property (strong, nonatomic) UIImage *trackImage;
// 填充图像
@property (strong, nonatomic) UIImage *progressImage;
@property (nonatomic) CGFloat progress; //进度
@property (nonatomic) CGFloat currentProgress; //当前进度

@property (nonatomic, weak)id<JXProgressDelegate> delegate;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;//设置进度
- (void)setProgress:(CGFloat)progress animations:(void(^)())animation completion:(void(^)(BOOL finished))completion;//设置进度
@end
