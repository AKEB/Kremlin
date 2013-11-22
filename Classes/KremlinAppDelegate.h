//
//  KremlinAppDelegate.h
//  Kremlin
//
//  Created by AKEB on 9/1/10.
//  Copyright AKEB.RU 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KremlinViewController;

@interface KremlinAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    KremlinViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet KremlinViewController *viewController;

@end

