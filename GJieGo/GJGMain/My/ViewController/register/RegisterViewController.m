//
//  RegisterViewController.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//
//  系统名称：RegisterViewController
//  功能描述：注册/忘记密码/修改密码/绑定手机号
//  修改记录：(仅记录功能修改)


#import "RegisterViewController.h"
#import "LoginTextField.h"
#import "IntroductionViewController.h"
#import "ModifyInformationViewController.h"
#import "DetailWebViewController.h"

#import "UserEntity.h"
#import "ChatUtil.h"
#import <CloudPushSDK/CloudPushSDK.h>

#define registerLeading  20
#define registerHeight   44

@interface RegisterViewController ()<UITextFieldDelegate>{
    LoginTextField    * _mobileTextField;
    LoginTextField    * _passwordTextField;
    LoginTextField    * _verficationTextField;
    LoginTextField    * _confirmPasswordTextField;//确认密码/邀请码
    
    UIButton       * _verficationButton;
    
    UIButton       * _registerButton;
    UIButton       * _privacyButton;
    
    UILabel        * agreeLabel;
    
    UIActivityIndicatorView * _activityView;
    
    NSString    * previousTextFieldContent;
    UITextRange * previousSelection;
    NSString    * mobileStr;
}

@end

@implementation RegisterViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

    self.view.backgroundColor = [UIColor whiteColor];
    
    _mobileTextField.backgroundColor = JXClearColor;
    _mobileTextField.borderStyle = UITextBorderStyleNone;
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _mobileTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mobileTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileTextField.delegate = self;
    _mobileTextField.placeholder = @"请输入手机号码";
    _mobileTextField.textColor = JX333333Color;
    _mobileTextField.font = JXFontForNormal(13);
    [_mobileTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_mobileTextField];
    
    _verficationTextField.backgroundColor = JXClearColor;
    _verficationTextField.borderStyle = UITextBorderStyleNone;
    _verficationTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verficationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _verficationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _verficationTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _verficationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verficationTextField.delegate = self;
    _verficationTextField.placeholder = @"请输入验证码";
    _verficationTextField.textColor = JX333333Color;
    _verficationTextField.font = JXFontForNormal(13);
    [self.view addSubview:_verficationTextField];
    
    _passwordTextField.backgroundColor = JXClearColor;
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    _passwordTextField.rightView = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 4.75, 51, 34.5);
        [btn setTitleColor:JX333333Color forState:UIControlStateNormal];
        [btn setBackgroundImage:JXImageNamed(@"login_input_close") forState:UIControlStateNormal];
        [btn setBackgroundImage:JXImageNamed(@"login_input_open") forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5.f;
        [btn addTarget:self action:@selector(switchTextEntryStyle:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = NO;
        btn;
    });
    _passwordTextField.placeholder = @"请设置6-16位数字字母组成的密码";
    _passwordTextField.textColor = JX333333Color;
    _passwordTextField.font = JXFontForNormal(13);
    
    
    
    _confirmPasswordTextField.backgroundColor = JXClearColor;
    _confirmPasswordTextField.borderStyle = UITextBorderStyleNone;
    _confirmPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _confirmPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _confirmPasswordTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _confirmPasswordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.delegate = self;
    _confirmPasswordTextField.placeholder = @"请再次输入新密码";
    _confirmPasswordTextField.textColor = JX333333Color;
    _confirmPasswordTextField.font = JXFontForNormal(13);
    
    
    
    [_verficationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verficationButton setTitleColor:JX333333Color forState:UIControlStateNormal];
    [_verficationButton setBackgroundColor:JXClearColor];
    _verficationButton.titleLabel.font = JXFontForNormal(14);
    _verficationButton.layer.cornerRadius = 5.f;
    [_verficationButton addTarget:self action:@selector(acquireVerfication:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verficationButton];
    
    [_registerButton setTitle:@"同意协议并注册" forState:UIControlStateNormal];
//    [_registerButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
//    [_registerButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
    [_registerButton setTitleColor:JX333333Color forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
    _registerButton.titleLabel.font = JXFontForNormal(16);
    _registerButton.layer.cornerRadius = 5.f;
//    _registerButton.enabled = NO;
    [_registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityView];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
    
//    _mobileTextField.text = @"13121273646";
//    _passwordTextField.text = @"123456";
    
    NSString * title = @"注册";
    switch (self.accountType) {
        case UserRegisterAccountType:
        {
            title = @"注册";
            self.codeType = VerificationCodeRegisterType;
            [self.view addSubview:_passwordTextField];
            [self.view addSubview:_confirmPasswordTextField];
            _mobileTextField.placeholder = @"请输入注册手机号";
            _confirmPasswordTextField.placeholder = @"请输入邀请码（选填）";
            _confirmPasswordTextField.secureTextEntry = NO;
            _confirmPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
            [_registerButton setTitle:@"同意协议并注册" forState:UIControlStateNormal];
            
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc ]initWithString:@"用户协议" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:JXColorFromRGB(0x666666),NSForegroundColorAttributeName:JX333333Color}];
            [_privacyButton setAttributedTitle:attributedString forState:UIControlStateNormal];
            [_privacyButton setBackgroundColor:JXClearColor];
            _privacyButton.titleLabel.font = JXFontForNormal(13);
            _privacyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_privacyButton addTarget:self action:@selector(agreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:_privacyButton];
        }
            break;
        case UserForgetPasswordType:
        {
            title = @"忘记密码";
            self.codeType = VerificationCodeModifyPasswordType;
            [self.view addSubview:_passwordTextField];
            [_registerButton setTitle:@"完成" forState:UIControlStateNormal];
        }
            break;
        case UserModifyPasswordType:
        {
            title = @"修改密码";
            self.codeType = VerificationCodeModifyPasswordType;
            [self.view addSubview:_passwordTextField];
            [self.view addSubview:_confirmPasswordTextField];
            _passwordTextField.rightViewMode = UITextFieldViewModeNever;
            _mobileTextField.textAlignment = NSTextAlignmentCenter;
            _passwordTextField.placeholder = @"请设置6-16位数字字母组成的新密码";
            if ([UserDBManager shareManager].PhoneNumber.length >0){
                NSString * s = [UserDBManager shareManager].PhoneNumber;
                NSString * s1 = [s substringToIndex:3];
                NSString * s2 = [s substringWithRange:NSMakeRange(s1.length, 4)];
                NSString * s3 = [s substringWithRange:NSMakeRange(s1.length +s2.length, 4)];
                _mobileTextField.text = [NSString stringWithFormat:@"当前账号：%@-%@-%@",s1,s2,s3];
            }
            _mobileTextField.enabled = NO;
            [_registerButton setTitle:@"完成" forState:UIControlStateNormal];
            
        }
            break;
        case UserBindMobileType:
        {
            title = @"绑定手机";
            [_registerButton setTitle:@"提交" forState:UIControlStateNormal];
        }
            break;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [_registerButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
    _registerButton.enabled = NO;
    
    self.navigationItem.title = title;
    [self layoutSubViewWithType:self.accountType];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)loadView{
    [super loadView];
    self.navigationController.navigationBarHidden = NO;
    _mobileTextField = [LoginTextField new];
    _verficationTextField = [LoginTextField new];
    _passwordTextField = [LoginTextField new];
    _confirmPasswordTextField = [LoginTextField new];
    
    _verficationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];

}
- (void)layoutSubViewWithType:(UserAccountType)type{
    CGFloat mobileTextFieldTop = kNavStatusHeight;
    [_mobileTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(registerLeading);
        make.top.equalTo(self.view).offset(1 + mobileTextFieldTop);
        make.right.equalTo(self.view).offset(-registerLeading);
        make.height.equalTo(registerHeight);
    }];
    
    [_verficationTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobileTextField.bottom).offset(1);
        make.left.equalTo(self.view).offset(registerLeading);
        make.width.equalTo(200 *kPercent);
        make.height.equalTo(_mobileTextField);
        
    }];
    [_verficationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verficationTextField);
        make.right.equalTo(self.view).offset(-registerLeading);
        make.left.equalTo(_verficationTextField.right).offset(0);
        make.height.equalTo(_verficationTextField);
    }];
    CGFloat finishButtonTop;
    switch (type) {
        case UserRegisterAccountType:
        {
            [_privacyButton makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_confirmPasswordTextField.bottom).offset(10);
                make.left.equalTo(self.view).offset(registerLeading +10);
                make.width.equalTo(_mobileTextField);
                make.height.equalTo(20);
            }];
            finishButtonTop = 70;
            [_activityView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view).offset(40);
                make.centerY.equalTo(_registerButton);
                make.width.equalTo(30);
                make.height.equalTo(30);
            }];
        }
            break;
        case UserForgetPasswordType:
        case UserModifyPasswordType:
        case UserBindMobileType:{
            finishButtonTop = 40;
        }
            break;
    }
    if (type != UserBindMobileType) {
        [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_verficationTextField.bottom).offset(1);
            make.left.equalTo(self.view).offset(registerLeading);
            make.width.equalTo(_mobileTextField);
            make.height.equalTo(_mobileTextField);
            
        }];
    }
    if (type == UserModifyPasswordType || type == UserRegisterAccountType) {
        [_confirmPasswordTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_passwordTextField.bottom).offset(1);
            make.left.equalTo(self.view).offset(registerLeading);
            make.width.equalTo(_mobileTextField);
            make.height.equalTo(_mobileTextField);
            
        }];
    }
    [_registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(registerLeading);
        if (type != UserBindMobileType) {
            if (type == UserModifyPasswordType || type == UserRegisterAccountType){
                make.top.equalTo(_confirmPasswordTextField.bottom).offset(finishButtonTop);
            }else{
                make.top.equalTo(_passwordTextField.bottom).offset(finishButtonTop);
            }
        }else{
            make.top.equalTo(_verficationTextField.bottom).offset(finishButtonTop);
        }
        
        make.width.equalTo(_mobileTextField);
        make.height.equalTo(_mobileTextField);
    }];
    
    [self addOtherViews];
}
- (void)addOtherViews{

    UIView * line1 = [[UIView alloc  ]init ];
    line1.backgroundColor = JXSeparatorColor;
    [self.view addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobileTextField.bottom).offset(0);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(0.5);
    }];
    
    UIView * line2 = [[UIView alloc  ]init ];
    line2.backgroundColor = JXSeparatorColor;
    [self.view addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verficationTextField.bottom).offset(0);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(0.5);
    }];
    if (self.accountType != UserBindMobileType){
        UIView * line3 = [[UIView alloc  ]init ];
        line3.backgroundColor = JXSeparatorColor;
        [self.view addSubview:line3];
        [line3 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_passwordTextField.bottom).offset(0);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(0.5);
        }];
    }
    if (self.accountType == UserModifyPasswordType || self.accountType == UserRegisterAccountType){
        UIView * line4 = [[UIView alloc  ]init ];
        line4.backgroundColor = JXSeparatorColor;
        [self.view addSubview:line4];
        [line4 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_confirmPasswordTextField.bottom).offset(0);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(0.5);
        }];
    }
    
    UIView * line5 = [[UIView alloc  ]init ];
    line5.backgroundColor = JXSeparatorColor;
    [self.view addSubview:line5];
    [line5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verficationButton.top).offset(5);
        make.left.equalTo(_verficationButton.left).offset(5);
        make.width.equalTo(0.5);
        make.bottom.equalTo(_verficationButton.bottom).offset(-5);
    }];
    

    
    
}
#pragma mark - Click events
- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
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

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _mobileTextField) {
        [_verficationTextField becomeFirstResponder];
    }
    if (textField == _verficationTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    if (textField == _passwordTextField) {
        if (self.pageType != UserModifyPasswordType) {
            [_passwordTextField resignFirstResponder];
        }else{
            [_confirmPasswordTextField becomeFirstResponder];
        }
    }
    if (textField == _confirmPasswordTextField) {
        [_confirmPasswordTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
- (void)textFieldDidEndEditing:(UITextField *)textField{

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _mobileTextField){
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        if (range.location > 12){
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            text = [text substringToIndex:12];
            textField.text = text;
            [self showJXNoticeMessage:@"字符个数不能大于11"];
        }
    }
    if (textField == _passwordTextField){
        if (range.location > 15){
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            text = [text substringToIndex:15];
            textField.text = text;
            [self showJXNoticeMessage:@"字符个数不能大于16"];
        }
    }
    if (self.accountType == UserRegisterAccountType) {
        if (textField == _confirmPasswordTextField){
            if (range.location > 8){
                NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
                text = [text substringToIndex:8];
                textField.text = text;
                [self showJXNoticeMessage:@"字符个数不能大于9"];
            }
        }
    }else{
        if (textField == _confirmPasswordTextField){
            if (range.location > 15){
                NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
                text = [text substringToIndex:15];
                textField.text = text;
                [self showJXNoticeMessage:@"字符个数不能大于16"];
            }
        }
    }

    return YES;
}
- (void)acquireVerfication:(id)sender {
    if (![self verficationValidate]) {
        return;
    }
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_verficationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_verficationButton setTitleColor:JX333333Color forState:UIControlStateNormal];
                _verficationButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_verficationButton setTitle:[NSString stringWithFormat:@"%@S",strTime] forState:UIControlStateNormal];
                [_verficationButton setTitleColor:JX999999Color forState:UIControlStateNormal];
                [UIView commitAnimations];
                _verficationButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    
    [self showLoadView];
    if (self.accountType == UserRegisterAccountType){
        [[UserRequest shareManager] sendValiCode:kApiUserSendValiCode param:@{@"Ph":mobileStr,@"Mt":@(self.codeType)} success:^(id object,NSString *msg) {
            //
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        } failure:^(id object,NSString *msg) {
            //
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        }];
    }else if (self.accountType == UserForgetPasswordType){
        [[UserRequest shareManager] sendValiCode:kApiUserSendValiCode param:@{@"Ph":mobileStr,@"Mt":@(self.codeType)} success:^(id object,NSString *msg) {
            //
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        } failure:^(id object,NSString *msg) {
            //
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        }];
    }else{
        [[UserRequest shareManager] sendValiCode:kApiUserSendValiCodeL param:@{@"Mt":@(self.codeType)} success:^(id object,NSString *msg) {
            //
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        } failure:^(id object,NSString *msg) {
            //
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        }];
    }
    
}
- (void)registerButtonClick:(id)sender {
    if (![self registerValidate]) {
        return;
    }

    
    if (self.accountType == UserRegisterAccountType){
        
        [_registerButton setTitle:@"注册中" forState:UIControlStateNormal];
        [_activityView startAnimating];

        NSDictionary * dict = @{@"Ph":mobileStr,@"Up":_passwordTextField.text,@"Ug":[NSNumber numberWithInt:0],@"Uag":[NSNumber numberWithInt:18],@"Pc":_verficationTextField.text,@"Code":_confirmPasswordTextField.text?_confirmPasswordTextField.text:@""};
        [[UserRequest shareManager] userRegister:kApiUserRegiser param:dict success:^(id object,NSString *msg) {
            NSLog(@"app用户注册成功");
            NSString * ss = @"注册成功";
            if ([msg isKindOfClass:[NSString class]]) {
                ss = (NSString *)object;
            }
            //这块交给服务器来注册
            [self autoLogin:ss];
//            EMError *error = [[EMClient sharedClient] registerWithUsername:_mobileTextField.text password:_passwordTextField.text];
//            if (error==nil) {
//                NSLog(@"环信注册成功");
//                [self autoLogin];
//            }else{
//                NSLog(@"环信注册失败，重试...");
//                EMError *subError = [[EMClient sharedClient] registerWithUsername:_mobileTextField.text password:_passwordTextField.text];
//                if (subError==nil) {
//                    NSLog(@"环信注册成功");
//                    [self autoLogin];
//                }else{
//                    NSLog(@"环信注册失败");
//                }
//            }
        } failure:^(id object,NSString *msg) {
            NSLog(@"app用户注册失败");
            [_activityView stopAnimating];
            [_registerButton setTitle:@"同意协议并注册" forState:UIControlStateNormal];
            [self showJXNoticeMessage:msg];
        }];
    }else{
        [self showLoadView];
        NSString * mobileStr1;
        if (self.accountType == UserModifyPasswordType) {
            mobileStr1 = [UserDBManager shareManager].PhoneNumber;
        }else{
            mobileStr1 = mobileStr;
        }
        NSDictionary * dict = @{@"Ph":mobileStr1,@"Np":_passwordTextField.text,@"Pc":_verficationTextField.text};
        [[UserRequest shareManager] userModifyPassword:kApiUserResetPassword param:dict success:^(id object,NSString *msg) {
            
            if (self.accountType == UserModifyPasswordType){
                //
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[LoginManager shareManager] logOut];
                    EMError *error = [[EMClient sharedClient] logout:YES];
                    [[UserDBManager shareManager] deleteToken];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (error != nil) {
                            //                [weakSelf showHint:error.errorDescription];
                        }
                        else{
                            //[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                            
                        }
                    });
                    
                    NSString * parameterStr = [DJXNetworkConfig commonParameter:nil longitude:@0 latitude:@0];
                    [[UserRequest shareManager] userShortToken:kGJGRequestUrl_v_cp(kApiVersion,kApiUserShortToken,parameterStr) param:@{@"Uc":[DJXNetworkConfig tokenStr:nil]} success:^(id object,NSString *msg) {
                        [self showJXNoticeMessage:@"修改成功"];
                        [self hideLoadView];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        [[LoginManager shareManager] checkUserLoginState:nil];
                    } failure:^(id object,NSString *msg) {
                        [self hideLoadView];
                    }];
                });
            }else{
                [self hideLoadView];
                [self showJXNoticeMessage:@"重置成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(id object,NSString *msg) {
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        }];
    }
  
}
- (void)agreeButtonClick:(id)sender {

}
- (void)switchTextEntryStyle:(UIButton *)sw{
    sw.selected = !sw.selected;
    if (sw.isSelected) {
        _passwordTextField.secureTextEntry = NO;
    }else{
        _passwordTextField.secureTextEntry = YES;
    }
}

