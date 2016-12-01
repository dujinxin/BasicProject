//
//  SharedOrderInMainCell.h
//  GJieGo
//
//  Created by liubei on 16/5/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSharedOrderM.h"

typedef enum {
    
    SharedOrderCellTypeIsMain = 0,
    SharedOrderCellTypeIsUserHome = 1
    
}SharedOrderCellType;

@interface SharedOrderInMainCell : UICollectionViewCell

/** 晒单信息 */
@property (nonatomic, strong) LBSharedOrderM *sharedOrder;
/** 晒单cell的类型 */
@property (nonatomic, assign) SharedOrderCellType sharedOrderType;

+ (CGSize)getSizeWithType:(SharedOrderCellType)type;
+ (UIEdgeInsets)getEdgeInsets;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;

@end
