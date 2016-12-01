//
//  SharedOrderInSearchCollectionViewCell.h
//  GJieGo
//
//  Created by liubei on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSharedOrderM.h"

@interface SharedOrderInSearchCollectionViewCell : UICollectionViewCell

/** 晒单模型 */
@property (nonatomic, strong) LBSharedOrderM *sharedOrder;

+ (CGSize)getSize;
+ (UIEdgeInsets)getEdgeInsets;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;

@end
