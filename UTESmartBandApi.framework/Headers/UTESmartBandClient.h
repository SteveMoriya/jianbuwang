//
//  UTESmartBandClient.h
//  UTESmartBandClient
//
//  Created by VV on 14/11/28.
//  Copyright © 2014年 vv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>


/**
 *  NSDictionary 同步数据完 - 步数键值,value:NSArray
 */
extern NSString *const kUTEQueryRunData;
/**
 *  NSDictionary 同步数据完 - 睡眠键值,value:NSArray
 */
extern NSString *const kUTEQuerySleepData;
/**
 *  NSDictionary 同步数据完/测试心率完 - 心率键值,value:NSArray
 */
extern NSString *const kUTEQueryHRMData;
/**
 *  NSDictionary 同步数据完/测试血压完 - 血压键值,value:NSArray
 */
extern NSString *const kUTEQueryBloodData;
/**
 *  NSDictionary 设备密码状态 键值,value:NSString 转为NSInteger 对应UTEPasswordState枚举
 */
extern NSString *const kUTEPasswordState;

/**
 *  NSDictionary 当前气温键值,value: 请把NSInteger 转化为 NSNumber
 */
//最高气温
extern NSString *const kUTEMaxTemperature;
//最低气温
extern NSString *const kUTEMinTemperature;
//天气类型 value: 请把UTEWeatherType 转化为 NSNumber
extern NSString *const kUTEWeatherType;
//今天当前的气温 只有第一天(今天有这个键值)
extern NSString *const kUTECurrentTemperature;
//今天的PM2.5
extern NSString *const kUTETodayPM25;
//今天的AQI
extern NSString *const kUTETodayAQI;
//城市
extern NSString *const kUTEWeatherCity;


/*!
 *  @enum UTEOption
 *
 *  @discussion 设置设备特性
 *  
 *  
 *  @constant UTEOptionSyncAllStepsData      同步设备所有步数
 *  @constant UTEOptionSyncAllSleepData      同步设备所有睡眠
 *  @constant UTEOptionSyncAllHRMData        同步设备所有心率
 *  @constant UTEOptionSyncAllBloodData      同步设备所有血压
 *  @constant UTEOptionSyncAllData           同步设备所有数据 （步数和睡眠）
 *  @constant UTEOotionTodaySteps            获取今天总步数
 *  @constant UTEOptionIncall                来电指令 :当手机来电时，调用此值则设备会震动10次 1秒1次
 
 *  @constant UTEOptionHangup                挂断/接通:调用此值则设备会立即停止震动
 *  @constant UTEOptionFindBand              查找设备 :设备震动2次 1秒1次
 *  @constant UTEOptionSyncTime              同步当前手机时间
 *  @constant UTEOptionReadDevicesBattery    读取设备电量
 
 *  @constant UTEOptionHeartDetectingStart   开始测试心率
 *  @constant UTEOptionHeartDetectingStop    停止测试心率
 *  @constant UTEOptionHeartSwitchDynamic    切换为动态心率模式
 *  @constant UTEOptionHeartSwitchStatic     切换为静态心率模式
 
 *  @constant UTEOptionUnitInch              设置设备计量单位为 英制 磅(lbs) (RK 平台暂时无效)
 *  @constant UTEOptionUnitMeter             设置设备计量单位为 公制 千克    (RK 平台暂时无效)
 *  @constant UTEOptionUnitInch_12           设置设备计量单位为 英制 磅   时间12小时制(AM,PM) 需固件支持
 *  @constant UTEOptionUnitInch_24           设置设备计量单位为 英制 磅   时间24小时制        需固件支持
 *  @constant UTEOptionUnitMeter_12          设置设备计量单位为 公制 千克 时间12小时制(AM,PM) 需固件支持
 *  @constant UTEOptionUnitMeter_24          设置设备计量单位为 公制 千克 时间24小时制        需固件支持
 
   （RK平台 支持以下所有提醒，无需考虑isHasExtra值）
 *  @constant UTEOptionOpenRemindIncall      打开设备 来电提醒 震动1次  前提isHasExtra = YES
 *  @constant UTEOptionOpenRemindQQ          打开设备 QQ 提醒  震动1次   前提isHasExtra = YES
 *  @constant UTEOptionOpenRemindWeixin      打开设备 微信提醒 震动1次   前提isHasExtra = YES
 *  @constant UTEOptionOpenRemindSms         打开设备 SMS提醒  震动1次   前提isHasExtra = YES
 *  @constant UTEOptionOpenRemindMore        打开设备 更多提醒  震动1次   前提isHasExtra = YES
 *  @constant UTEOptionCloseRemindIncall     关闭设备 来电提醒           前提isHasExtra = YES
 *  @constant UTEOptionCloseRemindQQ         关闭设备 QQ提醒             前提isHasExtra = YES
 *  @constant UTEOptionCloseRemindWeixin     关闭设备 微信提醒           前提isHasExtra = YES
 *  @constant UTEOptionCloseRemindSms        关闭设备 SMS提醒            前提isHasExtra = YES
 *  @constant UTEOptionCloseRemindMore       关闭设备 更多提醒           前提isHasExtra = YES
 
 *  @constant UTEOptionOpenCameraMode        打开设备摇一摇拍照模式:接着用户每摇晃3次设备左右
                                             代理uteManagerTakePicture方法就被调用
 *  @constant UTEOptionCloseCameraMode       关闭设备摇一摇拍照模式:退出拍照模式 一定要调用此值
                                             否则设备可能不计步
 *
 *  @constant UTEOptionDeleteDevicesAllData  清除设备所有数据
 
    (横竖屏功能需要固件支持,请看isHasOrientation属性)
 *  @constant UTEOptionDeviceHorizontal      设置设备横屏
 *  @constant UTEOptionDeviceVertical        设置设备竖屏
 *
 *  @constant UTEOptionBloodDetectingStart   开始测试血压
 *  @constant UTEOptionBloodDetectingStop    停止测试血压
 *
 *  @constant UTEOptionReadDisplaySize       查询表盘分辨率和能切换的个数
 *
 */
