//
//  ShopMallTableCell.h
//  GJieGo
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ShopMallTableCell : BaseTableViewCell
/*背景图*/
@property (nonatomic, strong)UIImageView *backImageView;
/*店铺名称*/
@property (nonatomic, strong)UILabel *nameLabel;
/*店铺业态类型*/
//@property (nonatomic, strong)UILabel *addressLabel;
/*位置几层*/
@property (nonatomic, strong)UILabel *floorAddressLabel;
/*收藏数量*/
@property (nonatomic, strong)UILabel *strowLabel;
@end
