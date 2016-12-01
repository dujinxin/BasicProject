//
//  SearchResultViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#define ShopInSearchReuseIdentifier @"ShopInSearchReuseIdentifier"
#define SharedOrderInSearchReuseIdentifier @"SharedOrderInSearchReuseIdentifier"
#define OftenInSearchReuseIdentifier @"OftenInSearchReuseIdentifier"

#import "SearchResultViewController.h"
#import "SharedOrderDetailViewController.h"
#import "GeneralMarketController.h"
#import "RestaurantClassController.h"
#import "FilmClassController.h"
#import "SharedOrderInMainCell.h"
//#import "SharedOrderInSearchCollectionViewCell.h"
#import "ShopInSearchTableViewCell.h"
#import "OftenInSearchResultTableViewCell.h"
#import "SearchCommentTableViewCell.h"
#import "GJGSelectorBar.h"
#import "LBSharedOrderM.h"
#import "LBShopM.h"
#import "LBUserM.h"


@interface SearchResultViewController ()
<UITextFieldDelegate,
 UITableViewDelegate,
 UITableViewDataSource,
 UICollectionViewDelegateFlowLayout,
 UICollectionViewDataSource> {
    
    UIView *navBar;
    UIButton *backItem;
    UITextField *inputTextField;
    
    UITableView *table;
    UICollectionView *collectionView;
     
    GJGSelectorBar *selectorBar;
    UITableView *oftenTable;
    NSMutableArray *classes;
    NSArray *types;
    NSInteger selected_classes; // 选择的搜索分类id
    NSInteger selected_type;    // 选择的搜索类型
     
    NSInteger page;
}

@property (nonatomic, strong) NSMutableArray<LBShopM *> *shopDataSource;
@property (nonatomic, strong) NSMutableArray<LBSharedOrderM *> *sharedOrderDataSource;
@property (nonatomic, strong) NSMutableArray<LBShopM *> *oftenDataSource;
//@property (nonatomic, assign, getter=isSearching) BOOL searching;

@end

@implementation SearchResultViewController

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

- (NSMutableArray *)shopDataSource {
    if (!_shopDataSource) {
        _shopDataSource = [NSMutableArray array];
    }
    return _shopDataSource;
}
- (NSMutableArray *)sharedOrderDataSource {
    if (!_sharedOrderDataSource) {
        _sharedOrderDataSource = [NSMutableArray array];
    }
    return _sharedOrderDataSource;
}
- (NSMutableArray *)oftenDataSource {
    if (!_oftenDataSource) {
        _oftenDataSource = [NSMutableArray array];
    }
    return _oftenDataSource;
}


#pragma mark - setting

//- (void)setSearching:(BOOL)searching {
//    
//    if (searching != _searching) {
//        
//        [table reloadData];
//        if (searching) {
//            table.tableHeaderView = nil;
//            table.tableFooterView = nil;
//        }else {
//            table.tableHeaderView = headerViewHolder;
//            table.tableFooterView = footerViewHolder;
//        }
//    }
//    
//    _searching = searching;
//}


#pragma mark - Init

- (void)initAttributes {
    
    if (self.oftens) {
        selected_classes = self.oftens[self.oftenIndex].DicID;
    }
    selected_type = 1;
    page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = GJGRGB16Color(0xf1f1f1);
}

