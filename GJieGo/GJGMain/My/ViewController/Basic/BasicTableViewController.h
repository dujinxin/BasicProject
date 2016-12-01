//
//  BasicTableViewController.h
//  GJieGo
//
//  Created by dujinxin on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicTableViewController : BasicViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView    *  _tableView;
    NSInteger         _page;
    NSMutableArray *  _dataArray;
}

@property (nonatomic, strong, readwrite) UITableView    * tableView;
@property (nonatomic, strong, readwrite) NSMutableArray * dataArray;
@property (nonatomic, assign, readwrite) NSInteger        page;

- (void)refresh:(NSInteger)page;
- (void)loadMore:(NSInteger)page;
- (void)endRefresh;
@end
