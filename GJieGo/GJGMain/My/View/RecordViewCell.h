//
//  RecordViewCell.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, RecordType) {
    RecordDistributionType,
    RecordCommentionType
};

typedef void(^RecordBlock)(NSIndexPath *indexPath);

@interface RecordViewCell : UICollectionViewCell

@property (nonatomic, assign) RecordType     type;

@property (nonatomic, strong) NSIndexPath  * indexPath;

@property (nonatomic, strong) UIView       * topContentView;
@property (nonatomic, strong) UIView       * centerContentView;
@property (nonatomic, strong) UIView       * bottomContentView;

@property (nonatomic, strong) UIImageView  * bigImageView;
@property (nonatomic, strong) UIImageView  * guiderImageView;
@property (nonatomic, strong) UILabel      * guiderLabel;
@property (nonatomic, strong) UILabel      * infoLabel;

@property (nonatomic, strong) UIButton     * commentButton;//改为 浏览量
@property (nonatomic, strong) UIButton     * priseButton;

@property (nonatomic, strong) UIImageView  * leftImageView;
@property (nonatomic, strong) UILabel      * leftNumLabel;

@property (nonatomic, strong) UIImageView  * rightImageView;
@property (nonatomic, strong) UILabel      * rightNumLabel;

@property (nonatomic, assign) BOOL           isEditStyle;//11.04新增
@property (nonatomic, strong) UIView       * shadowView;
@property (nonatomic, strong) UIButton     * deleteButton;
@property (nonatomic, copy)   RecordBlock    block;


-(void)setRecordCellInfo:(id)entity indexPath:(NSIndexPath *)indexPath;
    
@end
