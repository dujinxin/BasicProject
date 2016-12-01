//
//  GJGBrandClassView.h
//  GJieGo
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseView.h"

@protocol BrandClassViewDelegate <NSObject>

- (void)clickBrandClassButton:(UIButton *)button;
@end

@interface GJGBrandClassView : BaseView
@property (nonatomic, assign)id<BrandClassViewDelegate>delegate;
@property (nonatomic, strong)NSMutableArray *sourceArray;
- (id)initWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArray;
@end
