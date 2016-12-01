//
//  ConversationListViewController.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/4.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "EaseConversationListViewController.h"

@interface ConversationListViewController : EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
