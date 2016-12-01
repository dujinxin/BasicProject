//
//  BaseViewController.m
//  GJieGo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize request = _request;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self back];
    request = [[AFNetWorkRequest__ alloc] init];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          GJGRGB16Color(0x333333),NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:17.0f],NSFontAttributeName,
                          nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

-(void)back
{
    UIBarButtonItem *btn_back = [[UIBarButtonItem alloc]init];
    btn_back.title = @"";
    self.navigationItem.backBarButtonItem = btn_back;
    
    self.navigationController.navigationBar.barTintColor = GJGRGB16Color(0xfee330);
    UIImage *img = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorImage = img;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = img;
}

- (NSString *)changeDistanceClass:(NSString *)distance{
    if ([distance isKindOfClass:[NSString class]]) {
        return distance;
    }else{
        return [NSString stringWithFormat:@"%.f", [distance floatValue]];
    }
//    return distance;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (BOOL) isBlankDictionary:(NSDictionary *)dic {
    if (dic == nil || dic == NULL) {
        return YES;
    }
    if ([dic isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (BOOL) isBlankArray:(NSArray *)array {
    if (array == nil || array == NULL) {
        return YES;
    }
    if ([array isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (array.count == 0) {
        return YES;
    }
    return NO;
}
@end
