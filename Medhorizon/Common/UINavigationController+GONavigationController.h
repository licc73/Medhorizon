//
//  UINavigationController+GONavigationController.h
//  Passcard
//
//  Created by lichangchun on 8/3/15.
//  Copyright (c) 2015 Passcard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (GONavigationController)
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)lock;
- (id)navigationlock;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)lock;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated navigationLock:(id)lock;
@end
