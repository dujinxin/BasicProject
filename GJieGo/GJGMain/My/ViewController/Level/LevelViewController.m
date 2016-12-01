//
//  LevelViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "LevelViewController.h"
#import "GrowInfoViewController.h"
#import "ModifyInformationViewController.h"
#import "ShareViewController.h"
#import "DetailWebViewController.h"

#import "LevelView.h"
#import "JXProgressView.h"

static CGFloat headViewTopHeight = 225.f;
static CGFloat headViewBottomHeight = 145.f;

@interface LevelViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UIView         * _headView;
    UIImageView    * bgImageView;
    UIView         * _growView;
    UIView         * _levelView;
    
    UIImageView    * _userImageView;
    LevelView      * _level;
    UILabel        * _nameLabel;
    
    UILabel        * label1;//成长值
    UILabel        * label2;//成长值说明
    UILabel        * label3;//还需多少成长值
    JXProgressView * progress;//等级
    UISegmentedControl * _levelTitle;

    NSMutableArray * _levelArray;
    UITableView    * _tableView;
    NSMutableArray * _dataArray;
    
    UIImageView    * percentImage;
    UILabel        * percentTitle;
    NSString       * growPoint;
    CGFloat        percentPoint;
    CGFloat        currentPoint;
    CGFloat        nextPoint;
    CGFloat        fullPoint;
}

@end

