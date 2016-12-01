//
//  ForgetViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/25.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "ForgetViewController.h"

#define registerLeading  20
#define registerHeight   40*kPercent

@interface ForgetViewController ()<UITextFieldDelegate>{
    UITextField * _mobileTextField;
    UITextField * _passwordTextField;
    UITextField * _verficationTextField;
    
    UIButton    * _verficationButton;
    
    UIButton    * _registerButton;
}

@end

@implementation ForgetViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isModifyPassword) {
        self.title = @"修改密码";
        _mobileTextField.textAlignment = NSTextAlignmentCenter;
    }
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
    
    [self addNavigationView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mobileTextField.backgroundColor = [UIColor redColor];
    _mobileTextField.borderStyle = UITextBorderStyleNone;
    _mobileTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _mobileTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mobileTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileTextField.delegate = self;
    _mobileTextField.placeholder = @"请输入手机号码";
    [self.view addSubview:_mobileTextField];
    
    _verficationTextField.backgroundColor = [UIColor yellowColor];
    _verficationTextField.borderStyle = UITextBorderStyleNone;
    _verficationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _verficationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _verficationTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _verficationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verficationTextField.delegate = self;
    _verficationTextField.placeholder = @"请输入验证码";
    [self.view addSubview:_verficationTextField];
    
    
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _passwordTextField.delegate = self;
    _passwordTextField.placeholder = @"请设置6-14位数字字母组成的新密码";
    [self.view addSubview:_passwordTextField];
    
    
    [_verficationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verficationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_verficationButton setBackgroundColor:[UIColor orangeColor]];
    _verficationButton.layer.cornerRadius = 5.f;
//    [_verficationButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verficationButton];
    
    
    [_registerButton setTitle:@"完成" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton setBackgroundColor:[UIColor orangeColor]];
    _registerButton.layer.cornerRadius = 5.f;
//    [_registerButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self layoutSubView];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.navigationController.navigationBarHidden = NO;
    _mobileTextField = [UITextField new];
    _verficationTextField = [UITextField new];
    _passwordTextField = [UITextField new];
    
    
    
    _verficationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
}

//-(void)updateViewConstraints{
//    _agreeButton_leading.constant = (kScreenWidth -(_agreeButton.frame.size.width + _agreeLabel.frame.size.width +_privacyButton.frame.size.width))/2.0;
//
//    [super updateViewConstraints];
//}

-(void)addNavigationView{
    self.navigationItem.title = @"忘记密码";
    self.navigationItem.leftBarButtonItem = getBackItem(self,@selector(back:));
}
- (void)layoutSubView{
    [_mobileTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(registerLeading);
        make.top.equalTo(self.view).offset(10 + kNavStatusHeight);
        make.right.equalTo(self.view).offset(-registerLeading);
        make.height.equalTo(registerHeight);
    }];
    
    [_verficationTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobileTextField.bottom).offset(10);
        make.left.equalTo(self.view).offset(registerLeading);
        make.width.equalTo(200);
        make.height.equalTo(_mobileTextField);
        
    }];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verficationTextField.bottom).offset(10);
        make.left.equalTo(self.view).offset(registerLeading);
        make.width.equalTo(_verficationTextField);
        make.height.equalTo(_mobileTextField);
        
    }];
    [_verficationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verficationTextField);
        make.right.equalTo(self.view).offset(-registerLeading);
        make.left.equalTo(_verficationTextField.right).offset(0);
        make.height.equalTo(_verficationTextField);
    }];
    [_registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(registerLeading);
        make.top.equalTo(_passwordTextField.bottom).offset(35);
        make.width.equalTo(_mobileTextField);
        make.height.equalTo(_mobileTextField);
    }];
    
    [self addOtherViews];
}
- (void)addOtherViews{
    //    UIView * line1 = [[UIView alloc  ]initWithFrame:CGRectMake(20, _mobileTextField.frame.size.height + _mobileTextField.frame.origin.y +4.5, kScreenWidth, 200)];
    UIView * line1 = [[UIView alloc  ]init ];
    line1.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobileTextField.bottom).offset(4.5);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(1);
    }];
    
    UIView * line2 = [[UIView alloc  ]init ];
    line2.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verficationTextField.bottom).offset(4.5);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(1);
    }];
    
    UIView * line3 = [[UIView alloc  ]init ];
    line3.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:line3];
    [line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.bottom).offset(4.5);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(1);
    }];
    
    UIView * line4 = [[UIView alloc  ]init ];
    line4.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:line4];
    [line4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verficationButton.top).offset(5);
        make.left.equalTo(_verficationButton.left).offset(5);
        make.width.equalTo(1);
        make.bottom.equalTo(_verficationButton.bottom).offset(-5);
    }];
    
    
    
    
}
#pragma mark - Click events
- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)login:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma TextFieldClick

