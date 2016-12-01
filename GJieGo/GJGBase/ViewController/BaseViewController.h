//
//  BaseViewController.h
//  GJieGo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetService.h"
#import "PrefixHeader.pch"
#import "AppMacro.h"
#import "HomeApis.h"
#import "NotificationMacro.h"
#import "UtilsMacro.h"
#import "VendorMacro.h"
#import "Masonry.h"
#import "BaseTableView.h"
#import "BaseView.h"
#import "BaseTableViewCell.h"
#import "SGAlertUtil.h"
#import <MJRefresh.h>
#import "UIView+frameExtension.h"
#import "LBRequestManager.h"
#import "MBProgressHUD+Add.h"
#import "GJGLocationManager.h"
#import "LBRequestManager.h"
#import "GJGStatisticManager.h"
#import "MBProgressHUD.h"
#import "JXViewManager.h"

@interface BaseViewController : UIViewController
{
    AFNetWorkRequest__ *request;
}
@property (nonatomic, strong)AFNetWorkRequest__ *request;
/*判断字符串类型的字段为空*/
- (BOOL) isBlankString:(NSString *)string;
/*判断字典类型的字段为空*/
- (BOOL) isBlankDictionary:(NSDictionary *)dic;
/*判断数组类型的字段为空*/
- (BOOL) isBlankArray:(NSArray *)array;
/*Distance由float类型转换成string类型*/
- (NSString *)changeDistanceClass:(NSString *)distance;
//- (id)requestPostTypeWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters;
@end
