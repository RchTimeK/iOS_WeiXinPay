//
//  ViewController.m
//  WeiXinPay
//
//  Created by RongCheng on 16/7/20.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "ViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"微信支付";
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(80, 200, 200, 50);
    [btn setTitle:@"点击调起微信支付" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(payClick) forControlEvents:(UIControlEventTouchUpInside)];
    btn.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:btn];
}
- (void)payClick
{
    [self WXPay];
}
- (void)WXPay{
    
    //根据查询微信API文档 ，我们需要添加两个判断
    // 是否安装了微信
    if (![WXApi isWXAppInstalled]){
        NSLog(@"没有安装微信");
        
    }
    // 是否支持微信支付
    else if (![WXApi isWXAppSupportApi]){
        NSLog(@"不支持微信支付");
    }
    
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSession * session=[NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ( data != nil) {
            NSMutableDictionary *dict = NULL;
            
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            NSLog(@"url:%@",urlString);
            if(dict != nil){
                NSMutableString *retcode = [dict objectForKey:@"retcode"];
                if (retcode.intValue == 0)
                {
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                    //日志输出
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                    //return @"";
                    
                }else{
                    // return [dict objectForKey:@"retmsg"];
                    NSLog(@"微信支付返回的信息:%@",[dict objectForKey:@"retmsg"]);
                }
            }
            
            else{
                //return @"服务器返回错误，未获取到json对象";
                NSLog(@"微信支付返回的信息:服务器返回错误，未获取到json对象");
            }
        }
        
        
        
        
        else{
            // return @"服务器返回错误";
            NSLog(@"微信支付返回的信息:服务器返回错误");
        }
    }];
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
