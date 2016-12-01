//
//  UserRecordListViewController.h
//  GJieGo
//
//  Created by dujinxin on 16/5/25.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicCollectionViewController.h"
#import "RecordViewCell.h"


@interface UserRecordListViewController : BasicCollectionViewController

@property (nonatomic , assign)  RecordType    recordType;
@property (nonatomic , assign)  BOOL          isEditStyle;

@end
