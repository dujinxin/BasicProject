//
//  RenderServiceCell.h
//  GJieGo
//
//  Created by apple on 16/7/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol RenderServiceCellDelegate <NSObject>

- (void)RenderServiceButtonAction:(UIButton *)button;

@end

@interface RenderServiceCell : BaseTableViewCell
@property (nonatomic, assign)id<RenderServiceCellDelegate> delegate;
@property (nonatomic, strong)NSArray *sourceArray;
@end