- (void)createUI {
    
    [self createNavUI];
    
    if (self.viewControllerType == SearchResultTypeIsShop) {
        [self createTableView];
        [table.mj_header beginRefreshing];
    }else if (self.viewControllerType == SearchResultTypeIsSharedOrder) {
        [self createCollectionView];
        [collectionView.mj_header beginRefreshing];
    }else if (self.viewControllerType == SearchResultTypeIsOften) {
        [self createOftenView];
        [oftenTable.mj_header beginRefreshing];
    }
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
    
    if (self.viewControllerType != SearchResultTypeIsOften) {
        
        inputTextField = [[UITextField alloc] init];
        [inputTextField setBorderStyle:UITextBorderStyleRoundedRect];
        inputTextField.placeholder = @"输入店铺品牌关键字";
        inputTextField.text = self.searchStr;
        inputTextField.font = [UIFont systemFontOfSize:13];
        inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputTextField.returnKeyType = UIReturnKeySearch;
        
        inputTextField.leftView = ({
            
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35 + 30, 35)];
            leftView.backgroundColor = [UIColor clearColor];
            
            UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.5, 10.5, 14, 14)];
            searchImg.image = [UIImage imageNamed:@"search_input_search"];
            [leftView addSubview:searchImg];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 0, 30, 35)];
            [typeLabel setFont:[UIFont systemFontOfSize:12]];
            [typeLabel setTextAlignment:NSTextAlignmentCenter];
            [typeLabel setTextColor:COLOR(102.f, 102.f, 102.f, 1)];
            [typeLabel setBackgroundColor:[UIColor clearColor]];
            [leftView addSubview:typeLabel];
            typeLabel.text = ({
                NSString *title = nil;
                switch (self.viewControllerType) {
                    case SearchResultTypeIsOften:
                        title = @"店铺";
                        break;
                    case SearchResultTypeIsSharedOrder:
                        title = @"晒单";
                        break;
                    case SearchResultTypeIsShop:
                        title = @"店铺";
                        break;
                    default:
                        title = @"晒单";
                        break;
                }
                title;
            });
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(34.5 + 30, 11.5, 0.5, 12)];
            line.backgroundColor = COLOR(153, 153, 153, 1);
            [leftView addSubview:line];
        
            leftView;
        });
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
    }else {
        UILabel *navTitleLabel = [[UILabel alloc] init];
        navTitleLabel.font = [UIFont systemFontOfSize:17];
        navTitleLabel.textAlignment = NSTextAlignmentCenter;
        navTitleLabel.textColor = GJGBLACKCOLOR;
        navTitleLabel.text = @"常用搜索";
        [navBar addSubview:navTitleLabel];
        [navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.bottom.and.right.equalTo(navBar).with.offset(0);
            make.height.mas_equalTo(@44);
        }];
    }
    
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
    table.showsVerticalScrollIndicator = NO;
    [table registerClass:[ShopInSearchTableViewCell class] forCellReuseIdentifier:ShopInSearchReuseIdentifier];
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(navBar.bottom).with.offset(0);
    }];
    
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self updateData];
    }];
    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView registerClass:[SharedOrderInMainCell class]
       forCellWithReuseIdentifier:@"SharedOrderInMainCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(navBar.mas_bottom).with.offset(0);
    }];
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self updateData];
    }];
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

- (void)createOftenView {
    
    [self createOftenTable];
    [self createSelectorBar];
}
- (void)createSelectorBar {
    
    classes = [NSMutableArray array];
    for (int i = 0; i < self.oftens.count; i++) {
        SearchOftenM *often = self.oftens[i];
        [classes addObject:often.DicName];
    }
    types = @[@"离我最近", @"收藏最多"];
    selectorBar =[GJGSelectorBar selectorBarWithClassificaitons:classes
                                                          types:types
                                                  selectedBlock:^(NSString *classification, NSString *type)
                  {
                      for (SearchOftenM *often in self.oftens) {
                          if ([classification isEqualToString:often.DicName]) {
                              selected_classes = often.DicID;
                              break;
                          }
                      }
                      for (NSString *typeStr in types) {
                          if ([typeStr isEqualToString:type]) {
                              selected_type = [types indexOfObject:typeStr] + 1;
                              break;
                          }
                      }
                      NSLog(@"U_selected_%lu %lu", selected_classes, selected_type);
                      [oftenTable.mj_header endRefreshing];
                      [oftenTable.mj_header beginRefreshing];
                  }];
    selectorBar.classSelectedIndex = self.oftenIndex;
    selectorBar.typeSelectedIndex = 0;
    selectorBar.classificationLabel.text = @"分类";
    [self.view addSubview:selectorBar];
    [selectorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(@64);
        make.height.mas_equalTo(@40);
    }];
}
- (void)createOftenTable {
    
    oftenTable = [[UITableView alloc] init];
    oftenTable.delegate = self;
    oftenTable.dataSource = self;
    oftenTable.backgroundColor = [UIColor clearColor];
    oftenTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    oftenTable.showsVerticalScrollIndicator = NO;
    [oftenTable registerClass:[OftenInSearchResultTableViewCell class] forCellReuseIdentifier:OftenInSearchReuseIdentifier];
    
    [self.view addSubview:oftenTable];
    [oftenTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(navBar.bottom).with.offset(@40);
    }];
    
    oftenTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    oftenTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self updateMoreData];
    }];
}


