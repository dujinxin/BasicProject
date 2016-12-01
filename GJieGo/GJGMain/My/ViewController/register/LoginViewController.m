//
//  LoginViewController.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//
//  系统名称：LoginViewController
//  功能描述：登录
//  修改记录：
//          dujx 2016-05-26 屏蔽第三方登录，增加随便逛逛

#import "LoginViewController.h"
#import "UINavigationBar+category.h"
#import "LoginTextField.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "IntroductionViewController.h"
#import "DetailWebViewController.h"

#import "UMSocial.h"
#import "ChatUtil.h"
#import "UserEntity.h"
#import <CloudPushSDK/CloudPushSDK.h>

#define loginLeading  44

typedef NS_ENUM(NSInteger, LoginViewControllerTag){
    LoginViewControllerForgetButtonTag      =    1,
    LoginViewControllerLoginButtonTag,
    LoginViewControllerRegisterButtonTag,
    LoginViewControllerGoShoppingButtonTag,
    LoginViewControllerPrivateButtonTag,
    LoginViewControllerQQButtonTag,
    LoginViewControllerWXButtonTag,

};

@interface LoginViewController ()<UITextFieldDelegate>{
    UIButton    * right;
    
    UIImageView * _bgImageView;
    LoginTextField * _userTextField;
    LoginTextField * _passwordTextField;
    UIButton    * _forgetButton;
    UIButton    * _loginButton;
    UIButton    * _registerButton;
    UIButton    * _goShoppingButton;
    
    UIButton    * _qqLoginButton;
    UIButton    * _wxLoginButton;
    
    UILabel     * _infoLeftLabel;
    UIButton    * _infoRightButton;
    
    UIImageView * _animationImageView;
    UIActivityIndicatorView * _activityView;
    
    NSString    * startupUser;
    
    NSString    * previousTextFieldContent;
    UITextRange * previousSelection;
    NSString    * mobileStr;
}

@end

@implementation LoginViewController


