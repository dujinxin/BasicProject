//
//  ShareManager.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareUtil.h"
@class ShareEntity;

typedef void(^ShareCallBackBlock)(id object,UserShareSns sns);

@interface ShareManager : NSObject<ShareUtilDelegate>

@property (nonatomic, strong) JXSelectView        * shareView;
@property (nonatomic, strong) UIView              * contentView;

@property (nonatomic, strong) ShareEntity         * entity;
@property (nonatomic, strong) NSString            * title;
@property (nonatomic, strong) NSString            * content;
@property (nonatomic, strong) NSString            * imageUrl;
@property (nonatomic, strong) NSString            * url;
@property (nonatomic, strong) NSString            * Descirption;
@property (nonatomic, strong) NSString            * infoId;
@property (nonatomic, assign) UserShareType         shareType;
@property (nonatomic, strong) UIViewController    * presentedController;
@property (nonatomic, copy)   ShareCallBackBlock    success;
@property (nonatomic, copy)   ShareCallBackBlock    failure;

@property (nonatomic, strong) NSString            * noticeMsg;

+(ShareManager *)shareManager;

@end


@interface ShareEntity : BasicEntity

@property (nonatomic, copy) NSString            * InfoId;
@property (nonatomic, copy) NSString            * Title;
@property (nonatomic, copy) NSString            * Content;
@property (nonatomic, copy) NSString            * Images;
@property (nonatomic, copy) NSString            * Url;

@end
