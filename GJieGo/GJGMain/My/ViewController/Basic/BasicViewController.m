//
//  BasicViewController.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()<UIGestureRecognizerDelegate>{
    UITapGestureRecognizer * _tapGestureRecognizer;
    UIBarButtonItem        * _backBarButtonItem;
}
@property (nonatomic, strong)UITapGestureRecognizer * tapGestureRecognizer;

@end
@implementation BasicViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    
}
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = JXF1f1f1Color;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = JXMainColor;//导航栏颜色
    self.navigationController.navigationBar.tintColor = JX333333Color;//按钮文字颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //self.navigationItem.backBarButtonItem = getBackItem(self,@selector(back:));
    self.navigationController.navigationBar.backIndicatorImage = [JXImageNamed(@"back") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [JXImageNamed(@"back") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    //self.navigationItem.backBarButtonItem.title = @"";
    [self setBackBarButtonItemTitle:@""];
    //[self initBasicBgView];
    //self.pageType = PageTypeNone;
}
#pragma mark - NavigationItem
/*
 * NavigationItem
 */
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector title:(NSString *)title style:(kNavigationItemStyle)style{
    return [self getNavigationItem:delegate selector:selector title:title image:nil style:style];
}
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector image:(UIImage *)image style:(kNavigationItemStyle)style{
    return [self getNavigationItem:delegate selector:selector title:nil image:image style:style];
}
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector title:(NSString *)title image:(UIImage *)image style:(kNavigationItemStyle)style{
    UIButton *superBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    superBtn.frame = CGRectMake(0, 0, 30, 30);
    if (image) {
        [superBtn setImage:image forState:UIControlStateNormal];
    }
    if (title) {
        superBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
        CGRect rect = [title boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
        superBtn.frame = CGRectMake(0, 0, rect.size.width +4, 44);
        [superBtn setTitleColor:JX333333Color forState:UIControlStateNormal];
        [superBtn setTitle:title forState:UIControlStateNormal];
        //superBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        if(style == kDoubleLineWords){
            superBtn.frame = CGRectMake(0, 0, 30, 30);
            superBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            superBtn.titleLabel.numberOfLines = 2;
        }
    }
    [superBtn addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:superBtn];
    
    return barButtonItem;
}
- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector title:(NSString *)title style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    return [self getNavigationItems:delegate selector:selector title:title image:nil style:style isLeft:isLeft];
}
- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    return [self getNavigationItems:delegate selector:selector title:nil image:image style:style isLeft:isLeft];
}

- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector title:(NSString *)title image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft{
    UIButton *superBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    superBtn.frame = CGRectMake(0, 0, 30, 30);
    //    superBtn.backgroundColor = [UIColor purpleColor];
    [superBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [superBtn addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    if (style) {
        self.navigationItemStyle = style;
    }else{
        self.navigationItemStyle = kDefault;
    }
    switch (self.navigationItemStyle) {
        case kDefault:
        {
            if (title) {
                superBtn.frame = CGRectMake(0, 0, 52, 44);
                [superBtn setTitle:title forState:UIControlStateNormal];
            }
            if (image) {
                superBtn.frame = CGRectMake(0, 0, 30, 30);
                [superBtn setImage:image forState:UIControlStateNormal];
            }
            
        }
            break;
        case kSingleLineWords:
        {
            superBtn.frame = CGRectMake(0, 0, 52, 44);
            [superBtn setTitle:title forState:UIControlStateNormal];
        }
            break;
        case kSingleImage:
        {
            [superBtn setImage:image forState:UIControlStateNormal];
        }
            break;
        case kDoubleLineWords:
        {
            superBtn.frame = CGRectMake(0, 0, 30, 30);
            [superBtn setTitle:title forState:UIControlStateNormal];
            superBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            superBtn.titleLabel.numberOfLines = 2;
        }
            break;
        case kDoubleImages:
        {
            
        }
            break;
        case kImage_textWithLeftImage:
        {
            superBtn.frame = CGRectMake(0, 0, 60, 30);
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            imageView.image = image;
            
            UIButton * titleView = [UIButton buttonWithType:UIButtonTypeCustom];
            titleView.frame = CGRectMake(30, 0, 30, 30);
            [titleView setTitle:title forState:UIControlStateNormal];
            //        [leftBtn setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
            titleView.titleLabel.font = [UIFont systemFontOfSize:11];
            titleView.titleLabel.numberOfLines = 2;
            [titleView setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            [superBtn addSubview:imageView];
            [superBtn addSubview:titleView];
        }
            break;
        case kImage_textWithLeftWord:
        {
            
        }
            break;
            
        default:
            break;
    }
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:superBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /****** 消除间距 ********
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    if (title) {
        if (kIOS_VERSION >= 7) {
            negativeSpacer.width = -10;
        }else{
            negativeSpacer.width = -5;
        }
    }
    NSMutableArray *buttonArray;
    if (isLeft) {
        buttonArray= [NSMutableArray arrayWithObjects:negativeSpacer,barButtonItem, nil];
    }else{
        //        buttonArray= [NSMutableArray arrayWithObjects:barButtonItem,negativeSpacer, nil];
        buttonArray= [NSMutableArray arrayWithObjects:negativeSpacer,barButtonItem, nil];
    }
    
    
    return buttonArray;
}

/*
 *custom NavigationBar
 */
-(UIView *)setNavigationBar:(NSString *)title backgroundColor:(UIColor *)backgroundColor leftItem:(UIView *)leftItem rightItem:(UIView *)rightItem delegete:(id)delegate{
    UIView * navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navigationBar.backgroundColor = JXClearColor;
    
    self.navigationBarBackgroundView = [UIView new];
    self.navigationBarBackgroundView.frame = navigationBar.bounds;
    self.navigationBarBackgroundView.tag = 10;
    self.navigationBarBackgroundView.backgroundColor = backgroundColor;
    [navigationBar addSubview:self.navigationBarBackgroundView];
    
    self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, kScreenWidth -120, 44)];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.text = title;
    self.titleView.textColor = JXFfffffColor;
    self.titleView.font = JXFontForNormal(17);
    self.titleView.tag = 11;
    self.titleView.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:self.titleView];
    //titleLabel.center = CGPointMake(SCREEN_WIDTH /2,  );
    
    if ([leftItem isKindOfClass:[UIButton class]]) {
        leftItem.frame = CGRectMake(10, 20, 30, 44);
        UIButton * btn = (UIButton *)leftItem;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navigationBar addSubview:leftItem];
    }
    if ([rightItem isKindOfClass:[UIButton class]]) {
        rightItem.frame = CGRectMake(kScreenWidth - 40, 20, 30, 44);
        UIButton * btn = (UIButton *)rightItem;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navigationBar addSubview:rightItem];
    }
    
    
    return navigationBar;
}
#pragma mark - LoadView and Notice,Alert
/*
 *@param MBProgressHUD
 */