#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];

    [self setSubView];
    [self layoutSubView];
    
    if (![kUserDefaults stringForKey:UDKEY_IsFirstLaunch]){
        [kUserDefaults setValue:@"1" forKey:UDKEY_IsFirstLaunch];
        [kUserDefaults synchronize];
        
        [_goShoppingButton setHidden:NO];
        [right setHidden:YES];
    }else{
        if ([[kUserDefaults stringForKey:UDKEY_IsFirstLaunch] isEqualToString:@"1"]) {
            [_goShoppingButton setHidden:YES];
            [right setHidden:NO];
        }else{
            [_goShoppingButton setHidden:NO];
            [right setHidden:YES];
        }
    }
    
    [_qqLoginButton setHidden:YES];
    [_wxLoginButton setHidden:YES];
    
    if ([kUserDefaults objectForKey:UDKEY_MobileNumber] && [[kUserDefaults objectForKey:UDKEY_MobileNumber] length] ==11){
        startupUser = [kUserDefaults objectForKey:UDKEY_MobileNumber];
        if (self.logoutType == kUserLogoutForOtherDevice) {
            NSMutableArray * array = [NSMutableArray array];
            NSString * str = @"";
            
            for (int i = 0; i < 11; i++) {
                [array addObject:[startupUser substringWithRange:NSMakeRange(i, 1)]];
                str = [str stringByAppendingString:[startupUser substringWithRange:NSMakeRange(i, 1)]];
                if (i == 2 || i == 6) {
                    [array addObject:@" "];
                    str = [str stringByAppendingString:@" "];
                }
            }
            if (str.length == 13){
                _userTextField.text = str;
                _passwordTextField.text = [kUserDefaults objectForKey:UDKEY_Password];
            }
        }
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = JXLocalizedString(@"login");
    
    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _userTextField = [LoginTextField new];
    _passwordTextField = [LoginTextField new];
    _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goShoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _qqLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _infoLeftLabel = [UILabel new];
    _infoRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
}
#pragma mark - subView init
-(void)setNavigationBar{
    
    right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:JXImageNamed(@"login_close") forState:UIControlStateNormal];
    [right addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:[self setNavigationBar:@"登录" backgroundColor:[UIColor clearColor] leftItem:nil rightItem:right delegete:self]];
}
- (void)setSubView{
    _bgImageView.backgroundColor = [UIColor redColor];
    [_bgImageView setImage:JXImageNamed(@"login_bg")];
    [self.view addSubview:_bgImageView];
    
    [self setNavigationBar];
    
    _userTextField.borderStyle = UITextBorderStyleRoundedRect;
    _userTextField.leftViewMode = UITextFieldViewModeAlways;
    _userTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userTextField.returnKeyType = UIReturnKeyNext;
    _userTextField.delegate = self;
    _userTextField.leftView = ({
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 19, 24)];
        leftView.contentMode = UIViewContentModeCenter;
        [leftView setImage:JXImageNamed(@"login_input_user")];
        leftView;
    });
    _userTextField.placeholder = @"请输入手机号码";
    _userTextField.font = JXFontForNormal(13);
    [_userTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_userTextField];
    
    
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.leftView = ({
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 19, 24)];
        leftView.contentMode = UIViewContentModeCenter;
        [leftView setImage:JXImageNamed(@"login_input_Lock")];
        leftView;
    });
    _passwordTextField.rightView = ({

        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 4.75, 51, 34.5);
        [btn setTitleColor:JX333333Color forState:UIControlStateNormal];
        [btn setBackgroundImage:JXImageNamed(@"login_input_close") forState:UIControlStateNormal];
        [btn setBackgroundImage:JXImageNamed(@"login_input_open") forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5.f;
        [btn addTarget:self action:@selector(switchTextEntryStyle:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = NO;
        btn.tag = LoginViewControllerLoginButtonTag;
        btn;
    });
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.font = JXFontForNormal(13);
    [self.view addSubview:_passwordTextField];
    
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc ]initWithString:@"忘记密码?" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:JXColorFromRGB(0x666666),NSForegroundColorAttributeName:JXColorFromRGB(0x666666)}];
    [_forgetButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    _forgetButton.titleLabel.font = JXFontForNormal(13);
    [_forgetButton setBackgroundColor:JXClearColor];
    _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgetButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _forgetButton.tag = LoginViewControllerForgetButtonTag;
    [self.view addSubview:_forgetButton];
    
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:JX333333Color forState:UIControlStateNormal];
//    [_loginButton setBackgroundColor:[UIColor orangeColor]];
    [_loginButton setBackgroundImage:JXImageNamed(@"login_btn_login") forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:JXImageNamed(@"login_btn_pressed") forState:UIControlStateHighlighted];
    _loginButton.layer.cornerRadius = 5.f;
    [_loginButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _loginButton.tag = LoginViewControllerLoginButtonTag;
    [self.view addSubview:_loginButton];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityView];
    
    
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
//    [_registerButton setBackgroundColor:[UIColor orangeColor]];
    [_registerButton setBackgroundImage:JXImageNamed(@"login_btn_reg") forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:JXImageNamed(@"login_btn_reg_pre") forState:UIControlStateHighlighted];
    _registerButton.layer.cornerRadius = 5.f;
    [_registerButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _registerButton.tag = LoginViewControllerRegisterButtonTag;
    [self.view addSubview:_registerButton];
    
    NSMutableAttributedString * goShoppingStr = [[NSMutableAttributedString alloc ]initWithString:@"随便逛逛" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:JXColorFromRGB(0x666666),NSForegroundColorAttributeName:JXColorFromRGB(0x666666)}];
    [_goShoppingButton setAttributedTitle:goShoppingStr forState:UIControlStateNormal];
    _goShoppingButton.titleLabel.font = JXFontForNormal(13);
    [_goShoppingButton setBackgroundColor:JXClearColor];
    _goShoppingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_goShoppingButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _goShoppingButton.tag = LoginViewControllerGoShoppingButtonTag;
    [self.view addSubview:_goShoppingButton];
    
    
    [_qqLoginButton setTitle:@"QQ登录" forState:UIControlStateNormal];
    [_qqLoginButton setImage:JXImageNamed(@"login_icon_qq") forState:UIControlStateNormal];
    [_qqLoginButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
    _qqLoginButton.titleLabel.font = JXFontForNormal(17);
    [_qqLoginButton setBackgroundColor:[UIColor blackColor]];
    _qqLoginButton.alpha = 0.5;
    [_qqLoginButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _qqLoginButton.tag = LoginViewControllerQQButtonTag;
    [self.view addSubview:_qqLoginButton];
    
    
    [_wxLoginButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [_wxLoginButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
    [_wxLoginButton setImage:JXImageNamed(@"login_icon_weixin") forState:UIControlStateNormal];
     _wxLoginButton.titleLabel.font = JXFontForNormal(17);
    [_wxLoginButton setBackgroundColor:[UIColor blackColor]];
    _wxLoginButton.alpha = 0.5;
    [_wxLoginButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _wxLoginButton.tag = LoginViewControllerWXButtonTag;
    [self.view addSubview:_wxLoginButton];
    
    
    _infoLeftLabel.backgroundColor = JXClearColor;
    _infoLeftLabel.textAlignment = NSTextAlignmentRight;
    _infoLeftLabel.text = @"登录或者注册即同意逛街购";
    _infoLeftLabel.textColor = JX333333Color;
    _infoLeftLabel.font = JXFontForNormal(12);
    [self.view addSubview:_infoLeftLabel];
    
    [_infoRightButton setTitle:@"用户服务协议" forState:UIControlStateNormal];
    [_infoRightButton setTitleColor:JX333333Color forState:UIControlStateNormal];
    _infoRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_infoRightButton setBackgroundColor:JXClearColor];
    _infoRightButton.titleLabel.font = JXFontForBold(12);
    [_infoRightButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _infoRightButton.tag = LoginViewControllerPrivateButtonTag;
    [self.view addSubview:_infoRightButton];
    
    

    
}
- (void)layoutSubView{
    _bgImageView.frame = self.view.bounds;
    
    [_userTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(loginLeading);
        make.top.equalTo(self.view).offset(loginLeading + kNavStatusHeight);
        make.right.equalTo(self.view).offset(-loginLeading);
        make.height.equalTo(loginLeading);
    }];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userTextField.bottom).offset(10);
        make.left.equalTo(self.view).offset(loginLeading);
        make.width.equalTo(_userTextField);
        make.height.equalTo(_userTextField);
        
    }];
    [_forgetButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.bottom).offset(13);
        make.right.equalTo(self.view).offset(-loginLeading);
        make.width.equalTo(_userTextField);
        make.height.equalTo(13);
    }];
    [_loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(loginLeading);
        make.top.equalTo(_forgetButton.bottom).offset(13);
        make.width.equalTo(_userTextField);
        make.height.equalTo(_userTextField);
    }];
    [_activityView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(40);
        make.centerY.equalTo(_loginButton);
        make.width.equalTo(30);
        make.height.equalTo(30);
    }];
    [_registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.bottom).offset(10);
        make.left.equalTo(self.view).offset(loginLeading);
        make.width.equalTo(_userTextField);
        make.height.equalTo(_userTextField);
        
    }];
    [_goShoppingButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registerButton.bottom).offset(13);
        make.right.equalTo(self.view).offset(-loginLeading);
        make.width.equalTo(_userTextField);
        make.height.equalTo(13);
    }];
    
    
    [_qqLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view.bottom).offset(0);
        make.width.equalTo(kScreenWidth/2);
        make.height.equalTo(kTabBarHeight);
    }];
    [_wxLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_qqLoginButton.top).offset(0);
        make.left.equalTo(_qqLoginButton.right).offset(0);
        make.width.equalTo(_qqLoginButton);
        make.height.equalTo(_qqLoginButton);
        
    }];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-1, 12, 1, 25)];
    line.backgroundColor = JXFfffffColor;
    [_qqLoginButton addSubview:line];
    
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObject:_infoLeftLabel.font forKey:NSFontAttributeName];
    NSDictionary *attributes2 = [NSDictionary dictionaryWithObject:_infoRightButton.titleLabel.font forKey:NSFontAttributeName];
    CGRect rect1 = [_infoLeftLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes1 context:nil];
    CGRect rect2 = [_infoRightButton.currentTitle boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes2 context:nil];
    CGFloat infoLeading = (kScreenWidth -rect1.size.width -rect2.size.width-4)/2;
    [_infoLeftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(infoLeading);
        make.bottom.equalTo(_qqLoginButton.top).offset(0);
        make.width.equalTo(rect1.size.width);
        make.height.equalTo(loginLeading);
    }];
    [_infoRightButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoLeftLabel.top).offset(0);
        make.left.equalTo(_infoLeftLabel.right).offset(0);
        make.width.equalTo(rect2.size.width+4);
        make.height.equalTo(_infoLeftLabel);
        
    }];
    
}