typedef NS_ENUM(NSInteger, UTEOption) {
    
    UTEOptionSyncAllStepsData,
    UTEOptionSyncAllSleepData,
    UTEOptionSyncAllHRMData,
    UTEOptionSyncAllBloodData,
    UTEOptionSyncAllData,
    UTEOotionTodaySteps,
    UTEOptionIncall,
    UTEOptionHangup,
    UTEOptionFindBand,
    UTEOptionSyncTime,
    UTEOptionReadDevicesBattery,
    
    UTEOptionHeartDetectingStart,
    UTEOptionHeartDetectingStop,
    UTEOptionHeartSwitchDynamic,
    UTEOptionHeartSwitchStatic,
    
    UTEOptionUnitInch,
    UTEOptionUnitMeter,
    UTEOptionUnitInch_12,
    UTEOptionUnitInch_24,
    UTEOptionUnitMeter_12,
    UTEOptionUnitMeter_24,
    
    UTEOptionOpenRemindIncall,
    UTEOptionOpenRemindQQ,
    UTEOptionOpenRemindWeixin,
    UTEOptionOpenRemindSms,
    UTEOptionOpenRemindMore,
    UTEOptionCloseRemindIncall,
    UTEOptionCloseRemindQQ,
    UTEOptionCloseRemindWeixin,
    UTEOptionCloseRemindSms,
    UTEOptionCloseRemindMore,
    
    UTEOptionOpenCameraMode,
    UTEOptionCloseCameraMode,
    
    UTEOptionDeleteDevicesAllData,
    
    UTEOptionDeviceHorizontal,
    UTEOptionDeviceVertical,
    
    UTEOptionBloodDetectingStart,
    UTEOptionBloodDetectingStop,
    UTEOptionReadDisplaySize,
};


/*!
 *  @enum UTECallBack
 
 *
 *  @discussion SDK对固件发送命令以下对应，如固件接收到值，将发送返回值给SDK，如SDK接收到值将回调；否则无。
 *
 *  @constant UTECallBackUnit                     设置设备计量单位
 *  @constant UTECallBackInfoHeightWeight         设置设备里面身高、体重
 *  @constant UTECallBackSyncTime                 同步当前时间
 *  @constant UTECallBackAlarm                    设置闹钟
 
 *  @constant UTECallBackOpenRemindIncall         打开设备 来电提醒
 *  @constant UTECallBackOpenRemindQQ             打开设备 QQ 提醒
 *  @constant UTECallBackOpenRemindWeixin         打开设备 微信提醒
 *  @constant UTECallBackOpenRemindSms            打开设备 SMS提醒
 *  @constant UTECallBackOpenRemindMore           打开设备 更多提醒（除以上提醒，所有的App允许系统打开了的通知提示）
 
 *  @constant UTECallBackCloseRemindIncall        关闭设备 来电提醒
 *  @constant UTECallBackCloseRemindQQ            关闭设备 QQ提醒
 *  @constant UTECallBackCloseRemindWeixin        关闭设备 微信提醒
 *  @constant UTECallBackCloseRemindSms           关闭设备 SMS提醒
 *  @constant UTECallBackCloseRemindMore          关闭设备 更多提醒
 
 *  @constant UTECallBackOpenUnitSitRemind        打开久坐提醒
 *  @constant UTECallBackCloseSitRemind           关闭久坐提醒
 
 *  @constant UTECallBackHeartSwitchDynamic       切换动态心率
 *  @constant UTECallBackHeartSwitchStatic        切换静态心率
 
 *  @constant UTECallBackDevicesVersion           获取到了设备版本号
 *
 *  @constant UTECallBackDeviceHorizontal         设备横屏
 *  @constant UTECallBackDeviceVertical           设备竖屏
 
 *  @constant UTECallBackDeviceSilence            设备勿打扰
 *
 *  @constant UTECallBackDeviceWeather            设置2天内的天气
 *
 *  @constant UTECallBackDeviceBattery            获取到电量
 *  @constant UTECallBackSwitchHandAndDisplay     切换佩戴方式和表盘显示模式
 *  @constant UTECallBackWeatherSevenDay          设置7天内的天气
 *  @constant UTECallBackIbeaconOption            设置ibeacon数据
 */
typedef NS_ENUM(NSInteger, UTECallBack) {
    
    UTECallBackUnit,
    UTECallBackInfoHeightWeight,
    UTECallBackSyncTime,
    UTECallBackAlarm,
    
    UTECallBackOpenRemindIncall,
    UTECallBackOpenRemindQQ,
    UTECallBackOpenRemindWeixin,
    UTECallBackOpenRemindSms,
    UTECallBackOpenRemindMore,
    
    UTECallBackCloseRemindIncall,
    UTECallBackCloseRemindQQ,
    UTECallBackCloseRemindWeixin,
    UTECallBackCloseRemindSms,
    UTECallBackCloseRemindMore,
    
    UTECallBackOpenUnitSitRemind,
    UTECallBackCloseSitRemind,
    
    UTECallBackHeartSwitchDynamic,
    UTECallBackHeartSwitchStatic,
    
    UTECallBackDevicesVersion,
    
    UTECallBackDeviceHorizontal,
    UTECallBackDeviceVertical,
    
    UTECallBackDeviceSilence,
    
    UTECallBackDeviceWeather,
    UTECallBackDeviceBattery,
    UTECallBackSwitchHandAndDisplay,
    UTECallBackWeatherSevenDay,
    UTECallBackIbeaconOption,
};

/*!
 *  @enum UTEDevicesSate
 *
 *  @discussion 设备状态
 *
 *  @constant UTEDevicesSateConnected             设备已经连接状态
 *  @constant UTEDevicesSateDisconnected          设备已经断开状态，如有错误码，请查看UTEErrorCode
 
 *  @constant UTEDevicesSateSyncBegin             设备在同步数据开始
 *  @constant UTEDevicesSateSyncSuccess           设备同步成功完毕
 *  @constant UTEDevicesSateSyncError             设备同步错误，请查看UTEErrorCode
 
 *  @constant UTEDevicesSateHeartDetectingStart   设备心率开始检测
 *  @constant UTEDevicesSateHeartDetectingProcess 设备心率检测中（带有值）
 *  @constant UTEDevicesSateHeartDetectingStop    设备心率停止检测
 *  @constant UTEDevicesSateHeartDetectingError   设备心率检测中错误， 请查看UTEErrorCode
 
 *  @constant UTEDevicesSateBloodDetectingStart   设备血压开始检测
 *  @constant UTEDevicesSateBloodDetectingProcess 设备血压检测中（带有值）
 *  @constant UTEDevicesSateBloodDetectingStop    设备血压停止检测
 *  @constant UTEDevicesSateBloodDetectingError   设备血压检测中错误， 请查看UTEErrorCode
 
 *  @constant UTEDevicesSateCheckFirmwareError    设备检查错误，请查看UTEErrorCode
 
 *  @constant UTEDevicesSateUpdateHaveNewVersion  设备没有新版本
 *  @constant UTEDevicesSateUpdateNoNewVersion    设备有新版本
 *  @constant UTEDevicesSateUpdateBegin           设备升级开始
 *  @constant UTEDevicesSateUpdateSuccess         设备升级成功，设备会自动断开，请重新连接
 *  @constant UTEDevicesSateUpdateError           设备升级失败，请查看UTEErrorCode
 *
 *  @constant UTEDevicesSateCardApduError         设备Apdu数据交互失败，请查看UTEErrorCode
 *  
 *  @constant UTEDevicesSatePasswordState         设备密码验证状态 请看UTEPasswordState 请询问相关人员：设备是否有连接的密码验证过程
 */
