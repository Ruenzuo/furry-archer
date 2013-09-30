//
//  AppDelegate.m
//  WeatherApp
//
//  Created by Taller Technologies on 9/20/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "AppDelegate.h"
#import "City.h"

@interface AppDelegate ()

- (void)setupAppearance;

@end

@implementation AppDelegate
{
}

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAppearance];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

#pragma mark - Private Methods

- (void)setupAppearance
{
    [[self window] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
