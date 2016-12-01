//
//  JXProgressView.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/4.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "JXProgressView.h"

@implementation JXProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = frame.size.height /2;
        // 背景图像
        _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_trackView setImage:[JXImageNamed(@"bar_gray") stretchableImageWithLeftCapWidth:3.0 topCapHeight:3.0]];
        _trackView.layer.cornerRadius = frame.size.height /2;
        _trackView.clipsToBounds = YES;//当前view的主要作用是将出界了的_progressView剪切掉，所以需将clipsToBounds设置为YES
        [self addSubview:_trackView];
        // 填充图像
        _progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0-frame.size.width, 0, frame.size.width, frame.size.height)];
        [_progressView setImage:[JXImageNamed(@"bar_yellow") stretchableImageWithLeftCapWidth:3.0 topCapHeight:3.0]];
        [_trackView addSubview:_progressView];
        
        _currentProgress = 0.0;
        
    }
    return self;
}
- (void)setTrackImage:(UIImage *)trackImage{
    _trackImage = trackImage;
}
- (void)setProgressImage:(UIImage *)progressImage{
    _progressImage = progressImage;
}
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    _progress = progress;
    if (animated) {
        [self setProgress:progress animations:nil completion:nil];
    }else{
        _progressView.frame = CGRectMake(self.frame.size.width * (_progress) - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
    
    if (0 == progress) {
        self.currentProgress = 0;
        [self changeProgressViewFrame];
        return;
    }
    if (_progressTimer == nil)
    {
        //创建定时器
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(moveProgress) userInfo:nil repeats:YES];
    }
}
- (void)setProgress:(CGFloat)progress animations:(void (^)())animation completion:(void (^)(BOOL))completion{
    _progress = progress;
    [UIView animateWithDuration:1 animations:^{
        _progressView.frame = CGRectMake(self.frame.size.width * (_progress) - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        if (animation) {
            animation();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}
//////////////////////////////////////////////////////
//修改进度
- (void) moveProgress
{
    //判断当前进度是否大于进度值
    if (self.currentProgress < _progress)
    {
//        self.currentProgress = MIN(self.currentProgress + 0.1*_targetProgress, _targetProgress);
//        if (_targetProgress >=10) {
//            [_delegate changeTextProgress:[NSString stringWithFormat:@"%d %%",(int)self.currentProgress]];
//        }else{
//            [_delegate changeTextProgress:[NSString stringWithFormat:@"%.1f %%",self.currentProgress]];
//        }
        
        //改变界面内容
        [self changeProgressViewFrame];
        
    } else {
        //当超过进度时就结束定时器，并处理代理方法
        [_progressTimer invalidate];
        _progressTimer = nil;
        [_delegate endTime];  
    }  
}  
//修改显示内容  
- (void)changeProgressViewFrame{  
    //只要改变frame的x的坐标就能看到进度一样的效果
    [UIView animateWithDuration:1 animations:^{
        _progressView.frame = CGRectMake(self.frame.size.width * (_progress) - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
