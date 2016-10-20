//
//  ShareToThirdPartyView.m
//  Passcard
//
//  Created by lichangchun on 5/11/15.
//  Copyright (c) 2015 Passcard. All rights reserved.
//

#import "ShareToThirdPartyView.h"
#import "Medhorizon-swift.h"
#define COLOR(R,G,B) [UIColor colorWithIntValue:R :G :B :1];
//#define self.buttonWidth    43
//#define buttonHeight   36
#define X_OFFSET        16
#define BUTTON_GAP      5
@interface ShareToThirdPartyView ()
@property (nonatomic, strong) UIView *vTransparentView;
@property (nonatomic, strong) UIView *vContent;
@property (nonatomic, assign) CGFloat buttonWidth;
@property (nonatomic, assign) CGFloat buttonHeight;
@end

@implementation ShareToThirdPartyView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, [AppInfo screenWidth], [AppInfo screenHeight])];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configSubViews];
    }
    return self;
}

- (void) configSubViews
{
    self.buttonWidth = ([AppInfo screenWidth] - BUTTON_GAP * 3 - X_OFFSET) / 4.0;
    self.buttonHeight = self.buttonWidth * 109.0 / 131.0;
    self.vTransparentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.vTransparentView];
    self.vTransparentView.backgroundColor = [UIColor colorWithIntValue:37 :37 :37 :1];
    self.vTransparentView.alpha = 0.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf:)];
    [self.vTransparentView addGestureRecognizer:tap];
    
    self.vContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AppInfo screenWidth], 220)];
    self.vContent.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.vContent];

    UIImageView *imgvTopSep = [[UIImageView alloc] initWithFrame:CGRectMake(17, 20, [AppInfo screenWidth] - 17 * 2, .5)];
    imgvTopSep.backgroundColor = [UIColor colorWithHex:0xdddddd alpha:.8];
    [self.vContent addSubview:imgvTopSep];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake([AppInfo screenWidth] / 2 - 35, 10, 70, 24)];
    labTitle.backgroundColor = [UIColor whiteColor];
    labTitle.font = [UIFont systemFontOfSize:13];
    labTitle.textColor = [UIColor colorWithHex:0x2e92cb alpha:1];
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.text = @"分享到";
    [self.vContent addSubview:labTitle];
    

    
    CGFloat fXOffset = ([AppInfo screenWidth] - (BUTTON_GAP + self.buttonWidth) * 3 - self.buttonWidth) / 2;
    
    UIButton *btnWeixin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWeixin.frame = CGRectMake(fXOffset, 50, self.buttonWidth, self.buttonHeight);
    [btnWeixin setBackgroundImage:[UIImage imageNamed:@"icon_weixin_friend"] forState:UIControlStateNormal];
    btnWeixin.tag = ShareToThirdPartyPlatformWeixin;
    [btnWeixin addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.vContent addSubview:btnWeixin];
    
    UILabel *labWexin = [[UILabel alloc] initWithFrame:CGRectMake(fXOffset - 15, self.buttonHeight + 60, self.buttonWidth + 30, 15)];
    labWexin.font = [UIFont systemFontOfSize:13];
    labWexin.backgroundColor = [UIColor clearColor];
    labWexin.textColor = COLOR(33, 33, 33);
    labWexin.textAlignment = NSTextAlignmentCenter;
    labWexin.text = @"微信好友";
    [self.vContent addSubview:labWexin];
    
    UIButton *btnWeixinFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWeixinFriend.frame = CGRectMake(fXOffset + BUTTON_GAP + self.buttonWidth, 50, self.buttonWidth, self.buttonHeight);
    [btnWeixinFriend setBackgroundImage:[UIImage imageNamed:@"icon_weixin"] forState:UIControlStateNormal];
    btnWeixinFriend.tag = ShareToThirdPartyPlatformWeixinFriend;
    [btnWeixinFriend addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.vContent addSubview:btnWeixinFriend];
    
    UILabel *labWeixinFriend = [[UILabel alloc] initWithFrame:CGRectMake(fXOffset + BUTTON_GAP + self.buttonWidth - 15, self.buttonHeight + 60, self.buttonWidth + 30, 15)];
    labWeixinFriend.font = [UIFont systemFontOfSize:13];
    labWeixinFriend.backgroundColor = [UIColor clearColor];
    labWeixinFriend.textColor = COLOR(33, 33, 33);
    labWeixinFriend.textAlignment = NSTextAlignmentCenter;
    labWeixinFriend.text = @"微信朋友圈";
    [self.vContent addSubview:labWeixinFriend];
    
    UIButton *btnQQ = [UIButton buttonWithType:UIButtonTypeCustom];
    btnQQ.frame = CGRectMake(fXOffset + BUTTON_GAP * 2 + self.buttonWidth * 2, 50, self.buttonWidth, self.buttonHeight);
    [btnQQ setBackgroundImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateNormal];
    btnQQ.tag = ShareToThirdPartyPlatformQQFriend;
    [btnQQ addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.vContent addSubview:btnQQ];
    
    UILabel *labQQ = [[UILabel alloc] initWithFrame:CGRectMake(fXOffset + BUTTON_GAP * 2 + self.buttonWidth * 2 - 15, self.buttonHeight + 60, self.buttonWidth + 30, 15)];
    labQQ.font = [UIFont systemFontOfSize:13];
    labQQ.backgroundColor = [UIColor clearColor];
    labQQ.textColor = COLOR(33, 33, 33);
    labQQ.textAlignment = NSTextAlignmentCenter;
    labQQ.text = @"QQ好友";
    [self.vContent addSubview:labQQ];
    
    UIButton *btnQQZone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnQQZone.frame = CGRectMake(fXOffset + BUTTON_GAP * 3 + self.buttonWidth * 3, 50, self.buttonWidth, self.buttonHeight);
    [btnQQZone setBackgroundImage:[UIImage imageNamed:@"icon_qq_zone"] forState:UIControlStateNormal];
    btnQQZone.tag = ShareToThirdPartyPlatformQQZone;
    [btnQQZone addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.vContent addSubview:btnQQZone];
    
    UILabel *labQQZone = [[UILabel alloc] initWithFrame:CGRectMake(fXOffset + BUTTON_GAP * 3 + self.buttonWidth * 3 - 15, self.buttonHeight + 60, self.buttonWidth + 30, 15)];
    labQQZone.font = [UIFont systemFontOfSize:13];
    labQQZone.backgroundColor = [UIColor clearColor];
    labQQZone.textColor = COLOR(33, 33, 33);
    labQQZone.textAlignment = NSTextAlignmentCenter;
    labQQZone.text = @"QQ空间";
    [self.vContent addSubview:labQQZone];
    
    UIImageView *imgvBottomSep = [[UIImageView alloc] initWithFrame:CGRectMake(17, CGRectGetHeight(self.vContent.bounds) - 40 - 1, [AppInfo screenWidth] - 34, .5)];
    imgvBottomSep.backgroundColor = [UIColor colorWithHex:0xdddddd alpha:.8];
    [self.vContent addSubview:imgvBottomSep];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.frame = CGRectMake(0, CGRectGetHeight(self.vContent.bounds) - 40, [AppInfo screenWidth], 40);
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:16];
    btnCancel.titleLabel.textColor = [UIColor grayColor];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(cancelOperator:) forControlEvents:UIControlEventTouchUpInside];
    [self.vContent addSubview:btnCancel];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}
- (void) showInView:(UIView *)view
{
    [view addSubview:self];
    self.bounds = view.bounds;
    self.vContent.center = CGPointMake([AppInfo screenWidth] / 2, CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         self.vTransparentView.alpha = 0.35f;
                         self.vContent.center = CGPointMake([AppInfo screenWidth] / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.vContent.frame) / 2);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void) dismiss
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         self.vTransparentView.alpha = 0.0f;
                         self.vContent.center = CGPointMake([AppInfo screenWidth] / 2, CGRectGetHeight(self.bounds) + CGRectGetHeight(self.vContent.frame) / 2);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void) share:(UIButton *) button
{
    [self.delegate shareToThirdPartyView:self shareWith:button.tag];
}

- (void) cancelOperator:(UIButton *)button
{
    [self dismiss];
}

- (void) hideSelf:(UITapGestureRecognizer *)gesture
{
    [self dismiss];
}

@end
