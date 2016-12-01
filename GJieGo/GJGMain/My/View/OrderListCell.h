//
//  OrderListCell.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderStoreView.h"
#import "OrderContentView.h"

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *contentBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;

@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *VIPDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDiscountLabel;

@property (weak, nonatomic) IBOutlet UILabel *guiderLabel;

@property (strong, nonatomic) OrderStoreView    * orderStoreView;
@property (strong, nonatomic) OrderContentView  * orderContentView;

- (IBAction)enterStore:(id)sender;

- (void)setOrderListCell:(id)entity indexPath:(NSIndexPath *)indexPath;
@end
