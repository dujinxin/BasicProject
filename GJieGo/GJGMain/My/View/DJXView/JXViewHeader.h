//
//  JXViewHeader.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#ifndef JXViewHeader_h
#define JXViewHeader_h

//使用ARC和不使用ARC
#if __has_feature(objc_arc)//compiling with ARC

#define DJXAutorelease(obj)
#define DJXReturnAutoreleased(obj) (obj)

#define DJXRetain(obj)
#define DJXReturnRetained(obj) (obj)

#define DJXRelease(obj)
#define DJXSafeRelease(obj) (obj = nil);
#define DJXSuperDealloc

#define DJXWeak __unsafe_unretained

#else  //compiling without ARC

#define DJXAutorelease(obj) ([obj autorelease]);
#define DJXReturnAutoreleased DJXAutorelease

#define DJXRetain(obj) ([obj retain]);
#define DJXReturnRetained DJXRetain

#define DJXRelease(obj) ([obj release]);
#define DJXSafeRelease(obj) ([obj release], obj = nil);
#define DJXSuperDealloc [super dealloc];

#define DJXWeak

#endif



#import "JXButton.h"
#import "JXLabel.h"
#import "JXImageView.h"
#import "JXViewManager.h"
#import "UITool.h"
#import "UIView+Addition.h"

#import "JXSelectView.h"



#endif /* JXViewHeader_h */
