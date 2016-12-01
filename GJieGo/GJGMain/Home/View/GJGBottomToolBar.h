//
//  GJGBottomToolBar.h
//  GJieGo
//
//  Created by liubei on 16/5/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GJGBottomToolBarDelegate <NSObject>
 @optional
- (void)bottomToolBarDidSelected:(NSInteger)index title:(NSString *)title;
@end

@interface GJGBottomToolBar : UIView
+ (instancetype)bottomToolBarWithTitles:(NSArray *)titles imgs:(NSArray *)imgs hightLightImgs:(NSArray *)imgs;
@property (nonatomic, weak) id<GJGBottomToolBarDelegate> delegate;
/** subButtons */
@property (nonatomic, strong) NSMutableArray<UIButton *> *btns;
@end
