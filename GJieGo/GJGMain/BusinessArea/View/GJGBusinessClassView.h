//
//  GJGBusinessClassView.h
//  GJieGo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseView.h"

@protocol businessViewDelegate <NSObject>

- (void)transformBusinessViewButtonAction:(UIButton *)button;

@end

@interface GJGBusinessClassView : BaseView
@property (nonatomic, weak)id <businessViewDelegate>delegate;
@property (nonatomic, strong)NSMutableArray *sourceArray;
//商圈分类
- (id)initWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArray;
- (void)makeGJGBusinessArearUIWithCalssData:(NSArray*)classArray;
@end
