//
//  HyBridBridge1.h
//  London2
//
//  Created by Mr.Yao on 16/3/24.
//  Copyright © 2016年 yaoquafeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HybirdUrlHandler.h"

@interface HyBridBridge : NSObject

- (BOOL)registerHybridUrlHanlder:(id<HybridUrlHanlder>)handler andBridge:(WebViewJavascriptBridge*)bridge ;


@end
