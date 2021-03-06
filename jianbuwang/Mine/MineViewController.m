//
//  MineViewController.m
//  jianbuwang
//
//  Created by Steve on 24/07/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//

#define kDEVICEWIDTH  [UIScreen mainScreen].bounds.size.width
#define kDEVICEHEIGHT  [UIScreen mainScreen].bounds.size.height

#import "AppDelegate.h"
#import "MineViewController.h"
#import <WebKit/WebKit.h>
#import "LoginRegistViewController.h"
#import "MBProgressHUD.h"

@interface MineViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) WKWebView                *webView;
@property (nonatomic, strong)  AppDelegate             *appdelegate;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //设置监听
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"app"];
    // 设置偏好设置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    //解决音乐播放问题
    config.allowsInlineMediaPlayback = YES;
    config.mediaPlaybackRequiresUserAction = false;
    //    config.preferences = [[WKPreferences alloc] init]; // 默认为0
    //    config.preferences.minimumFontSize = 10; // 默认认为YES
    //    config.preferences.javaScriptEnabled = YES;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,  kDEVICEWIDTH, kDEVICEHEIGHT - 49  ) configuration:config];
//    [_webView sizeToFit];
    
    
    _webView.scrollView.bounces = YES;
    _webView.navigationDelegate = self;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
    
    
    // Do any additional setup after loading the view from its nib.
    
    NSString* userTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    
    NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/userCenter.htm?userToken=%@",userTokenString];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
   
    
    
    
    NSLog(@"message.name %@",message.name);
    NSLog(@"message.body %@",message.body);
    
    NSDictionary *dic = message.body;
    NSLog(@"dic %@",dic);
    
    if ([dic[@"function"] isEqualToString:@"logout"] ) {
        
        
        //情况用户名，密码，用户token
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userPWD"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userToken"];
        
        LoginRegistViewController* LoginRegistVC = [[LoginRegistViewController alloc] init];
        [self presentViewController:LoginRegistVC animated:YES completion:nil]; // 调用pushViewController
        
    }
    
    else if ([dic[@"function"] isEqualToString:@"setTarget"]) {
        
        NSString* targetNum = dic[@"targetNum"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTarget" object:targetNum];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"目标修改成功";
        hud.detailsLabel.text = nil;
        [hud hideAnimated:YES afterDelay:1];
        
    }
    
    else if ([dic[@"function"] isEqualToString:@"updatePassword"]) {
        
        NSString* password = dic[@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"userPWD"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"密码修改成功";
        hud.detailsLabel.text = nil;
        [hud hideAnimated:YES afterDelay:1];
        
    }
    
    
}

/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"1");
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabel.text = nil;
    [hud hideAnimated:YES afterDelay:5];
    
    //添加检查网络方法
    NetworkStatus status = _appdelegate.reachability.currentReachabilityStatus;
    
    [self showHUDWithReachabilityStatus:status];
    
}

/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"2");
}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"3");
    //    [self.indicatorView stopAnimating];
    [MBProgressHUD hideHUDForView:self.view animated:true];
    
}


/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"4");
    [MBProgressHUD hideHUDForView:self.view animated:true];
}

#pragma mark-- 执行网络判断
- (void)showHUDWithReachabilityStatus:(NetworkStatus)status
{
    if (status == NotReachable) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterView show];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
