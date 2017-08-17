//
//  BaseHomeViewController.m
//  jianbuwang
//
//  Created by Steve on 24/07/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//

#import "BaseHomeViewController.h"
#import "AFNetworking.h"
#import "LoginRegistViewController.h"
#import "Bean4UserInfo.h"
#import "MJExtension.h"

#import "MBProgressHUD.h"

#import "CicrlView.h"
#import "AppDelegate.h"

@import UTESmartBandApi;

@interface BaseHomeViewController ()<UTEManagerDelegate>

{
    
    Bean4UserInfo* beanResp;//用户单例数据
    
}


@property (weak, nonatomic) IBOutlet CicrlView *homeCircleView;//首页进度圈

@property (weak, nonatomic) IBOutlet UILabel *todaySteps; // 今日步数
@property (weak, nonatomic) IBOutlet UILabel *goalSteps; // 目标步数
@property (weak, nonatomic) IBOutlet UILabel *calories; //  卡路里数
@property (weak, nonatomic) IBOutlet UILabel *distance; // 距离
@property (weak, nonatomic) IBOutlet UILabel *getSteps; // 获取到的步数

@property (weak, nonatomic) IBOutlet UILabel *rank;//今日步数排名
@property (weak, nonatomic) IBOutlet UILabel *AllDay;//万步走总天数
@property (weak, nonatomic) IBOutlet UILabel *AllWalkNum;//总步数
@property (weak, nonatomic) IBOutlet UILabel *AllTime;//总时长
@property (weak, nonatomic) IBOutlet UILabel *AllProbability;//总万步率

@property (nonatomic,strong) UTESmartBandClient *smartBandMgr;
@property (nonatomic, strong)  AppDelegate             *appdelegate;


@end

@implementation BaseHomeViewController

- (void) viewDidAppear:(BOOL)animated {
    
    //如果没有用户信息，跳转登录注册页面
    NSString* userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
    NSString* userPWD = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPWD"];
    
    if (userPhone.length == 0 || userPWD.length == 0) {
        
        LoginRegistViewController* LoginRegistVC = [[LoginRegistViewController alloc] init];
        [self presentViewController:LoginRegistVC animated:YES completion:nil]; // 调用pushViewController
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //用户登录接口
    [self loginAction];
    
    
    //    //设置登录页面的等待时间
    //    [NSThread sleepForTimeInterval:2.0];
    
    //更改步数通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo:) name:@"uteSteps" object:nil];
    
    //更改目标通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTarget:) name:@"updateTarget" object:nil];
    
    
    
    //1. 实例化
    self.smartBandMgr = [UTESmartBandClient sharedInstance];
    //2. 初始化
    [self.smartBandMgr initUTESmartBandClient];
    //3. 设置代理
    self.smartBandMgr.delegate = self;
    //4. 打开log
    self.smartBandMgr.debugUTELog = YES;
    
    //启动自动连接设备
    
    [self performSelector:@selector(connectDefaultDevice) withObject:nil afterDelay:3];
    
//    [self connectDefaultDevice];
    
    
}

- (void) connectDefaultDevice {
    
    //如果存在默认设备，则显示这个设备
    NSString* defaultDeviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultDeviceID"];
    NSString* defaultDeviceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultDeviceName"];
    
    //设置设备状态为未连接
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"defaultDeviceConnected"];
    
    if (defaultDeviceID) {
        
        UTEModelDevices *model = [[UTEModelDevices alloc] init];
        model.identifier = defaultDeviceID;
        model.name = defaultDeviceName;
        
        [self.smartBandMgr connectUTEModelDevices:model];
    }
    
}


#pragma mark - UTEManagerDelegate


- (void)uteManagerReceiveTodaySteps:(UTEModelRunData *)runData
{
    NSLog(@"***今天时间=%@，总步数=%ld,总路程=%f,总卡路里=%f,当前小时步数=%ld",runData.time,(long)runData.totalSteps,runData.distances,runData.calories,(long)runData.hourSteps);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uteSteps" object:runData];
    
}

- (void)uteManagerDevicesSate:(UTEDevicesSate)devicesState error:(NSError *)error userInfo:(NSDictionary *)info
{
    
    
    if (error) {
        NSLog(@"***错误码=%ld,msg=%@",(long)error.code,error.domain);
    }
    
    switch (devicesState) {
        case UTEDevicesSateConnected: {
            //每次连上应该设置一下配置，保证App和设备的信息统一
            [self setupConfiguration];
            
            break;
        }
            
        default: {
            break;
        }
            
    }
    
}