@implementation LevelViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    JXWeakSelf(self);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        [[UserRequest shareManager] userLevelList:kApiLevelList param:nil success:^(id object,NSString *msg) {
            _levelArray = [NSMutableArray arrayWithArray:(NSArray *)object];
            [weakSelf setLevelView:_levelArray];
            [weakSelf calculateGrowLevel];
            NSLog(@"等级：%@",object);
        } failure:^(id object,NSString *msg) {
            //
        }];
    });
    dispatch_group_async(group, queue, ^{
        [[UserRequest shareManager] userTaskList:kApiTaskList param:nil success:^(id object,NSString *msg) {
            NSArray * array = (NSArray *)object;
            _dataArray = [NSMutableArray arrayWithArray:array];
            [_tableView reloadData];
        } failure:^(id object,NSString *msg) {
            //
        }];
    });
    dispatch_group_async(group, queue, ^{
        [[UserRequest shareManager] userLevel:kApiUserLevel param:nil success:^(id object,NSString *msg) {
            UserLevelEntity * entity = (UserLevelEntity *)object;
            NSLog(@"成长值：%@",entity.GrowthValue);
            NSString * s1 = @"成长值:";
            NSString * s2 = entity.GrowthValue;
            growPoint = entity.GrowthValue;
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",s1,s2]];
            [attStr addAttribute:NSForegroundColorAttributeName value:JX333333Color range:NSMakeRange(0, s1.length)];
            [attStr addAttribute:NSForegroundColorAttributeName value:JXff5252Color range:NSMakeRange(s1.length, s2.length)];
            label1.attributedText = attStr;
            [weakSelf calculateGrowLevel];
        } failure:^(id object,NSString *msg) {
            //
        }];
    });
    [_tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!_isShowNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:_userDetailEntity.HeadPortrait] placeholderImage:JXImageNamed(@"portrait_default")];
    _nameLabel.text = _userDetailEntity.UserName;
    [_level setLevelNum:[NSString stringWithFormat:@"V%@",_userDetailEntity.UserLevel] levelTitle:_userDetailEntity.UserLevelName];
    
    //    _dataArray = [NSMutableArray arrayWithArray:@[@"注册",@"完善资料",@"粉丝数量超过10",@"粉丝数量超过50",@"粉丝数量超过100"]];
    //    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    
    [self setHeadView];
    [self setNavigationBar];
    [self layoutSubView];
}
#pragma mark - 计时方法
- (void)timerFireMethod:(NSTimer *)theTimerP
{
    if (currentPoint < percentPoint) {
        currentPoint +=1;
        //percentTitle.text = [NSString stringWithFormat:@"%d%%",(int)((currentPoint/fullPoint)*100)];
        percentTitle.text = [NSString stringWithFormat:@"%d/%d",(int)currentPoint,(int)nextPoint];
    }else{
        [theTimerP invalidate];
    }
    
}
#pragma mark - subView init
- (void)setNavigationBar{
    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:JXImageNamed(@"white_back") forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIView * navigationBar = [self setNavigationBar:@"等级与成长值" backgroundColor:JXClearColor leftItem:left rightItem:nil delegete:self];
    navigationBar.frame = CGRectMake(0, 0, kScreenWidth, kNavStatusHeight);
    [self.view addSubview:navigationBar];
}
- (void)setHeadView{

    CGFloat headViewHeight = headViewTopHeight + headViewBottomHeight;
    _headView = [[UIView alloc ]init ];
    _headView.backgroundColor = [UIColor clearColor];
    _headView.frame = CGRectMake(0, -headViewHeight, kScreenWidth, headViewHeight);
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.1;
    _tableView.backgroundColor = JXF1f1f1Color;
    [self.view addSubview:_tableView];
    
    _tableView.contentInset = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(0, -headViewHeight, kScreenWidth, headViewTopHeight);
    bgImageView.image = [UIImage imageNamed:@"bg"];
    [_tableView addSubview:bgImageView];
    
    
    UIImageView * _userBgImageView=[[UIImageView alloc]init];
    _userBgImageView.image=[UIImage imageNamed:@"portrait_storke"];
    _userBgImageView.frame=CGRectMake((kScreenWidth-71.0)/2, 64 +20, 71, 71);
    _userBgImageView.layer.cornerRadius = 71.0/2;
    _userBgImageView.clipsToBounds = YES;
    _userBgImageView.userInteractionEnabled = YES;
    [_headView addSubview:_userBgImageView];
    
    _userImageView =[[UIImageView alloc]init];
    _userImageView.image=[UIImage imageNamed:@"portrait_default"];
    _userImageView.frame =CGRectMake((kScreenWidth-65.0)/2, 64 +20 +3, 65, 65);
    _userImageView.layer.cornerRadius = 65.0/2;
    _userImageView.clipsToBounds = YES;
    _userImageView.userInteractionEnabled = YES;
    [_headView addSubview:_userImageView];
    

    UIView * _BGView = [[UIView alloc]init];
    _BGView.backgroundColor =[UIColor clearColor];
    _BGView.frame =CGRectMake(0, -headViewHeight, kScreenWidth, headViewHeight);
    
    [_tableView addSubview:_headView];
    //[_tableView addSubview:_BGView];
    //[_tableView addSubview:navigationBar];
    
    
    //
    _level = [[LevelView alloc ]initWithFrame:CGRectMake(0, CGRectGetMaxY(_userBgImageView.frame)+14, kScreenWidth, 12)];
    _level.titleLabel.textColor = JXFfffffColor;
    [_headView addSubview:_level];
    

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text =@"超级购物狂";
    _nameLabel.textColor = JXFfffffColor;
    _nameLabel.font = JXFontForNormal(13);
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.frame = CGRectMake(0, CGRectGetMaxY(_level.frame)+8, kScreenWidth, 13);
    [_headView addSubview:_nameLabel];
    
//    _growView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame) + 10, kScreenWidth, headViewBottomHeight)];
    _growView = [[UIView alloc]initWithFrame:CGRectMake(0, headViewTopHeight, kScreenWidth, headViewBottomHeight)];
    _growView.backgroundColor = JXFfffffColor;
    _growView.userInteractionEnabled = YES;
    [_headView addSubview:_growView];
    
    _levelView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame) + 20, kScreenWidth, headViewBottomHeight)];
    _levelView.backgroundColor = JXFfffffColor;
    [_headView addSubview:_levelView];
    
    [_growView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView).equalTo(0);
