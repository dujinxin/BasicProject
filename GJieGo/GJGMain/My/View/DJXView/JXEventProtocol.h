//
//  JXEventProtocol.h
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JXEventProtocol <NSObject>

- (void) setClickEvent:(void (^) (id sender))block;

@end
