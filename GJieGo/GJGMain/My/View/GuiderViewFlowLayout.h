//
//  GuiderViewFlowLayout.h
//  GJieGo
//
//  Created by dujinxin on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuiderViewFlowLayout;
@protocol WaterFlowLayoutDelegate <NSObject>

// 计算item高度
- (CGFloat)waterFlow:(GuiderViewFlowLayout *)waterFlow itemWidth:(CGFloat)itemW cellIndexPath:(NSIndexPath *)indexPath;

@end

@interface GuiderViewFlowLayout : UICollectionViewFlowLayout

//数据源  从中可以获得每个cell的宽高 和 一共有多少个cell
//@property(nonatomic,strong)NSArray *dataList;

//需要显示多少列
@property(nonatomic,assign) int columnCount;

@property(nonatomic,weak) id<WaterFlowLayoutDelegate> delegate;
@end
