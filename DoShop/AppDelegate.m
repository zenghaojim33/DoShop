//
//  AppDelegate.m
//  DoShop
//
//  Created by Anson on 15/2/4.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "AFNetworking.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UIAlertView+Blocks.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSnsService.h"
#import "MiPushSDK.h"
@interface AppDelegate ()<MiPushSDKDelegate,UIAlertViewDelegate>

@end

@implementation AppDelegate{
    
    NSString * _UUID;
    
}


//异常处理
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //创建一个2m的内存缓存和100m的硬盘缓存
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [[[TMCache sharedCache] memoryCache] setCostLimit:100];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //判断是否初次使用
    BOOL hasLaunchedBefore = [[NSUserDefaults standardUserDefaults]boolForKey:@"hasLaunchedBefore"];
    
    NSString *storyboardId = hasLaunchedBefore ? @"mainentrance" : @"welcomepage";
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedBefore"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoShop" bundle:[NSBundle mainBundle]];
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = initViewController;
    [self.window makeKeyAndVisible];
    

    [MiPushSDK registerMiPush:self];
    

    [self setUMSocial];
    [self setPush:application];
    [self configNetwork];
    
    _UUID =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults]setObject:_UUID forKey:@"UUID"];
    
    return YES;
}

//设置推送
-(void)setPush:(UIApplication*)application
{
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue]<8.0) {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }else
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge
                                                | UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    
    
    
    
}

//设置分享
-(void)setUMSocial
{
    
    [UMSocialData setAppKey:UMAppKey];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxcba57e18daaff3f9" appSecret:@"2de9197cbfae27eaa9feabcf1eb4f672" url:@"www.dome123.com"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://api.weibo.com/oauth2/default.html"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1103312909" appKey:@"G5a0tbDJOqRunAmQ" url:@"http://www.beautyway.com.cn"];
    
    
    
}

//设置网络


-(void)configNetwork
{
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    
    
}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    
    NSLog(@"新浪微博回调：%@",url.description);
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"注册APNS成功, 注册deviceToken");
    NSLog(@"APNS token: %@", [deviceToken description]);
    [MiPushSDK bindDeviceToken:deviceToken];

    [MiPushSDK setAlias:_UUID];
    
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    NSLog(@"推送通知注册失败");
    
}


-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    
    return UIInterfaceOrientationMaskPortrait;
    
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];
    DEF_WEAKSELF
    if ([userInfo[@"type"] isEqualToString:@"logout"])
    {
        
        
        DEF_STRONGSELF
        [UIAlertView showWithTitle:@"您的账号已在别处登录" message:@"请重新登录" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0)
            {
                [self.window.rootViewController dismissModalViewControllerAnimated:YES];
            }
        }];
        
        
    }

}



-(void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    
    NSLog(@"Success");
    
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[TMCache sharedCache]removeAllObjects];
     
}



@end
