//
//  AppDelegate+Parse.h
//  
//
//  Created by apple on 16/4/22.
//
//

#import "AppDelegate.h"

@interface AppDelegate (Parse)

- (void)parseApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)initParse;

- (void)clearParse;

@end