typedef NS_ENUM(NSInteger, UTEDevicesSate) {
    UTEDevicesSateConnected = 0,
    UTEDevicesSateDisconnected,
    
    UTEDevicesSateSyncBegin,
    UTEDevicesSateSyncSuccess,
    UTEDevicesSateSyncError,
    
    UTEDevicesSateHeartDetectingStart,
    UTEDevicesSateHeartDetectingProcess,
    UTEDevicesSateHeartDetectingStop,
    UTEDevicesSateHeartDetectingError,
    
    UTEDevicesSateBloodDetectingStart,
    UTEDevicesSateBloodDetectingProcess,
    UTEDevicesSateBloodDetectingStop,
    UTEDevicesSateBloodDetectingError,
    
    UTEDevicesSateCheckFirmwareError,
    
    UTEDevicesSateUpdateHaveNewVersion,
    UTEDevicesSateUpdateNoNewVersion,
    UTEDevicesSateUpdateBegin,
    UTEDevicesSateUpdateSuccess,
    UTEDevicesSateUpdateError,
    
    UTEDevicesSateCardApduError,
    
    UTEDevicesSatePasswordState,
};

/*!
 *  @enum UTEPasswordState
 *
 *  @discussion 密码状态
 *
 *  @constant UTEPasswordStateNew               设备需要设置一个新的密码(设备从未被连接过,密码是空的)
 *  @constant UTEPasswordStateNeed              设备需要密码输入(设备已设置过密码)
 *  @constant UTEPasswordStateCorrect           输入、验证或者修改的密码成功
 *  @constant UTEPasswordStateError             输入、验证或者修改的密码失败
 */
typedef NS_ENUM(NSInteger, UTEPasswordState) {
    
    UTEPasswordStateNew    = 1,
    UTEPasswordStateNeed,
    UTEPasswordStateCorrect,
    UTEPasswordStateError,
};

/*!
 *  @enum UTEPasswordType
 *
 *  @discussion 密码类型
 *
 *  @constant UTEPasswordTypeConnect           用于连接设备的时候
 *  @constant UTEPasswordTypeConfirm           用于修改密码时候必须验证
 *  @constant UTEPasswordTypeReset             用于修改密码时候验证成功后 重新设置密码
 */
typedef NS_ENUM(NSInteger, UTEPasswordType) {
    
    UTEPasswordTypeConnect    = 1,
    UTEPasswordTypeConfirm,
    UTEPasswordTypeReset,
};

/*!
 *  @enum UTEErrorCode
 *
 *  @discussion 设备错误码
 *
 *  @constant UTEErrorCodeDisconnect          设备远离手机断开，或没电了
 
 *  @constant UTEErrorCodeSyncDisconnect      同步数据时，设备异常断开
 *  @constant UTEErrorCodeHeartingDisconnect  心率测试时，设备异常断开
 *  @constant UTEErrorCodeBloodDisconnect     血压测试时，设备异常断开
 
 *  @constant UTEErrorCodeCheckTimeout        检查设备超时，一般网络超时
 *  @constant UTEErrorCodeCheckChara          检查设备时，固件不完整
 *  @constant UTEErrorCodeCheckAddress        检查设备时，固件不完整
 
 *  @constant UTEErrorCodeUpdateDownload      升级设备时，下载固件错误
 *  @constant UTEErrorCodeUpdateDisconnect    升级设备时，设备断开
 
 *  @constant UTEErrorCodeApduDisconnect      设备Apdu数据交互时，设备断开了
 */
typedef NS_ENUM(NSInteger, UTEErrorCode) {
    UTEErrorCodeDisconnect = 1,
    
    UTEErrorCodeSyncDisconnect,
    UTEErrorCodeHeartingDisconnect,
    UTEErrorCodeBloodDisconnect,
    
    UTEErrorCodeCheckTimeout,
    UTEErrorCodeCheckChara,
    UTEErrorCodeCheckAddress,
    
    UTEErrorCodeUpdateDownload,
    UTEErrorCodeUpdateDisconnect,
    
    UTEErrorCodeApduDisconnect,
};

/*!
 *  @enum UTEBluetoothSate
 *
 *  @discussion 手机蓝牙状态
 *
 *  @constant UTEBluetoothSateOpen       手机蓝牙打开
 *  @constant UTEBluetoothSateClose      手机蓝牙关闭
 *  @constant UTEBluetoothSateResetting  手机蓝牙重启
 */
typedef NS_ENUM(NSInteger, UTEBluetoothSate) {
    UTEBluetoothSateOpen = 0,
    UTEBluetoothSateClose,
    UTEBluetoothSateResetting,
};

/*!
 *  @enum UTEQueryType
 *
 *  @discussion 查找数据类型
 *
 *  @constant UTEQueryTypeRun        步数数据
 *  @constant UTEQueryTypeSleep      睡眠数据
 *  @constant UTEQueryTypeHRM        心率数据
 *  @constant UTEQueryTypeAll        所有数据(步数+睡眠)
 */
typedef NS_ENUM(NSInteger, UTEQueryType) {
    UTEQueryTypeRun = 0,
    UTEQueryTypeSleep,
    UTEQueryTypeHRM,
    UTEQueryTypeAll,
};

/*!
 *  @enum UTESleepType
 *
 *  @discussion 睡眠状况
 *
 *  @constant UTESleepTypeAwake          清醒
 *  @constant UTESleepTypeDeepSleep      深睡
 *  @constant UTESleepTypeLightSleep     浅睡
 */
typedef NS_ENUM(NSInteger, UTESleepType) {
    UTESleepTypeAwake = 0,
    UTESleepTypeDeepSleep,
    UTESleepTypeLightSleep,
};

