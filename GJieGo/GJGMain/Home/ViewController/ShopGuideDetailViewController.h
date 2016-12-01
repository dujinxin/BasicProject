//
//  ShopGuideDetailViewController.h
//  GJieGo
//
//  Created by liubei on 16/4/27.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopGuideDetailViewController : BaseViewController

/** 指定促销信息编号 */
@property (nonatomic, assign) NSInteger infoid;

/** 数据埋点编号 */
@property (nonatomic, copy) NSString *statisticChat;

/** 数据埋点编号 评论发送 */
@property (nonatomic, copy) NSString *statisticSendMsg;
/** 数据埋点编号 点赞 */
@property (nonatomic, copy) NSString *statisticLike;
/** 数据埋点编号 分享 */
@property (nonatomic, copy) NSString *statisticShare;

@end
