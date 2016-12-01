//
//  GJGSelectorBar.m
//  Radar
//
//  Created by liubei on 16/4/26.
//  Copyright © 2016年 ABCoder. All rights reserved.
//

#define animationDuration 0.24f

#define classSelectedBGColor COLOR(253, 238, 48, 1)
#define classUnselectedBGColor [UIColor whiteColor]
#define distanceSelectedBGColor COLOR(241, 241, 241, 1)
#define distanceUnselectedBGColor [UIColor whiteColor]

#import "GJGSelectorBar.h"
#import "AppMacro.h"

@interface GJGSelectorBar () {
    
    UIView *bgView;
    CGRect selfFrame;
    
    UIImageView *indicatorImgView;
    

    UIButton *classLastSelectedBtn;
    UIButton *typeLastSelectedBtn;
}

@property (nonatomic, strong) UIView *classificationViewHolder;
@property (nonatomic, strong) UIView *distanceViewHolder;
@property (nonatomic, assign, getter=isShowList) BOOL showList;
@property (nonatomic, assign, getter=isShowLeft) BOOL showLeft;
@property (nonatomic, copy) didSelectedBlock block;

@end

@implementation GJGSelectorBar

+ (instancetype)selectorBarWithClassificaitons:(NSArray *)classifications
                                         types:(NSArray *)types
                                 selectedBlock:(didSelectedBlock)block{
    
    GJGSelectorBar *selectorBar = [[self alloc] init];
    selectorBar.classifications = classifications;
    selectorBar.types = types;
    selectorBar.block = block;
    return selectorBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.classSelectedIndex = 0;
        self.typeSelectedIndex = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.classificationLabel = [[UILabel alloc] init];
        self.classificationLabel.backgroundColor = [UIColor whiteColor];
        self.classificationLabel.textAlignment = NSTextAlignmentCenter;
        self.classificationLabel.font = [UIFont systemFontOfSize:12];
        self.classificationLabel.textColor = COLOR(51, 51, 51, 1);
        [self addSubview:self.classificationLabel];
        [self.classificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.and.bottom.equalTo(self).with.offset(0);
            make.width.mas_equalTo(@50);
        }];
        
        classificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [classificationButton setBackgroundColor:[UIColor whiteColor]];
        [classificationButton addTarget:self
                                 action:@selector(classificationButtonClick:)
                       forControlEvents:UIControlEventTouchUpInside];
        [classificationButton setTitleColor:COLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        [classificationButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:classificationButton];
        [classificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.and.bottom.equalTo(self).with.offset(0);
            make.left.equalTo(self.classificationLabel.mas_right).with.offset(0);
        }];
        
        indicatorImgView = [[UIImageView alloc] init];
        indicatorImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(classificationButtonClick:)];
        [indicatorImgView addGestureRecognizer:tap];
        indicatorImgView.contentMode = UIViewContentModeScaleAspectFit;
        indicatorImgView.image = [UIImage imageNamed:@"classification_cbb"];
//        indicatorImgView.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:indicatorImgView];
        [indicatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self).with.offset(0);
            make.left.equalTo(classificationButton.mas_right).with.offset(3);
        }];
        
        typeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [typeButton addTarget:self
                           action:@selector(distanceButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [typeButton setTitleColor:COLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        [typeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [typeButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:typeButton];
        [typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.and.right.equalTo(self).with.offset(0);
            make.width.mas_equalTo(@80);
        }];
        
        self.rightIndicImgView = [[UIImageView alloc] init];
        self.rightIndicImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(distanceButtonClick:)];
        [self.rightIndicImgView addGestureRecognizer:tap2];
        self.rightIndicImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.rightIndicImgView.image = [UIImage imageNamed:@"classification_cbb"];
        [self addSubview:self.rightIndicImgView];
        [self.rightIndicImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self).with.offset(0);
            make.right.equalTo(typeButton.mas_left).with.offset(0);
        }];
    }
    return self;
}

- (void)setClassifications:(NSArray *)classifications {
    _classifications = classifications;
    if (classifications.count > 0) {
        [classificationButton setTitle:[classifications firstObject] forState:UIControlStateNormal];
        [self hiddenOrShowViewHolder:_classificationViewHolder yesSignifyHidden:YES];
        _classificationViewHolder = nil;
    }
}
- (void)setTypes:(NSArray *)types {
    _types = types;
    if (types.count > 0) {
        [typeButton setTitle:[types firstObject] forState:UIControlStateNormal];
        [self hiddenOrShowViewHolder:_distanceViewHolder yesSignifyHidden:YES];
        _distanceViewHolder = nil;
    }else {
        typeButton.enabled = NO;
    }
}

