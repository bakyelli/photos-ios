//
//  CSAppDelegate.m
//  Photos
//
//  Created by Cameron Spickert on 2/4/13.
//  Copyright (c) 2013 Cameron Spickert. All rights reserved.
//

#import "CSAppDelegate.h"
#import "CSPhotosViewController.h"
#import "CSDataStore.h"
@implementation CSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    CSPhotosViewController *photosController = [[CSPhotosViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photosController];
    
    [[self window] setRootViewController:navigationController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[CSDataStore sharedStore] saveContext];
}



@end
