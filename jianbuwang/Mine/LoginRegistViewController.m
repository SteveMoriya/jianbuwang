//
//  LoginRegistViewController.m
//  jianbuwang
//
//  Created by Steve on 27/07/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//

#import "LoginRegistViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"

#import "HomeTabBarViewController.h"

@interface LoginRegistViewController ()

@end

@implementation LoginRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    //如果已经存在用户信息，则直接登录
    NSString* userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
    NSString* userPWD = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPWD"];
    
    if (userPhone.length > 0 || userPWD.length > 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)login:(id)sender {
    
    LoginViewController* loginVC = [[LoginViewController alloc] init];
    
    [self presentViewController:loginVC animated:YES completion:nil];
    
    
}

- (IBAction)regist:(id)sender {
    RegistViewController* registVC = [[RegistViewController alloc] init];
    [self presentViewController:registVC animated:YES completion:nil];
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
