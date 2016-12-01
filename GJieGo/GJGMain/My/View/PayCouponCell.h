//
//  PayCouponCell.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedBlock)(NSInteger selectedRow);

typedef NS_ENUM(NSInteger ,MyCouponType) {
    MyCouponUsableType    = 1,  //可用优惠券
    MyCouponListType,           //优惠券列表
    MyCouponDetailType          //优惠券详情
};

@interface PayCouponCell : UITableViewCell

@property (nonatomic, assign ,readwrite) MyCouponType  type;
@property (nonatomic, strong ,readwrite) NSIndexPath * indexPath;
@property (nonatomic, copy, readwrite )  selectedBlock block;

@property (nonatomic, strong ,readwrite) UIImageView * bgImageView;
@property (nonatomic, strong ,readwrite) UILabel     * moneyLabel;
@property (nonatomic, strong ,readwrite) UILabel     * styleLabel;
@property (nonatomic, strong ,readwrite) UILabel     * nameLabel;
@property (nonatomic, strong ,readwrite) UILabel     * numberLabel;
@property (nonatomic, strong ,readwrite) UILabel     * limitLabel;
@property (nonatomic, strong ,readwrite) UILabel     * dateLabel;
@property (nonatomic, strong ,readwrite) UIButton    * selectButton;

- (void)setCouponContent:(id)object indexPath:(NSIndexPath *)indexPath;
- (void)setCouponContent:(id)object indexPath:(NSIndexPath *)indexPath selectedRow:(NSInteger)selectRow selectedBlock:(selectedBlock)block;

@end
