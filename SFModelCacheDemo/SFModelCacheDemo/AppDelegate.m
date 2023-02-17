//
//  AppDelegate.m
//  SFModelCacheDemo
//
//  Created by lurich on 2023/2/17.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [NSClassFromString(@"ViewController") new];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
