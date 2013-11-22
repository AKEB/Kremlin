//
//  KremlinAppDelegate.m
//  Kremlin
//
//  Created by AKEB on 9/1/10.
//  Copyright AKEB.RU 2010. All rights reserved.
//

#import "KremlinAppDelegate.h"
#import "KremlinViewController.h"

@implementation KremlinAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
