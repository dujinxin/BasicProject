//
//  GuideHomeViewController.h
//  GJieGo
//
//  Created by liubei on 16/5/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"

@interface GuideHomeViewController : BaseViewController

@property (nonatomic, assign) NSInteger gid;   // 导购编号
@property (nonatomic, copy) NSString *statisticChatOfHome; // 聊天的数据埋点编号, 可不填, 默认所有分类

@end
