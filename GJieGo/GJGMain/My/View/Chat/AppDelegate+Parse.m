//
//  AppDelegate+Parse.m
//  
//
//  Created by apple on 16/4/22.
//
//

#import "AppDelegate+Parse.h"

//#import <Parse/Parse.h>
//#import "UserProfileManager.h"

@implementation AppDelegate (Parse)

- (void)parseApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [Parse enableLocalDatastore];
//    
//    // Initialize Parse.
//    [Parse setApplicationId:@"UUL8TxlHwKj7ZXEUr2brF3ydOxirCXdIj9LscvJs"
//                  clientKey:@"B1jH9bmxuYyTcpoFfpeVslhmLYsytWTxqYqKQhBJ"];
//    
//    // [Optional] Track statistics around application opens.
//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    
//    
//    // setup ACL
//    PFACL *defaultACL = [PFACL ACL];
//    
//    [defaultACL setPublicReadAccess:YES];
//    [defaultACL setPublicWriteAccess:YES];
//    
//    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

- (void)initParse
{
//    [[UserProfileManager sharedInstance] initParse];
}

- (void)clearParse
{
//    [[UserProfileManager sharedInstance] clearParse];
}
@end
