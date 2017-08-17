//
//  DeviceViewController.m
//  jianbuwang
//
//  Created by Steve on 24/07/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//

#import "DeviceViewController.h"
@import UTESmartBandApi;
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Bean4UserInfo.h"
#import "AppDelegate.h"

@interface DeviceViewController ()<UTEManagerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    Bean4UserInfo* beanResp;//用户单例数据
}

@property (nonatomic,strong) UTESmartBandClient *smartBandMgr;

@property (nonatomic,strong) NSMutableArray     *mArrayDevices;
@property (nonatomic,strong) UIAlertView        *alertView;
@property (weak, nonatomic) IBOutlet UITableView *deviceList;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (nonatomic, strong)  AppDelegate             *appdelegate;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //初始化用户单例数据
    beanResp = [Bean4UserInfo sharedInstance];
    
    
    //1. 实例化
    self.smartBandMgr = [UTESmartBandClient sharedInstance];
    //2. 初始化
    [self.smartBandMgr initUTESmartBandClient];
    //3. 设置代理
    self.smartBandMgr.delegate = self;
    //4. 打开log
    self.smartBandMgr.debugUTELog = YES;
    
    //5. 设置过滤设备名称
    //    self.smartBandMgr.filterName = @"MH08";
    //5.1 设置过滤设备信号强度范围 默认为-70
    //    self.smartBandMgr.filerRSSI = -99;
    //6. 重复扫描设备(这样设备信号值才会实时变化)
    
    self.smartBandMgr.isScanRepeat = YES;
    
    NSLog(@"sdk vsersion =%@",self.smartBandMgr.sdkVersion);
    
    self.mArrayDevices = [NSMutableArray array];
    self.deviceList.delegate = self;
    self.deviceList.dataSource = self;
    
    
    //如果存在默认设备，则显示这个设备
    NSString* defaultDeviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultDeviceID"];
    NSString* defaultDeviceName = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultDeviceName"];
    NSString* defaultDeviceConnected = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultDeviceConnected"];
    
    if (defaultDeviceID) {
        
        UTEModelDevices *model = [[UTEModelDevices alloc] init];
        model.identifier = defaultDeviceID;
        model.name = defaultDeviceName;
        
        if ([defaultDeviceConnected isEqualToString:@"1"]) {
            model.isConnected = YES;
        }
        
        [self.mArrayDevices addObject:model];
        [self.deviceList reloadData];
        
    }
    
    //启动一次搜索
//    [self searchDevice:nil];
    
    //通知自动连接成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectedDefaultDevice:) name:@"connectDefaultDeviceSuccess" object:nil];
    
}

- (void) connectedDefaultDevice :(NSNotification *)notification {
    
    
    NSString* defaultDeviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultDeviceID"];
    
    for (UTEModelDevices *model in self.mArrayDevices) {
        if ([model.identifier isEqualToString:defaultDeviceID]) {
            model.isConnected = YES;
            break;
        }
    }
    
    [self.deviceList reloadData];
}



- (IBAction)searchDevice:(id)sender {
    
    //清空当前列表
//    [self.mArrayDevices removeAllObjects];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在扫描设备中";
    hud.detailsLabel.text = @"请稍等";
    [hud hideAnimated:YES afterDelay:10];
    
    //搜索设备方法
    [self.smartBandMgr startScanDevices];
    
}


#pragma mark - UTEManagerDelegate
- (void)uteManagerDiscoverDevices:(UTEModelDevices *)modelDevices
{
    NSLog(@"***扫描到的设备name=%@ id=%@",modelDevices.name,modelDevices.identifier);
    
    BOOL sameDevices = NO;
    for (UTEModelDevices *model in self.mArrayDevices) {
        if ([model.identifier isEqualToString:modelDevices.identifier]) {
            model.rssi = modelDevices.rssi;
            model.name = modelDevices.name;
            sameDevices = YES;
            break;
        }
    }
    
    if (!sameDevices) {
        NSLog(@"***扫描到的设备name=%@ id=%@",modelDevices.name,modelDevices.identifier);
        [self.mArrayDevices addObject:modelDevices];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        [self.deviceList reloadData];
    });
    
    
}