/*!
*  @enum UTEHRMType
*
*  @discussion 睡眠状况
*
*  @constant UTEHRMTypeNormal      心率数据正常（用于同步心率数据、正在测试心率时）
*  @constant UTEHRMTypeSuccess     测试心率成功（用于测试心率完毕后返回，成功）
*  @constant UTEHRMTypeFail        测试心率失败（用于测试心率完毕后返回，失败）
*  @constant UTEHRMTypeTimeout     测试心率超时（用于测试心率完毕后返回，超时）
*/
typedef NS_ENUM(NSInteger, UTEHRMType) {
    UTEHRMTypeNormal = 0,
    UTEHRMTypeSuccess,
    UTEHRMTypeFail,
    UTEHRMTypeTimeout,
};

/*!
 *  @enum UTEBloodType
 *
 *  @discussion 血压状况
 *
 *  @constant UTEHRMTypeNormal      血压数据正常（用于同步数据的血压）
 *  @constant UTEHRMTypeSuccess     血压数据成功（用于测试血压完毕后返回，成功）
 *  @constant UTEHRMTypeFail        血压数据失败（用于测试血压完毕后返回，失败）
 *  @constant UTEHRMTypeTimeout     血压数据超时（用于测试血压完毕后返回，超时）
 */
typedef NS_ENUM(NSInteger, UTEBloodType) {
    UTEBloodTypeNormal = 0,
    UTEBloodTypeSuccess,
    UTEBloodTypeFail,
    UTEBloodTypeTimeout,
};

/*!
 *  @enum UTEAlarmWeek
 *
 *  @discussion 星期
 *
 *  @constant UTEAlarmWeekSunday       星期天
 *  @constant UTEAlarmWeekMonday       星期一
 *  @constant UTEAlarmWeekTuesday      星期二
 *  @constant UTEAlarmWeekWednesday    星期三
 *  @constant UTEAlarmWeekThursday     星期四
 *  @constant UTEAlarmWeekFriday       星期五
 *  @constant UTEAlarmWeekSaturday     星期六
 */
typedef NS_ENUM(NSInteger, UTEAlarmWeek) {
    UTEAlarmWeekSunday    = 0x01,
    UTEAlarmWeekMonday    = 0x02,
    UTEAlarmWeekTuesday   = 0x04,
    UTEAlarmWeekWednesday = 0x08,
    UTEAlarmWeekThursday  = 0x10,
    UTEAlarmWeekFriday    = 0x20,
    UTEAlarmWeekSaturday  = 0x40,
};

/*!
 *  @enum UTEAlarmNum
 *
 *  @discussion 闹钟序列号
 *
 *  @constant UTEAlarmNum1       第一个闹钟
 *  @constant UTEAlarmNum2       第二个闹钟
 *  @constant UTEAlarmNum3       第三个闹钟
 */
typedef NS_ENUM(NSInteger, UTEAlarmNum) {
    UTEAlarmNum1 = 1,
    UTEAlarmNum2,
    UTEAlarmNum3,
};

/*!
 *  @enum UTEDeviceFeature
 *
 *  @discussion 设备特性 （RK平台无此信息，无需考虑此属性）
 *
 *  @constant UTEDeviceFeatureNone             默认模式
 *  @constant UTEDeviceFeatureWechat           微信模式(微信排行)
 *  @constant UTEDeviceFeatureMessage          消息推送模式
 *  @constant UTEDeviceFeatureWechatMessage    消息推送与微信模式
 *  @constant UTEDeviceFeatureUpdate           升级模式
 *  @constant UTEDeviceFeatureUpdateWechat     升级模式与微信模式(微信排行)
 */
typedef NS_ENUM(NSInteger, UTEDeviceFeature) {
    UTEDeviceFeatureNone,
    UTEDeviceFeatureWechat,
    UTEDeviceFeatureMessage,
    UTEDeviceFeatureWechatMessage,
    UTEDeviceFeatureUpdate,
    UTEDeviceFeatureUpdateWechat,
};

/*!
 *  @enum UTESilenceType
 *
 *  @discussion 勿打扰模式 （需要固件支持）
 *
 *  @constant UTESilenceTypeNone             打开所有功能(不需要手环勿打扰)
 *  @constant UTESilenceTypeScreen           关闭手环屏幕，屏幕将永不亮屏
 *  @constant UTESilenceTypeVibration        关闭手环马达震动，手环将永不震动
 *  @constant UTESilenceTypeMessage          关闭手环任何信息提醒（QQ/Wechat/短信/电话）
 *  @constant UTESilenceTypePhone            关闭手环上一键挂电话功能
 */
typedef NS_ENUM(NSInteger, UTESilenceType) {
    UTESilenceTypeNone              = 0x00,
    UTESilenceTypeScreen            = 0x01,
    UTESilenceTypeVibration         = 0x02,
    UTESilenceTypeMessage           = 0x04,
    UTESilenceTypePhone             = 0x08,
};

/*!
 *  @enum UTEDeviceFeature
 *
 *  @discussion 天气类型 (固件支持的天气类型)
 *
 *  @constant UTEWeatherTypeSunny         //晴朗
 *  @constant UTEWeatherTypeCloudy        //多云
 *  @constant UTEWeatherTypeOvercast      //阴天
 *  @constant UTEWeatherTypeShower        //阵雨
 *  @constant UTEWeatherTypeThunderStorm  //雷阵雨
 *  @constant UTEWeatherTypeRainSnow      //雨夹雪
 *  @constant UTEWeatherTypeLightRain     //小雨
 *  @constant UTEWeatherTypePouring       //大雨
 *  @constant UTEWeatherTypeSnow          //下雪
 *  @constant UTEWeatherTypeSandstorm     //沙尘暴
 *  @constant UTEWeatherTypeMistHaze      //雾霾
 *  @constant UTEWeatherTypeWind          //有风
 */
typedef NS_ENUM(NSInteger, UTEWeatherType) {
    UTEWeatherTypeSunny         = 1,
    UTEWeatherTypeCloudy,
    UTEWeatherTypeOvercast,
    UTEWeatherTypeShower,
    UTEWeatherTypeThunderStorm,
    UTEWeatherTypeRainSnow,
    UTEWeatherTypeLightRain,
    UTEWeatherTypePouring,
    UTEWeatherTypeSnow,
    UTEWeatherTypeSandstorm,
    UTEWeatherTypeMistHaze,
    UTEWeatherTypeWind,
};

/*!
 *  @enum UTEDeviceSreenDisplayType
 *
 *  @discussion 表盘显示方式
 *
 *  @constant UTEDeviceSreenDisplayTypeHorizontal        //横屏
 *  @constant UTEDeviceSreenDisplayTypeVerticalEN        //竖屏 英文显示
 *  @constant UTEDeviceSreenDisplayTypeVerticalCH        //竖屏 中文显示
 */
