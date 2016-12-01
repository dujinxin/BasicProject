//
//  DetailMsgTableViewCell.h
//  GJieGo
//
//  Created by liubei on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBMsgM;

@interface DetailMsgTableViewCell : UITableViewCell
/** 消息模型 */
@property (nonatomic, strong) LBMsgM *msg;
@end