#pragma mark - click events
- (void)cancel:(UIButton *)button{
    if (_loginCancelBlock) {
        self.loginCancelBlock(nil);
        return;
    }
    if (!_loginInfomationUnavailble){
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}
- (void)loginBtnClick:(UIButton *)button{


    switch (button.tag) {
        case LoginViewControllerForgetButtonTag:
        {
            RegisterViewController * rvc = [[RegisterViewController alloc] init];
            rvc.accountType = UserForgetPasswordType;
            //self.navigationItem.backBarButtonItem.title = JXLocalizedString(@"login");
            //[self setBackBarButtonItemTitle:JXLocalizedString(@"login")];
            [self.navigationController pushViewController:rvc animated:YES];
        }
            break;
        case LoginViewControllerLoginButtonTag:
        {
            if (![self loginValidate]) {
                return;
            }
            [_activityView startAnimating];
            [_loginButton setTitle:@"登录中" forState:UIControlStateNormal];
            //统计
            [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201080250002 andBCID:nil andMallID:nil andShopID:nil andBusinessType:nil andItemID:nil andItemText:nil andOpUserID:nil];
            [[UserRequest shareManager] userLogin:kApiUserLogin param:@{@"ua":mobileStr,@"Up":_passwordTextField.text} success:^(id object,NSString *msg) {
                NSLog(@"app用户登陆成功");
                EMError *error = [[EMClient sharedClient] loginWithUsername:[UserDBManager shareManager].HxAccount password:[UserDBManager shareManager].HxPassword];
                if (!error) {
                    NSLog(@"环信登陆成功");
                    [_activityView stopAnimating];
                    [self handleLoginSuccessResult:msg];
                }else{
                    NSLog(@"环信登陆失败，重试...");
                    if (error.code == EMErrorUserAlreadyLogin) {
                        [[EMClient sharedClient] logout:YES];
                    }
                    EMError *subError = [[EMClient sharedClient] loginWithUsername:[UserDBManager shareManager].HxAccount password:[UserDBManager shareManager].HxPassword];
                    if (!subError) {
                        NSLog(@"环信登陆成功");
                        [_activityView stopAnimating];
                        [self handleLoginSuccessResult:msg];
                    }else{
                        NSLog(@"环信登陆失败:%@",subError.errorDescription);
                        [self showJXNoticeMessage:@"登录失败"];
                        [_activityView stopAnimating];
                        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
                    }
                }
             
            } failure:^(id object,NSString *msg) {
                NSLog(@"app用户登陆失败");
                [self showJXNoticeMessage:msg];
                [_activityView stopAnimating];
                [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
            }];
            
            
        }
            break;
        case LoginViewControllerRegisterButtonTag:
        {
            RegisterViewController * rvc = [[RegisterViewController alloc] init];
            rvc.accountType = UserRegisterAccountType;
            //self.navigationItem.backBarButtonItem.title = JXLocalizedString(@"login");
            [self.navigationController pushViewController:rvc animated:YES];
        }
            break;
        case LoginViewControllerGoShoppingButtonTag:
        {
            if (![kUserDefaults stringForKey:UDKEY_IsFirstLoginRegister]){
                [kUserDefaults setValue:@"1" forKey:UDKEY_IsFirstLoginRegister];
                [kUserDefaults synchronize];
            }
            [[JXViewManager sharedInstance] dismissViewController:YES resetRootViewController:YES];
        }
            break;
        case LoginViewControllerPrivateButtonTag:
        {
            DetailWebViewController * rvc = [[DetailWebViewController alloc] init];
            rvc.urlStr = kPrivacyUrl;
            rvc.title = @"隐私政策";
            [self.navigationController pushViewController:rvc animated:YES];
            
//            IntroductionViewController * rvc = [[IntroductionViewController alloc] init];
//            rvc.type = IntroductionPrivateType;
//            [self.navigationController pushViewController:rvc animated:YES];
            
        }
            break;
        case LoginViewControllerQQButtonTag:
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                NSLog(@"data:%@",response.data);
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    
                    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, nil, nil, response.message);
                    
                    RegisterViewController * rvc = [[RegisterViewController alloc] init];
                    rvc.accountType = UserBindMobileType;
                    [self.navigationController pushViewController:rvc animated:YES];
                }else{
                    NSLog(@"message:%@",response.message);
                    NSLog(@"error:%@",response.error.localizedDescription);
                }
            });
        }
            break;
        case LoginViewControllerWXButtonTag:
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"data:%@",response.data);
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                    
//                    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                     NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, nil, nil, response.message);
                    //绑定手机号。。。
                    RegisterViewController * rvc = [[RegisterViewController alloc] init];
                    rvc.accountType = UserBindMobileType;
                    [self.navigationController pushViewController:rvc animated:YES];
                    
                }else{
                    NSLog(@"message:%@",response.message);
                    NSLog(@"error:%@",response.error.localizedDescription);
                }
                
            });
        }
            break;
    }
}
- (void)switchTextEntryStyle:(UIButton *)sw{
    sw.selected = !sw.selected;
    if (sw.isSelected) {
        _passwordTextField.secureTextEntry = NO;
    }else{
        _passwordTextField.secureTextEntry = YES;
    }
}
//- (void)switchTextEntryStyle:(UISwitch *)sw{
//    if (sw.isOn) {
//        _passwordTextField.secureTextEntry = NO;
//    }else{
//        _passwordTextField.secureTextEntry = YES;
//    }
//}
#pragma mark - private methods
- (void)textFieldEditingChanged:(UITextField *)textField
{
    //限制手机账号长度（有两个空格）
    if (textField.text.length > 13) {
        textField.text = [textField.text substringToIndex:13];
    }
    
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //正在执行删除操作时为0，否则为1
    char editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    }
    else {
        editFlag = 1;
    }
    
    NSMutableString *tempStr = [NSMutableString new];
    
    int spaceCount = 0;
    if (currentStr.length < 3 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 7 && currentStr.length > 2) {
        spaceCount = 1;
    }else if (currentStr.length < 12 && currentStr.length > 6) {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
        }else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
        }else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
    }
    
    if (currentStr.length == 11) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
    }
    if (currentStr.length < 4) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
    }else if(currentStr.length > 3 && currentStr.length <12) {
        NSString *str = [currentStr substringFromIndex:3];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 11) {
            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    textField.text = tempStr;
    // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    
    if (editFlag == 0) {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }else {
        //添加
        if (currentStr.length == 8 || currentStr.length == 4) {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
}
- (BOOL)loginValidate{
    //去空格
    mobileStr = [_userTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(mobileStr.length == 0){
        [self showJXNoticeMessage:@"请输入手机号"];
        return NO;
    }else{
        if (![NSString validateTelephone:mobileStr]){
            [self showJXNoticeMessage:@"手机号输入有误"];
            return NO;
        }
    }
    if (_passwordTextField.text.length == 0){
        [self showJXNoticeMessage:@"请输入密码"];
        return NO;
    }else{
        if (![NSString validatePassword:_passwordTextField.text]){
            [self showJXNoticeMessage:@"密码格式错误"];
            return NO;
        }
    }
    return YES;
}
- (void)handleLoginSuccessResult:(id)object{
    
    //设置是否自动登录
    [[EMClient sharedClient].options setIsAutoLogin:YES];
    
    //获取数据库中数据
    //[MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] dataMigrationTo3];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showJXNoticeMessage:object];
            [[ChatUtil shareHelper] asyncGroupFromServer];
            [[ChatUtil shareHelper] asyncConversationFromDB];
            [[ChatUtil shareHelper] asyncPushOptions];
            
            [CloudPushSDK bindAccount:[NSString stringWithFormat:@"user%@",[UserDBManager shareManager].UserID] withCallback:^(CloudPushCallbackResult *res) {
                if (res.success){
                    NSLog(@"阿里推送绑定账号成功");
                }else{
                    NSLog(@"阿里推送绑定账号失败：%@",res.error);
                }
            }];
            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            
            //保存最近一次登录用户名
            //[weakself saveLastLoginUsername];
            //存储手机号，用于判断登录用户是否为新用户，以及快捷登录
            [kUserDefaults setObject:mobileStr forKey:UDKEY_MobileNumber];
            [kUserDefaults setObject:_passwordTextField.text forKey:UDKEY_Password];
            [kUserDefaults synchronize];

            BOOL isSameUser = YES;
            if (![startupUser isEqualToString:mobileStr]) {
                isSameUser = NO;
                if ([[NotificationManager shareManager] isExist:NotificationDBName]){
                    [[NotificationManager shareManager] deleteData:NotificationDBName];
                    [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadSystemMessagesNotification object:@NO];
                }
            }
            AppDelegate * appDelegate = [AppDelegate appDelegate];
            JXDispatch_async_global((^{
                [[UserRequest shareManager] userNotificationNews:kApiNotificationNews param:nil success:^(id object,NSString *msg) {
                    BOOL yesOrNo = [object[@"hasNotice"] boolValue];
                    [NotificationManager shareManager].isHasNews = [object[@"hasNotice"] intValue];
                    [appDelegate showBadge:yesOrNo];
                    [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadSystemMessagesNotification object:@(yesOrNo)];
                    //[UIApplication sharedApplication].applicationIconBadgeNumber = [object[@"hasNotice"] intValue];
                } failure:^(id object,NSString *msg) {}];
            }));
            

            if (right.isHidden){
                [[JXViewManager sharedInstance] dismissViewController:YES resetRootViewController:YES];
            }else{
                if (_loginSuccessBlock && _loginInfomationUnavailble){
                    self.loginSuccessBlock(@(isSameUser));
                }else{
                    [self dismissViewControllerAnimated:YES completion:^{}];
                }
            }
            
            if (![kUserDefaults stringForKey:UDKEY_IsFirstLoginRegister]){
                [kUserDefaults setValue:@"1" forKey:UDKEY_IsFirstLoginRegister];
                [kUserDefaults synchronize];
            }
        });
    });

}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _userTextField){
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
    }
    if (textField == _passwordTextField){
        if (range.location > 15){
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            text = [text substringToIndex:15];
            textField.text = text;
            [self showJXNoticeMessage:@"字符个数不能大于16"];
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    if (textField == _passwordTextField) {
        [_passwordTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    _currentTextField = textField;
    //    [_keyBoard ShowBar:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

@end
