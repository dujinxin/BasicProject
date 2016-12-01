//
//  SearchCommentTableViewCell.h
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchOftenM;

@protocol SearchCommentTableViewCellDelegate <NSObject>

@optional
- (void)searchCommentTableViewCellDidSelected:(NSInteger)selectedIndex;

@end

@interface SearchCommentTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SearchCommentTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<SearchOftenM *> *items;

+ (CGFloat)lb_rowHeight;

@end

#import "LBBaseModel.h"

@interface SearchOftenM : LBBaseModel
@property (nonatomic, assign) NSInteger DicID;
@property (nonatomic, copy) NSString *DicKey;
@property (nonatomic, copy) NSString *DicName;
@property (nonatomic, copy) NSString *DicExt;
- (NSDictionary *)backToDict;
@end