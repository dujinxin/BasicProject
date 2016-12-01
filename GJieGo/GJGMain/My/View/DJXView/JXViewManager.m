//
//  JXViewManager.m
//  JXView
//
//  Created by dujinxin on 15-5-25.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "JXViewManager.h"

//#import "StoreListViewController.h"
//#import "CityListViewController.h"


@interface JXViewManager (){
    UIWindow * _bgWindow;
}

@property (nonatomic, strong)UIWindow * bgWindow;

@end

@implementation JXViewManager


#define Tag_appStartImageView 1314521

static UIWindow * startImageWindow = nil;


static JXViewManager * manager;
+ (JXViewManager *)sharedInstance{
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(UIWindow *)bgWindow{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgWindow.backgroundColor = [UIColor clearColor];
        _bgWindow.windowLevel = UIWindowLevelStatusBar + 1;
        _bgWindow.hidden = NO;
    }
    return _bgWindow;
}
#pragma mark - JXNoticeViewMessage
- (void)showJXNoticeMessage:(NSString *)message{
    [self showJXNoticeMessage:message completion:nil];
}
- (void)showJXNoticeMessage:(NSString *)message completion:(completionHandler)completion{
    if ([message isKindOfClass:[NSNull class]]) {
        return;
    }
    if (nil ==message || message.length ==0){
        return;
    }
    JXNoticeView * notice = [[JXNoticeView alloc] initWithText:message];
    notice.noticeViewPosition = JXNoticeViewShowPositionMiddle;
    notice.noticeViewDuration = 2;
    [notice showInView:[[[UIApplication sharedApplication]delegate]window] animate:YES];
}
#pragma mark - JXAlertViewMessage
- (void)showJXAlertMessage:(NSString *)message{
    [self showJXAlertMessage:message title:nil];
}
- (void)showJXAlertMessage:(NSString *)message title:(NSString *)title{
    [self showJXAlertMessage:message title:title delegate:nil];
}
- (void)showJXAlertMessage:(NSString *)message title:(NSString *)title delegate:(id<JXAlertViewDelegate>)delegate{
    NSString * titleStr = title? title:@"提示";
    JXAlertView * alert = [[JXAlertView alloc] initWithTitle:titleStr message:message target:delegate buttonTitles:@[@"取消",@"确定"]];
    [alert showInView:[[[UIApplication sharedApplication]delegate]window] animate:YES];
}
/*
 *@param UIAlertView
 */
#pragma mark - UIAlertView
- (void)showAlertMessage:(NSString *)message{
    [self showAlertMessage:message title:nil];
}
- (void)showAlertMessage:(NSString *)message title:(NSString *)title{
    [self showAlertMessage:message title:title delegate:nil];
}
- (void)showAlertMessage:(NSString *)message title:(NSString *)title delegate:(id<UIAlertViewDelegate>)delegate{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}
#pragma mark - JXGuideViewImages
- (void)showJXGuideImages:(NSArray *)images{
    [self showJXGuideImages:images delegate:nil];
}
- (void)showJXGuideImages:(NSArray *)images delegate:(id<JXGuideViewDelegate>)delegate{
    JXGuideView * guide = [[JXGuideView alloc]initWithFrame:[UIScreen mainScreen].bounds imageArray:images];
    guide.delegate = delegate;
    [guide show:YES];
}
- (void)showJXGuideImages:(NSArray *)images completion:(completionHandler)completion{
    JXGuideView * guide = [[JXGuideView alloc]initWithFrame:[UIScreen mainScreen].bounds imageArray:images];
    guide.completion = ^(id object){
        if (completion) {
            completion(nil);
        }
    };
    [guide show:YES];
}
#pragma mark - JXStoreOrCityList

- (void)showViewController:(UIViewController *)vc{
    [self showViewController:vc delegate:nil];
}
- (void)showViewController:(UIViewController *)vc delegate:(id)delegate{
    self.bgWindow.rootViewController = vc;
}
- (void)showViewController:(UIViewController *)vc completion:(void(^)(id object))completion{
    
    self.bgWindow.rootViewController = vc;
    //[AppDelegate appDelegate].window.rootViewController = vc;
    if (completion) {
        _completion = completion ;
    }
}
- (void)showWindowRootViewController:(UIViewController *)vc completion:(void(^)(id object))completion{
    self.bgWindow = [[[UIApplication sharedApplication]delegate]window];
    self.bgWindow.rootViewController = vc;
}
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void(^)(id object))completion{
    
    if (completion) {
        _completion = completion ;
    }
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            [vc.view setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -kScreenHeight)];
        } completion:^(BOOL finished) {
            self.bgWindow.rootViewController = vc;
        }];
    }else{
        self.bgWindow.rootViewController = vc;
    }
}
- (void)popViewController:(BOOL)animated
{
    UINavigationController * nlvc = (UINavigationController *)[self.bgWindow rootViewController];
    if (nlvc) {
        if (_completion) {
            self.completion(nil);
        }
        if (animated) {

            [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
                [nlvc.view setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, kScreenWidth, 0)];
            } completion:^(BOOL finished) {
                [[JXViewManager sharedInstance] clear];
            }];
        }else
        {
            [[JXViewManager sharedInstance] clear];
        }
    }else{
        [[JXViewManager sharedInstance] clear];
    }
}
- (void)dismissViewController:(BOOL)animated
{
    UINavigationController * nlvc = (UINavigationController *)[self.bgWindow rootViewController];
    if (nlvc) {
        if (_completion) {
            self.completion(nil);
        }
        if (animated) {
            
            [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
                [nlvc.view setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, kScreenHeight)];
            } completion:^(BOOL finished) {
                [[JXViewManager sharedInstance] clear];
            }];
        }else
        {
            [[JXViewManager sharedInstance] clear];
        }
    }else{
        [[JXViewManager sharedInstance] clear];
    }
}
- (void)dismissViewController:(BOOL)animated resetRootViewController:(BOOL)yesOrNo{
    if (_bgWindow && animated) {
        UINavigationController * nlvc = (UINavigationController *)[self.bgWindow rootViewController];
        if (nlvc) {
            if (animated) {
                [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
                    [nlvc.view setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, kScreenHeight)];
                } completion:^(BOOL finished) {}];
            }
        }
    }
    
    if (yesOrNo) {
        //_tabBarController = [[BaseTabBarController alloc] init];
        //[UIApplication sharedApplication].keyWindow.rootViewController = _tabBarController;
        AppDelegate * appDelegate = [AppDelegate appDelegate];
        appDelegate.tabBarController = [[BaseTabBarController alloc] init];
        appDelegate.tabBarController.delegate = appDelegate;
        appDelegate.window.rootViewController = appDelegate.tabBarController;
    }
}
- (void)clear
{
    UINavigationController * nlvc = (UINavigationController *)[self.bgWindow rootViewController];
    if (nlvc) {
        nlvc = nil;
    }
    _bgWindow.rootViewController = nil;
    _bgWindow = nil;
}














