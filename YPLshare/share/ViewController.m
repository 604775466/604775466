//
//  ViewController.m
//  share
//
//  Created by CYH06 on 17/1/5.
//  Copyright © 2017年 CYH06. All rights reserved.
//
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }

#import "ViewController.h"

#import "OpenShareHeader.h"

@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)login:(id)sender
{
    [OpenShare QQAuth:@"get_user_info" Success:^(NSDictionary *message) {
        ULog(@"QQ登录成功\n%@",message);
    } Fail:^(NSDictionary *message, NSError *error) {
        ULog(@"QQ登录失败\n%@\n%@",error,message);
    }];
}

- (IBAction)sendMassage:(id)sender
{
    OSMessage *msg=[[OSMessage alloc]init];

    msg.title=[NSString stringWithFormat:@"Hello OpenShare (msg.title) %f",[[NSDate date] timeIntervalSince1970]];

    [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
        ULog(@"微信分享到会话成功：\n%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        ULog(@"微信分享到会话失败：\n%@\n%@",error,message);
    }];
}
- (IBAction)share:(id)sender
{
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title=@"你好易馨";
    
    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
        ULog(@"微信分享到朋友圈成功：\n%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        ULog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
    }];
}
- (IBAction)collection:(id)sender
{
    OSMessage *msg=[[OSMessage alloc]init];
    
    msg.title=@"你好易馨";
    
    [OpenShare shareToWeixinFavorite:msg Success:^(OSMessage *message) {
        ULog(@"微信分享到收藏成功：\n%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        ULog(@"微信分享到收藏失败：\n%@\n%@",error,message);
    }];
}

- (IBAction)pay:(id)sender
{
    NSString *apiUrl=@"https://pay.example.com/pay.php?payType=weixin";
    if ([apiUrl hasPrefix:@"https://pay.example.com"])
    {
        
        ULog(@"请部署pay.php，填写自家的key。");
    }
    else
    {
        //网络请求不要阻塞UI，仅限Demo
        NSData *data=[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:apiUrl]] returningResponse:nil error:nil];
        NSString *link=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [OpenShare WeixinPay:link Success:^(NSDictionary *message) {
            ULog(@"微信支付成功:\n%@",message);
        } Fail:^(NSDictionary *message, NSError *error) {
            ULog(@"微信支付失败:\n%@\n%@",message,error);
        }];
    }

}


@end
