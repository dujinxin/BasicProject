//
//  IntroductionViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/5/30.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "IntroductionViewController.h"

static CGFloat PayBillViewHeight = 221;

@interface IntroductionViewController (){
    UIView         * _headView;
    UIImageView    * _headImageView;
    UITextView     * _textView;
}

@end

@implementation IntroductionViewController

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
    
    switch (self.type) {
        case IntroductionPrivateType:
        {
            self.title = @"用户协议";
            _textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget odio.（显示逛街购b端APP以及逛街购的一些介绍信息，具体内容由运营人员给出文字）";
        }
            break;
        case IntroductionCompanyType:
        {
            self.title = @"公司介绍";
            [self setHeadView];
            _headImageView.image = JXImageNamed(@"bg");
            _textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget odio.（显示逛街购b端APP以及逛街购的一些介绍信息，具体内容由运营人员给出文字）";
        }
            break;
        case IntroductionTeamType:
        {
            self.title = @"团队介绍";
            [self setHeadView];
            _headImageView.image = JXImageNamed(@"bg");
            _textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget odio.（显示逛街购b端APP以及逛街购的一些介绍信息，具体内容由运营人员给出文字）";
        }
            break;
        case IntroductionOrderType:
        {
            self.title = @"买单流程";
            _textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget odio.（显示逛街购b端APP以及逛街购的一些介绍信息，具体内容由运营人员给出文字）";
        }
            break;
        default:
            break;
    }
     [self layoutSubView];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    
    _textView = [[UITextView alloc ]initWithFrame:CGRectZero];
    _textView.textColor = JX999999Color;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.font = JXFontForNormal(13);
    _textView.backgroundColor = JXFfffffColor;
    _textView.editable = NO;
    _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    [self.view addSubview:_textView];
}
#pragma mark - subView init

- (void)setHeadView{
    
    _headView = [[UIView alloc ]init ];
    _headView.backgroundColor = JXF1f1f1Color;
    _headView.frame = CGRectMake(10, 10 +kNavStatusHeight, kScreenWidth -20, PayBillViewHeight);
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(0, 0, kScreenWidth -20, PayBillViewHeight);
    [_headView addSubview:_headImageView];
    [self.view addSubview:_headView];
    
}
- (void)layoutSubView{
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        if (_type == IntroductionPrivateType || _type == IntroductionOrderType) {
            make.top.equalTo(self.view).offset(10 +kNavStatusHeight);
        }else{
            make.top.equalTo(_headView.bottom).offset(10);
        }
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

@end
