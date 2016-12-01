//
//  IntroductionViewController.h
//  GJieGo
//
//  Created by dujinxin on 16/5/30.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicViewController.h"

typedef NS_ENUM(NSInteger ,IntroductionType) {
    IntroductionPrivateType,
    IntroductionCompanyType,
    IntroductionTeamType,
    IntroductionOrderType
};

@interface IntroductionViewController : BasicViewController
@property (nonatomic ,copy) NSString * titleStr;
@property (nonatomic ,copy) NSString * textStr;
@property (nonatomic ,assign)IntroductionType type;
@end