//-(void)registerKeyBord {
//    NSArray * tempArray = [[NSArray alloc] initWithObjects:_mobileTextField,_passwordTextField,_recommendedTextField,_verficationTextField,nil];
//    _keyBoard =[[KeyBoardTopBar alloc] initWithArray:tempArray];
//
//   	[_keyBoard  setAllowShowPreAndNext:YES];
//    _keyBoard.delegate = self;
//}
//-(void)keyBoardTopBarConfirmClicked:(UITextField *)textField {
//    [_bgScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
//}
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _mobileTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    if (textField == _verficationTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    if (textField == _verficationTextField) {
        [_passwordTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    _currentTextField = textField;
    //    [_keyBoard ShowBar:textField];
    
}


- (void)verficationButtonClick:(id)sender {
    //[[UserRequest shareManager] userGetCaptcha:self mobile:_mobileTextField.text type:@"register"];
}
- (void)registerButtonClick:(id)sender {
    if (![self isValid]) {
        return;
    }
    // 注册
    //                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[self pushMessage:FJ_Local(@"Loading")];
    
    //[[UserRequest shareManager] userRegister:self mobile:_mobileTextField.text password:_passwordTextField.text recommend_mobile:_recommendedTextField.text captcha:_verficationTextField.text clientId:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
}
- (IBAction)agreeButtonClick:(id)sender {
    //    UIButton * button = (UIButton *)sender;
    //    button.selected = !button.selected;
    //    if (!button.selected) {
    //        [button setImage:FJ_IMAGE(@"not_agree_register") forState:UIControlStateNormal];
    //        _registerButton.enabled = NO;
    //    } else {
    //        [button setImage:FJ_IMAGE(@"agree_register") forState:UIControlStateNormal];
    //        _registerButton.enabled = YES;
    //    }
}
- (void)privacyButtonClick:(id)sender {
    //    JXWebInfoViewController *wivc = [[JXWebInfoViewController alloc] init];
    //    wivc.type = WebInfoTypePrivate;
    //    [self.navigationController pushViewController:wivc animated:YES];
}

#pragma mark - KeyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    //CGFloat keyboardTop = keyboardRect.origin.y;
    
    CGFloat navigationBarHeight;
    if ([self isKindOfClass:[UINavigationController class]] || self.navigationController) {
        navigationBarHeight = 64;
    }
//    CGFloat _keyBoardHeight = 44;
    /*
     *1.(屏幕高度 > 点击的输入框下边界 + 键盘 + toolbar)-----意味着已发生遮挡
     *2.屏幕高度 - (点击的输入框下边界 + 键盘 + toolbar)-----遮挡住的部分即是需要上移的高度
     *3.有导航栏的时候需要算上导航栏的高度,为了美观可以多留一些距离:
     height = 屏幕高度 - (点击的输入框下边界 + 键盘 + toolbar) + 15
     */
    //    CGFloat height = _currentTextField.frame.origin.y + _currentTextField.frame.size.height + _keyBoardHeight + keyboardRect.size.height + 64 + 15;
    //    if (height > kScreenHeight) {
    //        //        [UIView animateWithDuration:0.2 animations:^{
    //        //            [_bgScrollview setContentOffset:CGPointMake(0, (height +15 - kScreenHeight))];
    //        //            //_bgScrollview.origin = CGPointMake(0, keyboardTop - 44);
    //        //        }];
    //        [_bgScrollview setContentOffset:CGPointMake(0, height- kScreenHeight) animated:YES];
    //    }
    //
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //    [UIView animateWithDuration:0.2 animations:^{
    //        _bgScrollview.origin = CGPointMake(0,kScreenHeight-44.f - _bgScrollview.frame.size.height);
    //        NSLog(@"self.view.frame.size.height is %f",self.view.frame.size.height);
    //    }];
    //    [_bgScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
}


//验证码输入前校验
-(BOOL)isValidVerCode
{
    //    if(_mobileTextField.text.length == 0)
    //    {
    //        [self pushWarnMessage:@"请输入手机号"];
    //        return NO;
    //    }
    //    else
    //    {
    //
    //        if (![FJ_Public isMobileNumber:_mobileTextField.text])
    //        {
    //            [self pushWarnMessage:@"手机号必须是11位以1开头的纯数字"];
    //            return NO;
    //        }
    //
    //    }
    //    if (_passwordTextField.text.length == 0)
    //    {
    //        [self pushWarnMessage:@"请输入密码"];
    //        return NO;
    //    }
    //    else
    //    {
    //        if (![FJ_Public isVaildPassword:_passwordTextField.text])
    //        {
    //            [self pushWarnMessage:@"密码应为6-20位的数字和字母组合"];
    //            return NO;
    //        }
    //    }
    //    if (_recommendedTextField.text.length > 0) {
    //        if (![FJ_Public isMobileNumber:_recommendedTextField.text])
    //        {
    //            [self pushWarnMessage:@"手机号必须是11位以1开头的纯数字"];
    //            return NO;
    //        }
    //    }
    return YES;
    
}
// 注册之前校验参数
- (BOOL)isValid
{
    
    //    if(_mobileTextField.text.length == 0)
    //    {
    //        [self pushWarnMessage:@"请输入手机号"];
    //        return NO;
    //    }
    //    else
    //    {
    //        if (![FJ_Public isMobileNumber:_mobileTextField.text])
    //        {
    //            [self pushWarnMessage:@"手机号格式错误"];
    //            return NO;
    //        }
    //
    //    }
    //
    //    if (_passwordTextField.text.length == 0)
    //    {
    //        [self pushWarnMessage:@"请输入密码"];
    //        return NO;
    //    }
    //    else
    //    {
    //        if (![FJ_Public isVaildPassword:_passwordTextField.text])
    //        {
    //            [self pushWarnMessage:@"密码应为6-20位的数字和字母组合"];
    //            return NO;
    //        }
    //    }
    //    if (_recommendedTextField.text.length > 0)
    //    {
    //        if (![FJ_Public isMobileNumber:_recommendedTextField.text]) {
    //            [self pushWarnMessage:@"推荐人手机格式错误"];
    //            return NO;
    //        }
    //    }
    //    if(_verficationTextField.text.length != 6){
    //        [self pushWarnMessage:@"请输入 6 位数字验证码"];
    //        return NO;
    //    }
    return YES;
}

/**
 *  60秒倒计时操作
 */

-(void)sixTy
{
    //    numTitle = 60;
    //    time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnTitle:) userInfo:nil repeats:YES];
    //    [time fire];
}

-(void)btnTitle:(id)sender
{
    //    if (isSucee == NO)
    //    {
    //        [time invalidate];
    //        return;
    //    }
    //    if (numTitle == 0)
    //    {
    //        [time invalidate];
    //        [_verficationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    //        [_verficationButton setBackgroundColor:FJ_HexStr(@"#FC5860")];
    //        [_verficationButton setEnabled:YES];
    //    }
    //    else
    //    {
    //        [_verficationButton setEnabled:NO];
    //        [_verficationButton setBackgroundColor:FJ_HexStr(@"#DDDDDD")];
    //        NSString * str_num = [NSString stringWithFormat:@"重新获取(%ld)" , (long)numTitle];
    //        NSLog(@"%@" , str_num);
    //        [_verficationButton setTitle:str_num forState:UIControlStateNormal];
    //        _verficationButton.titleLabel.text = str_num;
    //        //        NSLog(@"%@" , btn_1.titleLabel.text);
    //        numTitle--;
    //        //        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    //    }
}


-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    //    [self dismissMessage];
    //    // 获取短信验证码成功
    //    if (nTag == t_API_USER_PLATFORM_VERCODE_API)
    //    {
    //        NSString *successStr = (NSString *)netTransObj;
    //        NSLog(@"netTransObj is %@",successStr);
    //
    //        [self alertMessage:successStr];
    //    }
    //    // 注册成功
    //    if (nTag == t_API_USER_REGISTER_API)
    //    {
    //        //调用登录接口
    //        [UserObj requestWithDelegate:self nApiTag:kApiUserLoginTag url:kRequestUrl(kUserLogin) param:@{@"user_name":_mobileTextField.text,@"password":_passwordTextField.text,@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]}];
    //    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    //    [self dismissMessage];
    //    [self pushWarnMessage:errMsg];
}

