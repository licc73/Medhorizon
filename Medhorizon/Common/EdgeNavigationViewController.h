//
//  EdgeNavigationViewController.h
//  Passcard
//
//  Created by lichangchun on 12/10/14.
//  Copyright (c) 2014 Passcard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APBaseNavigationController.h"
@protocol EdgeNavigationViewController<NSObject>
- (void) edgeNavPopToLastViewCtrl;
@end
@interface EdgeNavigationViewController : APBaseNavigationController
@property (nonatomic,assign) BOOL canDragBack;
- (void) removeSubViewController:(UIViewController *)subCtrl isActionPush:(BOOL)bPush;
@end
