//
//  LocationViewController.m
//  GJieGo
//
//  Created by liubei on 16/4/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#define UserDefault_LocationHistoryKey @"LocationHistoryKeyOfMain"

#import "LocationViewController.h"
#import "LocationCell.h"

@interface LocationViewController ()
<UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
CLLocationManagerDelegate> {
    
    UIView *navBar;
    UIButton *backItem;
    UITextField *inputTextField;
    
    UITableView *table;
    UIView *headerViewHolder;
    UIView *footerViewHolder;
    
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) NSMutableArray *localLocationsDataSource;
@property (nonatomic, strong) NSMutableArray *searchLocationsDataSource;
@property (nonatomic, assign, getter=isSearching) BOOL searching;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAttributes];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - lazy

- (NSMutableArray *)localLocationsDataSource {
    
    if (!_localLocationsDataSource) {
        
        NSString *keyName = [NSString stringWithFormat:@"%@%@", @"userName", UserDefault_LocationHistoryKey];
        NSArray *tmpArr = [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
        _localLocationsDataSource = [NSMutableArray arrayWithArray:tmpArr];
    }
    return _localLocationsDataSource;
}

- (NSMutableArray *)searchLocationsDataSource {
    
    if (!_searchLocationsDataSource) {
        
        _searchLocationsDataSource = [NSMutableArray array];
    }
    return _localLocationsDataSource;
}


#pragma mark - setting

- (void)setSearching:(BOOL)searching {
    
    if (searching != _searching) {
        
        [table reloadData];
        if (searching) {
            table.tableHeaderView = nil;
            table.tableFooterView = nil;
        }else {
            table.tableHeaderView = headerViewHolder;
            table.tableFooterView = footerViewHolder;
        }
    }
    
    _searching = searching;
}


#pragma mark - Init

- (void)initAttributes {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(241, 241, 241, 1);
}

- (void)createUI {
    
    [self createNavUI];
    [self createTableView];
}

- (void)createNavUI {
    
    navBar = [[UIView alloc] init];
    navBar.backgroundColor = COLOR(254.f, 227.f, 48.f, 1.f);
    
    backItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backItem addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [backItem setImage:[[UIImage imageNamed:@"back"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
              forState:UIControlStateNormal];
    [navBar addSubview:backItem];
    [backItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.bottom.equalTo(navBar).with.offset(0);
        make.width.and.height.equalTo(@44);
    }];
    
    inputTextField = [[UITextField alloc] init];
    [inputTextField setBorderStyle:UITextBorderStyleRoundedRect];
    inputTextField.placeholder = @"输入搜索地址";
    inputTextField.font = [UIFont systemFontOfSize:13];
    inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputTextField.returnKeyType = UIReturnKeySearch;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.5, 10.5, 14, 14)];
    searchImg.image = [UIImage imageNamed:@"search_input_search"];
    [leftView addSubview:searchImg];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(34.5, 11.5, 0.5, 12)];
    line.backgroundColor = COLOR(153, 153, 153, 1);
    [leftView addSubview:line];
    
    inputTextField.leftView = leftView;
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    inputTextField.delegate = self;
    [inputTextField addTarget:self
                       action:@selector(textFieldValueChanged:)
             forControlEvents:UIControlEventEditingChanged];
    
    [navBar addSubview:inputTextField];
    [inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(backItem.right).with.offset(0);
        make.bottom.equalTo(navBar.bottom).with.offset(-5);
        make.right.equalTo(navBar.right).with.offset(-30);
        make.height.equalTo(@35);
    }];
    
    [self.view addSubview:navBar];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.and.right.equalTo(self.view).with.offset(0);
        make.height.equalTo(@64);
    }];
}

