//
//  ShareActivityModel.h
//  GJieGo
//
//  Created by liubei on 2016/11/15.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareActivityModel : LBBaseModel

@property (nonatomic, copy) NSString *AvailableDate;
@property (nonatomic, copy) NSString *Image;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *ActivityId;
@property (nonatomic, copy) NSString *ActivityName;
@property (nonatomic, copy) NSString *ActivityUrl;

@end