#pragma mark - Update

- (void)updateData {
    
    if (self.viewControllerType == SearchResultTypeIsShop) {
        
        [table.mj_footer endRefreshing];
        [DJXRequest requestWithBlock:kApiShopSearch
                               param:@{@"Sn" : self.searchStr ? self.searchStr : @"",
                                       @"Cp" : @1}
                             success:^(id object,NSString *msg)
        {
            [table.mj_header endRefreshing];
            if ([object isKindOfClass:[NSArray class]]) {
                page = 2;
                [self.shopDataSource removeAllObjects];
                [self.shopDataSource addObjectsFromArray:[LBShopM objectsWithArray:object]];
                [table reloadData];
                if (self.shopDataSource.count < 20) {
                    [table.mj_footer endRefreshingWithNoMoreData];
                }
            }
        } failure:^(id object,NSString *msg) {
            [table.mj_header endRefreshing];
            if ([msg isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:msg toView:self.view];
            }
        }];
    }else if (self.viewControllerType == SearchResultTypeIsSharedOrder) {
        
        [collectionView.mj_footer endRefreshing];
        [DJXRequest requestWithBlock:kApiUserShowSearch
                               param:@{@"keyword" : self.searchStr,
                                       @"page" : @1,
                                       @"order" : @0}
                             success:^(id object,NSString *msg)
         {
             [collectionView.mj_header endRefreshing];
             if ([object isKindOfClass:[NSArray class]]) {
                 page = 2;
                 [self.sharedOrderDataSource removeAllObjects];
                 [self.sharedOrderDataSource addObjectsFromArray:[LBSharedOrderM objectsWithArray:object]];
                 [collectionView reloadData];
                 
                 if (self.sharedOrderDataSource.count < 10) {
                     [collectionView.mj_footer endRefreshingWithNoMoreData];
                 }
             }
         } failure:^(id object,NSString *msg) {
             [collectionView.mj_header endRefreshing];
             if ([msg isKindOfClass:[NSString class]]) {
                 [MBProgressHUD showError:msg toView:self.view];
             }
         }];
    }else if (self.viewControllerType == SearchResultTypeIsOften) {
        
        [oftenTable.mj_footer endRefreshing];
        [DJXRequest requestWithBlock:kApiGetShopByType
                               param:@{//@"BcId" : @0,
                                       @"Type" : @(selected_classes),
                                       @"orderType" : @(selected_type),
                                       @"Cp" : @1}
                             success:^(id object,NSString *msg)
         {
             [oftenTable.mj_header endRefreshing];
             if ([object isKindOfClass:[NSArray class]]) {
                 page = 2;
                 [self.oftenDataSource removeAllObjects];
                 [self.oftenDataSource addObjectsFromArray:[LBShopM objectsWithArray:object]];
                 [oftenTable reloadData];
                 if (self.oftenDataSource.count < 20) {
                     [oftenTable.mj_footer endRefreshingWithNoMoreData];
                 }
             }
         } failure:^(id object,NSString *msg) {
             [oftenTable.mj_header endRefreshing];
             if ([msg isKindOfClass:[NSString class]]) {
                 [MBProgressHUD showError:msg toView:self.view];
             }
         }];
    }
}

