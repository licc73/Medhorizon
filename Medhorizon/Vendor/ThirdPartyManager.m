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
#import <SVProgressHUD/SVProgressHUD.h>
#include <sys/types.h>
#include <sys/sysctl.h>

#define WXAppId @"wxd6cfa4b7e0104f54"
#define WXAppSecret @"a6289763642953ca832be61e0abfcf0f"
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

- (void)sendAuthRequest:(UIViewController *)ctrl {
    [self sendAuthRequestScope: @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
                                        State:@"xxx"
                                       OpenID:WXAppId
                             InViewController:ctrl];
}

- (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;

    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:self];
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
    if ([WXApi registerApp:WXAppId]) {
        
    }
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:WXAppId])
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
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *wxResp = (SendAuthResp *)resp;
        if (wxResp.errCode == WXSuccess) {


            NSURLSession *session = [NSURLSession sharedSession];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WXAppId, WXAppSecret, wxResp.code]]];
            request.HTTPMethod = @"GET";

            NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

                if (error != nil) {
                    tips(@"", @"获取微信token失败");
                    return;
                }

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] ;
                if (dic != nil) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXLOGINSUCNOTIFICATION" object:nil userInfo:dic];
                }
                else {
                    tips(@"", @"获取微信token失败");
                }
            }];
            [task resume];
        }
        else if (wxResp.errCode == WXErrCodeAuthDeny) {
            //
            tips("", @"用户拒绝授权");
        }
        else if (wxResp.errCode == WXErrCodeUserCancel) {
            //用户取消
        }

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
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;

    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);

    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);

    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";

    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";

    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";

    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";

    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";

    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";

    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end
