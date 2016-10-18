//
//  ThirdPartyManager.h
//  Passcard
//
//  Created by lichangchun on 5/8/14.
//  Copyright (c) 2014 lichangchun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareData : NSObject

@property (nonatomic, copy) NSString *sShareId;
@property (nonatomic, copy) NSString *sTitle;
@property (nonatomic, copy) NSString *sPicUrl;
@property (nonatomic, copy) NSString *sContent;
@property (nonatomic, copy) NSString *sLinkUrl;

@end

@interface ThirdPartyManager : NSObject
+ (ThirdPartyManager *)shareInstance;

@property (nonatomic, retain) ShareData *data;

- (void) shareWithWX;//朋友圈
- (void) shareToWXFriend;//我的好友
- (void) shareWithQQFriend;
- (void) shareWithQQZone;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
