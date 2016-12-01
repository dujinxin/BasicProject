//
//  SearchOfMainViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SearchOfMainViewController.h"
#import "SearchResultViewController.h"
#import "SearchOfMainHeaderView.h"
#import "SearchHotTableViewCell.h"
#import "SearchCommentTableViewCell.h"
#import "SearchClearTableViewCell.h"
#import "AppMacro.h"

@interface SearchOfMainViewController ()
<UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
SearchHotTableViewCellDelegate,
SearchCommentTableViewCellDelegate> {
    
    UIView *navBar;
    UITextField *inputTextField;
    UIView *textFieldLeftView;
    UIView *textFieldRightView;
    UILabel *searchTypeLabel;
    UIImageView *indroImgView;
    NSInteger selectedIndex;
    UIButton *backItem;
    
    UITableView *table;
    UIView *footerViewHolder;
}

@property (nonatomic, strong) NSMutableArray *hots;
@property (nonatomic, assign) CGFloat hotsHeight;
@property (nonatomic, strong) NSMutableArray<SearchOftenM *> *oftens;
@property (nonatomic, assign) CGFloat oftenHeight;

@property (nonatomic, strong) NSMutableArray *groupTitles;
@property (nonatomic, strong) NSMutableArray *searchHistoryDataSource;
@property (nonatomic, strong) NSMutableArray *searchResultsDataSource;
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, assign, getter=isChangingSearchType) BOOL changingSearchType;
@property (nonatomic, strong) NSArray *searchTypeArray;
@property (nonatomic, strong) UIButton *searchTypeOther;

@property (nonatomic, strong) SearchHotTableViewCell *hotCell;

@end

@implementation SearchOfMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAttributs];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.searchHistoryDataSource = nil;
    [table reloadData];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillDisappear:animated];
}


#pragma mark - lazy

- (NSMutableArray *)groupTitles {
    
    if (!_groupTitles) {
        
        _groupTitles = [NSMutableArray arrayWithObjects:@"热门搜索", @"搜索记录", nil];
//        _groupTitles = [NSMutableArray arrayWithObjects:@"热门搜索", @"热门店铺分类", @"搜索记录", nil];
    }
    return _groupTitles;
}

- (NSMutableArray *)hots {
    
    if (!_hots) {
        
        _hots = [NSMutableArray array];
        if ([kUserDefaults objectForKey:kSearchHotsKey]) {
            [_hots addObjectsFromArray:[kUserDefaults objectForKey:kSearchHotsKey]];
        }
        [DJXRequest requestWithBlock:kApiSearchTop param:nil success:^(id object,NSString *msg) {
            if ([object isKindOfClass:[NSArray class]]) {
                [_hots removeAllObjects];
                NSMutableArray *hotDicts = [NSMutableArray array];
                for (NSDictionary *hot in object) {
                    [hotDicts addObject:[hot objectForKey:@"Words"]];
                }
                _hots = hotDicts;
                [table reloadData];
                [kUserDefaults setObject:hotDicts forKey:kSearchHotsKey];
                [kUserDefaults synchronize];
            }
        } failure:^(id object,NSString *msg) {
            if ([msg isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:object toView:self.view];
            }
        }];
    }
    return _hots;
}

- (NSMutableArray *)oftens {
    
    if (!_oftens) {
        
        _oftens = [NSMutableArray array];
        if ([kUserDefaults objectForKey:kSearchOftensKey]) {
            [_oftens addObjectsFromArray:[SearchOftenM objectsWithArray:[kUserDefaults objectForKey:kSearchOftensKey]]];
        }
        
        [DJXRequest requestWithBlock:kApiSearchOften
                               param:nil
                             success:^(id object,NSString *msg)
        {
            if ([object isKindOfClass:[NSArray class]]) {
                [_oftens removeAllObjects];
                [_oftens addObjectsFromArray:[SearchOftenM objectsWithArray:object]];
                [table reloadData];
                NSMutableArray *dicts = [NSMutableArray array];
                for (SearchOftenM *often in _oftens) {
                    [dicts addObject:[often backToDict]];
                }
                [kUserDefaults setObject:dicts forKey:kSearchOftensKey];
                [kUserDefaults synchronize];
            }
        } failure:^(id object,NSString *msg) {
            if ([msg isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:msg toView:self.view];
            }
        }];
    }
    return _oftens;
}

