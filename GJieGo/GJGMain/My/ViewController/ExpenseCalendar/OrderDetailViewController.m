//
//  OrderDetailViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderStoreView.h"
#import "OrderContentView.h"
#import "OrderGuiderView.h"

@interface OrderDetailViewController ()<UIActionSheetDelegate>{
    OrderStoreView    *   _storeView;
    OrderContentView  *   _contentView;
    OrderGuiderView   *   _guiderView;
    
    UILabel           *   _surplusTimeLabel;
    UIButton          *   _payButton;
    
    OrderDetailEntity *   orderEntity;
}

@end

@implementation OrderDetailViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
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
    [self showLoadView];
    [[UserRequest shareManager] userOrderDetail:kApiUserOrderDetail param:@{@"Oid":self.orderId} success:^(id object,NSString *msg) {
        [self hideLoadView];
        [self setOrderEntity:(OrderDetailEntity *)object];
        
    } failure:^(id object,NSString *msg) {
        [self hideLoadView];
    }];
    
    //[_storeView setStoreName:@"onlyAPM店"];
    NSInteger i = 4;
    if (i ==4){
        [_payButton setHidden:NO];
        [_surplusTimeLabel setHidden:NO];
        [self setSurplusTime:60*60*24*3];
    }else{
        [_payButton setHidden:YES];
        [_surplusTimeLabel setHidden:YES];
    }
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"消费记录";
    
    _storeView = [OrderStoreView new];
    _contentView = [OrderContentView new];
    [_contentView setGuiderViewHidden:YES];
    
    _guiderView = [[OrderGuiderView alloc] initWithStyle:OrderGuiderStyleSubtitle];
    _surplusTimeLabel = [UILabel new];
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self setSubView];
    
    [self.view addSubview:_storeView];
    [self.view addSubview:_contentView];
    [self.view addSubview:_guiderView];
    [self.view addSubview:_surplusTimeLabel];
    [self.view addSubview:_payButton];
    
    [self layoutSubView];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 30.5, 5, 9)];
    [arrow setImage:JXImageNamed(@"list_arrow")];
    [_guiderView addSubview:arrow];
}
- (void)setSubView{
    JXWeakSelf(self);
    __unsafe_unretained OrderDetailEntity * entity = orderEntity;
    [_storeView setClickEvents:^(id object) {
//        FilmClassController *controller = [[FilmClassController alloc] init];
//        controller.title = entity.ShopName;
//        controller.shopId = entity.ShopID;
//        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    [_guiderView setClickEvents:^(id object) {
//        GuideHomeViewController *home = [[GuideHomeViewController alloc] init];
//        home.gid = entity.GuideID.integerValue;
//        home.statisticChatOfHome = ID_0201080180003;
//        [weakSelf.navigationController pushViewController:home animated:YES];
    }];
    
    _surplusTimeLabel.text = @"剩余支付时间：59min59s";
    _surplusTimeLabel.textColor = JX999999Color;
    _surplusTimeLabel.font = JXFontForNormal(11);
    _surplusTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    [_payButton setTitle:@"支付" forState:UIControlStateNormal];
    [_payButton setTitleColor:JX333333Color forState:UIControlStateNormal];
    [_payButton setBackgroundColor:JXMainColor];
    _payButton.layer.cornerRadius = 10.f;
    [_payButton addTarget:self action:@selector(PayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)layoutSubView{
    [_storeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(_storeView.bottom).offset(5);
        make.height.equalTo(107);
    }];
    [_guiderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(_contentView.bottom).offset(5);
        make.height.equalTo(70);
    }];
    [_payButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(_guiderView.bottom).offset(141);
        make.height.equalTo(44);
    }];
    [_surplusTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(_payButton.top).offset(-10);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(11);
    }];
    
}
- (void)setOrderEntity:(OrderDetailEntity *)entity{
    orderEntity = (OrderDetailEntity *)entity;
    _storeView.nameLabel.text = orderEntity.ShopName;
    [_storeView setStoreName:orderEntity.ShopName];
    _storeView.detailLabel.text = orderEntity.State;
    
    _contentView.orderTimeLabel.text = [NSString stringWithFormat:@"消费时间：%@",orderEntity.PayDate];
    _contentView.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",orderEntity.OrderNumber];
    [_contentView.orderImageView sd_setImageWithURL:[NSURL URLWithString:@""]placeholderImage:JXImageNamed(@"default_portrait_less")];
    _contentView.orderMoneyLabel.text = [NSString stringWithFormat:@"￥%@",orderEntity.Cost];
    _contentView.VIPDiscountLabel.text = [NSString stringWithFormat:@"节省：会员折上扣-%@",orderEntity.Discount];
    _contentView.couponDiscountLabel.text = [NSString stringWithFormat:@"优惠券抵扣-%@",nil];
    
    _guiderView.nameLabel.text = orderEntity.GuideName;
    _guiderView.detailLabel.text = orderEntity.FollowNumber;
    [_guiderView.userImageView sd_setImageWithURL:[NSURL URLWithString:orderEntity.GuideImage]placeholderImage:JXImageNamed(@"portrait_default")];

}
- (void)setSurplusTime:(NSInteger)timeNum{
    __block NSInteger timeout = timeNum -1; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _surplusTimeLabel.text = [NSString stringWithFormat:@"剩余支付时间：%@min%@s",@"0",@"0"];
            });
        }else{
            NSInteger day     = (timeout /(60 *60 *24)) % 365;
            NSInteger hour    = (timeout /(60 *60))     % 24;
            NSInteger minutes = (timeout /60)           % 60;
            int seconds = timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
                if (day >0) {
                    _surplusTimeLabel.text = [NSString stringWithFormat:@"剩余支付时间：%ldd%ldh%ldmin%ds",day,hour,minutes,seconds];
                    return ;
                }
                if (hour >0) {
                    _surplusTimeLabel.text = [NSString stringWithFormat:@"剩余支付时间：%ldh%ldmin%ds",hour,minutes,seconds];
                    return;
                }
                if (minutes >0) {
                    _surplusTimeLabel.text = [NSString stringWithFormat:@"剩余支付时间：%ldmin%ds",minutes,seconds];
                    return;
                }
                if (seconds >0) {
                    _surplusTimeLabel.text = [NSString stringWithFormat:@"剩余支付时间：%ds",seconds];
                    return;
                }
//                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - click events
- (void)PayButtonClick:(UIButton *)button{
    if (kIOS_VERSION >= 8) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * pictureAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //支付宝
            
        }];
        UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //微信
            
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:pictureAction];
        [alertVC addAction:cameraAction];
        [alertVC addAction:cancelAction];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        //        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        //        UIFont *font = [UIFont systemFontOfSize:15];
        //        [appearanceLabel setAppearanceFont:font];
        [pictureAction setValue:JXTextColor forKey:@"_titleTextColor"];
        [cameraAction setValue:JXTextColor forKey:@"_titleTextColor"];
        [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }else{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"支付宝支付",@"微信支付", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tintColor = JXTextColor;//不起作用
        [actionSheet showInView:self.view];
        //注意整个工程的view 都会被修改
        // [[UIView appearance] setTintColor:JXTextColor];
    }
}

#pragma mark –-------------------------UIActionSheetDelegate
// iOS8.0之前可用
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *view in actionSheet.subviews) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:JXTextColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //支付宝
        
    }
    if (buttonIndex == 1) {
        //微信
        
    }
    
}
@end
