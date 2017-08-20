//
//  RegistViewController.m
//  jianbuwang
//
//  Created by Steve on 27/07/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//

#import "RegistViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTV;
@property (weak, nonatomic) IBOutlet UITextField *codeTV;
@property (weak, nonatomic) IBOutlet UITextField *PWDTV;
@property (nonatomic, strong)  AppDelegate             *appdelegate;


@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (IBAction)getCodeAction:(id)sender {
    
    if (self.phoneTV.text.length != 11) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    //添加检查网络方法
    NetworkStatus status = _appdelegate.reachability.currentReachabilityStatus;
    
    if (status == NotReachable) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterView show];
        
        return;
    }
    
    //获取验证码接口，并返回相关数据
    NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/sendShortMessage.htm?type=register&mobilePhone=%@",self.phoneTV.text];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error %@",error);
        
    }];
    
}
- (IBAction)registAction:(id)sender {
    
    //添加检查网络方法
    NetworkStatus status = _appdelegate.reachability.currentReachabilityStatus;
    if (status == NotReachable) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterView show];
        
        return;
    }
    
    //获取验证码接口，并返回相关数据
    NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/checkShortMessage.htm?mobile=%@&shortCode=%@",self.phoneTV.text,self.codeTV.text];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"flag"] ] isEqualToString:@"1"]) {
            //验证验证码成功，调用找回密码
            [self regist];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error %@",error);
        
    }];
    
}

- (void) regist {
    
    
    //添加检查网络方法
    NetworkStatus status = _appdelegate.reachability.currentReachabilityStatus;
    if (status == NotReachable) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterView show];
        
        return;
    }
    
    //注册接口，并返回相关数据
    NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/register.htm?mobilePhone=%@&password=%@",self.phoneTV.text,self.PWDTV.text];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"flag"] ] isEqualToString:@"1"]) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error %@",error);
        
    }];
    
}


- (IBAction)popAction:(id)sender {
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