- (NSMutableArray *)searchHistoryDataSource {
    
    if (!_searchHistoryDataSource) {
        
        NSArray *tmpArr = [kUserDefaults objectForKey:UserDefault_SearchHistoryKey];
        if (tmpArr.count > 15) {
            _searchHistoryDataSource = [NSMutableArray array];
            for (int i = 0; i < 15; i++) {
                [_searchHistoryDataSource addObject:tmpArr[i]];
            }
        }else {
            _searchHistoryDataSource = [NSMutableArray arrayWithArray:tmpArr];
        }
    }
    return _searchHistoryDataSource;
}

- (NSMutableArray *)searchResultsDataSource {
    
    if (!_searchResultsDataSource) {
        
        _searchResultsDataSource = [NSMutableArray array];
    }
    return _searchResultsDataSource;
}

- (NSArray *)searchTypeArray {
    
    if (!_searchTypeArray) {
        
        _searchTypeArray = [NSArray arrayWithObjects:@"搜店铺", @"搜晒单", nil];
    }
    return _searchTypeArray;
}

- (UIButton *)searchTypeOther {
    
    if (!_searchTypeOther) {
        
        _searchTypeOther = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchTypeOther setBackgroundImage:[[UIImage imageNamed:@"search_cbb_bg"]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(75, 100, 74, 99)]
                                    forState:UIControlStateNormal];
        [_searchTypeOther setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchTypeOther setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 0)];
        [_searchTypeOther.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_searchTypeOther addTarget:self action:@selector(searchTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchTypeOther;
}


#pragma mark - setting

- (void)setSearching:(BOOL)searching {
    
    if (_searching != searching) {
        _searching = searching;
        [table reloadData];
    }
}

- (void)setChangingSearchType:(BOOL)changingSearchType {
    
    if (changingSearchType)
        [self showSelectedTable];
    else
        [self hiddenSelectedTable];
    
    _changingSearchType = changingSearchType;
}

- (void)showSelectedTable {
    
    CGRect frame = [UIView relativeFrameForScreenWithView:textFieldLeftView];
    
    CGFloat currentW = 65.f;
    CGFloat currentH = 49;
    CGFloat currentX = frame.origin.x;
    CGFloat currentY = frame.origin.y + frame.size.height;
    
    [self.searchTypeOther setTitle:self.searchTypeArray[selectedIndex ? 0 : 1] forState:UIControlStateNormal];
    self.searchTypeOther.frame = CGRectMake(currentX, currentY, currentW, currentH);
    self.searchTypeOther.transform = CGAffineTransformMakeScale(0, 0);
    [self.view addSubview:self.searchTypeOther];
    [UIView animateWithDuration:0.15 animations:^{
        self.searchTypeOther.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.searchTypeOther.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

- (void)hiddenSelectedTable {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.searchTypeOther.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.searchTypeOther.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            self.searchTypeOther.transform = CGAffineTransformMakeScale(1, 1);
            [self.searchTypeOther removeFromSuperview];
        }];
    }];
}

- (void)searchTypeClick:(UIButton *)btn {
    
    [self hiddenSelectedTable];
    _changingSearchType = NO;
    
    NSString *selectedStr = [_searchTypeOther titleForState:UIControlStateNormal];
    if ([selectedStr isEqualToString:[self.searchTypeArray firstObject]]) {
        selectedIndex = 0;
    }else {
        selectedIndex = 1;
    }
    [_searchTypeOther setTitle:searchTypeLabel.text forState:UIControlStateNormal];
    searchTypeLabel.text = selectedStr;
}


