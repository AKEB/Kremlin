//
//  AKEBModelController.h
//  TEST
//
//  Created by Вадим Бабаджанян on 1/16/12.
//  Copyright (c) 2012 "АйТи Территория". All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKEBDataViewController;

@interface AKEBModelController : NSObject <UIPageViewControllerDataSource>
- (AKEBDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(AKEBDataViewController *)viewController;
@end
