//
//  GJGActivityClassView.h
//  GJieGo
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseView.h"

@protocol GJGActivityClassDelegate <NSObject>

- (void)didClickActivityButton:(UIButton *)button;

@end

@interface GJGActivityClassView : BaseView
@property (nonatomic ,assign)id <GJGActivityClassDelegate>activityDelegate;
@property (nonatomic, strong)NSMutableArray *sourceArray;
- (id)initWithFrame:(CGRect)frame withSourceArray:(NSArray *)sourceArray;
@end
