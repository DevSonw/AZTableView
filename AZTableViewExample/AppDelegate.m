//
//  AppDelegate.m
//  AZTableViewExample
//
//  Created by Arron Zhang on 16/3/2.
//  Copyright © 2016年 Arron Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AZTableView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];

    NSArray *ar = [NSArray arrayWithObjects:[self jsonCont], [self baseCont], [self dictionaryCont], nil];
//    NSArray *ar = [NSArray arrayWithObjects:[self jsonCont], nil];

    for (id cont in ar) {
        [tabBarController addChildViewController:[[UINavigationController alloc] initWithRootViewController:cont]];
    }
    
    UIWindow *window = [[UIWindow alloc] init];
    self.window = window;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}


-(UIViewController *)baseCont{
    AZRow *row1 = [AZRow new];
    row1.text = @"Title";
    row1.onSelect = ^(AZRow *row, UIView *from, id value){
        NSLog(@"onSelect");
    };
    
    AZRow *row2 = [AZRow new];
    row2.text = @"Title";
    row2.detail = @"Detail";
    row2.style = UITableViewCellStyleSubtitle;
    AZSection *section = [AZSection new];
    [section addRow:row1];
    [section addRow:row2];
    
    AZRoot *root = [AZRoot new];
    [root addSection:section];
    root.grouped = YES;
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    
    ViewController *cont = [ViewController new];
    cont.title = @"In view ViewController";
    cont.view = tableView;
    return cont;
}

-(UIViewController *)dictionaryCont{
    AZRowEvent event = ^(AZRow *row, UIView *from, id value){
        NSLog(@"onSelect from json");
    };
    
    NSDictionary *dict = @{
                           @"grouped": @(YES),
                           @"sections": @[
                                   @{
                                       @"header": @"Header",
                                       @"rows": @[
                                               @{
                                                   @"text": @"Title",
                                                   @"onSelect": event,
                                                   @"type": @"button",
                                                   },
                                               @{
                                                   @"text": @"Title",
                                                   @"detail": @"Detail",
                                                   @"style": @(UITableViewCellStyleSubtitle),
                                                   }
                                               ]
                                       }
                                   ]
                           };
    
    AZRoot *root = [AZRoot new];
    [root yy_modelSetWithJSON:dict];

    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    
    ViewController *cont = [ViewController new];
    cont.title = @"From Dictionary";
    cont.view = tableView;
    return cont;
}

-(UIViewController *)jsonCont{
    NSString *json = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"table" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    AZRoot *root = [AZRoot new];
    [root yy_modelSetWithJSON:json];
    
    AZTableView *tableView = [[AZTableView alloc] initWithRoot:root];
    
    ViewController *cont = [ViewController new];
    cont.title = @"From JSON";
    cont.view = tableView;
    return cont;
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