#pragma mark - Init

- (void)initAttributs {
    self.hotsHeight = 44;
    [self hots];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)createUI {
    
    [self createNavBar];
    [self createTableView];
}

- (void)createNavBar {
    
    navBar = [[UIView alloc] init];
    navBar.backgroundColor = COLOR(254.f, 227.f, 48.f, 1.f);
    
    backItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backItem setContentMode:UIViewContentModeCenter];
    [backItem addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [backItem.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backItem setTitleColor:COLOR(51.f, 51.f, 51.f, 1) forState:UIControlStateNormal];
    [backItem setTitle:@"取消" forState:UIControlStateNormal];
    [navBar addSubview:backItem];
    [backItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.and.right.equalTo(navBar).with.offset(0);
        make.height.equalTo(@44);
        make.width.equalTo(@66);
    }];
    
    inputTextField = [[UITextField alloc] init];
    [inputTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [inputTextField setBackgroundColor:[UIColor whiteColor]];
    inputTextField.placeholder = @"输入店铺品牌关键字";
    inputTextField.font = [UIFont systemFontOfSize:13];
    inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputTextField.returnKeyType = UIReturnKeySearch;
    
    textFieldLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 35)];
    textFieldLeftView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(changeSearchType)];
    textFieldLeftView.userInteractionEnabled = YES;
    [textFieldLeftView addGestureRecognizer:tap];
    
    searchTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 35)];
    if (self.searchTypeArray.count > 0) {

        searchTypeLabel.text = [self.searchTypeArray firstObject];
        selectedIndex = 0;
    }
    [searchTypeLabel setFont:[UIFont systemFontOfSize:12]];
    [searchTypeLabel setTextAlignment:NSTextAlignmentCenter];
    [searchTypeLabel setTextColor:COLOR(102.f, 102.f, 102.f, 1)];
    [searchTypeLabel setBackgroundColor:[UIColor clearColor]];
    [textFieldLeftView addSubview:searchTypeLabel];
    
    indroImgView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 0, 10, 35)];
    [indroImgView setContentMode:UIViewContentModeScaleAspectFit];
    indroImgView.image = [UIImage imageNamed:@"search_Search_cbb"];
    [textFieldLeftView addSubview:indroImgView];
    
    inputTextField.leftView = textFieldLeftView;
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    textFieldRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 35)];
    textFieldRightView.hidden = YES;
    [textFieldRightView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(clearTextField)];
    textFieldRightView.userInteractionEnabled = YES;
    [textFieldRightView addGestureRecognizer:rightTap];
    
    UIImageView *deleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11.5, 35)];
    [deleImgView setImage:[UIImage imageNamed:@"search_searchbox_delete"]];
    [deleImgView setContentMode:UIViewContentModeScaleAspectFit];
    [textFieldRightView addSubview:deleImgView];
    
    inputTextField.rightView = textFieldRightView;
    inputTextField.rightViewMode = UITextFieldViewModeAlways;
    
    inputTextField.delegate = self;
    [inputTextField addTarget:self
                       action:@selector(textFieldValueChanged:)
             forControlEvents:UIControlEventEditingChanged];
    
    [navBar addSubview:inputTextField];
    [inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(navBar.left).with.offset(15);
        make.bottom.equalTo(navBar.bottom).with.offset(-5);
        make.right.equalTo(backItem.left).with.offset(0);
        make.height.equalTo(@35);
    }];
    
    [self.view addSubview:navBar];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.and.right.equalTo(self.view).with.offset(0);
        make.height.equalTo(@64);
    }];
}

