//
//  ShopingCenterDetailTopView.h
//  GJieGo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseView.h"

@interface ShopingCenterDetailTopView : BaseView
@property (nonatomic, strong) UILabel *timeInfoLabel;
- (id)initWithFrame:(CGRect)frame backImageName:(NSString *)imageName businessName:(NSString *)businessName subName:(NSString *)subName time:(NSString *)time;
@end
