//
//  GJGTopView.h
//  GJieGo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseView.h"
#import "MallHomeInfoModel.h"

@protocol GJGTopViewDelegate <NSObject>

- (void)clickMapButtonAction:(UIButton *)button;

@end

@interface GJGTopView : BaseView
@property (nonatomic, assign)id<GJGTopViewDelegate> delegate;

@property (nonatomic, strong)MallHomeInfoItem *mallHomeInfoItem;
@property (nonatomic, strong)ShopHomeInfoItem *shopHomeInfoItem;
- (id)initWithFrame:(CGRect)frame Height:(CGFloat)height imageName:(NSString *)imageName name:(NSString *)name subName:(NSString *)subName distance:(NSString *)distance;
@end
