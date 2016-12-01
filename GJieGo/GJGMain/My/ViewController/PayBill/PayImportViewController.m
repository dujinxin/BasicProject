//
//  PayImportViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "PayImportViewController.h"
#import "PayBillViewController.h"

@interface PayImportViewController ()<UITextFieldDelegate>{
    UILabel          *   _menuLabel;
    UILabel          *   _payLabel;
    UITextField      *   _payTextField;
    
    UILabel          *   _saveLabel;
    UITextField      *   _saveTextField;
    
    UIButton         *   _nextButton;
}

@end

@implementation PayImportViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)loadView{
    [super loadView];
    self.title = @"买单";
    
    _menuLabel = [UILabel new];
    _payLabel = [UILabel new];
    _payTextField = [UITextField new];
    _saveLabel = [UILabel new];
    _saveTextField = [UITextField new];
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self setSubView];
    [self layoutSubView];
}

- (void)layoutSubView{
    [_menuLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(kNavStatusHeight +11);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(14);
    }];
    [_payLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuLabel.bottom).offset(27);
        make.left.equalTo(self.view).offset(0);
        make.width.equalTo(_menuLabel);
        make.height.equalTo(14);
    }];
    [_payTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(_payLabel.bottom).offset(11);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(70);
    }];
    [_saveLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payTextField.bottom).offset(10);
        make.left.equalTo(self.view).offset(0);
        make.width.equalTo(_menuLabel);
        make.height.equalTo(36);
    }];
    [_saveTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(_saveLabel.bottom).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(70);
    }];
    [_nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveTextField.bottom).offset(70);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(44);
    }];
}
- (void)setSubView{
    
    _menuLabel.backgroundColor = JXClearColor;
    _menuLabel.textAlignment = NSTextAlignmentCenter;
    _menuLabel.text = @"菜名";
    _menuLabel.textColor = JX333333Color;
    _menuLabel.font  = JXFontForNormal(14);
    [self.view addSubview:_menuLabel];
    
    _payLabel.backgroundColor = JXClearColor;
    _payLabel.textAlignment = NSTextAlignmentCenter;
    _payLabel.text = @"请输入金额";
    _payLabel.textColor = JX999999Color;
    _payLabel.font  = JXFontForNormal(14);
    [self.view addSubview:_payLabel];

    
    _payTextField.backgroundColor = JXFfffffColor;
    _payTextField.borderStyle = UITextBorderStyleNone;
    _payTextField.leftViewMode = UITextFieldViewModeAlways;
    //_payTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _payTextField.textAlignment = NSTextAlignmentCenter;
    _payTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _payTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _payTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _payTextField.delegate = self;
    _payTextField.placeholder = @"请在此输入";
    [self.view addSubview:_payTextField];
    
    
    _saveLabel.backgroundColor = JXClearColor;
    _saveLabel.textAlignment = NSTextAlignmentCenter;
    _saveLabel.text = @"不参与折扣的金额";
    _saveLabel.textColor = JX999999Color;
    _saveLabel.font  = JXFontForNormal(14);
    [self.view addSubview:_saveLabel];
    
    _saveTextField.backgroundColor = JXFfffffColor;
    _saveTextField.borderStyle = UITextBorderStyleNone;
    _saveTextField.leftViewMode = UITextFieldViewModeAlways;
    //_saveTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _saveTextField.textAlignment = NSTextAlignmentCenter;
    _saveTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _saveTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _saveTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _saveTextField.delegate = self;
    _saveTextField.placeholder = @"请在此输入";
    [self.view addSubview:_saveTextField];

    
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
    //[_nextButton setBackgroundColor:JX999999Color];
    [_nextButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
    _nextButton.layer.cornerRadius = 5.f;
    _nextButton.enabled = NO;
    [_nextButton addTarget:self action:@selector(nextStepClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
}
- (void)textChange:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[UITextField class]]) {
        //UITextField * textField = (UITextField *)notification.object;
        if (_payTextField.text.length) {
            _nextButton.enabled = YES;
            [_nextButton setTitleColor:JX333333Color forState:UIControlStateNormal];
            [_nextButton setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
        }else{
            _nextButton.enabled = NO;
            [_nextButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
            [_nextButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
        }
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
#pragma mark - Click events
- (void)nextStepClick:(UIButton *)button{
    PayBillViewController * bvc = [[PayBillViewController alloc ]init ];
    [self.navigationController pushViewController:bvc animated:YES];
}
@end
