//
//  ShareActivityViewController.m
//  GJieGo
//
//  Created by liubei on 2016/11/15.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShareActivityViewController.h"
#import "ShareActivityTableViewCell.h"

@interface ShareActivityViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate
> {
    UIView *statusBackView;
    UITextField *inputTextField;
    UILabel *tableTitle;
    UITableView *activityTableView;
    BOOL isSearching;
    
    NSInteger hotPage;
    NSInteger searchPage;
}

@property (nonatomic, strong) NSMutableArray<ShareActivityModel *> *hotDataSource;
@property (nonatomic, strong) NSMutableArray<ShareActivityModel *> *searchDataSource;

@end

@implementation ShareActivityViewController
NSObject *a;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAttributes];
    [self createUI];
    [self requestHotActivity:hotPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initAttributes {
    isSearching = NO;
    hotPage = 1;
    searchPage = 1;
    _hotDataSource = [NSMutableArray array];
    _searchDataSource = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = GJGRGB16Color(0xf1f1f1);
}


#pragma mark - UI

- (void)createUI {
    [self createNav];
    [self createSearchBar];
    [self createTableView];
}

- (void)createNav {
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [titleLabel setText:@"参与活动与主题"];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:COLOR(51, 51, 51, 1)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)createSearchBar {
    
    inputTextField = [[UITextField alloc] init];
    inputTextField.delegate = self;
    [inputTextField setBorderStyle:UITextBorderStyleNone];
    [inputTextField setBackgroundColor:[UIColor whiteColor]];
    inputTextField.layer.cornerRadius = 15;
    inputTextField.layer.masksToBounds = YES;
    inputTextField.placeholder = @"输入关键字搜索活动";
    inputTextField.font = [UIFont systemFontOfSize:13];
    inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputTextField.returnKeyType = UIReturnKeySearch;
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    inputTextField.leftView = ({
        
        UIView *textFieldLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        textFieldLeftView.backgroundColor = [UIColor clearColor];
        
        UIImageView *indroImgView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 15, 15)];
        [indroImgView setContentMode:UIViewContentModeScaleAspectFit];
        indroImgView.image = [UIImage imageNamed:@"search_input_search"];
        [textFieldLeftView addSubview:indroImgView];
        
        textFieldLeftView;
    });
    [inputTextField addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    [self.view addSubview:inputTextField];
    [inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(@(64 + 15));
        make.height.mas_equalTo(@30);
        make.left.equalTo(self.view).with.offset(@15);
        make.right.equalTo(self.view.mas_right).with.offset(@(-15));
    }];
}

- (void)createTableView {
    
    tableTitle = [[UILabel alloc] init];
    tableTitle.font = [UIFont systemFontOfSize:14];
    tableTitle.text = @"最新活动";
    tableTitle.textColor = GJGRGB16Color(0x666666);
    
    [self.view addSubview:tableTitle];
    [tableTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputTextField.mas_bottom).with.offset(@10);
        make.left.equalTo(self.view.mas_left).with.offset(@15);
    }];
    
    activityTableView = [[UITableView alloc] init];
    activityTableView.delegate = self;
    activityTableView.dataSource = self;
    activityTableView.backgroundColor = [UIColor clearColor];
    activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    activityTableView.showsVerticalScrollIndicator = NO;
    [activityTableView registerClass:[ShareActivityTableViewCell class] forCellReuseIdentifier:@"ShareActivityTableViewCell"];
    [self.view addSubview:activityTableView];
    [activityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableTitle.mas_bottom).with.offset(10);
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    activityTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (isSearching) {
            if (inputTextField.text) {
                [self loadMoreData:searchPage keyWord:inputTextField.text];
            }
        }else {
            [self requestHotActivity:hotPage];
        }
    }];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(shareActivityViewControllerDidSelectedActivity:)]) {
        [self.delegate shareActivityViewControllerDidSelectedActivity:isSearching ? self.searchDataSource[indexPath.row] : self.hotDataSource[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  isSearching ? self.searchDataSource.count : self.hotDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareActivityTableViewCell"];
    cell.model = isSearching ? self.searchDataSource[indexPath.row] : self.hotDataSource[indexPath.row];
    return cell;
}


#pragma mark - UITextfield delegate

- (void)valueChanged:(UITextField *)textField {
    if (textField.text.length) {
        isSearching = YES;
        [self.searchDataSource removeAllObjects];
        [activityTableView reloadData];
        searchPage = 1;
        [self requestSearchActivity:searchPage keyWord:textField.text];
    }else {
        if (isSearching) {
            isSearching = NO;
            [activityTableView reloadData];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField.text.length) {
//        [self.searchDataSource removeAllObjects];
//        [activityTableView reloadData];
//        searchPage = 1;
//        [self requestSearchActivity:searchPage keyWord:textField.text];
//    }
    return YES;
}


#pragma mark - Net

- (void)requestHotActivity:(NSInteger)page {
    [DJXRequest requestWithBlock:kApiGetHotActivity
                           param:@{@"page" : @(page),
                                   @"order" : @1}
                         success:^(id object,NSString *msg)
    {
        if ([object isKindOfClass:[NSArray class]]) {
            [self.hotDataSource addObjectsFromArray:[ShareActivityModel objectsWithArray:object]];
            [activityTableView reloadData];
            if (((NSArray *)object).count < 10) {
                [activityTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [activityTableView.mj_footer endRefreshing];
            }
            hotPage ++;
        }
    } failure:^(id object,NSString *msg) {
        [activityTableView.mj_footer endRefreshing];
        if ([msg isKindOfClass:[NSString class]]) {
            [MBProgressHUD showMessag:object toView:self.view];
        }
    }];
}

- (void)requestSearchActivity:(NSInteger)page keyWord:(NSString *)keyWord {
    [DJXRequest requestWithBlock:kApiGetSearchActivity
                           param:@{@"page" : @(page),
                                   @"keyword" : keyWord}
                         success:^(id object,NSString *msg)
     {
         if ([object isKindOfClass:[NSArray class]]) {
             [self.searchDataSource removeAllObjects];
             [self.searchDataSource addObjectsFromArray:[ShareActivityModel objectsWithArray:object]];
             [activityTableView reloadData];
             if (((NSArray *)object).count < 10) {
                 [activityTableView.mj_footer endRefreshingWithNoMoreData];
             }else {
                 [activityTableView.mj_footer endRefreshing];
             }
         }
     } failure:^(id object,NSString *msg) {
         [activityTableView.mj_footer endRefreshing];
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showMessag:object toView:self.view];
         }
     }];
}

- (void)loadMoreData:(NSInteger)page keyWord:(NSString *)keyWord{
    [DJXRequest requestWithBlock:kApiGetSearchActivity
                           param:@{@"page" : @(page),
                                   @"keyword" : keyWord}
                         success:^(id object,NSString *msg)
     {
         if ([object isKindOfClass:[NSArray class]]) {
             [self.searchDataSource addObjectsFromArray:[ShareActivityModel objectsWithArray:object]];
             [activityTableView reloadData];
             if (((NSArray *)object).count < 10) {
                 [activityTableView.mj_footer endRefreshingWithNoMoreData];
             }else {
                 [activityTableView.mj_footer endRefreshing];
             }
             searchPage ++;
         }
     } failure:^(id object,NSString *msg) {
         [activityTableView.mj_footer endRefreshing];
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showMessag:object toView:self.view];
         }
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