- (void)setClassSelectedIndex:(NSInteger)classSelectedIndex {
    
    _classSelectedIndex = classSelectedIndex;
    [classificationButton setTitle:self.classifications[classSelectedIndex] forState:UIControlStateNormal];
}

- (void)setTypeSelectedIndex:(NSInteger)typeSelectedIndex {
    
    _typeSelectedIndex = typeSelectedIndex;
    [typeButton setTitle:self.types[typeSelectedIndex] forState:UIControlStateNormal];
}

- (UIView *)classificationViewHolder {
    
    if (!_classificationViewHolder) {
        
        if (!self.classifications.count) {
            
            return nil;
        }
        
        CGFloat horMargin = 14;
        CGFloat outDerMargin = 24;
        CGFloat inDerMargin = 10;
        int colCount = 3;
        
        CGFloat buttonH = 34;
        CGFloat buttonW = (self.frame.size.width - horMargin * (colCount + 1))/colCount;
        CGFloat holderH = outDerMargin * 2 + (buttonH + inDerMargin) * ((self.classifications.count - 1) / colCount + 1);//buttonH * ((self.classifications.count -1) / colCount + 1) + inDerMargin * ((self.classifications.count - 1) / colCount - 1) + outDerMargin * 2;
        selfFrame = [UIView relativeFrameForScreenWithView:self];
        CGFloat viewY = 0;
        if ((selfFrame.origin.y + self.frame.size.height + 0.5 + holderH) > kScreenHeight) {
            viewY = selfFrame.origin.y;
        }else {
            viewY = selfFrame.origin.y + self.frame.size.height + 0.5;
        }
        _classificationViewHolder = [[UIView alloc]
                                     initWithFrame:CGRectMake(selfFrame.origin.x,//self.frame.origin.x,
                                                              viewY,
                                                              self.frame.size.width,
                                                              holderH)];
        [_classificationViewHolder setBackgroundColor:COLOR(241, 241, 241, 1)];
        [_classificationViewHolder setClipsToBounds:YES];
        
        for (int i = 0; i < self.classifications.count; i++) {
            
            CGFloat buttonX = horMargin + (buttonW + horMargin) * (i % colCount);
            CGFloat buttonY = outDerMargin + (buttonH + inDerMargin) * (i / colCount);
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            [button setTitleColor:COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button.layer setCornerRadius:5];
            button.layer.masksToBounds = YES;
            button.layer.shouldRasterize = YES;
            button.tag = 10 + i;
            button.layer.rasterizationScale = [UIScreen mainScreen].scale;
            [button addTarget:self action:@selector(classificationDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            if (button.tag - 10 == self.classSelectedIndex) {
                [button setBackgroundColor:classSelectedBGColor];
            } else {
                [button setBackgroundColor:classUnselectedBGColor];
            }
            [button setTitle:self.classifications[i] forState:UIControlStateNormal];
            [_classificationViewHolder addSubview:button];
        }
    }
    return _classificationViewHolder;
}
- (UIView *)distanceViewHolder {
    
    if (!_distanceViewHolder) {
        
        CGFloat buttonH = 35;
        CGFloat holderH = buttonH * self.types.count;
        selfFrame = [UIView relativeFrameForScreenWithView:self];
        CGFloat viewY = 0;
        if ((selfFrame.origin.y + self.frame.size.height + 0.5 + holderH) > kScreenHeight) {
            viewY = selfFrame.origin.y;
        }else {
            viewY = selfFrame.origin.y + self.frame.size.height + 0.5;
        }
        _distanceViewHolder = [[UIView alloc] initWithFrame:CGRectMake(selfFrame.origin.x,
                                                                       viewY,
                                                                       self.frame.size.width,
                                                                       holderH)];
        [_distanceViewHolder setBackgroundColor:[UIColor whiteColor]];
        [_distanceViewHolder setClipsToBounds:YES];
        
        for (int i = 0; i < self.types.count; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          buttonH * i,
                                                                          self.frame.size.width,
                                                                          buttonH)];
            button.tag = 1000 + i;
            [button setTitleColor:COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [button addTarget:self action:@selector(distanceDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            if (button.tag - 1000 == self.typeSelectedIndex) {
                [button setBackgroundColor:distanceSelectedBGColor];
                typeLastSelectedBtn = button;
            }else {
                [button setBackgroundColor:distanceUnselectedBGColor];
            }
            [button setTitle:self.types[i] forState:UIControlStateNormal];
            [_distanceViewHolder addSubview:button];
        }
    }
    return _distanceViewHolder;
}

- (void)hiddenOrShowViewHolder:(UIView *)view yesSignifyHidden:(BOOL)choose {
    
    CGRect oldFrame = view.frame;
    CGRect tmpFrame = view.frame;
    
    if (choose) {
        
        tmpFrame.size.height = 0.f;
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            bgView.alpha = 0;
            view.frame = tmpFrame;
            if (view == _classificationViewHolder)
                indicatorImgView.transform = CGAffineTransformMakeRotation(0);
            else
                self.rightIndicImgView.transform = CGAffineTransformMakeRotation(0);
            
        } completion:^(BOOL finished) {
            
            [view removeFromSuperview];
            [bgView removeFromSuperview];

            [self.distanceViewHolder removeFromSuperview];
            [self.classificationViewHolder removeFromSuperview];
            self.distanceViewHolder = nil;
            self.classificationViewHolder = nil;
        }];
    }else {
        
        tmpFrame.size.height = 0.f;
        if (view.frame.origin.y < (selfFrame.origin.y + selfFrame.size.height)) {
            tmpFrame.origin.y = selfFrame.origin.y;
            oldFrame.origin.y = selfFrame.origin.y - oldFrame.size.height;
        }
        view.frame = tmpFrame;
        bgView = [[UIView alloc] initWithFrame:kScreenBounds];
        bgView.backgroundColor = GJGRGBAColor(0, 0, 0, 0.6);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)];
        bgView.userInteractionEnabled = YES;
        [bgView addGestureRecognizer:tap];
        [bgView addSubview:view];
        [[UIApplication sharedApplication].keyWindow addSubview:bgView];
        [UIView animateWithDuration:animationDuration animations:^{
            
            view.frame = oldFrame;
            if (view == _classificationViewHolder)
                indicatorImgView.transform = CGAffineTransformMakeRotation(M_PI);
            else
                self.rightIndicImgView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:nil];
    }
}

