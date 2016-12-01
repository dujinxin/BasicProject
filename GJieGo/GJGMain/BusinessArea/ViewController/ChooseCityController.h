//
//  ChooseCityController.h
//  GJieGo
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@protocol chooseNameDelegate <NSObject>

- (void)chooseCityName:(NSString *)cityName cityId:(NSString *)cityId;

@end

@interface ChooseCityController : BaseViewController
@property (nonatomic, strong)NSMutableArray *openedCityArray;
@property (nonatomic, assign)id<chooseNameDelegate> delegate;
@end
