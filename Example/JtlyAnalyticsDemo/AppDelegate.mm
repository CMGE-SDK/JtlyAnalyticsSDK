//
//  AppDelegate.m
//  GameDemo
//
//  Created by Zec on 15/2/10.
//  Copyright (c) 2015年 JTLY. All rights reserved.
//

#import "AppDelegate.h"
#import "JtlyDemoViewController.h"
#import <JtlyAnalyticsKit/JtlyAnalyticsKit.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    JtlyDemoViewController *demoVC = [[JtlyDemoViewController alloc] init];
    self.window.rootViewController = demoVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [JtlyAnalytics.shared application:application didFinishLaunchingWithOptions:launchOptions];
    NSLog(@"===JtlyAnalytics===SDK Version Information=== %@", [JtlyAnalytics.shared versionInfo]);
   
    return YES;
}

#pragma mark - 第三方登录回调
//iOS9及以上系统走此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    //设置第三方登录回调
    return [JtlyAnalytics.shared application:app openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //设置第三方登录回调
    return [JtlyAnalytics.shared application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //设置第三方登录回调
    return [JtlyAnalytics.shared application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    //继续用户活动
    return [JtlyAnalytics.shared application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JtlyAnalytics.shared application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

-(void) application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    [JtlyAnalytics.shared application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
