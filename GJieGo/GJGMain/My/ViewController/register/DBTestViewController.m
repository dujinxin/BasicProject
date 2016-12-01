//
//  DBTestViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "DBTestViewController.h"


@implementation DBTestViewController


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
    self.title = @"login";

    [self setSubView];
}
- (void)didReceiveMemoryWarning{
    
}
- (void)loadView{
    [super loadView];
}
- (void)setSubView{
    NSArray * array = @[@"建表1",@"建表2",@"删表",@"插入数据",@"修改数据",@"查询数据",@"全部查询",@"删除数据",@"全部删除"];
    for (int i = 0; i < array.count ; i ++) {
        UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 30)];
        l.text = @"DBManager";
        [self.view addSubview:l];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 70 +40 *i, 80, 30);
        [btn setTitleColor:JX333333Color forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor grayColor]];
        btn.layer.cornerRadius = 5.f;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10 +i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, 80, 30)];
        l1.text = @"UserDB";
        [self.view addSubview:l1];
        
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(140, 70 +40 *i, 80, 30);
        [btn1 setTitleColor:JX333333Color forState:UIControlStateNormal];
        [btn1 setBackgroundColor:[UIColor grayColor]];
        btn1.layer.cornerRadius = 5.f;
        [btn1 addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = 10 +i;
        [btn1 setTitle:array[i] forState:UIControlStateNormal];
        [self.view addSubview:btn1];
    }
}
#pragma mark - click events
- (void)cancel:(UIButton *)button{
    [[JXViewManager sharedInstance] dismissViewController:YES];
}
- (void)buttonClick:(UIButton *)button{
    NSDictionary * object = @{
                              @"Token": @"werwewerwerwerwerwerwee",
                              @"RefreshToken": @"fhrthfhfghfghgfhfghfghfghgf",
                              @"Phonenumber": @"13121273646",
                              @"UserName": @"阿杜",
                              @"UserAge": @"18",
                              @"UserImage": @"http://images.gjg.com/test.jpg",
                              @"UserGender": @"0",
                              };
    NSString * name = @"base";
    
    switch (button.tag) {
        case 10:
        {
            NSArray * a = @[
                            @{@"key":@"UserName",@"type":@"varchar(256)"},
                            @{@"key":@"UserAge",@"type":@"integer"},
                            @{@"key":@"UserImage",@"type":@"varchar(256)"}
                            ];
            [[DBManager shareManager] createTable:name valueTypes:a];
        }
            break;
        case 11:
        {
            NSArray * a = @[@"UserName",@"UserAge",@"UserImage"];
            [[DBManager shareManager] createTable:name keys:a];
            
        }
            break;
            
        case 12:
        {
            [[DBManager shareManager] dropTable:name];
    
        }
            break;
        case 13:
        {
            NSDictionary * a =
            @{@"UserName": @"阿杜",
              @"UserAge": @"18",
              @"UserImage": @"http://images.gjg.com/test.jpg"}
            ;
            [[DBManager shareManager] insertData:name keyValues:a];
            

        }
            break;
        case 14:
        {
            NSDictionary * a =
            @{@"UserName": @"阿紫",
              @"UserAge": @"16",
              @"UserImage": @"http://images.222222222.com/test.jpg"};
            [[DBManager shareManager] updateData:name keyValues:a where:@[@"UserAge = 18"]];

        }
            break;
        case 15:
        {
            NSArray * arr = [[DBManager shareManager] selectData:name keys:@[@"UserName"] where:@[@"UserName like '%阿%'"]];
            NSLog(@"select arr:%@",arr);

        }
            break;
        case 16:
        {
            NSArray * a =
            @[@"UserName",
              @"UserAge"];
            NSArray * arr = [[DBManager shareManager] selectData:name keys:a where:nil];
            NSLog(@"select arr:%@",arr);
        }
            break;
        case 17:
        {
            [[DBManager shareManager] deleteData:name where:@[@"UserAge > 18"]];
        }
            break;
        case 18:
        {
            [[DBManager shareManager] deleteData:name];
        }
            break;
    }
}
- (void)buttonClick1:(UIButton *)button{
    NSDictionary * object = @{
                              @"Token": @"werwewerwerwerwerwerwee",
                              @"RefreshToken": @"fhrthfhfghfghgfhfghfghfghgf",
                              @"Phonenumber": @"13121273646",
                              @"UserName": @"阿杜",
                              @"UserAge": @"18",
                              @"UserImage": @"http://images.gjg.com/test.jpg",
                              @"UserGender": @"0",
                              };
    NSString * name = @"test";
    
    switch (button.tag) {
        case 10:
        {
            NSArray * a = @[
                            @{@"key":@"UserName",@"type":@"varchar(256)"},
                            @{@"key":@"UserAge",@"type":@"integer"},
                            @{@"key":@"UserImage",@"type":@"varchar(256)"}
                            ];
            [[UserDBManager shareManager] createTable:name valueTypes:a];
        }
            break;
        case 11:
        {
            NSArray * a = @[@"UserName",@"UserAge",@"UserImage"];
            [[UserDBManager shareManager] createTable:name keys:a];
            
        }
            break;
            
        case 12:
        {
            [[UserDBManager shareManager] dropTable:name];
            
        }
            break;
        case 13:
        {
            NSDictionary * a =
            @{@"UserName": @"阿杜",
              @"UserAge": @"18",
              @"UserImage": @"http://images.gjg.com/test.jpg"}
            ;
            [[UserDBManager shareManager] insertData:name keyValues:a];
            
            
        }
            break;
        case 14:
        {
            NSDictionary * a =
            @{@"UserName": @"阿紫",
              @"UserAge": @"16",
              @"UserImage": @"http://images.222222222.com/test.jpg"};
            [[UserDBManager shareManager] updateData:name keyValues:a where:@[@"UserAge = 18"]];
            
        }
            break;
        case 15:
        {
            NSArray * arr = [[UserDBManager shareManager] selectData:name keys:@[@"UserName"] where:@[@"UserName like '%阿%'"]];
            NSLog(@"select arr:%@",arr);
            
        }
            break;
        case 16:
        {
            NSArray * a =
            @[@"UserName",
              @"UserAge"];
            NSArray * arr = [[UserDBManager shareManager] selectData:name keys:a where:nil];
            NSLog(@"select arr:%@",arr);
        }
            break;
        case 17:
        {
            [[UserDBManager shareManager] deleteData:name where:@[@"UserAge > 17"]];
        }
            break;
        case 18:
        {
            [[UserDBManager shareManager] deleteData:name];
        }
            break;
    }
}
@end