typedef NS_ENUM(NSInteger, UTEDeviceSreenDisplayType) {
    UTEDeviceSreenDisplayTypeHorizontal,
    UTEDeviceSreenDisplayTypeVerticalEN,
    UTEDeviceSreenDisplayTypeVerticalCH,
};

/*!
 *  @enum UTEWearType
 *
 *  @discussion 佩戴方式
 *
 *  @constant UTEWearTypeLeft         //左手
 *  @constant UTEWearTypeRight        //右手
 */
typedef NS_ENUM(NSInteger, UTEWearType) {
    UTEWearTypeLeft,
    UTEWearTypeRight,
};

/*!
 *  @enum UTEIbeaconOption
 *
 *  @discussion ibeacon 设置类型
 *
 *  @constant UTEIbeaconOptionUUID          //uuid
 *  @constant UTEIbeaconOptionMajor         //major
 *  @constant UTEIbeaconOptionMinor         //minor
 *  @constant UTEIbeaconOptionName          //device name
 */
typedef NS_ENUM(NSInteger, UTEIbeaconOption) {
    UTEIbeaconOptionUUID,
    UTEIbeaconOptionMajor,
    UTEIbeaconOptionMinor,
    UTEIbeaconOptionName,
};

/*!
 *  UTEModelDevices 设备属性模型
 */
@interface UTEModelDevices : NSObject
/**
 *  设备版本
 */
@property (nonatomic,copy  ) NSString *version;
/**
 *  设备名称
 */
@property (nonatomic,copy  ) NSString *name;
/**
 *  设备唯一标示
 */
@property (nonatomic,copy  ) NSString *identifier;
/**
 *  设备电量 只有连接上设备才有值
 */
@property (nonatomic,assign) NSInteger battery;
/**
 *  设备连接状态
 */
@property (nonatomic,assign) BOOL     isConnected;
/**
 *  设备是否具有此属性（连接上才有值） 也可向SDK开发人员询问 （RK平台无此信息，无需考虑此属性）
 */
@property (nonatomic,assign) BOOL     isHasExtra;
/**
 *  设备是否具心率功能
 */
@property (nonatomic,assign) BOOL     isHasHRM;
/**
 *  设备是否具血压功能
 */
@property (nonatomic,assign) BOOL     isHasBlood;
/**
 *  设备是否具天气功能 设备支持2天内的天气
 */
@property (nonatomic,assign) BOOL     isHasWeather;
/**
 *  设备是否具天气功能 设备支持7天内的天气
 */
@property (nonatomic,assign) BOOL     isHasWeatherSeven;
/**
 *  设备是否具横竖屏幕切换功能
 */
@property (nonatomic,assign) BOOL     isHasOrientation;
/**
 *  设备是否具勿打扰功能
 */
@property (nonatomic,assign) BOOL     isHasSilence;
/**
 *  设备是否可以使能抬手亮屏
 */
@property (nonatomic,assign) BOOL     isHasHandLight;
/**
 *  设备是否具备最大心率警报功能
 */
@property (nonatomic,assign) BOOL     isHasMaxHeartAlert;
/**
 *  设备是否支持动静态切换功能 
 *  这个值只在扫描设备时有值,连接之后无效
 */
@property (nonatomic,assign) BOOL     isSwitchHeart;
/**
 *  设备是否支持表盘切换 和 左右手切换
 */
@property (nonatomic,assign) BOOL     isHasSwitchHand;
/**
 *  设备是否支ibeacon 功能
 */
@property (nonatomic,assign) BOOL     isHasIbeacon;
/**
 *  设备信号强度 （如_isScanRepeat=true，则在扫描过程中会实时变化,被连上的设备不被赋值）
 */
@property (nonatomic,assign) NSInteger rssi;
/**
 *  设备蓝牙地址，只有连接上设备才有值
 */
@property (nonatomic,strong) NSData   *address;
/**
 *  设备另外特性，只有连接上设备才有实际值：不同的特性支持不同的功能（具体请看文档说明）
 */
@property (nonatomic,assign) UTEDeviceFeature   featureAnother;
/**
 *  设备广播里面包含的内容(4个key):
 *
 *    kCBAdvDataServiceUUIDs
 *    kCBAdvDataLocalName
 *    kCBAdvDataManufacturerData
 *    kCBAdvDataIsConnectable
 *
 *  备注:如设备连上了，此值将变为空.
 */
@property (nonatomic,strong) NSDictionary       *advertisementData;
@end

/*!
 *  UTEModelAlarm 设备闹钟模型
 */
@interface UTEModelAlarm : NSObject
/**
 *  闹钟时间24进制 格式: @"09:30" @"21:05"
 */
@property (nonatomic,copy  ) NSString      *time;
/**
 *  闹钟星期(七位数) 格式:详细请看文档
 */
@property (nonatomic,assign) UTEAlarmWeek  week;
/**
 *  闹钟使能
 */
@property (nonatomic,assign) BOOL          enable;
/**
 *  闹钟序列号,第几个闹钟
 */
@property (nonatomic,assign) UTEAlarmNum   num;

@end

/*!
 *  UTEModelRunData 历史步数模型
 */
@interface UTEModelRunData : NSObject
/**
 *  时间格式: @"2015-08-08-13"
 */
@property (nonatomic,copy  ) NSString     *time;
/**
 *  一天的总卡路里 单位千卡
 */
@property (nonatomic,assign) CGFloat      calories;
/**
 *  一小时内的卡路里 单位千卡
 */
@property (nonatomic,assign) CGFloat      hourCalories;
/**
 *  一小时内步数
 */
@property (nonatomic,assign) NSInteger    hourSteps;
/**
 *  一天的总步数
 */
@property (nonatomic,assign) NSInteger    totalSteps;
/**
 *  一天的总距离 单位米
 */
@property (nonatomic,assign) CGFloat      distances;
/**
 *  一小时内的距离 单位米
 */
@property (nonatomic,assign) CGFloat      hourDistances;

@end

/*!
 *  UTEModelSleepData 历史睡眠模型
 */
@interface UTEModelSleepData : NSObject
/**
 *  开始时间格式: @"2015-08-08-23-30"
 */
@property (nonatomic,copy  ) NSString     *startTime;
/**
 *  结束时间格式: @"2015-08-09-07-30"
 */
@property (nonatomic,copy  ) NSString     *endTime;
/**
 *  睡眠状况
 */
@property (nonatomic,assign) UTESleepType sleepType;

@end

/*!
 *  UTEModelHRMData 心率模型
 */
