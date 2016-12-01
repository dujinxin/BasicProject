//
//  CollectionViewCell.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/3.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath  * indexPath;

@property (nonatomic, strong) UIView       * mainContentView;
@property (nonatomic, strong) UIImageView  * mainImageView;

@property (nonatomic, strong) UILabel      * storeLabel;
@property (nonatomic, strong) UILabel      * locationLabel;


@property (nonatomic, strong) UIView       * bottomContentView;
@property (nonatomic, strong) UIImageView  * leftImageView;
@property (nonatomic, strong) UILabel      * leftNumLabel;
@property (nonatomic, strong) UIImageView  * rightImageView;
@property (nonatomic, strong) UILabel      * rightNumLabel;

@property (nonatomic, strong) UIButton     * leftButton;
@property (nonatomic, strong) UIButton     * rightButton;

@property (nonatomic, strong) UIView       * shadeView;

- (void)setCollectionCellInfo:(id)entity indexPath:(NSIndexPath *)indexPath;

@end