#pragma mark - 私有方法，用于传用户的身高，体重，以及亮屏时间
- (void)setupConfiguration
{
 
    //通知，告知已经自动连接成功
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectDefaultDeviceSuccess" object:@"1"];
    //存储已连接状态
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"defaultDeviceConnected"];
    
    //1.关闭扫描
    //    [self onClickStopSearch];
    //停止搜索设备
    [self.smartBandMgr stopScanDevices];
    //2.设置设备时间
    [self.smartBandMgr setUTEOption:UTEOptionSyncTime];
    //3.设置设备闹钟
    //    [self setDevicesAlarm];
    
    //4.1 先设置设备单位:公尺
    [self.smartBandMgr setUTEOption:UTEOptionUnitMeter];
    //4.2 后设置设备中身高、体重
    [self.smartBandMgr setUTEInfoHeigh:beanResp.userHeight weight:beanResp.userWeight light:6 sportTarget:8000 handlight:NO maxHeart:0];
    
//    [self.smartBandMgr setUTEOption:UTEOptionHeartSwitchDynamic];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"连接成功";
        hud.detailsLabel.text = @"正在同步数据";
        [hud hideAnimated:YES afterDelay:1];
        
    });
    
}



- (void) loginAction {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步数据";
    hud.detailsLabel.text = nil;
    [hud hideAnimated:YES afterDelay:1];
    
    
    //如果已经存在用户信息，则直接登录
    NSString* userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
    NSString* userPWD = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPWD"];
    
    if (userPhone.length > 0 || userPWD.length > 0) {
        
        NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/login.htm?mobilePhone=%@&password=%@",userPhone,userPWD];
        
        //添加检查网络方法
        NetworkStatus status = _appdelegate.reachability.currentReachabilityStatus;
        if (status == NotReachable) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
            
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alterView show];
            
            return;
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"下载的进度");
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"responseObject %@",responseObject);
            
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"flag"] ] isEqualToString:@"1"]) {
                
                //获取 userToken
                NSString* userTokenString = responseObject[@"userToken"];
                [[NSUserDefaults standardUserDefaults] setObject:userTokenString forKey:@"userToken"];
                
                //获取用户单例数据
                NSDictionary* userInfoDic = responseObject[@"userInfo"];
                beanResp = [Bean4UserInfo mj_objectWithKeyValues:userInfoDic];
                
                [self.AllDay setText: [NSString stringWithFormat:@"%ld天",(long)beanResp.allDay]];
                [self.AllWalkNum setText: [NSString stringWithFormat:@"%ld步",(long)beanResp.allWalkNum]];
                [self.AllTime setText: [NSString stringWithFormat:@"%.2f时",(float) beanResp.allTime / (60 * 60 * 1000)]];
                [self.AllProbability setText: [NSString stringWithFormat:@"%.2f%%",beanResp.allProbability]];
                
                
                //当登录成功后，立即去获取一遍默认数据并显示
                
                if (beanResp.userToken.length >0) {
                    [self getDefaultData];
                }
                
                
            }
            
            //自动登录失败，跳转登录界面
            else {
                
                //情况用户名，密码，用户token
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userPhone"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userPWD"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userToken"];
                
                LoginRegistViewController* LoginRegistVC = [[LoginRegistViewController alloc] init];
                [self presentViewController:LoginRegistVC animated:YES completion:nil]; // 调用pushViewController
                
            }
            
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //            [alert show];
            
            
            //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            hud.label.text = responseObject[@"message"];
            //            hud.detailsLabel.text = nil;
            //            [hud hideAnimated:YES afterDelay:1];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败:%@", error);
        }];
        
    }
    
}