- (void)createTableView {
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = COLOR(241, 241, 241, 1);
    
    [table registerClass:[SearchOfMainHeaderView class] forHeaderFooterViewReuseIdentifier:SearchHeaderViewIdentifier];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:SearchHistoryCellIdentifier];
    [table registerClass:[SearchHotTableViewCell class] forCellReuseIdentifier:SearchHotCellIdentifier];
//    [table registerClass:[SearchCommentTableViewCell class] forCellReuseIdentifier:SearchCommentCellIdentifier];
    [table registerClass:[SearchClearTableViewCell class] forCellReuseIdentifier:SearchClearCellIdentifier];
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(navBar.bottom).with.offset(0);
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.isSearching ? 1 : self.groupTitles.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearching) {
        return self.searchResultsDataSource.count;
    }else {
        return section != 1 ? 1 : self.searchHistoryDataSource.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isSearching) {

        if (indexPath.section == 0) {
            
            SearchHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchHotCellIdentifier];
            cell.hots = self.hots;
            cell.delegate = self;
            return cell;
            
//        }else if (indexPath.section == 1) {
//            
//            SearchCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCommentCellIdentifier];
//            cell.items = self.oftens;
//            cell.delegate = self;
//            return cell;
//            
        }else if (indexPath.section == 1) {
            
            if (indexPath.row == self.searchHistoryDataSource.count) {
                
                SearchClearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchClearCellIdentifier];
                return cell;
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchHistoryCellIdentifier];
                cell.textLabel.textColor = COLOR(51, 51, 51, 1);
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = self.searchHistoryDataSource[indexPath.row];
                return cell;
            }
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchHistoryCellIdentifier];
    cell.textLabel.textColor = COLOR(51, 51, 51, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.searchResultsDataSource[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isSearching && indexPath.section == 1) {
        if (indexPath.row == self.searchHistoryDataSource.count) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"是否确认清空?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                [self clearLocalHistorys];
                [table reloadData];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:sure];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            [self search:self.searchHistoryDataSource[indexPath.row] isOften:NO index:0];
        }
    }else if(self.isSearching){
        [self search:self.searchResultsDataSource[indexPath.row] isOften:NO index:0];
    }
//    else if () {
//        // search for result
//        [self.searchHistoryDataSource insertObject:self.searchResultsDataSource[indexPath.row] atIndex:0];
////        [self.searchHistoryDataSource addObject:self.searchResultsDataSource[indexPath.row]]; 将最近搜索的插入到前排
//        [kUserDefaults setObject:self.searchHistoryDataSource forKey:UserDefault_SearchHistoryKey];
//        [kUserDefaults synchronize];
//        inputTextField.text = self.searchResultsDataSource[indexPath.row];
//        [self textFieldValueChanged:inputTextField];
//        [self search:self.searchResultsDataSource[indexPath.row] isOften:NO index:0];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isSearching) {
        if (indexPath.section == 0) {
            
            _hotCell = [table dequeueReusableCellWithIdentifier:SearchHotCellIdentifier];
            _hotCell.hots = _hots;
            self.hotsHeight = _hotCell.lb_rowHeight;
            return self.hotsHeight;
//        }else if (indexPath.section == 1) {
//            return [SearchCommentTableViewCell lb_rowHeight];
        }
    }else {
        return 43;
    }
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    if (self.isSearching)    return nil;

    SearchOfMainHeaderView *groupHeader = nil;
    groupHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SearchHeaderViewIdentifier];
    groupHeader.text = self.groupTitles[section];
    return groupHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.isSearching ?  1.f : 43.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (!self.isSearching && indexPath.section == 1 && indexPath.row != self.searchHistoryDataSource.count);
}

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.searchHistoryDataSource removeObjectAtIndex:indexPath.row];
        [table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [kUserDefaults setObject:self.searchHistoryDataSource forKey:UserDefault_SearchHistoryKey];
        [kUserDefaults synchronize];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self hiddenSelectedTable];
    [inputTextField resignFirstResponder];
}


#pragma mark - Search custom cell delegate