+ (void)show{
    if (startImageWindow == nil) {
        startImageWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        startImageWindow.backgroundColor = [UIColor clearColor];
        startImageWindow.windowLevel = UIWindowLevelStatusBar + 1; //必须加1
        startImageWindow.rootViewController = [[SYAppStartViewController alloc] init];
        startImageWindow.hidden = NO;
    }
    UIImageView *imageView;
    imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSString * imageName;
    if (iPhone5) {
        imageName = @"LaunchImage-700-568h";
    }else if (iPhone6) {
        imageName = @"LaunchImage-800-667h";
    }else if (iPhone6Plus) {
        imageName = @"LaunchImage-800-Portrait-736h";
    }else {
        imageName = @"LaunchImage-700";
    }
    UIImage * image = JXImageNamed(imageName);
    [imageView setImage:image];
    imageView.tag = Tag_appStartImageView;
    imageView.userInteractionEnabled = NO;
    imageView.backgroundColor = [UIColor clearColor];
    [startImageWindow.rootViewController.view addSubview:imageView];
    [startImageWindow setHidden:NO];
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [DJXRequest requestWithBlock:kRequestUrl(kLanuchImage) param:nil success:^(id object) {
//            NSLog(@"kLanuchImage-success:%@",object);
//            if ([object isKindOfClass:[NSArray class]]) {
//                NSArray * array = (NSArray *)object;
//                if (array && array.count) {
//                    NSDictionary * dict = [array lastObject];
//                    [imageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photo"]] placeholderImage:image];
//                    [[JXViewManager sharedInstance] performSelector:@selector(hide:) withObject:nil afterDelay:[[dict objectForKey:@"show_time"] floatValue]];
//                }else{
//                    [[JXViewManager sharedInstance] hide:NO];
//                }
//            }else{
//                [[JXViewManager sharedInstance] hide:NO];
//            }
//        } failure:^(id object) {
//            [[JXViewManager sharedInstance] hide:NO];
//        }];
//                          
//    });
    
        
        
    
}
+ (void)show:(UIImage *)imageUrl
{
    if (startImageWindow == nil) {
        startImageWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        startImageWindow.backgroundColor = [UIColor clearColor];
        startImageWindow.userInteractionEnabled = NO;
        startImageWindow.windowLevel = UIWindowLevelStatusBar + 1; //必须加1
        
    }
    
}
- (void)hide:(BOOL)animated
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView];
    if (imageView) {
        if (animated) {
            [UIView animateWithDuration:1.5 delay:0 options:0 animations:^{
                [imageView setTransform:CGAffineTransformMakeScale(2, 2)];
                [imageView setAlpha:0];
            } completion:^(BOOL finished) {
                [JXViewManager clear];
            }];
        }else
        {
            [JXViewManager clear];
        }
    }
}
+ (void)hide:(BOOL)animated
{
    UINavigationController * nlvc = (UINavigationController *)[startImageWindow rootViewController];
    if (nlvc) {
        if (animated) {
            [UIView animateWithDuration:1.5 delay:0 options:0 animations:^{
                [nlvc.view setTransform:CGAffineTransformMakeScale(2, 2)];
                [nlvc.view setAlpha:0];
            } completion:^(BOOL finished) {
                [JXViewManager clear];
            }];
        }else
        {
            [JXViewManager clear];
        }
    }
}

+ (void)hideWithCustomBlock:(void (^)(UIImageView *))block
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView];
    if (imageView) {
        if (block) {
            block(imageView);
        }
    }
}

+ (void)clear
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView];
    [imageView removeFromSuperview];
    imageView = nil;
    UINavigationController * nlvc = (UINavigationController *)[startImageWindow rootViewController];
    if (nlvc) {
        nlvc = nil;
    }
    startImageWindow.rootViewController = nil;
    [startImageWindow removeFromSuperview];
    startImageWindow = nil;
}




@end


@implementation SYAppStartViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
