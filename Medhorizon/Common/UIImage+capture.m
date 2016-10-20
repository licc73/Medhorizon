//
//  UIImage+capture.m
//  Passcard
//
//  Created by lichangchun on 12/12/14.
//  Copyright (c) 2014 Passcard. All rights reserved.
//

#import "UIImage+capture.h"

@implementation UIImage (capture)
+ (UIImage *) captureView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
