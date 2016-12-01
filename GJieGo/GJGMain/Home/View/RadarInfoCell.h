//
//  GJGRadarInfoCell.h
//  Radar
//
//  Created by liubei on 16/4/21.
//  Copyright © 2016年 ABCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBRadarItemM;

@interface RadarInfoCell : UICollectionViewCell

typedef enum {
    
    RadarTypeIsGuide = 0,
    RadarTypeIsSharedOrder = 1
    
}RadarType;

@property (nonatomic, assign) RadarType radarType;
@property (nonatomic, strong) LBRadarItemM *radarItem;

+ (CGSize)lb_getSize;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;

@end
