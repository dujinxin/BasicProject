//
//  LBSharedOrderDetailM.m
//  GJieGo
//
//  Created by liubei on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBSharedOrderDetailM.h"
#import "LBUserM.h"
#import "LBGuideInfoM.h"
#import "LBGuideDetailM.h"

@implementation LBSharedOrderDetailM

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"User"]) {
        self.userM = [LBUserM modelWithDict:value];
    }else if ([key isEqualToString:@"ActivityInfo"]) {
        if (value) {
            self.activityM = [ShareActivityModel modelWithDict:value];
        }
    }
}
- (LBGuideInfoM *)guideInfo {
    
    if (!_guideInfo) {
        
        _guideInfo = [[LBGuideInfoM alloc] init];
        _guideInfo.guider = [[LBGuideDetailM alloc] init];
        _guideInfo.guider.HeadPortrait = self.userM.HeadPortrait;
        _guideInfo.guider.UserId = self.userM.UserId;
        _guideInfo.guider.UserName = self.userM.UserName;
        _guideInfo.guider.UserLevel = self.userM.UserLevel;
        _guideInfo.guider.UserLevelName = self.userM.UserLevelName;
        
        _guideInfo.activityM = self.activityM;
        
        _guideInfo.CreateTime = self.CreateTime;
        _guideInfo.CommentNum = self.Comment;
        _guideInfo.ViewNum = self.ViewNum;
        _guideInfo.LikeNum = self.Like;
        _guideInfo.Content = self.Description;
    }
    _guideInfo.HasLike = self.HasLike;
    return _guideInfo;
}
@end
