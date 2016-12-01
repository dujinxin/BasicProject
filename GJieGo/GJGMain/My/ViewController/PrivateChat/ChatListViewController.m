//
//  ChatListViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/3.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "OrderGuiderView.h"

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *   _tableView;
}
@end

@implementation ChatListViewController

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
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"私聊";
    self.view.backgroundColor = JXF1f1f1Color;
    self.navigationItem.leftBarButtonItem = getBackItem(self,@selector(back:));
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //_tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.1;
    _tableView.backgroundColor = JXF1f1f1Color;
    [self.view addSubview:_tableView];
    
    [self  layoutSubView];
}
- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}
#pragma mark - Click events
- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        OrderGuiderView * view = [[OrderGuiderView alloc ]initWithFrame:cell.bounds];
        view.tag = 10;
        [cell.contentView addSubview:view];
    }
    OrderGuiderView * view = [cell.contentView viewWithTag:10];
//    view.userImageView;
    view.nameLabel.text = @"abc";
    view.detailLabel.text = @"abc";
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (conversationModel) {
//        EMConversation *conversation = conversationModel.conversation;
//        if (conversation) {
//            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
//                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
//                [self.navigationController pushViewController:chatController animated:YES];
//            } else {
//                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//                chatController.title = conversationModel.title;
//                [self.navigationController pushViewController:chatController animated:YES];
//            }
//        }
    
    
//     ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:@"8001" conversationType:EMConversationTypeChat];
////    chatController.title = conversationModel.title;
//    chatController.title = @"妹子";
//    [self.navigationController pushViewController:chatController animated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
//        [_tableView reloadData];
    
    
//    }
    if (indexPath.row == 0){
        [[ChatManager shareManager] getConversation:@"8001" parentViewController:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [_tableView reloadData];
    }else{
        [[ChatManager shareManager] getConversation:@"13121273646" title:@"阿杜" headImage:nil type:EMConversationTypeChat parentViewController:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [_tableView reloadData];
    }
    
}


@end
