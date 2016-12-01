/*
 
 The MIT License (MIT)
 
 Copyright (c) 2015 ABM Adnan
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <UIKit/UIKit.h>
#import "LBRadarM.h"

@interface Dot : UIView {

}

typedef enum {
    
    DotTypeIsUser = 0,
    DotTypeIsGuider = 1,
    DotTypeIsImage = 2,
    DotTypeIsGroup = 3
    
}DotType;

@property (nonatomic, strong) NSNumber *bearing;
@property (nonatomic, strong) NSNumber *userDistance;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, readwrite) BOOL zoomEnabled;

//@property (nonatomic, strong) NSDictionary *userProfile;    // Will be replace to RadarItem
@property (nonatomic, strong) LBRadarItemM *radarItem;

@property (nonatomic, assign, getter=isOut) BOOL out;                       // 判定是否出界，用来防止多次动画
@property (nonatomic, assign, getter=isInOutAnimating) BOOL inOutAnima;     // 判断是否正在进行进出场动画

//@property (nonatomic, assign, getter=isOutAnimating) BOOL outAnimation;

@property (nonatomic, assign) DotType type;                                 // Dot类型
@property (nonatomic, assign, getter=isNeedLoadImg) BOOL needLoadImg;       // 是否需要下载图片, 关闭状态不会自己下载图片
@property (nonatomic, strong) UIImage *image;                               // 图片 **弃用**
@property (nonatomic, assign) CGFloat value;                                // 位置变化量
@property (nonatomic, strong) NSMutableArray<Dot *> *subDots;               // Dots, 组dot包含的子dot
@property (nonatomic, strong) UILabel *badge;                               // 角标label
@property (nonatomic, strong) CAAnimation *ani;                             // 将给dot添加的动画（进出场动画）赋给这个指针，用来在内部监听动画开始结束
/** 正在动画 */
//@property (nonatomic, assign, getter=isMoving) BOOL moving;
@property (nonatomic, assign, getter=isShowIcon) BOOL showIcon;             // 是否显示icon

//- (void)dotAddAnimation:(CAAnimation *)ani;

@end
