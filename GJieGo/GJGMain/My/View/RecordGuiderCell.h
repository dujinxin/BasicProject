//
//  RecordGuiderCell.h
//  GJieGo
//
//  Created by dujinxin on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelView.h"

@class RecordGuiderCell;
@protocol UIGuiderViewCellDelegate <NSObject>

- (void)guiderViewCell:(RecordGuiderCell *)recordGuiderCell indexPath:(NSIndexPath *)indexPath index:(NSInteger)index;

@end

@interface RecordGuiderCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath  * indexPath;

@property (nonatomic, strong) UIView       * topContentView;
@property (nonatomic, strong) UIView       * centerContentView;
@property (nonatomic, strong) UIView       * bottomContentView;

@property (nonatomic, strong) UIImageView  * userImageView;
@property (nonatomic, strong) UILabel      * nameLabel;
@property (nonatomic, strong) UILabel      * timeLabel;
@property (nonatomic, strong) LevelView    * levelView;

@property (nonatomic, strong) UILabel      * contentLabel;
@property (nonatomic, strong) UIImageView  * leftImageView;
@property (nonatomic, strong) UIImageView  * centerImageView;
@property (nonatomic, strong) UIImageView  * rightImageView;
@property (nonatomic, strong) UILabel      * numLabel;

@property (nonatomic, strong) UIView       * line;

@property (nonatomic, strong) UIButton     * priseButton;
@property (nonatomic, strong) UIButton     * commentButton;
@property (nonatomic, strong) UIButton     * locationButton;

@property (nonatomic, strong) UITapGestureRecognizer * tap;
@property (nonatomic, weak)id<UIGuiderViewCellDelegate> delegate;


- (void)setRecordCellInfo:(id)entity dateFormatter:(NSDateFormatter *)dateFormatter dateString:(NSString *)dateString indexPath:(NSIndexPath *)indexPath;

@end
