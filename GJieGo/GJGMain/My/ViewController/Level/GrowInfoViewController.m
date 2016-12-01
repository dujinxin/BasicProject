//
//  GrowInfoViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/28.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "GrowInfoViewController.h"

#define kDebug

@interface GrowInfoViewController (){
    UIView * _headView;
    UIView * _contentView;
    UILabel* _bottomView;
    
    
}

@end

@implementation GrowInfoViewController

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
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"什么是成长值";
    
    _headView = [UIView new];
    _contentView = [UIView new];
    _bottomView = [UILabel new];
    
    _headView.backgroundColor = JXFfffffColor;
    _contentView.backgroundColor = JXFfffffColor;
    _bottomView.backgroundColor = JXClearColor;
    
    _bottomView.numberOfLines = 0;
    _bottomView.textColor = JX999999Color;
    _bottomView.font = JXFontForNormal(11);
    _bottomView.textAlignment = NSTextAlignmentCenter;
    _bottomView.text = @"除了成长任务获得的成长值外，每个逛街购的小伙伴最多获得50个成长值哦~~";
    
    [self.view addSubview:_headView];
    [self.view addSubview:_contentView];
    [self.view addSubview:_bottomView];
    
    [self layoutSubview];
    
    [self addHeadSubviews];
    [self addContentSubviews];
}
- (void)layoutSubview{
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavStatusHeight);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(_headView.bottom).offset(10);
        make.height.mas_equalTo(200);
    }];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.top.equalTo(_contentView.bottom).offset(59);
        make.height.mas_equalTo(30);
    }];
}
- (void)addHeadSubviews{
    UILabel * titleView = [UILabel new];
    titleView.text = @"成长值的作用";
    titleView.textColor = JXff5252Color;
    titleView.textAlignment = NSTextAlignmentLeft;
    titleView.font = JXFontForNormal(13);
    titleView.backgroundColor = JXDebugColor;
    [_headView addSubview:titleView];
    
    UIView * point = [UIView new];
    point.backgroundColor = [UIColor blackColor];
    point.layer.cornerRadius = 2;
    [_headView addSubview:point];
    
    UILabel * contentView = [UILabel new];
//    contentView.text = @"公司法师法师打发士大夫似的放松放松的方式的发生地方师傅的说法是发生地方师傅师傅师傅身上的发生的放松放松法第三方士大夫";
    contentView.textColor = JX333333Color;
    contentView.textAlignment = NSTextAlignmentLeft;
    contentView.font = JXFontForNormal(12);
    contentView.numberOfLines = 0;
    contentView.backgroundColor = JXDebugColor;
    [_headView addSubview:contentView];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 6;
    //paragraphStyle.paragraphSpacing = 6;

    NSString * s = @"公司法师法师打发士大夫似的放松放松的方式的发生地方师傅的说法是发生地方师傅师傅师傅身上的发生的放松放松法第三方士大夫";
  
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{NSFontAttributeName:contentView.font,NSParagraphStyleAttributeName:paragraphStyle};
    CGRect rect = [s boundingRectWithSize:CGSizeMake(kScreenWidth -40, 1000) options:option attributes:attributes context:nil];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:s];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    contentView.attributedText = attStr;
    
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView).offset(10);
        make.left.equalTo(_headView).offset(15);
        make.right.equalTo(_headView).offset(-15);
        make.height.mas_equalTo(13);
    }];
    [point makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.bottom).offset(15);
        make.left.equalTo(_headView).offset(15);
        make.size.equalTo(CGSizeMake(4, 4));
    }];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(point.right).offset(11);
        make.top.equalTo(titleView.bottom).offset(14);
        make.size.equalTo(rect.size);
    }];
    [_headView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(50 +rect.size.height);
    }];
    
}
- (void)addContentSubviews{
    UILabel * titleView = [UILabel new];
    titleView.text = @"如何获取成长值";
    titleView.textColor = JXff5252Color;
    titleView.textAlignment = NSTextAlignmentLeft;
    titleView.font = JXFontForNormal(13);
    titleView.backgroundColor = JXDebugColor;
    [_contentView addSubview:titleView];
    
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(10);
        make.left.equalTo(_contentView).offset(15);
        make.right.equalTo(_contentView).offset(-15);
        make.height.mas_equalTo(13);
    }];
    NSArray * leftTitles = @[@"登录",@"收到新的赞",@"成功评论",@"分享到微信、QQ、微博",@"晒单"];
    NSArray * rightTitles = @[@"+1 成长点",@"+1 成长点",@"+2 成长点",@"+3 成长点",@"+5 成长点"];
    
    
    for (int i = 0; i < leftTitles.count; i ++) {
        UILabel * leftLabel = [UILabel new];
        UILabel * rightLabel = [UILabel new];
        
        [_contentView addSubview:rightLabel];
        [_contentView addSubview:leftLabel];
        
        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contentView.right).offset(-40);
            make.top.equalTo(titleView.bottom).offset(13 +32.5*i);
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(80);
        }];
        [leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(titleView.bottom).offset(13 +32.5*i);
            make.height.mas_equalTo(13);
            make.right.equalTo(rightLabel.left).offset(10);
        }];
        if (i < leftTitles.count -1){
            UIView  * line = [UIView new];
            [_contentView addSubview:line];
            line.backgroundColor = JXSeparatorColor;
            
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(28);
                make.top.mas_equalTo(titleView.bottom).offset(35.5 +32.5*i);
                make.height.mas_equalTo(0.5);
                make.right.equalTo(_contentView.right).offset(-28);
            }];
        }
        
        leftLabel.text = leftTitles[i];
        leftLabel.textColor = JX333333Color;
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.font = JXFontForNormal(13);
        leftLabel.backgroundColor = JXDebugColor;
        
        NSInteger length = [rightTitles[i] length];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:rightTitles[i]];
        [attStr addAttribute:NSForegroundColorAttributeName value:JXff5252Color range:NSMakeRange(0, length -3)];
        [attStr addAttribute:NSForegroundColorAttributeName value:JX333333Color range:NSMakeRange(length -3, 3)];
        rightLabel.attributedText = attStr;

        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = JXFontForNormal(13);
        rightLabel.backgroundColor = JXDebugColor;
        
        
    }
    
    [_contentView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(_headView.bottom).offset(10);
        make.height.mas_equalTo(32 +32.5*leftTitles.count);
    }];
}

@end
