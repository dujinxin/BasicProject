//
//  GJGSubTopView.h
//  GJieGo
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseView.h"

@protocol GJGSubTopViewDelegate <NSObject>

- (void)clickSubTopButtonAction:(UIButton *)button;

@end
@interface GJGSubTopView : BaseView
@property (nonatomic, assign)id<GJGSubTopViewDelegate> delegate;
@property (nonatomic, strong)NSMutableArray *sourceArray;
- (id)initWithFrame:(CGRect)frame withSourceArray:(NSArray *)sourceArray;
@end
