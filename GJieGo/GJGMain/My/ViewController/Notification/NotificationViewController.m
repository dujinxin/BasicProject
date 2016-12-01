//
//  NotificationViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "NotificationViewController.h"
#import "NewsListViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
//    for (NSDictionary * dict in _dataArray) {
//        [NotificationManager shareManager].isHasNews = NO;
//        if ([dict[@"isHasNews"] integerValue] >0) {
//            [NotificationManager shareManager].isHasNews = YES;
//            break;
//        }
//    }
//    if (![NotificationManager shareManager].isHasNews) {
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    }
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
    JXDispatch_async_global((^{
        [[UserRequest shareManager] userNotificationList:kApiNotificationSubNews param:nil success:^(id object,NSString *msg) {
            JXDispatch_async_main((^{
                NSArray * array = (NSArray *)object;
                NSArray * textArray = @[@"新的粉丝",@"新的点赞",@"新的评论",@"新的分享",@"新的回复"];
                
                NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
                
                for (int i = 0; i< textArray.count ; i++) {
                    NSString * str = textArray[i];
                    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes context:nil];
                    NSNumber * isHasNews;
                    if ([array containsObject:@(i+1)]) {
                        isHasNews = @1;
                    }else{
                        isHasNews = @0;
                    }
//                    if (array) {
//                        isHasNews = array[i];
//                    }else{
//                        isHasNews = @0;
//                    }
                    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:@{@"text":str,@"rect":[NSValue valueWithCGRect:rect],@"isHasNews":isHasNews}];
                    
                    [_dataArray addObject:dict];
                }
                [_tableView reloadData];
            }));
        } failure:^(id object,NSString *msg) {
            //
        }];
    }));

//    NSArray * array = [[NotificationManager shareManager] selectNumbers:NotificationDBName key:nil where:@[@"NoteType = 1",@"NoteType = 2",@"NoteType = 3",@"NoteType = 4",@"NoteType = 5"]];
    
//    NSArray * textArray = @[@"新的粉丝",@"新的点赞",@"新的评论",@"新的分享",@"新的回复"];
//
//    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
//    
//    for (int i = 0; i< textArray.count ; i++) {
//        NSString * str = textArray[i];
//        CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 20) options:option attributes:attributes context:nil];
//        NSNumber * isHasNews;
//        if (array) {
//            isHasNews = array[i];
//        }else{
//            isHasNews = @0;
//        }
//        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:@{@"text":str,@"rect":[NSValue valueWithCGRect:rect],@"isHasNews":isHasNews}];
//        
//        [_dataArray addObject:dict];
//    }
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"通知";
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = JX333333Color;
        cell.textLabel.font = JXFontForNormal(13);
        
        NSDictionary * dict = _dataArray[indexPath.row];
        CGRect rect = [[dict objectForKey:@"rect"] CGRectValue];
        UILabel * text = [[UILabel alloc ] initWithFrame:CGRectMake(15, 0, rect.size.width, 44)];
//        text.backgroundColor = [UIColor blueColor];
        text.font = [UIFont systemFontOfSize:13];
        text.tag = 10;
        [cell.contentView addSubview:text];
        
        UIView * redPoint = [[UIView alloc]initWithFrame:CGRectMake(15 +rect.size.width, 10, 8, 8)];
        redPoint.backgroundColor = JXff5252Color;
        redPoint.layer.cornerRadius = 4.0f;
        redPoint.tag = 11;
        redPoint.hidden = YES;
        [cell.contentView addSubview:redPoint];
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 17, 5, 9)];
        [arrow setImage:JXImageNamed(@"list_arrow")];
        [cell.contentView addSubview:arrow];
        
        UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
        line.backgroundColor = JXSeparatorColor;
        [cell.contentView addSubview:line];
    }
    NSDictionary * dict = _dataArray[indexPath.row];
    UILabel * text = [cell.contentView viewWithTag:10];
    UIView * redPoint = [cell.contentView viewWithTag:11];
    text.text = dict[@"text"];
    if ([dict[@"isHasNews"] integerValue] >0) {
        redPoint.hidden = NO;
    }else{
        redPoint.hidden = YES;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsListViewController * nvc = [[NewsListViewController alloc ]init ];
    switch (indexPath.row) {
        case 0:
            nvc.type = NotificationFansType;
            break;
        case 1:
            nvc.type = NotificationPriseType;
            break;
        case 2:
            nvc.type = NotificationCommentType;
            break;
        case 3:
            nvc.type = NotificationShareType;
            break;
        case 4:
            nvc.type = NotificationReturnType;
            break;
    }
    NSMutableDictionary * dict = _dataArray[indexPath.row];
    dict[@"isHasNews"] = @0;
    //[dict setObject:@0 forKey:@"isHasNews"];
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:dict];
    [self.navigationController pushViewController:nvc animated:YES];
}
@end