//获取默认步数，卡路里，距离等数据
- (void) getDefaultData {
    
    //添加检查网络方法
    NetworkStatus status = _appdelegate.reachability.currentReachabilityStatus;
    if (status == NotReachable) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterView show];
        
        return;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/changeUserStep.htm?userToken=%@&walkNum=0&kcal=0&distance=0",beanResp.userToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载的进度");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject %@",responseObject);
        
        
        
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"flag"] ] isEqualToString:@"1"]) {
            
            //重新获取一次最后一次上传的数据
            NSDictionary* userInfoDic = responseObject[@"rank"];
            
            [self.rank setText: [NSString stringWithFormat:@"%@",userInfoDic[@"rank"]]];
            [self.goalSteps setText: [NSString stringWithFormat:@"目标 %@",userInfoDic[@"target_num"]]];
            
            [self.todaySteps setText: [NSString stringWithFormat:@"%@",userInfoDic[@"walk_num"]]];
            [self.getSteps setText:  [NSString stringWithFormat:@"%@ 步",userInfoDic[@"walk_num"]]];
//            [self.calories setText: [NSString stringWithFormat:@"%@ 卡",userInfoDic[@"kcal"]]];
            [self.calories setText: [NSString stringWithFormat:@"%.2f 卡",(float)[userInfoDic[@"kcal"] intValue]]];
            //            [self.distance setText: [NSString stringWithFormat:@"%@ km",userInfoDic[@"distance"]]];
            [self.distance setText: [NSString stringWithFormat:@"%.2f km",(float)([userInfoDic[@"distance"] intValue]/1000.0)]];
            
            //更新圆环进度
            self.homeCircleView.goalSteps = [userInfoDic[@"target_num"] intValue];
            self.homeCircleView.todaySteps = [userInfoDic[@"walk_num"] intValue];
            [self.homeCircleView changeInfo];
        }
        
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.label.text = responseObject[@"message"];
//        hud.detailsLabel.text = nil;
//        [hud hideAnimated:YES afterDelay:1];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error);
    }];
    
    
}

- (void) updateInfo:(NSNotification *)notification {
    
    //回主线程刷新页面
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UTEModelRunData *runData = [notification object];
        
        [self.todaySteps setText: [NSString stringWithFormat:@"%ld",(long)runData.totalSteps]];
        [self.getSteps setText:  [NSString stringWithFormat:@"%ld 步",(long)runData.totalSteps]];
        
        [self.calories setText: [NSString stringWithFormat:@"%ld 卡",(long)runData.calories]];
        [self.distance setText: [NSString stringWithFormat:@"%ld km",(long)runData.distances/1000]];
        
    });
    
    
    //调用 步数改变接口
    UTEModelRunData *runData = [notification object];
    
    
    //添加检查网络方法
    NetworkStatus status = _appdelegate.reachability.currentReachabilityStatus;
    if (status == NotReachable) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterView show];
        
        return;
    }
    
    
    NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/changeUserStep.htm?userToken=%@&deviceId=%@&walkNum=%ld&kcal=%f&distance=%.0f",beanResp.userToken,beanResp.deviceId,(long)runData.totalSteps,runData.calories,runData.distances];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载的进度");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject %@",responseObject);
        
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"flag"] ] isEqualToString:@"1"]) {
            
            //重新获取一次最后一次上传的数据
            NSDictionary* userInfoDic = responseObject[@"rank"];
            
            [self.rank setText: [NSString stringWithFormat:@"%@",userInfoDic[@"rank"]]];
            [self.goalSteps setText: [NSString stringWithFormat:@"目标 %@",userInfoDic[@"target_num"]]];
            
            [self.todaySteps setText: [NSString stringWithFormat:@"%@",userInfoDic[@"walk_num"]]];
            [self.getSteps setText:  [NSString stringWithFormat:@"%@ 步",userInfoDic[@"walk_num"]]];
            [self.calories setText: [NSString stringWithFormat:@"%.2f 卡",(float)[userInfoDic[@"kcal"] intValue]]];
            [self.distance setText: [NSString stringWithFormat:@"%.2f km",(float)([userInfoDic[@"distance"] intValue]/1000.0)]];
            
            //更新圆环进度
            self.homeCircleView.goalSteps = [userInfoDic[@"target_num"] intValue];
            self.homeCircleView.todaySteps = [userInfoDic[@"walk_num"] intValue];
            [self.homeCircleView changeInfo];
            
        }
        
        
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.label.text = responseObject[@"message"];
//        hud.detailsLabel.text = nil;
//        [hud hideAnimated:YES afterDelay:1];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error);
    }];
    
    
}


- (void) updateTarget:(NSNotification *)notification {
    
    NSString* targetNum = [notification object];
    [self.goalSteps setText: [NSString stringWithFormat:@"目标 %@",targetNum]];
    
    
    //更新圆环进度
    self.homeCircleView.goalSteps = [targetNum intValue];
    self.homeCircleView.todaySteps = [self.todaySteps.text intValue];
    [self.homeCircleView changeInfo];
    
    
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
