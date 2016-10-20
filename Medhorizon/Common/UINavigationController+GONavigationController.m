//
//  UINavigationController+GONavigationController.m
//  Passcard
//
//  Created by lichangchun on 8/3/15.
//  Copyright (c) 2015 Passcard. All rights reserved.
//

#import "UINavigationController+GONavigationController.h"

@implementation UINavigationController (GONavigationController)
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)lock
{
    if (!lock || self.topViewController == lock)
    {
        [self pushViewController:viewController animated:animated];
    }
}
- (id)navigationlock
{
    return self.topViewController;
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)lock
{
    if (!lock || self.topViewController == lock)
    {
        [self popToViewController:viewController animated:animated];
    }
    return @[];
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated navigationLock:(id)lock
{
    if (!lock || self.topViewController == lock)
    {
        [self popToRootViewControllerAnimated:animated];
    }
    return @[];
}
@end
