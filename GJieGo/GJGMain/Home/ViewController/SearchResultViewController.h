//
//  SearchResultViewController.h
//  GJieGo
//
//  Created by liubei on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchOfMainViewController.h"
@class SearchOftenM;

typedef enum {
 
    SearchResultTypeIsShop = 1,
    SearchResultTypeIsSharedOrder = 2,
    SearchResultTypeIsOften = 3
    
}SearchResultType;

@interface SearchResultViewController : BaseViewController

@property (nonatomic, strong) NSString *searchStr;
@property (nonatomic, assign) SearchResultType viewControllerType;

@property (nonatomic, strong) NSMutableArray<SearchOftenM *> *oftens;       // 如果是常用分类, 那么用
@property (nonatomic, assign) NSInteger oftenIndex;                         // 常用搜索下标

@end