- (void)searchHotTableViewCellDidSelected:(NSString *)searchStr {
    [self search:searchStr isOften:NO index:0];
}

- (void)searchCommentTableViewCellDidSelected:(NSInteger)oftenSelectedIndex {
    [self search:nil isOften:YES index:oftenSelectedIndex];
}


#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [inputTextField resignFirstResponder];
    
    [self search:textField.text isOften:NO index:0];
    
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)textField {
    
    BOOL have = (textField.text.length > 0);
    self.searching = have;
    textFieldRightView.hidden = !have;
    
    if (have)
        [self hiddenSelectedTable];
    else
        return;
    
    NSString *suggestionApi = nil;
    if ([searchTypeLabel.text isEqualToString:@"搜店铺"])
        suggestionApi = kApiShopSearchSug;
    else if ([searchTypeLabel.text isEqualToString:@"搜晒单"])
        suggestionApi = kApiUserShowSearchSug;
    
    [DJXRequest requestWithBlock:suggestionApi
                           param:@{@"Sw" : textField.text}
                         success:^(id object,NSString *msg)
    {
        if ([object isKindOfClass:[NSArray class]]) {
            [self.searchResultsDataSource removeAllObjects];
            for (NSDictionary *result in object) {
                [self.searchResultsDataSource addObject:[result objectForKey:@"Suggestion"]];
            }
            [table reloadData];
        }
    } failure:^(id object,NSString *msg) {
        if ([msg isKindOfClass:[NSString class]]) {
            [MBProgressHUD showError:object toView:self.view];
        }
    }];
}


#pragma mark - Button click event

- (void)changeSearchType {
    
    self.changingSearchType = !self.changingSearchType;
}

- (void)clearTextField {
    
    inputTextField.text = nil;
    [self textFieldValueChanged:inputTextField];
}

- (void)navBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearLocalHistorys {
    
    // <2> clear dataSource
    [self.searchHistoryDataSource removeAllObjects];
    [table reloadData];
    
    // <1> clear local info
    [kUserDefaults setObject:[NSArray array] forKey:UserDefault_SearchHistoryKey];
    [kUserDefaults synchronize];
}


#pragma mark - Get search condition & search & show result

- (void)search:(NSString *)searchStr isOften:(BOOL)status index:(NSInteger)index {
    
    if (!status && (searchStr.length == 0 || searchStr == nil)) {
        return;
    }
    
    SearchResultType searchType = 0;
    
    if (status) {
        searchType = SearchResultTypeIsOften;
    }else {
        for (int i = 0; i < self.searchHistoryDataSource.count; i++) {
            NSString *historyStr = self.searchHistoryDataSource[i];
            if ([historyStr isEqualToString:searchStr]) {
                [self.searchHistoryDataSource removeObject:historyStr];
            }
        }
        [self.searchHistoryDataSource insertObject:searchStr atIndex:0];
        
        [kUserDefaults setObject:self.searchHistoryDataSource forKey:UserDefault_SearchHistoryKey];
        [kUserDefaults synchronize];
        
        if ([searchTypeLabel.text isEqualToString:@"搜店铺"])
            searchType = SearchResultTypeIsShop;
        else if ([searchTypeLabel.text isEqualToString:@"搜晒单"])
            searchType = SearchResultTypeIsSharedOrder;
    }
    
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    resultVC.searchStr = searchStr;
    if (status) {
        resultVC.oftenIndex = index;
        resultVC.oftens = self.oftens;
    }
    resultVC.viewControllerType = searchType;
    [self.navigationController pushViewController:resultVC animated:YES];
    
    if (searchType != SearchResultTypeIsOften) {
        [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201040220001
                                                        andBCID:nil
                                                      andMallID:nil
                                                      andShopID:nil
                                                andBusinessType:nil
                                                      andItemID:nil
                                                    andItemText:searchStr
                                                    andOpUserID:nil];
    }
}

@end
