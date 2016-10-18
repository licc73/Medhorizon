//
//  ThirdPartyManager.m
//  Passcard
//
//  Created by lichangchun on 5/8/14.
//  Copyright (c) 2014 lichangchun. All rights reserved.
//

#import "ThirdPartyManager.h"
#import "Medhorizon-swift.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#define tcAppKey @"801536108"
#define tcAppSecret @"33401d179803a303a0f323f3e2720d32"
#define tcRedirectURL @"http://www.passcard.com.cn"

#define qqAppKey @"1105664608"

#define tips(t, m) [AppInfo showToast:m duration:2]

@implementation ShareData


@end

@interface ThirdPartyManager() <WXApiDelegate,TencentSessionDelegate, TencentApiInterfaceDelegate,  TCAPIRequestDelegate, QQApiInterfaceDelegate>

//由于微信朋友圈与微信好友用的同一个sdk，分享函数基本相同，从响应上无法判断是使用哪个分享
@property (nonatomic, assign) int WXSence;


@property (nonatomic, retain) TencentOAuth *QQOauth;

@end

@implementation ThirdPartyManager
+ (ThirdPartyManager *)shareInstance
{
    static ThirdPartyManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self WXWeiboAuthor];
        [self tcQQOauth];
    }
    return self;
}


//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}



#pragma mark WXRequestDelegate

- (void)WXWeiboAuthor
{
    if ([WXApi registerApp:@"wxd6cfa4b7e0104f54"]) {
        
    }
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"wxd6cfa4b7e0104f54"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.scheme isEqualToString:@"tencent1105664608"])
    {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }
    return YES;
}

- (void) shareToWXFriend
{
    [self shareWithWXSence:WXSceneSession];
}

- (void) shareWithWX
{
    [self shareWithWXSence:WXSceneTimeline];
}

- (void) shareWithWXSence:(int)sence
{
    self.WXSence = sence;
    if ([WXApi isWXAppInstalled]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *shareImg = [UIImage imageNamed:@"IconShare"];
            
            UIImage *lastShareImg = [self scaleToSize:shareImg size:CGSizeMake(120, 120)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *sShareContent = [NSString stringWithFormat:@"%@", self.data.sContent];
                NSString *sShareTitle = [NSString stringWithFormat:@"%@", self.data.sTitle];
                
                WXWebpageObject *webPage = [WXWebpageObject object];
                webPage.webpageUrl = self.data.sLinkUrl;
                
                WXMediaMessage *mediaMsg = [WXMediaMessage message];
                mediaMsg.mediaObject = webPage;
                mediaMsg.title = sShareTitle;
                mediaMsg.description = sShareContent;
                [mediaMsg setThumbImage:lastShareImg];
                
                SendMessageToWXReq* resp = [[SendMessageToWXReq alloc] init];
                resp.text = sShareContent;
                resp.bText = NO;
                resp.scene = sence;
                resp.message = mediaMsg;
                [WXApi sendReq:resp];

            });
            
        });
        
    }
    else
    {
        tips(@"", @"手机未安装微信应用");
    }
    
}
-(void) onReq:(id)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        
    }
    
}

-(void) onResp:(id)resp
{
    //可以省略
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        BaseResp *wxResp = (SendMessageToWXResp *)resp;
        switch (wxResp.errCode) {
            case WXSuccess:
            {
                tips("", @"分享成功");
            }
                break;
            case WXErrCodeAuthDeny:
            {
                tips(@"", @"微信授权失败");
            }
                break;
            case WXErrCodeCommon:
            {
                tips(@"", @"分享失败");
            }
                break;
            case WXErrCodeUserCancel:
            {
                tips(@"", @"用户取消分享");
            }
                break;
            case WXErrCodeSentFail:
            {
                tips(@"", @"发送失败");
            }
                break;
            case WXErrCodeUnsupport:
            {
                tips(@"", @" 微信不支持");
            }
                break;
                
                
            default:
                break;
        }
    }
    else if ([resp isKindOfClass:[SendMessageToQQResp class]])
    {
        SendMessageToQQResp *qqReq = (SendMessageToQQResp *)resp;
        switch ([qqReq.result intValue]) {
            case -4:
            {
                
            }
                break;
            case 0:
            {
            
                tips("", @"分享成功");
            }
                break;
                
            default:
                break;
        }
    }
    else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        //BaseResp *wxPayResp = (PayResp *)resp;
        
    }
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

//qq
- (void) tcQQOauth
{
    self.QQOauth = [[TencentOAuth alloc] initWithAppId:qqAppKey
                                     andDelegate:self];
}


- (void)tencentDidLogin
{
   
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

- (void)tencentDidNotNetWork
{
    
}

- (void)tencentDidLogout
{
    
}

//- (BOOL)onTencentReq:(TencentApiReq *)req
//{
//    
//}
//
//- (BOOL)onTencentResp:(TencentApiResp *)resp
//{
//    
//}
/**
 * 请求获得内容 当前版本只支持第三方相应腾讯业务请求
 */
- (BOOL)onTencentReq:(TencentApiReq *)req
{
    return YES;
}

/**
 * 响应请求答复 当前版本只支持腾讯业务相应第三方的请求答复
 */
- (BOOL)onTencentResp:(TencentApiResp *)resp
{
    return YES;
}
- (void) shareWithQQFriend
{
    //分享跳转URL
    NSString *url = self.data.sLinkUrl;
    NSString *sShareContent = self.data.sContent;
    NSString *sShareTitle = self.data.sTitle;
    //分享图预览图URL地址
    //UIImage *shareImg = [self getShareImageData:[[[AppGlobalData shareInstance] dicShareToThirdPlatData] objectForKey:ShareToThirdPartyPicUrl]];
    NSString *sPicUrl = self.data.sPicUrl;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title: sShareTitle
                                description:sShareContent
                                previewImageURL:[NSURL URLWithString:sPicUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sentCode = [QQApiInterface sendReq:req];
    [self handleSendResult:sentCode];
}

- (void) shareWithQQZone
{
    //分享跳转URL
    NSString *url = self.data.sLinkUrl;
    NSString *sShareContent = self.data.sContent;
    NSString *sShareTitle = self.data.sTitle;
    //分享图预览图URL地址
    //UIImage *shareImg = [self getShareImageData:[[[AppGlobalData shareInstance] dicShareToThirdPlatData] objectForKey:ShareToThirdPartyPicUrl]];
    NSString *sPicUrl = self.data.sPicUrl;
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title: sShareTitle
                                description:sShareContent
                                 previewImageURL:[NSURL URLWithString:sPicUrl]];
    [newsObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sentCode = [QQApiInterface sendReq:req];
    [self handleSendResult:sentCode];
}



- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            tips(@"", @"app未注册");
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            tips(@"", @"发送参数错误");
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            tips(@"", @"未安装手机QQ");
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            tips(@"", @"API接口不支持");
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            tips(@"", @"发送失败");
            
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
