//
//  FreshFoodCollectionCell.h
//  GJieGo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreshFoodCollectionCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *tradeImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *originalPriceLabel;
@property (nonatomic, strong)UILabel *currentPriceLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@end
