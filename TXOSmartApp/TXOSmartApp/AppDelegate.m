//
//  AppDelegate.m
//  TXOSmartApp
//
//  Created by moxin.xt on 14-7-1.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "AppDelegate.h"
#import "TXORootViewController.h"
#import "TXOSlideModel.h"
#import "TXOSlideItem.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.rootViewController = [[UINavigationController alloc]initWithRootViewController:[TXORootViewController new]];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    
    //load config
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://fierce-meadow-3934.herokuapp.com/tags?format=json"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* err;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        NSLog(@"main thhred? %d, JSON:%@",[NSThread isMainThread], json);
        
        NSArray* tags = json[@"tags"];
        NSMutableArray* list = [NSMutableArray arrayWithCapacity:tags.count];
        
        for (NSDictionary* dict in tags) {
            
            TXOSlideItem* item = [TXOSlideItem new];
            [item autoKVCBinding:dict];
            [item setValue:dict[@"id"] forKeyPath:@"identifier"];
            [list addObject:item];
        }
        
        NSData* archivedData = [NSKeyedArchiver archivedDataWithRootObject:[list copy]];
        [[NSUserDefaults standardUserDefaults] setObject:archivedData forKey:@"tags"];
        
    }] resume];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