- (void)uteManagerExtraIsAble:(BOOL)isAble
{
    if (isAble) {
        NSLog(@"***成功打开设备额外功能");
    }else{
        NSLog(@"***未能打开设备额外功能，设备主动断开连接，请重新连接设备");
    }
}

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
    
    [self.smartBandMgr setUTEOption:UTEOptionHeartSwitchDynamic];
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.label.text = @"连接成功";
//        hud.detailsLabel.text = @"正在同步数据";
//        [hud hideAnimated:YES afterDelay:1];
//        
//    });
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mArrayDevices.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString static *identifierUTE = @"UTECell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierUTE];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierUTE];
    }
    if (self.mArrayDevices.count == 0) {
        NSLog(@"***-------空array");
        return cell;
    }
    UTEModelDevices *model = self.mArrayDevices[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"华舜手环(%@)",model.name] ;
    
    if (model.isConnected) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"连接成功"];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"未连接(%ld)",(long)model.rssi];
    }
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)model.rssi];
    UIImage *image = nil;
    if (model.rssi > -40) {
        image = [UIImage imageNamed:@"signal5"];
    }else if(model.rssi > -50){
        image = [UIImage imageNamed:@"signal4"];
    }else if(model.rssi > -65){
        image = [UIImage imageNamed:@"signal3"];
    }else if(model.rssi > -80){
        image = [UIImage imageNamed:@"signal2"];
    }else if(model.rssi > -90){
        image = [UIImage imageNamed:@"signal1"];
    }else{
        image = [UIImage imageNamed:@"signal0"];
    }
    
    cell.imageView.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//添加选中后，一闪而过的效果
    
    
    if (self.mArrayDevices.count == 0) {
        NSLog(@"***tableViewCell-------空array");
        return;
    }
    UTEModelDevices *model = self.mArrayDevices[indexPath.row];
    
    //如果用户还没绑定设备，调用绑定设备方法
    if (beanResp.deviceId.length == 0) {
        
        //存储默认设备
        [[NSUserDefaults standardUserDefaults] setObject:model.identifier forKey:@"defaultDeviceID"];
        [[NSUserDefaults standardUserDefaults] setObject:model.name forKey:@"defaultDeviceName"];
        
        
        model.isConnected = YES;
        [self.smartBandMgr connectUTEModelDevices:model];
        
        [self bindDeviceIdAction:model];
        
    }
    
    //如果用户已经绑定设备，且设备与搜索到的设备id相等,直接连接
    else if (beanResp.deviceId.length > 0 && [beanResp.deviceId isEqualToString:model.identifier]) {
        
        //存储默认设备
        [[NSUserDefaults standardUserDefaults] setObject:model.identifier forKey:@"defaultDeviceID"];
        [[NSUserDefaults standardUserDefaults] setObject:model.name forKey:@"defaultDeviceName"];
        
        
        model.isConnected = YES;
        [self.smartBandMgr connectUTEModelDevices:model];
        
    }
    
    //如果用户已经绑定设备，且设备与搜索到的设备id不相等,提示请联系管理员
    else if (beanResp.deviceId.length > 0 && ![beanResp.deviceId isEqualToString:model.identifier]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"不能连接，请联系管理员";
        hud.detailsLabel.text = nil;
        [hud hideAnimated:YES afterDelay:1];
    }
    
    //停止搜索设备
    [self.smartBandMgr stopScanDevices];
    
    //刷新设备状态
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        [self.deviceList reloadData];
    });
    
    
    [self performSelector:@selector(getinfo) withObject:nil afterDelay:3];
}

#pragma 获取用户的卡路里，距离，步数
- (void) getinfo {
    NSLog(@"start get info");
    
    [self.smartBandMgr setUTEOption:UTEOotionTodaySteps];
    
}

//第一次连接设备，调用绑定设备方法
- (void) bindDeviceIdAction :(UTEModelDevices *) modle {
    
    NSString* urlString = [NSString stringWithFormat:@"http://jianbu.club/jbw/bindDeviceId.htm?userToken=%@&deviceId=%@",beanResp.userToken,modle.address];
    
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
            
            //已经绑定成功，将设备id存入单例数据
            beanResp.deviceId = modle.identifier;
            
        }
        
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //            [alert show];
        
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.label.text = responseObject[@"message"];
//        hud.detailsLabel.text = nil;
//        [hud hideAnimated:YES afterDelay:1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [MBProgressHUD hideHUDForView:self.view animated:true];
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
