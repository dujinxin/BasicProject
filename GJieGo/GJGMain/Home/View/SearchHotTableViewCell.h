//
//  SearchHotTableViewCell.h
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchHotTableViewCellDelegate <NSObject>

@optional
- (void)searchHotTableViewCellDidSelected:(NSString *)searchStr;

@end

@interface SearchHotTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SearchHotTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSArray *hots;
@property (nonatomic, assign) CGFloat lb_rowHeight;

@end