- (void)classificationButtonClick:(id)sender {
    
    if (self.isShowList) {
        
        if (self.isShowLeft) {
            
            [self hiddenOrShowViewHolder:self.classificationViewHolder yesSignifyHidden:YES];
            self.showList = NO;
        }else {
            
            [self hiddenOrShowViewHolder:self.distanceViewHolder yesSignifyHidden:YES];
            [self hiddenOrShowViewHolder:self.classificationViewHolder yesSignifyHidden:NO];
            self.showLeft = YES;
        }
    }else {
        
        [self hiddenOrShowViewHolder:self.classificationViewHolder yesSignifyHidden:NO];
        self.showList = YES;
        self.showLeft = YES;
    }
}

- (void)distanceButtonClick:(id)sender {
    
    if (self.isShowList) {
        
        if (self.isShowLeft) {
            
            [self hiddenOrShowViewHolder:self.classificationViewHolder yesSignifyHidden:YES];
            [self hiddenOrShowViewHolder:self.distanceViewHolder yesSignifyHidden:NO];
            self.showLeft = NO;
        }else {
            
            [self hiddenOrShowViewHolder:self.distanceViewHolder yesSignifyHidden:YES];
            self.showList = NO;
        }
    }else {
        
        [self hiddenOrShowViewHolder:self.distanceViewHolder yesSignifyHidden:NO];
        self.showList = YES;
        self.showLeft = NO;
    }
}

- (void)classificationDidSelected:(UIButton *)button {
    
    [classificationButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    [button setBackgroundColor:classSelectedBGColor];
    [classLastSelectedBtn setBackgroundColor:classUnselectedBGColor];
//    classLastSelectedBtn = button;
    self.classSelectedIndex = button.tag - 10;
    self.block([classificationButton titleForState:UIControlStateNormal],
               [typeButton titleForState:UIControlStateNormal]);
    [self hiddenSelectView];
}

- (void)distanceDidSelected:(UIButton *)button {
    
    [typeButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    [button setBackgroundColor:distanceSelectedBGColor];
    [typeLastSelectedBtn setBackgroundColor:distanceUnselectedBGColor];
//    distanceLastSelectedBtn = button;
    self.typeSelectedIndex = button.tag - 1000;
    self.block([classificationButton titleForState:UIControlStateNormal],
               [typeButton titleForState:UIControlStateNormal]);
    [self hiddenSelectView];
}

- (void)hiddenSelectView {
    
    [self hiddenOrShowViewHolder:self.classificationViewHolder yesSignifyHidden:YES];
    [self hiddenOrShowViewHolder:self.distanceViewHolder yesSignifyHidden:YES];
    self.showList = NO;
}

- (void)bgViewTap:(UITapGestureRecognizer *)tapGes {
    [self hiddenSelectView];
}

@end