- (void)showLoadView{
    [self showLoadView:nil];
}
- (void)showLoadView:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = JXLocalizedString(@"Loading");
}
- (void)hideLoadView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
/*
 *@param Toast
 */
- (void)showNoticeMessage:(NSString *)message{
    
}
/*
 *@param UIAlertView
 */
- (void)showAlertMessage:(NSString *)message{
    [[JXViewManager sharedInstance] showAlertMessage:message title:@"提示"];
}
/*
 *@param JXNoticeView
 */
- (void)showJXNoticeMessage:(NSString *)message{
    [[JXViewManager sharedInstance] showJXNoticeMessage:message];
}
/*
 *@param JXAlertView
 */
- (void)showJXAlertMessage:(NSString *)message{
    [[JXViewManager sharedInstance] showJXAlertMessage:message title:@"提示"];
}
- (void)initBasicBgView{
    [self.view addSubview:self.basicBgView];
    [self.basicBgView addSubview:self.basicImageView];
    [self.basicBgView addSubview:self.basicLabelView];
    [self setPageType:PageTypeNone];
}
- (void)basicBgViewEvent:(id)object{
    NSLog(@"basicBgViewEvent: = %@",object);
    [self requestData];
}
#pragma mark - Click events
//- (void)back:(UIButton *)button{
//    [self backItemClick:button];
//}
#pragma mark - subviewController overwrite
- (void)setBackBarButtonItemTitle:(NSString *)title{
    if (title) {
        if (!_backBarButtonItem) {
            _backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
        }
        _backBarButtonItem.title = title;
        self.navigationItem.backBarButtonItem = _backBarButtonItem;
    }
}
- (void)backItemClick:(UIButton *)button{
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)reloadData{}
- (void)requestData{}
- (void)requestWithPage:(NSUInteger)page{}
#pragma mark -
- (void)setPageType:(PageType)pageType{
    [self setPageType:pageType image:nil content:nil];
}
- (void)setPageType:(PageType)pageType image:(NSString *)imageStr content:(NSString *)contentStr{
    _pageType = pageType;
    switch (_pageType) {
        case PageTypeNone:
        {
            [self.basicBgView setHidden:YES];
            [self.basicBgView removeGestureRecognizer:self.tapGestureRecognizer];
            [self.basicImageView setImage:nil];
            [self.basicLabelView setText:nil];
        }
            break;
        case PageTypeNetworkLost:
        {
            [self.basicBgView setHidden:NO];
            [self.basicBgView addGestureRecognizer:self.tapGestureRecognizer];
            [self.basicImageView setImage:JXImageNamed(@"null_network")];
            [self.basicLabelView setText:@"请检查网络后，重试~~~"];
        }
            break;
        case PageTypeDataEmpty:
        {
            [self.basicBgView setHidden:NO];
            [self.basicBgView addGestureRecognizer:self.tapGestureRecognizer];
            [self.basicImageView setImage:JXImageNamed(imageStr)];
            [self.basicLabelView setText:contentStr];
        }
            break;
            
        default:{
            [self.basicBgView setHidden:YES];
            [self.basicBgView removeGestureRecognizer:self.tapGestureRecognizer];
            [self.basicImageView setImage:nil];
            [self.basicLabelView setText:nil];
        }
            break;
    }
}

#pragma mark - subView init
- (UIView *)basicBgView{
    if (!_basicBgView) {
        _basicBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _basicBgView.backgroundColor = [UIColor redColor];
        [_basicBgView addGestureRecognizer:self.tapGestureRecognizer];
    }
    return _basicBgView;
}
- (UIImageView *)basicImageView{
    if (!_basicImageView) {
        _basicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160*kPercent, 160*kPercent)];
        _basicImageView.backgroundColor = [UIColor yellowColor];
        _basicImageView.center = self.basicBgView.center;
        _basicImageView.userInteractionEnabled = YES;
    }
    return _basicImageView;
}
- (UILabel *)basicLabelView{
    if (!_basicLabelView) {
        _basicLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        CGPoint point = _basicImageView.center;
        _basicLabelView.center = CGPointMake(point.x, point.y + _basicImageView.frame.size.height /2 + 40);
        _basicLabelView.backgroundColor = [UIColor greenColor];
        _basicLabelView.numberOfLines = 0;
        _basicLabelView.textAlignment = NSTextAlignmentCenter;
        
    }
    return _basicLabelView;
}

- (UITapGestureRecognizer *)tapGestureRecognizer{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(basicBgViewEvent:)];
    }
    return _tapGestureRecognizer;
}
@end