- (void)agreementButtonClick:(id)sender {
//    IntroductionViewController * rvc = [[IntroductionViewController alloc] init];
//    rvc.type = IntroductionPrivateType;
//    [self.navigationController pushViewController:rvc animated:YES];
    DetailWebViewController * rvc = [[DetailWebViewController alloc] init];
    rvc.urlStr = kPrivacyUrl;
    rvc.title = @"隐私政策";
    [self.navigationController pushViewController:rvc animated:YES];
}
#pragma mark - private methods
- (BOOL)registerValidate{
    //去空格
    mobileStr = [_mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (self.accountType != UserModifyPasswordType){
        if(mobileStr.length == 0){
            [self showJXNoticeMessage:@"请输入手机号"];
            return NO;
        }else{
            if (![NSString validateTelephone:mobileStr]){
                [self showJXNoticeMessage:@"手机号输入有误"];
                return NO;
            }
        }
    }
    
    if(_verficationTextField.text.length == 0){
        [self showJXNoticeMessage:@"请输入验证码"];
        return NO;
    }else{
        if (![NSString validateVerficationCode:_verficationTextField.text]){
            [self showJXNoticeMessage:@"验证码格式错误"];
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
    if (self.accountType == UserModifyPasswordType){
        if (![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
            [self showJXNoticeMessage:@"两次密码输入不一致"];
            return NO;
        }
    }else if(self.accountType == UserRegisterAccountType && _confirmPasswordTextField.text.length){
        if (![NSString validateInvitationCode: _confirmPasswordTextField.text]) {
            [self showJXNoticeMessage:@"邀请码输入有误"];
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)verficationValidate{
    
    if (self.accountType != UserModifyPasswordType){
        //去空格
        mobileStr = [_mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(mobileStr.length == 0){
            [self showJXNoticeMessage:@"请输入手机号"];
            return NO;
        }else{
            if (![NSString validateTelephone:mobileStr]){
                [self showJXNoticeMessage:@"手机号输入有误"];
                return NO;
            }
        }
    }
    return YES;
}
- (void)autoLogin:(NSString *)msg{
    
    [[UserRequest shareManager] userLogin:kApiUserLogin param:@{@"ua":mobileStr,@"Up":_passwordTextField.text} success:^(id object,NSString *msg) {
        NSLog(@"app用户登陆成功");
        EMError *error = [[EMClient sharedClient] loginWithUsername:[UserDBManager shareManager].HxAccount password:[UserDBManager shareManager].HxPassword];
        if (!error) {
            NSLog(@"环信登陆成功");
            [_activityView stopAnimating];
            [self handleLoginSuccessResult:msg];
        }else{
            NSLog(@"环信登陆失败，重试...");
            EMError *subError = [[EMClient sharedClient] loginWithUsername:[UserDBManager shareManager].HxAccount password:[UserDBManager shareManager].HxPassword];
            if (!subError) {
                NSLog(@"环信登陆成功");
                [_activityView stopAnimating];
                [self handleLoginSuccessResult:msg];
            }else{
                NSLog(@"环信登陆失败");
                [self showJXNoticeMessage:@"自动登录失败"];
                [_activityView stopAnimating];
                [_registerButton setTitle:@"同意协议并注册" forState:UIControlStateNormal];
            }
        }
        
    } failure:^(id object,NSString *msg) {
        NSLog(@"app用户登陆失败");
        [self showJXNoticeMessage:msg];
        [_activityView stopAnimating];
        [_registerButton setTitle:@"同意协议并注册" forState:UIControlStateNormal];
    }];

}
- (void)handleLoginSuccessResult:(NSString *)msg{
    [_registerButton setTitle:@"同意协议并注册" forState:UIControlStateNormal];
    //设置是否自动登录
    [[EMClient sharedClient].options setIsAutoLogin:YES];
    
    //获取数据库中数据
    //[MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] dataMigrationTo3];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showJXNoticeMessage:msg];
            [[ChatUtil shareHelper] asyncGroupFromServer];
            [[ChatUtil shareHelper] asyncConversationFromDB];
            [[ChatUtil shareHelper] asyncPushOptions];
            //[MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            
            [CloudPushSDK bindAccount:[NSString stringWithFormat:@"user%@",[UserDBManager shareManager].UserID] withCallback:^(CloudPushCallbackResult *res) {
                if (res.success){
                    NSLog(@"阿里推送绑定账号成功");
                }else{
                    NSLog(@"阿里推送绑定账号失败：%@",res.error);
                }
            }];
            //保存最近一次登录用户名
            //[weakself saveLastLoginUsername];
            //存储手机号，用于判断登录用户是否为新用户，以及快捷登录
            [kUserDefaults setObject:mobileStr forKey:UDKEY_MobileNumber];
            [kUserDefaults setObject:_passwordTextField.text forKey:UDKEY_Password];
            [kUserDefaults synchronize];
            //切换用户，清除通知消息
            if ([[NotificationManager shareManager] isExist:NotificationDBName]){
                [[NotificationManager shareManager] deleteData:NotificationDBName];
                [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadSystemMessagesNotification object:@NO];
            }
            ModifyInformationViewController * mvc =[[ModifyInformationViewController alloc ]init ];
            mvc.registerSuccessEnter = YES;
            [self.navigationController pushViewController:mvc animated:YES];
            
        });
    });
    
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

- (void)textChange:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[UITextField class]]) {
        //UITextField * textField = (UITextField *)notification.object;
        if (_mobileTextField.text.length && _verficationTextField.text.length && _passwordTextField.text.length) {
            _registerButton.enabled = YES;
            [_registerButton setTitleColor:JX333333Color forState:UIControlStateNormal];
            [_registerButton setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
        }else{
            _registerButton.enabled = NO;
            [_registerButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
            [_registerButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
        }
        
        if (self.accountType == UserModifyPasswordType) {
            if (_confirmPasswordTextField.text.length) {
                _registerButton.enabled = YES;
                [_registerButton setTitleColor:JX333333Color forState:UIControlStateNormal];
                [_registerButton setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
            }else{
                _registerButton.enabled = NO;
                [_registerButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
                [_registerButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
            }
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_mobileTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_verficationTextField resignFirstResponder];
}
@end
