//
//  ShopGuideTableViewCell.h
//  Radar
//
//  Created by liubei on 16/4/27.
//  Copyright © 2016年 ABCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBGuideInfoM.h"

typedef enum {
    
    ShopGuideCellTypeIsMain = 0,
    ShopGuideCellTypeIsDetail = 1,
    ShopGuideCellTypeIsGuideHome = 2,
    ShopGuideCellTypeIsSharedOrderDetail = 3,
    ShopGuideCellTypeIsInMy = 4,
    ShopGuideCellTypeIsInBusinessArea
    
}ShopGuideCellType;

@interface ShopGuideTableViewCell : UITableViewCell

/** Cell 类型 ,shopGuide->没有右下角定位按钮, detail->有右下角定位按钮 */
@property (nonatomic, assign) ShopGuideCellType type;
//@property (nonatomic, assign) CGFloat cellHeight;
/*
 *  一定要先设置cell的类型，再给cell传递数据
 */
/** Cell数据源 */
@property (nonatomic, strong) LBGuideInfoM *guideInfo;
/*
 *  假数据入口, 将要废弃
 */
- (void)setSomeOne:(NSInteger)imgCount;
@end
