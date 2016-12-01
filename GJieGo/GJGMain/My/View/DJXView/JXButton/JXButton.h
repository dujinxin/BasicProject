//
//  JXButton.h
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXEventProtocol.h"

#ifndef JXButton_h
#define JXButton_h

#endif

@interface JXButton : UIButton <JXEventProtocol> {
    // 这是blocks的定义
    void (^saveA)(id sender);
    int p;
}
@end