@interface UTEModelHRMData : NSObject

/**
 *  心率时间格式: @"2015-08-08-23-30"
 */
@property (nonatomic,copy  ) NSString  *heartTime;
/**
 *  心率每分钟跳动次数
 */
@property (nonatomic,copy  ) NSString  *heartCount;
/**
 *  UTEHRMType 心率测试数据是否 正常、成功、超时、失败
 */
@property (nonatomic,assign) UTEHRMType heartType;

@end

/*!
 *  UTEModelBloodData 血压模型
 */
@interface UTEModelBloodData : NSObject

/**
 *  时间格式: @"2015-08-08-23-30"
 */
@property (nonatomic,copy) NSString  *bloodTime;
/**
 *  收缩压
 */
@property (nonatomic,copy) NSString  *bloodSystolic;
/**
 *  舒张压
 */
@property (nonatomic,copy) NSString  *bloodDiastolic;
/**
 *  血压状态
 */
@property (nonatomic,assign) UTEBloodType  bloodType;

@end

#pragma mark - UTEManagerDelegate 代理

/*!
 *  UTEManagerDelegate 代理
 */
@protocol UTEManagerDelegate;

@protocol UTEManagerDelegate <NSObject>

@optional

/**
 *  @discussion 每找到一个设备，就会调用一次
 *
 *  @param modelDevices 设备属性模型
 */
- (void)uteManagerDiscoverDevices:(UTEModelDevices *)modelDevices;

/**
 *  @discussion 时时监听了已连接设备状态
 *
 *  @param devicesState 设备状态
 *  @param error        错误码
 */
- (void)uteManagerDevicesSate:(UTEDevicesSate)devicesState error:(NSError *)error userInfo:(NSDictionary *)info;

/**
 *  @discussion 时时监听了蓝牙连接状态
 *
 *  @param bluetoothState 蓝牙状态
 */
- (void)uteManagerBluetoothState:(UTEBluetoothSate)bluetoothState;

/**
 *  @discussion 当第一次打开来电 QQ 微信 sms提醒功能时，系统会弹出对话框要求绑定（系统绑定）
 *   1.如设备已经绑定，系统是不会弹出对话框，且SDK无返回值
 *   2.如设备未绑定过，用户点击绑定（则设备与系统绑定），则返回YES：来电 QQ 微信 sms相对应的提醒有效；
*                                             否则返回NO，全部无效，且硬件设备会主动断开，请开发者主动调用连接。但是RK平台设备不会断开
 *
 *  @param isAble 设备来电 QQ 微信 sms提醒是否有效
 */
- (void)uteManagerExtraIsAble:(BOOL)isAble;

/**
 *  @discussion 实时监听了设备步数变化 会频繁被调用
 *
 *  @param runData 今天总步数
 */
- (void)uteManagerReceiveTodaySteps:(UTEModelRunData *)runData;

/**
 *  @discussion 实时监听了设备睡眠记录变化
 *              如有新的睡眠记录，请先同步睡眠记录（因为要过滤是否在真正的睡觉），再查询历史睡眠记录
 *              最好早上同步睡眠数据，因为这时候睡眠数据才是完整的，而且同步睡眠需要时间比较久
 *
 *  @param isNewSleep 是否有新的睡眠数据
 */
- (void)uteManagerReceiveTodaySleeps:(BOOL)isNewSleep;

/**
 *  @discussion 同步设备数据进度
 *
 *  @param process 进度(0到100)
 */
- (void)uteManagerSyncProcess:(NSInteger)process;

/**
 *  @discussion 升级设备进度
 *
 *  @param process 进度(0到100)
 */
- (void)uteManagerUpdateProcess:(NSInteger)process;

/**
 *  @discussion 当设备UTEOptionOpenCameraMode拍照模式，每摇晃3次就回调一次
 *   退出拍照模式一定调用UTEOptionCloseCameraMode
 */
- (void)uteManagerTakePicture;

/**
 *  @discussion 通过UTEOptionReadDisplaySize 查询 回调此方法
 *
 *  @param width   设备屏分辨率 宽
 *  @param height  设备屏分辨率 高
 *  @param count   能切换的个数
 */
- (void)uteManagerDisplaySizeWidth:(NSInteger)width height:(NSInteger)height count:(NSInteger)count;

/**
 *  @discussion 通过readUTEIbeacon 读取ibeacon信息的回调
 */
- (void)uteManagerUTEIbeaconOption:(UTEIbeaconOption)option value:(NSString *)value;

/**
 *  @discussion SDK对固件发送命令，如固件接收到值，将发送返回值给SDK，如SDK接收到值将回调；否则无
 */
- (void)uteManageUTEOptionCallBack:(UTECallBack)callback;
@end

#pragma mark - UTESmartBandClient 属性

typedef void(^cardApduResponseBlock)(NSData *data,BOOL success);

/*!
 *  UTESmartBandClient
 */
@interface UTESmartBandClient : NSObject

/**
*   SDK调试Log 默认false
*/
@property (nonatomic,assign ) BOOL  debugUTELog;
/**
 *  UTEManagerClient代理
 */
@property (nonatomic,weak   ) id<UTEManagerDelegate> delegate;
/**
 *  设备是否在同步数据（步数、睡眠、心率）
 */
@property (nonatomic,assign,readonly) BOOL  isSyncDevices;
/**
 *  设备是否在升级
 */
@property (nonatomic,assign,readonly) BOOL  isUpdateDevices;
/**
 *  设备是否在测试心率中
 */
@property (nonatomic,assign,readonly) BOOL  isHeartDetecting;
/**
 *  设备是否在测试血压中
 */
@property (nonatomic,assign,readonly) BOOL  isBloodDetecting;
/** 
 *  是否正在改变设备特性（RK平台无此信息，无需考虑此属性）
 */
@property (nonatomic,assign,readonly) BOOL  isChangeFeature;
/**
 *  已连接上设备模型,断开状态为 nil
 */
@property (nonatomic,strong,readonly) UTEModelDevices  *connectedDevicesModel;
/**
 *  设置要扫描指定的设备(蓝牙)名称,区分大小写,默认为 nil,扫描所有
 */
@property (nonatomic,copy  ) NSString    *filterName;
/**
 *  设置要扫描的设备信号范围强度以内（0 > filerRSSI > -100，默认-70）
 */
@property (nonatomic,assign) NSInteger    filerRSSI;
/** 
 *  设置是否重复扫描设备 默认NO
 */
@property (nonatomic,assign) BOOL         isScanRepeat;
/**
 *   设备是否为RK平台手环(可事先问相关人员,是否有这设备)，设备断开情况下为false
 */