- (void)updateMoreData {
    
    if (self.viewControllerType == SearchResultTypeIsShop) {
        
        [DJXRequest requestWithBlock:kApiShopSearch
                               param:@{@"Sn" : self.searchStr,
                                       @"Cp" : [NSNumber numberWithInteger:page]}
                             success:^(id object,NSString *msg)
        {
            if ([object isKindOfClass:[NSArray class]]) {
                page ++;
                [self.shopDataSource addObjectsFromArray:[LBShopM objectsWithArray:object]];
                [table reloadData];
                if (((NSArray *)object).count < 20) {
                    [table.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [table.mj_footer endRefreshing];
                }
            }else {
                [table.mj_footer endRefreshing];
            }
        } failure:^(id object,NSString *msg) {
            [table.mj_footer endRefreshing];
            if ([msg isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:msg toView:self.view];
            }
        }];
    }else if (self.viewControllerType == SearchResultTypeIsSharedOrder) {
        
        [DJXRequest requestWithBlock:kApiUserShowSearch
                               param:@{@"keyword" : self.searchStr,
                                       @"page" : [NSNumber numberWithInteger:page],
                                       @"order" : @0}
                             success:^(id object,NSString *msg)
         {
             if ([object isKindOfClass:[NSArray class]]) {
                 page ++;
                 [self.sharedOrderDataSource addObjectsFromArray:[LBSharedOrderM objectsWithArray:object]];
                 [collectionView reloadData];
                 if (((NSArray *)object).count < 10) {
                     [collectionView.mj_footer endRefreshingWithNoMoreData];
                 }else {
                     [collectionView.mj_footer endRefreshing];
                 }
             }else {
                 [collectionView.mj_footer endRefreshing];
             }
         } failure:^(id object,NSString *msg) {
             [collectionView.mj_footer endRefreshingWithNoMoreData];
             if ([msg isKindOfClass:[NSString class]]) {
                 [MBProgressHUD showError:msg toView:self.view];
             }
         }];
    }else if (self.viewControllerType == SearchResultTypeIsOften) {
        
        [DJXRequest requestWithBlock:kApiGetShopByType
                               param:@{//@"BcId" : @0,
                                       @"Type" : @(selected_classes),
                                       @"orderType" : @(selected_type),
                                       @"Cp" : @(page)}
                             success:^(id object,NSString *msg)
         {
             if ([object isKindOfClass:[NSArray class]]) {
                 page ++;
                 [self.oftenDataSource addObjectsFromArray:[LBShopM objectsWithArray:object]];
                 [oftenTable reloadData];
                 if (((NSArray *)object).count < 20) {
                     [oftenTable.mj_footer endRefreshingWithNoMoreData];
                 }
             }
         } failure:^(id object,NSString *msg) {
             [oftenTable.mj_footer endRefreshing];
             if ([msg isKindOfClass:[NSString class]]) {
                 [MBProgressHUD showError:msg toView:self.view];
             }
         }];
    }
}


#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewControllerType == SearchResultTypeIsShop) {
        return self.shopDataSource.count;
    }else if (self.viewControllerType == SearchResultTypeIsOften) {
        return self.oftenDataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewControllerType == SearchResultTypeIsShop) {
        ShopInSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopInSearchReuseIdentifier];
        cell.shop = self.shopDataSource[indexPath.row];
        return cell;
    }else if (self.viewControllerType == SearchResultTypeIsOften) {
        OftenInSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OftenInSearchReuseIdentifier];
        cell.shop = self.oftenDataSource[indexPath.row];
        return cell;
    }
    return nil;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewControllerType == SearchResultTypeIsShop) {
        return 162.f + 10.f;
    }else if (self.viewControllerType == SearchResultTypeIsOften) {
        return 75.f + 10.f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *typeKey = nil;
    NSString *shopName = nil;
    NSString *shopId = nil;
    LBShopM *shop = nil;
    
    if (self.viewControllerType == SearchResultTypeIsShop) {
        // 进入店铺
        typeKey = self.shopDataSource[indexPath.row].TypeKey;
        shopName = self.shopDataSource[indexPath.row].ShopName;
        shopId = [NSString stringWithFormat:@"%lu", self.shopDataSource[indexPath.row].ShopID];
        shop = self.shopDataSource[indexPath.row];
        
    }else if (self.viewControllerType == SearchResultTypeIsOften) {
        typeKey = self.oftenDataSource[indexPath.row].TypeKey;
        shopName = self.oftenDataSource[indexPath.row].ShopName;
        shopId = [NSString stringWithFormat:@"%lu", self.oftenDataSource[indexPath.row].ShopID];
        shop = self.oftenDataSource[indexPath.row];
    }
    
    if ([typeKey isEqualToString:@"supermarket"]) {//超市    ②③
        GeneralMarketController *controller = [[GeneralMarketController alloc] init];
        controller.title = shopName;
        controller.shopId = shopId;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([typeKey isEqualToString:@"cafe"] ||
              [typeKey isEqualToString:@"hotel"] ||
              [typeKey isEqualToString:@"ktv"] ||
              [typeKey isEqualToString:@"restaurant"]){//咖啡店、酒店、KTV、美食  ①②
        RestaurantClassController *controller = [[RestaurantClassController alloc] init];
        controller.title = shopName;
        controller.shopId = shopId;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{//影院、亲子、甜点饮品、美业、酒吧、健身、培训、足疗按摩、宠物店 ②
        //        SpecialtyStoreClassController *controller = [[SpecialtyStoreClassController alloc] init];
        FilmClassController *controller = [[FilmClassController alloc] init];
        controller.title = shopName;
        controller.shopId = shopId;
        [self.navigationController pushViewController:controller animated:YES];
    }
    NSLog(@"Search_often: typekey:%@ shopName:%@ shopid:%@", typeKey, shopName, shopId);
    
    [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201040010002
                                                    andBCID:nil
                                                  andMallID:nil
                                                  andShopID:[NSString stringWithFormat:@"%lu", shop.ShopID]
                                            andBusinessType:shop.TypeKey
                                                  andItemID:nil
                                                andItemText:nil
                                                andOpUserID:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [selectorBar hiddenSelectView];
    [inputTextField resignFirstResponder];
}


#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.sharedOrderDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionV
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SharedOrderInMainCell *cell = nil;
    cell = [SharedOrderInMainCell cellWithCollectionView:collectionV
                                            andIndexPath:indexPath];
    cell.sharedOrderType = SharedOrderCellTypeIsMain;
    cell.sharedOrder = self.sharedOrderDataSource[indexPath.row];
    return cell;
}


#pragma mark - Collection view flow layout delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SharedOrderDetailViewController *detailVC = [[SharedOrderDetailViewController alloc] init];
    LBSharedOrderM *shareOrder = self.sharedOrderDataSource[indexPath.row];
    detailVC.infoId = shareOrder.Id;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201040140003
                                                    andBCID:nil
                                                  andMallID:nil
                                                  andShopID:nil
                                            andBusinessType:nil
                                                  andItemID:[NSString stringWithFormat:@"%lu", shareOrder.Id]
                                                andItemText:nil
                                                andOpUserID:[NSString stringWithFormat:@"%lu", shareOrder.userM.UserId]];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return [SharedOrderInMainCell getEdgeInsets];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [SharedOrderInMainCell getSizeWithType:SharedOrderCellTypeIsMain];
}


#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (!(textField.text.length > 0))    return YES;
    
    self.searchStr = textField.text;
    [self updateData];
    
    NSMutableArray *searchHistory = [NSMutableArray arrayWithArray:[kUserDefaults objectForKey:UserDefault_SearchHistoryKey]];
    if (searchHistory == nil) {
        searchHistory = [NSMutableArray array];
    }else {
        for (int i = 0; i < searchHistory.count; i++) {
            NSString *historyStr = searchHistory[i];
            if ([historyStr isEqualToString:self.searchStr]) {
                [searchHistory removeObject:historyStr];
            }
        }
    }
    [searchHistory insertObject:self.searchStr atIndex:0];
    [kUserDefaults setObject:searchHistory forKey:UserDefault_SearchHistoryKey];
    [kUserDefaults synchronize];
    
    [inputTextField resignFirstResponder];
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)textField {
    
//    self.searching = (textField.text.length > 0);
}

#pragma mark - Button click event

- (void)navBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
