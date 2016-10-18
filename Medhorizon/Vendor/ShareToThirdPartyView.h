//
//  ShareToThirdPartyView.h
//  Passcard
//
//  Created by lichangchun on 5/11/15.
//  Copyright (c) 2015 Passcard. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ShareToThirdPartyPlatform)
{
    ShareToThirdPartyPlatformWeixin             = 1,
    ShareToThirdPartyPlatformWeixinFriend       = 2,
    ShareToThirdPartyPlatformQQFriend           = 3,
    ShareToThirdPartyPlatformQQZone             = 4,
};

@class ShareToThirdPartyView;
@protocol shareToThirdPartyViewDelegate <NSObject>

- (void) shareToThirdPartyView:(ShareToThirdPartyView *)view shareWith:(ShareToThirdPartyPlatform)type;

@end

@interface ShareToThirdPartyView : UIView
- (void) showInView:(UIView *)view;
- (void) dismiss;
@property (nonatomic, weak) id<shareToThirdPartyViewDelegate> delegate;
@end
