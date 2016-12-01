//
//  ShopGuideViewController.m
//  GJieGo
//おいしそうですよね～食べたいです
//  Created by liubei on 16/4/27.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#define HalfScreenW [UIScreen mainScreen].bounds.size.width * 0.5
#define HalfScreenH [UIScreen mainScreen].bounds.size.height * 0.5
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

typedef enum {

    ListOrderTypeDefault = 0,       //  默认，不指定
    ListOrderTypeTime = 1,          //	发布时间
    ListOrderTypeDistance = 2,      //  距离
    ListOrderTypeLike = 3,          //  点赞数
    ListOrderTypeComment = 4,       //  评论数
    ListOrderTypeFoucs = 5,         //  关注数

}ListOrderType;

#import "ShopGuideViewController.h"
#import "ShopGuideDetailViewController.h"
#import "ShopGuideTableViewCell.h"
#import "LBGuideInfoM.h"
#import "RunTypeMallModel.h"
#import "GJGSelectorBar.h"

@interface ShopGuideViewController () <UITableViewDelegate, UITableViewDataSource>  {
    
    UIView *classificationViewHolder;
    GJGSelectorBar *selectorBar;
    UITableView *mainTableView;
    
    NSInteger page;
    NSInteger order;
    NSInteger selected_type;
}

@property (nonatomic, strong) NSMutableArray<LBGuideInfoM *> *dataSource;
/** 分类类型数组 */
@property (nonatomic, strong) NSArray<RunTypeMallItem *> *classfis;

@end

@implementation ShopGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttributes];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (_dataSource == nil) [mainTableView.mj_header beginRefreshing];
}


#pragma mark - Lazy

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma mark - Init some config

- (void)initAttributes {
    
    page = 1;
    order = 1;
    selected_type = 0;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - Create UI

- (void)createUI {
    
    [self createClassificationView];
    [self createMainTableView];
    
    [self.view bringSubviewToFront:selectorBar];
}

- (void)createClassificationView {
    
    CGFloat holderX = 10;
    CGFloat holderH = 44;
    
    //@[@"全部", @"发布时间", @"距离", @"点赞数", @"评论数", @"关注数"];
    NSArray *types = @[@"最新发布", @"离我最近", @"点赞最多", @"评论最多"];
    selectorBar =[GJGSelectorBar selectorBarWithClassificaitons:nil
                                                          types:types
                                                  selectedBlock:^(NSString *classification, NSString *type)
    {
         for (RunTypeMallItem *typeItem in self.classfis) {
             if ([classification isEqualToString:typeItem.DicName]) {
                 selected_type = typeItem.DicID;//[self.classfis indexOfObject:typeItem];
             }
         }
         for (NSString *typeStr in types) {
             if ([typeStr isEqualToString:type]) {
                 order = [types indexOfObject:typeStr] + 1;
             }
         }
         NSLog(@"U_selected_%lu %lu", selected_type, order);
        [mainTableView.mj_header endRefreshing];
        [mainTableView.mj_header beginRefreshing];
    }];
    selectorBar.classificationLabel.text = @"分类";
    [self.view addSubview:selectorBar];
    [selectorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(holderX);
        make.right.equalTo(self.view).with.offset(-holderX);
        make.top.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo([NSNumber numberWithDouble:holderH]);
    }];
    
    NSArray *classfiArr = [kUserDefaults objectForKey:kShopGuideClassfiUserDefaultKey];
    if (classfiArr) {
        self.classfis = [RunTypeMallItem objectsWithArray:classfiArr];
        [self setSelectorBarClassifications];
    }
    [self updateNewClassfi];
}


- (void)setSelectorBarClassifications {
    
    NSMutableArray *classStrs = [NSMutableArray array];
    for (int i = 0; i < self.classfis.count; i ++) {
        [classStrs addObject:self.classfis[i].DicName];
    }
    [selectorBar setClassifications:(NSArray *)classStrs];
}

- (void)createMainTableView {
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.delegate   = self;
    mainTableView.dataSource = self;
    mainTableView.rowHeight = UITableViewAutomaticDimension;
    mainTableView.estimatedRowHeight = 44.f;
    
    [mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopGuideTableViewCell class])
                                              bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:@"ShopGuideTableViewCell"];
    
    [self.view addSubview:mainTableView];
    [mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.and.bottom.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(44);
    }];
    
    mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self updateData];
    }];
    mainTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

#pragma mark - Update data