@property (nonatomic,assign,readonly) BOOL isRKDevices;
/**
 *   设置为设备为交通卡手环
 */
@property (nonatomic,assign) BOOL         isCardDevices;
/** 
 *   Apdu通道是否打开 
 */
@property (nonatomic,assign,readonly) BOOL isOpenApdu;
/**
 *  Apdu通道返回的数据
 */
@property (nonatomic,copy) cardApduResponseBlock  cardApduResponseBlock;

#pragma mark - UTESmartBandClient 方法

/**
 *  @discussion 实例化
 *
 *  @return UTESmartBandClient实例
 */
+ (UTESmartBandClient *)sharedInstance;

/**
 *  @discussion 初始化UTESmartBandClient
 */
-(void)initUTESmartBandClient;

/**
 *  @discussion 扫描周围设备
 */
- (void)startScanDevices;

/**
 *  @discussion 停止扫描设备
 */
- (void)stopScanDevices;

/**
 *  @discussion 连接设备
 *
 *  @param model 要连接的设备属性模型 identifier 一定不为nil就行
 */
- (void)connectUTEModelDevices:(UTEModelDevices *)model;

/**
 *  @discussion 断开设备
 *
 *  @param model 要断开的设备属性模型 identifier 一定不为nil就行
 *
 *  @return value 返回此方法是否真正被执行了
 *（蓝牙未打开、设备未连接 是可以执行；正在同步中、正在测试心率中、转化设备特性、Apdu交互中不执行）
 */
- (BOOL)disConnectUTEModelDevices:(UTEModelDevices *)model;

/**
 *  @discussion 设置设备特征
 *
 *  @param option 特征类型
 *
 *  @return 返回是否可以发送option, 或可先调用checkUTEDevicesStateIsEnable方法 检查此时是否给设置特征
 */
- (BOOL)setUTEOption:(UTEOption)option;

/**
 *  @discussion 设置设备闹钟
 *
 *  @param array 装有UTEModelAlarm 模型 最多3个
 *  @param count 闹钟震动次数 0-9次
 */
- (void)setUTEAlarmArray:(NSArray *)array vibrate:(NSInteger)count;

/**
 *  @discussion 设置打开设备久坐提醒 （设备自动识别如中午12点~14点与晚上睡眠 时间是不会提醒的）
 *
 *  @param remindTime 久坐多长时间就震动提醒 单位分钟 范围<10,180>
 */
- (void)setUTESitRemindOpenTime:(NSInteger)remindTime;

/**
 *  @discussion 设置关闭设备久坐提醒
 */
- (void)setUTESitRemindClose;

/**
 *  @discussion 设置设备里面身高、体重、亮屏时间、目标步数、抬手亮屏开关、心率警报值 如不设置，则距离和卡路里 可能全部为 0
 *              请先设置设备单位:公尺或英尺，然后再调用此方法；如之前设置过，SDK 会临时保存设备单位，可以不再调用设置单位(默认为UTEOptionUnitMeter)
 *
 *  @param heigh  身高 UTEOptionUnitMeter 单位cm  范围格式 <91,240>
 *                身高 UTEOptionUnitInch 单位inch 范围格式 <3.00,7.11> 3尺00寸 ~ 7尺11寸 (小数点为11进制)
 
 *  @param weight 体重 UTEOptionUnitMeter 单位kg 范围格式 <20,150>
 *                体重 UTEOptionUnitInch 单位lb 范围格式 <44,333>
 *
 *  @param sec     亮屏时间(秒) 范围<5,60>
 *
 *  @param sportTarget 有的设备支持显示一天的步数进度；如手环不支持，请填非0 值
 *
 *  @param handlight   抬手亮屏的开关 请查看isHasHandLight来判断是否支持此功能
 *
 *  @param maxHeart    超过最大心率值警报 请查看isHasMaxHeartAlert来判断是否支持此功能，关闭则填255
 *
 *  @return 返回以上参数是否有效
 */
- (BOOL)setUTEInfoHeigh:(CGFloat)heigh
                 weight:(NSInteger)weight
                  light:(NSInteger)sec
            sportTarget:(NSInteger)sportTarget
              handlight:(BOOL)handlight
               maxHeart:(NSInteger)maxHeart;

/**
 *  @discussion   设备心率每隔多长时间自动检测一次 有动静态心率切换的功能就有此功能
 *  
 *  @param isAuto 是否自动检测
 *
 *  @param time   每隔几小时检测一次 time范围 1~23
 */
- (void)setUTEHeartAuto:(BOOL)isAuto time:(NSInteger)time;

/***
 *  @discussion 发送密码 （请事先问相关人员 是否设备支持密码校验功能）
 *
 *  @param password 必须为4位长度的数字 如 @"1234"
 *
 *  @param type 密码类型，请看UTEPasswordType枚举
 */
- (void)sendUTEPassword:(NSString *)password type:(UTEPasswordType)type;

/***
 *  @discussion 客户自己定制的key设置，如有则必须每次第一次打开App 设置一次
 *
 *  @param key 如 @"90370abc1c1adc1a7d0439fb2cb7e522"
 */
- (void)setUTESDKKey:(NSString *)key;

/***
 *  @discussion 读取紫外线指数 （请事先问相关人员 是否设备具有紫外线功能）
 *
 *  @param result 指数 范围:0~15  对应的5个等级 0~2:最弱  3~5:弱  6~8:中等  9~11:强  12以上:很强
 *               不同等级的防嗮措施，请百度"紫外线指数"
 */
- (void)readUTEDeviceUV:(void(^)(NSInteger value))result;

/**
 *  @discussion 检查是否有新版本 回调uteManagerDevicesSate:error: 
 *              调试阶段运行一次App,可连续访问服务器5次,然后请重新运行App
 */
- (void)checkUTEFirmwareVersion;

/**
 *  @discussion 检查是否可以发送 UTEOption 等等对设备的设置
 *  设备在 未打开手机蓝牙、未连接设备、正在同步中、正在测试心率/血压中、转化设备特性，返回false，设置是无效的，即设备不处理。
 *
 *  例外：1.当设备是正在测试心率过程中，可以直接关闭心率UTEOptionHeartDetectingStop ，无需理会此返回值。
 *  例外：2.当设备是正在测试血压过程中，可以直接关闭心率UTEOptionBloodDetectingStop ，无需理会此返回值。
 *
 *  注意：交通卡apdu信息交互中，以上UTEOption指令都无效，此方法返回false。
 *
 *  @return 返回值
 */