-(void)responseSuccessObj:(id)responseObj tag:(DJXApiTag)tag{
    //    [self dismissMessage];
    //    //登录成功后
    //    if (tag == kApiUserLoginTag)
    //    {
    //        //UserAccount *userInfo = (UserAccount *)object;
    //        //调用购物车中的商品总数的接口
    //
    //        [[NSUserDefaults standardUserDefaults] setObject:_mobileTextField.text forKey:@"userName"];
    //        [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"passWord"];
    //        /*登录成功后调用获取购物车数量接口*/
    //        //获取购物车数量
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //            //获取购物车的数量
    //            [[OrderRequest shareManager] cartNum:^(id object) {
    //                if ([object isKindOfClass:[NSArray class]]) {
    //                    NSDictionary *dic = [(NSArray *)object firstObject];
    //                    NSString *total = [NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]];
    //                    [[AppDelegate appDelegate] changeCartNum:total];
    //                }
    //
    //            } failure:^(id object) {
    //
    //            }];
    //        });
    //        //登录成功后，登录界面自动消失
    //        [[AppDelegate appDelegate].mytabBarController dismissViewControllerAnimated:YES completion:^{
    //        }];
    //        [[AppDelegate appDelegate].mytabBarController setSelectedIndex:0];
    //        [[NSNotificationCenter defaultCenter ] postNotificationName:LoginViewControllerLoginNotification object:nil];
    //    }else if (tag == kApiUserGetCaptchaTag){
    //        NSString *successStr = (NSString *)responseObj;
    //        [self showAlertMessage:successStr];
    //    }else if (tag == kApiUserRegisterTag){
    //        //调用登录接口
    //        [UserObj requestWithDelegate:self nApiTag:kApiUserLoginTag url:kRequestUrl(kUserLogin) param:@{@"user_name":_mobileTextField.text,@"password":_passwordTextField.text,@"cid":[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]}];
    //    }
}
-(void)responseFailed:(DJXApiTag)tag withMessage:(NSString *)errMsg{
    //    [self dismissMessage];
    //    [self pushWarnMessage:errMsg];
}

@end