- (void)createTableView {
    
    table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[LocationCell class] forCellReuseIdentifier:@"LocationCell"];
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(navBar.bottom).with.offset(0);
    }];
    
    UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [positionBtn addTarget:self
                    action:@selector(ascertainPositionOfNow)
          forControlEvents:UIControlEventTouchUpInside];
    [positionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [positionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [positionBtn setBackgroundColor:[UIColor whiteColor]];
    [positionBtn setImage:[[UIImage imageNamed:@"add_selected"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                 forState:UIControlStateNormal];
    [positionBtn setTitle:@"点击定位当前地址" forState:UIControlStateNormal];
    [positionBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [positionBtn setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    
    headerViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 54)];
    headerViewHolder.backgroundColor = [UIColor clearColor];
    [headerViewHolder addSubview:positionBtn];
    [positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.and.right.equalTo(headerViewHolder).with.offset(0);
        make.height.equalTo(@44);
    }];
    table.tableHeaderView = headerViewHolder;
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearBtn addTarget:self
                 action:@selector(clearLocalLocations)
       forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setBackgroundColor:GJGRGB16Color(0xfee330)];
    [clearBtn.layer setCornerRadius:8];
    [clearBtn.layer setMasksToBounds:YES];
    [clearBtn setTitle:@"清空常用位置" forState:UIControlStateNormal];
    [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [clearBtn setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    
    footerViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
    footerViewHolder.backgroundColor = [UIColor clearColor];
    [footerViewHolder addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(footerViewHolder).with.offset(15);
        make.right.equalTo(footerViewHolder).with.offset(-15);
        make.top.equalTo(footerViewHolder).with.offset(8);
        make.height.equalTo(@44);
    }];
    table.tableFooterView = footerViewHolder;
}


#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearching) {
        return self.searchLocationsDataSource.count;
    }else {
        return self.localLocationsDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    
    if (self.isSearching) {
        cell.locationDict = self.searchLocationsDataSource[indexPath.row];
    }else {
        cell.locationDict = self.localLocationsDataSource[indexPath.row];
    }
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return !self.isSearching;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isSearching && editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.localLocationsDataSource removeObjectAtIndex:indexPath.row];
        [table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [kUserDefaults setObject:self.localLocationsDataSource forKey:UserDefault_LocationHistoryKey];
        [kUserDefaults synchronize];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearching) {
        
        [self.localLocationsDataSource addObject:self.searchLocationsDataSource[indexPath.row]];
        [kUserDefaults setObject:self.localLocationsDataSource forKey:UserDefault_LocationHistoryKey];
        [kUserDefaults synchronize];
        
        if ([self.delegate respondsToSelector:@selector(locationViewControllerSelectedLocation:)]) {
            [self.delegate locationViewControllerSelectedLocation:self.searchLocationsDataSource[indexPath.row]];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(locationViewControllerSelectedLocation:)]) {
            [self.delegate locationViewControllerSelectedLocation:self.localLocationsDataSource[indexPath.row]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [inputTextField resignFirstResponder];
}


#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
#warning 1. search
    
    // 2. 关闭键盘
    [inputTextField resignFirstResponder];
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)textField {
    
    self.searching = (textField.text.length > 0);
    
    // <2> get world, self.datasouce addobject.....
}


#pragma mark - CoreLocation delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [MBProgressHUD showMessag:@"定位开始" toView:self.view];
    CLLocation *newLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *array, NSError *error){
                       
        if (array.count > 0){
            
            CLPlacemark *placemark = [array objectAtIndex:0];   NSLog(@"lb_placeName: %@", placemark.name);
            NSString *city = placemark.locality;
            if (!city)    city = placemark.administrativeArea;  NSLog(@"lb_city: %@", city);
        }else if (error == nil && [array count] == 0) {
            NSLog(@"No results were returned.");
        }else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    [manager stopUpdatingLocation];
}


#pragma mark - Click event

- (void)navBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ascertainPositionOfNow {
    
    if ([[GJGLocationManager sharedManager] locationManagerGetLocationService]) {
        if ([self.delegate respondsToSelector:@selector(locationViewControllerSelectedLocation:)]) {
            [self.delegate locationViewControllerSelectedLocation:[GJGLocationManager sharedManager].locationName];
//            [MBProgressHUD showSuccess:@"定位成功!" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"定位功能未开启,请前往\n -设置-隐私-定位服务- \n开启之后, 再次使用本功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
//    [MBProgressHUD showMessag:@"正在定位中，请稍等.." toView:self.view];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    });
}

- (void)clearLocalLocations {
    
    [self.localLocationsDataSource removeAllObjects];
    self.localLocationsDataSource = nil;
    [table reloadData];
    
    [kUserDefaults setObject:[NSMutableArray array] forKey:UserDefault_LocationHistoryKey];
    [kUserDefaults synchronize];
}

@end