- (BOOL)checkUTEDevicesStateIsEnable;

/**
 *  @discussion 开始升级 升级中回调 uteManagerUpdateProcess:
 *                       升级失败或者成功回调 uteManagerDevicesSate:error:
 */
- (void)beginUpdateFirmware;

/**
 *  @discussion 改变设备特性
 *
 *  @param isSuccess 转换成功与否
 *
 *   isMustUpdate 是否必须强制升级（如果不升级，那么原来的功能将无法使用）
 *
 */
- (void)changeDeviveFeature:(void(^)(BOOL isSuccess,BOOL isMustUpdate))isSuccess;

/**
 *  @discussion 勿打扰模式
 *
 *  @param type 表示除了后面时间范围限制之外 需要进入那些勿打扰
 *
 *  @param start 开始时间 24小时制 如@"08:30"
 *
 *  @param end   结束时间 24小时制 如@"23:05"
 *
 *  @param except Yes:如在08:30~23:05范围内所有的4个type都进入勿打扰，其他时间以前面的type为准。 No:表示不需要时间范围限制的勿打扰，一整天全部以前面的type为准
 */
- (void)sendUTEAllTimeSilence:(UTESilenceType)type exceptStartTime:(NSString *)start endTime:(NSString *)end except:(BOOL)except;

/**
 *  @discussion 设置设备7天内天气的显示
 *
 *  @param weatherArray 里面装有7天的天气情况，每一天都是一个NSDictionary
    请看35行代码定义的键值 键key:
 
    这几个只有第一天(今天)要有
    kUTECurrentTemperature  :今天的当前温度      value:请把NSInteger 转化为 NSNumber
    kUTETodayPM25           :今天PM2.5         value:请把NSInteger 转化为 NSNumber
    kUTETodayAQI            :今天空气质量        value:请把NSInteger 转化为 NSNumber
    kUTEWeatherCity         :城市(设备仅支持显示最多中文4个字，其他语言请填@"00") value:NSString
 
    这几个7天都要有
    kUTEMaxTemperature      :最高气温           value:请把NSInteger 转化为 NSNumber
    kUTEMinTemperature      :最低气温           value:请把NSInteger 转化为 NSNumber
    kUTEWeatherType         :天气类型           value:请把NSInteger 转化为 NSNumber
 
 
    请按照顺序放置，index 0 为第一天(今天) ... index 6 为第七天
    
    @return 返回数据是否正确 或者 是否可设置(可调用checkUTEDevicesStateIsEnable查看)
 */
- (BOOL)sendUTESevenWeather:(NSArray *)weatherArray;

/**
 *  @discussion 设置设备2天内天气的显示 可先调用getUTEWeatherDataFormServer方法获取天气信息，或者使用其他方法获取到天气信息进行设置
 *
 *  @param todayType    查看 UTEWeatherType
 *  @param currentTemp  当前温度
 *  @param maxTemp      今天最高气温
 *  @param minTemp      今天最低气温
 *  @param pm25         今天PM2.5
 *  @param aqi          今天空气质量
 *
 *  @param tomorrowType 请查看 UTEWeatherType
 *  @param tmrMax       明天最高气温
 *  @param tmrMin       明天最低气温
 */
- (void)sendUTETodayWeather:(UTEWeatherType)todayType
                currentTemp:(NSInteger)currentTemp
                    maxTemp:(NSInteger)maxTemp
                    minTemp:(NSInteger)minTemp
                       pm25:(NSInteger)pm25
                        aqi:(NSInteger)aqi
               tomorrowType:(UTEWeatherType)tomorrowType
                     tmrMax:(NSInteger)tmrMax
                     tmrMin:(NSInteger)tmrMin;
/**
 *  @discussion 根据天气代号code(国内天气) 获取对应的天气类型
 *
 *  @param weatherCode 天气代号 如101
 *
 *  @return 天气类型
 */
- (UTEWeatherType)getUTEWeatherType:(NSInteger)weatherCode;

/**
 *  @discussion 获取天气信息 支持国内 (虽然兼容国外,但可能会获取不到)
 *
 *  @param cityID 城市代号 如@"CN101010100"或城市名 请看http://www.heweather.com/documents/city 找对应的城市
 *
 */
- (void)getUTEWeatherDataFormServer:(NSString *)cityID success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  @discussion 设备的显示方式 和 佩戴方式
 *
 *  @param wearType  佩戴方式
 *  @param sreenType 显示方式
 */
- (void)sendUTEWearType:(UTEWearType)wearType sreenType:(UTEDeviceSreenDisplayType)sreenType;

/**
 *  @discussion 设置ibeacon
 *
 *  @param option     设置类型
 *  @param dataString 数据 格式如下:
 
    当为类型UTEIbeaconOptionUUID:  数据范围(0~9 和 不区分大小写 a~f) 数据长度必须等于32
    如@"a2b9c738cc9d846aef90639e0e4c9562";
    
    当为类型UTEIbeaconOptionMajor: 数据范围(0~65535) 的数字
    如@"55365"
 
    当为类型UTEIbeaconOptionMinor: 数据范围(0~65535) 的数字
    如@"65"
    
    当为类型UTEIbeaconOptionName: 数据范围(0~9 和 区分大小写 a~Z 和键盘上的英文符号) 数据长度最长为14
    如@"UTE_001"
 
 *  return 返回数据格式是否正确 或者 是否可设置(可调用checkUTEDevicesStateIsEnable查看)
 */
- (BOOL)sendUTEIbeacon:(UTEIbeaconOption)option dataString:(NSString *)dataString;

/**
 *  @discussion 获取当前ibeacon数据
 *
 *  @param option     设置类型
 */
- (void)readUTEIbeacon:(UTEIbeaconOption)option;
/**
 *  @discussion 获取当前SDK 版本
 *
 *  @return 版本号 此版本为@"1.22"
 */
- (NSString *)sdkVersion;

#pragma mark - UTESmartBandClient 交通卡 方法
/**
 *  @discussion 关闭通道
 */
- (void)cardCloseApduChannel;
/**
 *  @discussion 发送数据到设备端
 *
 *  @param data 发送的数据
 */
- (void)cardApduSendData:(NSData *)data;


#pragma mark - 过时API,兼容以前版本,勿用
/*********************** 已过时(兼容以前版本) 勿用 ***********************/

- (void)allocateUTEData:(NSData *)data userInfo:(id)userInfo response:(BOOL)response;
@property (nonatomic,assign) BOOL  isOpenPhoneCall;

/******************************* 分割线  *********************************/



@end
