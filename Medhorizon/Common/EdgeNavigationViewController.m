//
//  EdgeNavigationViewController.m
//  Passcard
//
//  Created by lichangchun on 12/10/14.
//  Copyright (c) 2014 Passcard. All rights reserved.
//

#import "EdgeNavigationViewController.h"
#import "UIViewController+edgeBack.h"
#import "UIImage+capture.h"
#import "Medhorizon-swift.h"

@interface EdgeNavigationViewController ()<UINavigationControllerDelegate>
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;
@end

@implementation EdgeNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
    self.canDragBack = YES;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    self.delegate = self;
    [recognizer requireGestureRecognizerToFail:self.interactivePopGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 1) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    else
    {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = viewController;
        viewController.view.clipsToBounds = YES;
    }

    if (self.viewControllers.count <= self.screenShotsList.count) {
        NSRange rg = NSMakeRange((self.viewControllers.count - 1 <= 0) ? 0 : self.viewControllers.count - 1, self.screenShotsList.count - self.viewControllers.count + 1);
        [self.screenShotsList removeObjectsInRange:rg];
    }
}

- (void) removeSubViewController:(UIViewController *)subCtrl isActionPush:(BOOL)bPush
{
    NSInteger index = [self.viewControllers indexOfObject:subCtrl];
    if (index != NSNotFound) {
        if (bPush) {
            [self.screenShotsList removeObjectAtIndex:index];
        }
        else
        {
            [self.screenShotsList removeObjectAtIndex:index - 1];
        }
    }
    [subCtrl removeFromParentViewController];
}

- (void)dealloc
{
    self.screenShotsList = nil;    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
        return  YES;
    }

    return NO;
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:(BOOL)animated];
//    
////    if (self.screenShotsList.count == 0) {
////        UIImage *capturedImage = [self capture];
////        if (capturedImage) {
////            [self.screenShotsList addObject:capturedImage];
////        }
////    }
//}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIImage *capturedImage = [UIImage captureView:self.view];
    
    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
    }
    
    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

// get the current view screen shot
//- (UIImage *)capture
//{
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//}

#define PUSH_OFFSET 64
// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    //NSLogEx(@"Move to:%f",x);
    x = x > [AppInfo screenWidth] ? [AppInfo screenWidth] : x;
    x = x < 0 ? 0 : x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    //float scale = (x/6400)+0.95;
    //lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    
    float alpha = 0.4 - (x / 800);
    blackMask.alpha = alpha;
    
    CGPoint backgroundViewCenter = self.backgroundView.center;
    self.backgroundView.center = CGPointMake(PUSH_OFFSET + ([AppInfo screenWidth] / 2 - PUSH_OFFSET) * x / [AppInfo screenWidth], backgroundViewCenter.y);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1 || !self.canDragBack)
    {
        return NO;
    }
    return YES;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:[UIApplication sharedApplication].keyWindow];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    }
    else if (recoginzer.state == UIGestureRecognizerStateEnded){
        if (touchPoint.x - startTouch.x > 80)
        {
            if (self.viewControllers.count > 0) {
                UIViewController *viewCtrl = [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
                if ([viewCtrl respondsToSelector:@selector(edgeNavPopToLastViewCtrl)]) {
                    [viewCtrl performSelector:@selector(edgeNavPopToLastViewCtrl)];
                }
            }
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self moveViewWithX:[AppInfo screenWidth]];
                             }
                             completion:^(BOOL finished) {
                                 [self popViewControllerAnimated:NO];
                                 CGRect frame = self.view.frame;
                                 frame.origin.x = 0;
                                 self.view.frame = frame;
                                 _isMoving = NO;
                                 self.backgroundView.hidden = YES;
                             }];
        }
        else
        {
            [self restoreView];
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }
    else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        [self restoreView];
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

- (void) restoreView
{
    [UIView animateWithDuration:0.3 animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finished) {
        _isMoving = NO;
        self.backgroundView.hidden = YES;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
