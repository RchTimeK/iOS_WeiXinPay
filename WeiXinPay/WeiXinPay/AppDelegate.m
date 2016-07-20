//
//  AppDelegate.m
//  WeiXinPay
//
//  Created by RongCheng on 16/7/20.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
     *** 按照官方的read_me.txt的提示，我们把这段plist代码拷贝到info.plist文件中：
     
      <key>LSApplicationQueriesSchemes</key>
      <array>
      <string>weixin</string>
      </array>
      <key>NSAppTransportSecurity</key>
      <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
      </dict>
     
     */
    
    
    
    //微信支付测试APPID ：wxb4ba3c02aa476ea1
    // 1.导入微信支付SDK。注册微信支付
    // 2.设置微信APPID未 URL Schemes
    // 3.发起支付，调起微信支付 :  jumpToBizPay
    // 4.处理支付结果: 处理返回微信支付返回信息，使用了微信知否功能，不管是支付成功和失败，甚至还是用户自己取消支付，都会需要返回当前应用，并返回相关的信息。这里就需要用到微信SDK的处理返回信息的代理协议和代理方法了
     [WXApi registerApp:@"wxb4ba3c02aa476ea1" withDescription:@"JiYue.com"];
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init] ];
    
    return YES;
}
-(void)onResp:(BaseResp *)resp{
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        
        //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //    [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

@end
