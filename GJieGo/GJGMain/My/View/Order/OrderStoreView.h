//
//  OrderStoreView.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StoreViewBlock)(id object);

@interface OrderStoreView : UIView

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *infoDetalView;
@property (copy , nonatomic) StoreViewBlock clickBlock;

- (void)setClickEvents:(StoreViewBlock)block;
- (void)setStoreName:(NSString *)name;

@end