//        make.top.equalTo(_nameLabel.bottom).equalTo(10);
        make.top.equalTo(_headView.top).equalTo(headViewTopHeight);
        make.height.equalTo(44.5);
        make.right.equalTo(_headView);
    }];
    [_levelView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView);
        make.top.equalTo(_growView.bottom).equalTo(0);
        make.height.equalTo(100.5);
        make.right.equalTo(_headView);
    }];
    
    [self addGrowView];
    [self addLevelView];
  
}
- (void)addGrowView{
    CALayer * layer = [CALayer layer];
    layer.backgroundColor = JXSeparatorColor.CGColor;
    [_growView.layer addSublayer:layer];
    layer.frame = CGRectMake(15, 0, kScreenWidth -30, 0.5);
    
    label1 = [[UILabel alloc ] init];
    label1.text = @"成长值:0";
    label1.textColor = JXff5252Color;
    label1.font = JXFontForNormal(13);
    
    label1.textAlignment = NSTextAlignmentLeft;
    label1.backgroundColor = JXClearColor;
    [_growView addSubview:label1];
    
    label2 = [[UILabel alloc ] init];
    label2.text = @"什么是成长值";
    label2.textColor = JX999999Color;
    label2.font = JXFontForNormal(11);
    label2.textAlignment = NSTextAlignmentRight;
    label2.backgroundColor = JXClearColor;
    label2.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(grow:)];
    [label2 addGestureRecognizer:tap];
    [_growView addSubview:label2];
    
    
    UIImageView * arrow =[[UIImageView alloc]init];
    arrow.image =[UIImage imageNamed:@"list_arrow"];
    [_growView addSubview:arrow];
    
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_growView).equalTo(17.5);
        make.height.equalTo(9);
        make.width.equalTo(5);
        make.right.equalTo(_growView.right).offset(-22);
    }];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_growView).equalTo(5);
        make.height.equalTo(34.5);
        make.width.equalTo(120);
        make.right.equalTo(arrow.left).offset(-7);
    }];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_growView).equalTo(22);
        make.top.equalTo(_growView).equalTo(5);
        make.height.equalTo(34.5);
        make.right.equalTo(label2.left);
    }];
}
- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}
- (void)addLevelView{
    CALayer * layer2 = [CALayer layer];
    layer2.backgroundColor = JXSeparatorColor.CGColor;
    [_levelView.layer addSublayer:layer2];
    layer2.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
    
    
    [self addPercentView];
    percentTitle.text = @"0%";
    
    progress = [[JXProgressView alloc ]initWithFrame:CGRectMake(22*kPercent, 27, kScreenWidth -44*kPercent, 3)];
    [progress setProgress:0.0];
    __block UIImageView * weakImageView = percentImage;
    [progress setProgress:0.0 animations:^{
        weakImageView.frame = CGRectMake(22*kPercent -12 +(kScreenWidth -44*kPercent)*0.01, 12, 40, 12);
    } completion:^(BOOL finished) {}];
    [_levelView addSubview:progress];
    
}
- (void)addPercentView{
    percentImage = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 12, 40, 12) ];
    percentImage.contentMode = UIViewContentModeScaleToFill;
    //percentImage.image = [JXImageNamed(@"bar_number_bg") stretchableImageWithLeftCapWidth:6 topCapHeight:6];
    //percentImage.image = [JXImageNamed(@"bar_number_bg") resizableImageWithCapInsets:UIEdgeInsetsMake(6, 13, 0, 12) resizingMode:UIImageResizingModeStretch];

    percentImage.image = JXImageNamed(@"bar_number_bg");
    [_levelView addSubview:percentImage];
    
    percentTitle = [[UILabel alloc ]initWithFrame:CGRectMake(0, 0, 40, 10)];
    percentTitle.backgroundColor = JXClearColor;
    percentTitle.textColor = JXFfffffColor;
    percentTitle.font = JXFontForNormal(8);
    percentTitle.textAlignment = NSTextAlignmentCenter;
    [percentImage addSubview:percentTitle];
}
#pragma mark - Click Events
- (void)back:(UIButton *)button{
    _isShowNavigationBar = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)grow:(UITapGestureRecognizer *)tap{
//    GrowInfoViewController * gvc = [[GrowInfoViewController alloc ]init ];
//    [self.navigationController pushViewController:gvc animated:YES];
    
    DetailWebViewController * rvc = [[DetailWebViewController alloc] init];
    rvc.urlStr = kGrowLevelUrl;
    rvc.title = @"什么是成长值";
    [self.navigationController pushViewController:rvc animated:YES];
}
- (void)setLevelView1:(NSArray *)array{
    NSMutableArray * titleArray = [NSMutableArray array ];
    for (int i = 0; i < array.count; i ++) {
        LevelEntity * entity = array[i];
        [titleArray addObject:entity.LevelName];
    }
    //NSArray * titleArray = @[@"lv.1",@"lv.2",@"lv.3",@"lv.4",@"lv.5",@"lv.6",@"lv.7"];
    _levelTitle = [[UISegmentedControl alloc ]initWithItems:titleArray];
    _levelTitle.tintColor = JXClearColor;
    NSDictionary * unselectedAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12],NSForegroundColorAttributeName:JX333333Color,NSBackgroundColorAttributeName:JXClearColor};
    [_levelTitle setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    [_levelView addSubview:_levelTitle];
    
    
    label3 = [[UILabel alloc ] init];
    label3.text = @"再有170个成长值就升级到lv.2了哦";
    label3.textColor = JX999999Color;
    label3.font = JXFontForNormal(11);
    label3.textAlignment = NSTextAlignmentLeft;
    label3.backgroundColor = [UIColor whiteColor];
    [_levelView addSubview:label3];
    
    [_levelTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_levelView).equalTo(5);
        make.top.equalTo(progress.bottom).equalTo(9);
        make.height.equalTo(12);
        make.right.equalTo(_levelView.right).offset(-5);
    }];
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_levelView).offset(22);
        make.top.equalTo(_levelTitle.bottom).equalTo(20);
        make.height.equalTo(11);
        make.right.equalTo(_levelView.right).offset(-22);
    }];
}
- (void)calculateGrowLevel1{
    if (growPoint && _levelArray.count) {
        LevelEntity * lastEntity = (LevelEntity *)_levelArray.lastObject;
        fullPoint = lastEntity.Points.floatValue;
        currentPoint = 0.f;
        percentPoint = growPoint.floatValue;
        LevelEntity * entity;
        LevelEntity * entity1;
        for (int i = 0;  i< _levelArray.count; i ++) {
            entity = _levelArray[i];
            
            if (entity.Points.floatValue <= growPoint.floatValue) {
                if (i < _levelArray.count -1) {
                    entity1 = _levelArray[i +1];
                    label3.text = [NSString stringWithFormat:@"再有%ld个成长值就升级到%@了哦",entity1.Points.integerValue -growPoint.integerValue,entity1.LevelName];
                    nextPoint = entity1.Points.floatValue;
                    
                }else{
                    label3.text = [NSString stringWithFormat:@"您已经满级了哦"];
                    percentPoint = entity.Points.floatValue;
                    nextPoint = entity.Points.floatValue;
                }
                
            }
        }
        
        __block UIImageView * weakImageView = percentImage;
        __block UILabel     * weakLabel = percentTitle;
        //        CGFloat progressFloat = fullPoint >0 ? percentPoint/fullPoint:0;
        CGFloat progressFloat = 0;
        CGFloat oldProgress = percentPoint/_levelArray.count;
        CGFloat newProgress = ((percentPoint -entity.Points.floatValue)/nextPoint)/_levelArray.count;
        if (fullPoint >0) {
            progressFloat = oldProgress +newProgress;
        }
        NSString * text = [NSString stringWithFormat:@"%d/%d",(int)percentPoint,(int)nextPoint];
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:percentTitle.font forKey:NSFontAttributeName];
        CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes context:nil];
        //        percentImage.frame = CGRectMake(0, 12, rect.size.width +4, 12);
        //        percentTitle.frame = CGRectMake(0, 0, rect.size.width +2, 10);
        //        percentTitle.text = [NSString stringWithFormat:@"%d/%d",(int)percentPoint,(int)nextPoint];
        
        [progress setProgress:progressFloat animations:^{
            weakImageView.frame = CGRectMake(32 -12 +(kScreenWidth -44)*progressFloat, 12, rect.size.width +4, 12);
            weakLabel.frame = CGRectMake(0, 0, rect.size.width +2, 10);
            weakLabel.text = text;
        } completion:^(BOOL finished) {}];

        //启动定时器
        //[NSTimer scheduledTimerWithTimeInterval:1.f/(percentPoint) target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }
}
- (void)setLevelView:(NSArray *)array{

    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:11] forKey:NSFontAttributeName];
    CGRect rect = [@"lv.3" boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes context:nil];
    for (int i = 0; i < array.count;  i ++) {
        LevelEntity * entity = array[i];
        
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:11];
        //lab.backgroundColor = [UIColor redColor];
        lab.adjustsFontSizeToFitWidth = YES;
        lab.text = entity.LevelName;
        [_levelView addSubview:lab];
        
        rect.size.width = 16.3;
        [lab makeConstraints:^(MASConstraintMaker *make) {
            switch (i) {
                case 0:
                    make.left.equalTo(_levelView).equalTo(22*kPercent + rect.size.width *i*kPercent);
                    break;
                case 1:
                    make.left.equalTo(_levelView).equalTo(22*kPercent + rect.size.width *i +18.f/2*kPercent);
                    break;
                case 2:
                    make.left.equalTo(_levelView).equalTo(22*kPercent + rect.size.width *i +(18.f +52.f)/2*kPercent);
                    break;
                case 3:
                    make.left.equalTo(_levelView).equalTo(22*kPercent + rect.size.width *i +(18.f +52.f +142.f)/2*kPercent);
                    break;
                case 4:
                    make.right.equalTo(_levelView.right).equalTo(-22*kPercent);
                    //make.left.equalTo(_levelView).equalTo(22*kPercent + rect.size.width *i +(18.f +52.f +142.f +287.f)/2*kPercent);
                    break;
            }
            make.top.equalTo(progress.bottom).equalTo(9);
            make.height.equalTo(12);
            make.width.equalTo(rect.size.width*kPercent);
        }];
    }
    
    label3 = [[UILabel alloc ] init];
    label3.text = @"再有170个成长值就升级到lv.2了哦";
    label3.textColor = JX999999Color;
    label3.font = JXFontForNormal(11);
    label3.textAlignment = NSTextAlignmentLeft;
    label3.backgroundColor = [UIColor whiteColor];
    [_levelView addSubview:label3];
    
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_levelView).offset(22);
        make.top.equalTo(progress.bottom).equalTo(20 +9+12);
        make.height.equalTo(11);
        make.right.equalTo(_levelView.right).offset(-22);
    }];
}
- (void)calculateGrowLevel{
    if (growPoint && _levelArray.count) {
        LevelEntity * lastEntity = (LevelEntity *)_levelArray.lastObject;
        fullPoint = lastEntity.Points.floatValue;
        currentPoint = 0.f;
        percentPoint = growPoint.floatValue;
//        percentPoint = 6000;
        LevelEntity * entity;
        LevelEntity * entity1;
        for (int i = 0;  i< _levelArray.count; i ++) {
            entity = _levelArray[i];
            
            if (entity.Points.floatValue <= growPoint.floatValue) {
                if (i < _levelArray.count -1) {
                    entity1 = _levelArray[i +1];
                    label3.text = [NSString stringWithFormat:@"再有%ld个成长值就升级到%@了哦",entity1.Points.integerValue -growPoint.integerValue,entity1.LevelName];
                    nextPoint = entity1.Points.floatValue;
                    
                }else{
                    label3.text = [NSString stringWithFormat:@"您已经满级了哦"];
                    percentPoint = entity.Points.floatValue;
                    nextPoint = entity.Points.floatValue;
                }
                
            }
        }
        
        __block UIImageView * weakImageView = percentImage;
        __block UILabel     * weakLabel = percentTitle;
        CGFloat progressFloat = fullPoint >0 ? percentPoint/fullPoint:0;

        NSString * text = [NSString stringWithFormat:@"%d/%d",(int)percentPoint,(int)nextPoint];
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:percentTitle.font forKey:NSFontAttributeName];
        CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes context:nil];
        
        [progress setProgress:progressFloat animations:^{
            weakImageView.frame = CGRectMake(22*kPercent -(rect.size.width +4)/2 +(kScreenWidth -44*kPercent)*progressFloat, 12, rect.size.width +4, 12);
            weakLabel.frame = CGRectMake(0, 0, rect.size.width +2, 10);
            weakLabel.text = text;
        } completion:^(BOOL finished) {}];
        
        //启动定时器
        //[NSTimer scheduledTimerWithTimeInterval:1.f/(percentPoint) target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = JXF1f1f1Color;
    
    CALayer * layer = [CALayer layer];
    layer.backgroundColor = JXSeparatorColor.CGColor;
    [headerView.layer addSublayer:layer];
    layer.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame)/2, CGRectGetWidth(headerView.frame), 0.5);
    
    UILabel * textView = [[UILabel alloc ]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textView.text = @"成长任务";
    textView.textColor = JX999999Color;
    textView.font = JXFontForNormal(12);
    textView.textAlignment = NSTextAlignmentCenter;
    textView.backgroundColor = JXF1f1f1Color;
    [headerView addSubview:textView];
    textView.center = headerView.center;
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = JX333333Color;
        cell.textLabel.font = JXFontForNormal(13);
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 17, 5, 9)];
        [arrow setImage:JXImageNamed(@"list_arrow")];
        arrow.tag = 10;
        [cell.contentView addSubview:arrow];
        
        UILabel * infoLabel = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMidX(arrow.frame) -100, 0, 90, 44)];
        infoLabel.text = @"成长任务";
        infoLabel.textColor = JX333333Color;
        infoLabel.font = JXFontForNormal(11);
        infoLabel.tag = 11;
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:infoLabel];
        
    }
    TaskEntity * entity = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@+%@",entity.TaskName,entity.TaskPoint];
    UIImageView * arrow = (UIImageView *)[cell.contentView viewWithTag:10];
    UILabel * infoLabel = (UILabel *)[cell.contentView viewWithTag:11];
    
    if (entity.IsComplete.boolValue) {
        if (indexPath.row == 1) {
            infoLabel.text = @"已完善";
        }else{
            infoLabel.text = @"已获得";
        }
        infoLabel.textColor = JX999999Color;
        [arrow setImage:nil];
    }else{
        if (indexPath.row == 1) {
            infoLabel.text = @"去完善";
        }else{
            infoLabel.text = @"获得粉丝";
        }
        infoLabel.textColor = JX333333Color;
        [arrow setImage:JXImageNamed(@"list_arrow")];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaskEntity * entity = _dataArray[indexPath.row];
    if (!entity.IsComplete.boolValue){
        switch (indexPath.row) {
            case 1:{
                ModifyInformationViewController * mvc = [[ModifyInformationViewController alloc ]init ];
                [self.navigationController pushViewController:mvc animated:YES];
            }
                break;
            case 2:
            case 3:
            case 4:
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发布更多爱晒会吸引更多粉丝关注哦~~" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去发布", nil];
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + headViewTopHeight +headViewBottomHeight)/2;
    
    if (yOffset < -(headViewTopHeight +headViewBottomHeight)) {
        
        CGRect rect = bgImageView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset -headViewBottomHeight ;
        rect.origin.x = xOffset;
        rect.size.width = kScreenWidth + fabs(xOffset);
        bgImageView.frame = rect;
//        CGRect HeadImageRect = CGRectMake((kScreenWidth-PayBillViewHeight)/2, 40, PayBillViewHeight, PayBillViewHeight);
//        HeadImageRect.origin.y = bgImageView.frame.origin.y;
//        HeadImageRect.size.height =  PayBillViewHeight + fabs(xOffset)*0.5 ;
//        HeadImageRect.origin.x = self.view.center.x - HeadImageRect.size.height/2;
//        HeadImageRect.size.width = PayBillViewHeight + fabs(xOffset)*0.5;
//        bgImageView.frame = HeadImageRect;
//        bgImageView.layer.cornerRadius = HeadImageRect.size.height/2;
//        bgImageView.clipsToBounds = YES;

//        CGRect NameRect = CGRectMake((kScreenWidth-PayBillViewHeight)/2, CGRectGetMaxY(bgImageView.frame)+5, PayBillViewHeight, 20);
//        NameRect.origin.y = CGRectGetMaxY(bgImageView.frame)+5;
//        NameRect.size.height =  20 + fabs(xOffset)*0.5 ;
//        NameRect.size.width = PayBillViewHeight + fabs(xOffset)*0.5;
//        NameRect.origin.x = self.view.center.x - NameRect.size.width/2;
//
//        _nameLabel.font=[UIFont systemFontOfSize:17+fabs(xOffset)*0.2];
//
//        _nameLabel.frame = NameRect;
        
        
    }else{
        //        CGRect HeadImageRect = CGRectMake((KScreen_Width-HeadImageHeight)/2, 40, HeadImageHeight, HeadImageHeight);
        //        HeadImageRect.origin.y = _headImageView.frame.origin.y;
        //        HeadImageRect.size.height =  HeadImageHeight - fabs(xOffset)*0.5 ;
        //        HeadImageRect.origin.x = self.view.center.x - HeadImageRect.size.height/2;
        //        HeadImageRect.size.width = HeadImageHeight - fabs(xOffset)*0.5;
        //        _headImageView.frame = HeadImageRect;
        //        _headImageView.layer.cornerRadius = HeadImageRect.size.height/2;
        //        _headImageView.clipsToBounds = YES;
        //
        //        CGRect NameRect = CGRectMake((KScreen_Width-HeadImageHeight)/2, CGRectGetMaxY(_headImageView.frame)+5, HeadImageHeight, 20);
        //        NameRect.origin.y = CGRectGetMaxY(_headImageView.frame)+5;
        //        NameRect.size.height =  20;
        //        NameRect.size.width = HeadImageHeight - fabs(xOffset)*0.5;
        //        NameRect.origin.x = self.view.center.x - NameRect.size.width/2;
        //
        //        _nameLabel.font=[UIFont systemFontOfSize:17-fabs(xOffset)*0.2];
        //
        //        _nameLabel.frame = NameRect;
        
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        ShareViewController *shareVC = [[ShareViewController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
    }
}

@end