- (void)updateNewClassfi {
    
    [request requestUrl:kGJGRequestUrl(kApiGetGuideType)
            requestType:RequestGetType
             parameters:nil
           requestblock:^(id responseobject, NSError *error)
     {
         if (!error) {
             if ([[responseobject objectForKey:@"status"] isEqualToNumber:@0]) {    NSLog(@"获得最新分类数组:%@", responseobject);
                 if ([[responseobject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                     self.classfis = [RunTypeMallItem objectsWithArray:[responseobject objectForKey:@"data"]];
                     NSArray *classfiArr = [responseobject objectForKey:@"data"];
                     for (NSDictionary *dict in classfiArr) {
                         [dict setValue:@" " forKey:@"DicExt"];
                         [dict setValue:@" " forKey:@"DicKey"];
                     }
                     [kUserDefaults setObject:classfiArr forKey:kShopGuideClassfiUserDefaultKey];
                     [kUserDefaults synchronize];
                     [self setSelectorBarClassifications];
                 }
             }
         }
     }];
}

- (void)updateData {
    
    [mainTableView.mj_footer endRefreshing];
    
//    [DJXRequest requestWithBlock:kApiGetPromotions
//                           param:@{@"typeid" : [NSNumber numberWithInteger:selected_type],   // 0
//                                   @"page"   : @1,
//                                   @"order"  : [NSNumber numberWithInteger:order]}
//                         success:^(id object)
//    {
//        [mainTableView.mj_header endRefreshing];
//                             
//    } failure:^(id object) {
//        [mainTableView.mj_header endRefreshing];
//    }];
    NSLog(@"%ld %ld", selected_type, order);
    [request requestUrl:kGJGRequestUrl(kApiGetPromotions)
            requestType:RequestGetType
             parameters:@{@"typeid" : @(selected_type),//[NSNumber numberWithInteger:selected_type],   // 0
                          @"page"   : @1,
                          @"order"  : @(order)}//[NSNumber numberWithInteger:order]}   // 2
           requestblock:^(id responseobject, NSError *error) {
               [mainTableView.mj_header endRefreshing];
               if (!error) {
                   NSLog(@"导购促销内容object:%@", responseobject);
                   if ([[responseobject objectForKey:@"status"] isEqualToNumber:@0]) {
                       if ([[responseobject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                           [self.dataSource removeAllObjects];
                           NSArray *dicts = [responseobject objectForKey:@"data"];
                           for (int i = 0; i < dicts.count; i++) {
                               NSDictionary *dict = dicts[i];
                               [self.dataSource addObject:[LBGuideInfoM modelWithDict:dict]];
                           }
                           page = 2;
                           if (self.dataSource.count < 10) {
                               [mainTableView.mj_footer endRefreshingWithNoMoreData];
                               if (self.dataSource.count < 1) {
                                   [MBProgressHUD showError:@"无此分类消息" toView:self.view];
                               }
                           }
                           [mainTableView reloadData];
                       }else if ([[responseobject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                           [self.dataSource removeAllObjects];
                           [mainTableView reloadData];
                           [MBProgressHUD showError:@"无此分类消息" toView:self.view];
                       }
                   }else {
                       [MBProgressHUD showError:[responseobject objectForKey:@"message"] toView:self.view];
                   }
               }else {
                   NSLog(@"lb_request fail:%@",error);
               }
    }];
}

- (void)updateMoreData {
    
    [request requestUrl:kGJGRequestUrl(kApiGetPromotions)
            requestType:RequestGetType
             parameters:@{@"typeid" : @(selected_type),//[NSNumber numberWithInteger:selected_type],   // 0
                          @"page"   : @(page),//[NSNumber numberWithInteger:page],
                          @"order"  : @(order)}//[NSNumber numberWithInteger:order]}   // 2
           requestblock:^(id responseobject, NSError *error) {
               if (!error) {
                   if ([[responseobject objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInteger:0]]) {
                       if ([[responseobject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                           NSArray *dicts = [responseobject objectForKey:@"data"];
                           for (int i = 0; i < dicts.count; i++) {
                               NSDictionary *dict = dicts[i];
                               [self.dataSource addObject:[LBGuideInfoM modelWithDict:dict]];
                           }
//                           [self.dataSource addObjectsFromArray:[LBGuideInfoM objectsWithArray:[responseobject objectForKey:@"data"]]];
                           page ++;
                           if (((NSArray *)[responseobject objectForKey:@"data"]).count < 10) {
                               [mainTableView.mj_footer endRefreshingWithNoMoreData];
                           }else {
                               [mainTableView.mj_footer endRefreshing];
                           }
                           [mainTableView reloadData];
                       }
                   }else {
                       [MBProgressHUD showError:[responseobject objectForKey:@"message"] toView:self.view];
                   }
               }else {
                   NSLog(@"lb_request fail:%@",error);
               }
           }];
}


#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopGuideTableViewCell"];
    cell.type = ShopGuideCellTypeIsMain;
    cell.guideInfo = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [selectorBar hiddenSelectView];
    
    ShopGuideDetailViewController *detailVC = [[ShopGuideDetailViewController alloc] init];
    LBGuideInfoM *guider = [self.dataSource objectAtIndex:indexPath.row];
    detailVC.infoid = guider.InfoId;
    detailVC.statisticSendMsg = ID_0201030130002;
    detailVC.statisticLike = ID_0201030110003;
    detailVC.statisticShare = ID_0201030120004;

    [self.navigationController pushViewController:detailVC animated:YES];
    
    [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201030100001
                                                    andBCID:nil
                                                  andMallID:nil
                                                  andShopID:[NSString stringWithFormat:@"%lu", guider.guider.ShopId]
                                            andBusinessType:guider.guider.BusinessFormat
                                                  andItemID:[NSString stringWithFormat:@"%lu", guider.InfoId]
                                                andItemText:nil
                                                andOpUserID:[NSString stringWithFormat:@"%lu", guider.guider.UserId]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [selectorBar hiddenSelectView];
}

#pragma mark - System func

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
