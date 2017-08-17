//
//  LoginViewController.m
//  jianbuwang
//
//  Created by Steve on 27/07/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FindPWDViewController.h"
#import "AFNetworking.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTV;//电话号码文本框
@property (weak, nonatomic) IBOutlet UITextField *PWDTV;//密码文本框
@property (nonatomic, strong)  AppDelegate             *appdelegate;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (IBAction)popAction:(id)sender {
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)findPWDAction:(id)sender {
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    FindPWDViewController* findPWDVC = [[FindPWDViewController alloc] init];
    [self presentViewController:findPWDVC animated:YES completion:nil]; // 调用pushViewController
}

- (IBAction)loginAction:(id)sender {
    
    if (self.phoneTV.text.length != 11 || self.PWDTV.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"请输入正确信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    
    //登录接口，并返回相关数据
    NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/login.htm?mobilePhone=%@&password=%@",self.phoneTV.text,self.PWDTV.text];
    
    //添加检查网络方法
    NetworkStatus status = _appdelegate.reachability.currentReachabilityStatus;
    if (status == NotReachable) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterView show];
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载的进度");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"flag"] ] isEqualToString:@"1"]) {
            
            //存储登录成功的用户名，密码
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTV.text forKey:@"userPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:self.PWDTV.text forKey:@"userPWD"];
            
            //获取 userToken
            NSString* userTokenString = responseObject[@"userToken"];
            [[NSUserDefaults standardUserDefaults] setObject:userTokenString forKey:@"userToken"];
            
            //验证验证码成功，调用找回密码
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error);
    }];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
